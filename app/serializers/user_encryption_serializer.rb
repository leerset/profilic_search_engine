class UserEncryptionSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :access_token, :expires_time, :magic_link, :is_expired, :status,
    :created_time, :updated_time,
    :firstname, :lastname, :citizenship, :screen_name, :employer, :time_zone, :personal_summary,
    :drafts_amount, :inventions_amount,
    :home_address, :work_address, :organizations,
    :resume, :resume_filepath,
    :global_roles, :organization_roles, :invention_roles,
    :user_organization_statuses
  attribute :global_status, if: :god?

  def god?
    god = instance_options[:god]
    god.present? && god
  end

  def global_status
    object.status
  end

  # def self.eager_load_array(array)
  #   array.includes(
  #     :inventions,
  #     :user_organizations,
  #     :organizations,
  #     :user_organization_statuses,
  #     :user_roles,
  #     :addresses
  #   )
  # end

  def drafts_amount
    0
  end

  def inventions_amount
    object.inventions.uniq.count
  end

  def user_organization_statuses
    current_user_organization_statuses = object.user_organization_statuses.includes(:user, :organization)
    UserOrganizationStatusSerializer.build_array(current_user_organization_statuses)
  end

  def global_roles
    object.global_roles_array
  end

  def organization_roles
    object.organization_roles_array
  end

  def invention_roles
    object.invention_roles_array
  end

  def is_expired
    object.expired?
  end

  def home_address
    h_address = object.home_address
    AddressSerializer.new(h_address) if h_address
  end

  def work_address
    w_address = object.work_address
    AddressSerializer.new(w_address) if w_address
  end

  def organizations
    current_organizations = object.organizations.distinct
    OrganizationSimpleSerializer.build_array(current_organizations, user: object)
  end

  def expires_time
    object.expires_at.to_i
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
