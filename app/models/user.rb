class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  RESUME_CONTENT_TYPES = [
    # 'image/png', 'image/jpeg',
    # 'text/plain',
    # 'audio/mpeg', 'audio/mp3',
    'application/zip', 'application/msword', 'application/pdf', 'application/xlsx'
  ]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :concepts
  has_one :auth

  has_many :user_addresses
  has_many :addresses, through: :user_addresses

  has_many :user_citizenships
  has_many :citizenships, through: :user_citizenships
  has_many :user_languages
  has_many :languages, through: :user_languages
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :user_inventions
  has_many :inventions, through: :user_inventions
  has_many :user_organizations
  has_many :organizations, through: :user_organizations
  has_many :user_organization_statuses

  before_create :generate_access_token
  after_create :create_auth #, :join_prolific_organization

  has_attached_file :resume,
    path: ':rails_root/upload/users/:id/resume/:filename',
    url: '/users/:id/resume/:filename'
  validates_attachment_content_type :resume,
    :content_type => RESUME_CONTENT_TYPES

  # @@PROLIFIC_ORGANIZATION_ID = 1

  def organization_inventions
    Invention.where(organization: member_organizations, bulk_read_access: 'anyone-organization')
  end

  def read_access?(invention)
    case invention.bulk_read_access
    when 'anyone-organization'
      user_inventions.where(invention: invention).any? || member?(invention.organization)
    when 'only-inventors'
      user_inventions.where(invention: invention).any?
    else
      edit_access?(invention)
    end
  end

  def edit_access?(invention)
    inventor?(invention) || user_inventions.where(invention: invention, access: [1,2]).any?
  end

  def visible_inventions(includes = [])
    invention_ids = (inventions.map(&:id) | organization_inventions.map(&:id)).uniq
    Invention.includes(includes).where(id: invention_ids)
  end

  def update_resume(resume_file)
    # resume_file[:filename]
    # resume_file[:type]
    # resume_file[:tempfile]
    # binding.pry
    self.resume = resume_file[:tempfile]
    self.resume.save
    self.resume_filepath = self.resume.url
    self.save!
  end

  def create_auth
    self.build_auth(secure_random: Auth.generate_secure_random).save!
  end

  # def prolific_status
  #   # self.user_organization_statuses.select {|uos| uos.organization_id == @@PROLIFIC_ORGANIZATION_ID}[0].try(:status)
  # end

  # def join_prolific_organization
  #   prolific = Organization.find_by(id: @@PROLIFIC_ORGANIZATION_ID)
  #   return false if prolific.nil?
  #   join_organization(prolific)
  # end

  def join_organization(organization)
    organization_member_role = Role.find_by(code: 'organization_member')
    return false if organization_member_role.nil?
    user_organizations.find_or_create_by(organization_id: organization.id, role_id: organization_member_role.id)
    user_organization_statuses.find_or_create_by(organization_id: organization.id).update(status: 'Active')
    return true
  end

  def home_address
    addresses.find_by(address_type: 'home')
  end

  def work_address
    addresses.find_by(address_type: 'work')
  end

  def magic_link
    auth.try(:secure_random)
  end

  def update_home_address(address_params)
    if home_address.present?
      home_address.update_attributes(address_params)
    else
      addresses.create(address_params.merge(address_type: 'home'))
    end
  end

  def update_work_address(address_params)
    if work_address.present?
      work_address.update_attributes(address_params)
    else
      addresses.create(address_params.merge(address_type: 'work'))
    end
  end

  def full_name
    screen_name || [firstname, lastname].join(' ')
  end

  def auth?(object)
    object.respond_to?(:user_id) && object.user_id == self.id
  end

  def god?
    roles.find_by(code: 'god').present?
  end

  def oa?(organization)
    user_organizations.select {|uo| uo.organization_id = organization.id && uo.role.code == 'organization_administrator'}.any?
  end

  def member?(organization)
    user_organizations.joins(:role).where(organization: organization, roles: {code: 'organization_member'}).any?
  end

  def all_oa?(organizations)
    organizations.uniq.map{|a| oa?(a)}.uniq == [true]
  end

  def managed_organizations
    if self.god?
      Organization.all
    else
      user_organizations.includes(:organization).joins(:role).where(roles: {code: 'organization_administrator'}).map(&:organization).uniq.sort
    end
  end

  def member_organizations
    user_organizations.includes(:organization).joins(:role).where(roles: {code: 'organization_member'}).map(&:organization).uniq.sort
  end

  def only_member_organizations
    member_organizations - managed_organizations
  end

  def inventor?(invention)
    user_inventions.where(invention: invention).joins(:role).where(roles: {code: 'inventor'}).any?
  end

  def co_inventor?(invention)
    user_inventions.where(invention: invention).joins(:role).where(roles: {code: 'co_inventor'}).any?
  end

  def mentor?(invention)
    user_inventions.where(invention: invention).joins(:role).where(roles: {code: 'mentor'}).any?
  end

  def co_inventors
    array = []
    inventions.uniq.each do |invention|
      array += invention.user_invetions.includes(:user).joins(:role).where(roles: {code: ['inventor', 'co_inventor']}).map(&:user).uniq.sort
    end
    array.uniq.select{|user| user.id != self.id}
  end

  def invention_roles_array
    inv_roles = []
    uis = user_inventions.includes(:role, :invention)
    uis.map(&:invention).uniq.each do |invention|
      invention_roles(uis, invention).uniq.each do |role|
        inv_roles << {
          id: invention.id,
          name: invention.name,
          role_id: role.id,
          role_name: role.name
        }
      end
    end
    inv_roles
  end

  def invention_roles_array_in_organizations(orgs)
    inv_roles = []
    uis = user_inventions.includes(:role, invention: :organization).where.not(inventions: {organization: orgs})
    uis.map(&:invention).uniq.each do |invention|
      invention_roles(uis, invention).uniq.each do |role|
        inv_roles << {
          id: invention.id,
          name: invention.name,
          role_id: role.id,
          role_name: role.name
        }
      end
    end
    inv_roles
  end

  def organization_roles_array_in_organizations(orgs)
    org_roles = []
    user_organizations.includes(:role, :organization).where(organization: orgs).each do |uo|
      org_roles << {
        id: uo.organization.id,
        name: uo.organization.name,
        role_id: uo.role.try(:id),
        role_name: uo.role.try(:name)
      }
    end
    org_roles.uniq
  end

  def organization_roles_array
    organization_roles_array_in_organizations(organizations)
  end

  def global_roles_array
    glo_roles = []
    roles.each do |role|
      glo_roles << {
        role_id: role.id,
        role_name: role.name
      }
    end
    glo_roles.uniq
  end

  def organization_roles(organization)
    user_organizations.includes(:role, :organization).where(organization: organization).map(&:role)
  end

  def invention_roles(user_invention_array, invention)
    user_invention_array.select {|ui| ui.invention_id = invention.id}.map(&:role)
  end

  def expired?
    set_expiration if self.expires_at.nil?
    DateTime.now >= self.expires_at
  end

  def set_expiration
    self.expires_at = DateTime.now + 1    # 1 day
  end

  def authenticate?(password)
    self.password == password
  end

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists_access_token?(access_token)
    set_expiration
    self.access_token
  end

  def update_access_token
    self.generate_access_token
    self.save!
  end

  private

  def self.exists_access_token?(access_token)
    User.where(access_token: access_token).present?
  end
end
