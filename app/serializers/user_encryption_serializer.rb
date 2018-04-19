class UserEncryptionSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :access_token, :expires_time, :magic_link, :is_expired, :status,
    :created_time, :updated_time,
    :firstname, :lastname, :citizenship, :screen_name, :employer, :time_zone, :personal_summary,
    :drafts_amount, :inventions_amount,
    :home_address, :work_address, :organizations,
    :resume, :resume_filepath,
    :global_roles, :organization_roles, :invention_roles,
    :user_organization_statuses

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
    AddressSerializer.new(object.home_address) if object.home_address
  end

  def work_address
    AddressSerializer.new(object.work_address) if object.work_address
  end

  def organizations
    current_organizations = object.organizations.distinct
    OrganizationSimpleSerializer.build_array(current_organizations)
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
