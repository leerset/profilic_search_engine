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
  after_create :create_auth, :join_prolific_organization

  has_attached_file :resume,
    path: ':rails_root/upload/users/:id/resume/:filename',
    url: '/users/:id/resume/:filename'
  validates_attachment_content_type :resume,
    :content_type => RESUME_CONTENT_TYPES

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

  def prolific_status
    prolific = Organization.find_by(code: 'prolific')
    return nil if prolific.nil?
    self.user_organization_statuses.find_by(organization_id: prolific.id).try(:status)
  end

  def join_prolific_organization
    prolific = Organization.find_by(code: 'prolific')
    return false if prolific.nil?
    join_organization(prolific)
  end

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
    organization_roles(organization).detect{|role| role.code == 'organization_administrator'}.present?
  end

  def member?(organization)
    organization_roles(organization).detect{|role| role.code == 'organization_member'}.present?
  end

  def all_oa?(organizations)
    organizations.uniq.map{|a| oa?(a)}.uniq == [true]
  end

  def managed_organizations
    if self.god?
      Organization.all
    else
      self.user_organizations.includes(:organization).joins(:role).where(roles: {code: 'organization_administrator'}).map(&:organization).uniq.sort
    end
  end

  def member_organizations
    self.user_organizations.includes(:organization).joins(:role).where(roles: {code: 'organization_member'}).map(&:organization).uniq.sort
  end

  def inventor?(invention)
    invention_roles(invention).find_by(code: 'inventor').present?
  end

  def co_inventor?(invention)
    invention_roles(invention).find_by(code: 'co-inventor').present?
  end

  def co_inventors
    array = []
    inventions.uniq.each do |invention|
      array += invention.user_invetions.includes(:user).joins(:role).where(roles: {code: ['inventor', 'co-inventor']}).map(&:user).uniq.sort
    end
    array.uniq.select{|user| user.id != self.id}
  end

  def invention_roles_array
    inv_roles = []
    inventions.uniq.each do |invention|
      invention_roles(invention).uniq.each do |role|
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
    inventions.includes(:organization).where.not(organization: orgs).uniq.each do |invention|
      invention_roles(invention).uniq.each do |role|
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

  def organization_roles_array
    org_roles = []
    organizations.uniq.each do |organization|
      organization_roles(organization).uniq.each do |role|
        org_roles << {
          id: organization.id,
          name: organization.name,
          role_id: role.id,
          role_name: role.name
        }
      end
    end
    org_roles
  end

  def organization_roles_array_in_organizations(orgs)
    org_roles = []
    organizations.where(id: orgs.map(&:id)).uniq.each do |organization|
      organization_roles(organization).uniq.each do |role|
        org_roles << {
          id: organization.id,
          name: organization.name,
          role_id: role.id,
          role_name: role.name
        }
      end
    end
    org_roles
  end

  def global_roles_array
    glo_roles = []
    self.roles.uniq.each do |role|
      glo_roles << {
        role_id: role.id,
        role_name: role.name
      }
    end
    glo_roles
  end

  def organization_roles(organization)
    user_organizations.where(organization: organization).map(&:role)
  end

  def invention_roles(invention)
    user_inventions.where(invention: invention).map(&:role)
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
