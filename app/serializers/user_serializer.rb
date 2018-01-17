class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :access_token, :expires_time, :magic_link, :is_expired, :status,
    :firstname, :lastname, :citizenship, :screen_name, :employer, :time_zone, :personal_summary,
    :home_address, :work_address, :organizations,
    :resume, :resume_filepath,
    :global_roles, :organization_roles, :invention_roles,
    :user_organization_statuses

  def user_organization_statuses
    manage_organizations = instance_options[:manage_organizations]
    current_user_organization_statuses = if manage_organizations
      object.user_organization_statuses.where(organization: manage_organizations)
    else
      object.user_organization_statuses
    end
    UserOrganizationStatusSerializer.build_array(current_user_organization_statuses)
  end

  def global_roles
    object.global_roles_array
  end

  def organization_roles
    manage_organizations = instance_options[:manage_organizations]
    if manage_organizations
      object.organization_roles_array_in_organizations(manage_organizations)
    else
      object.organization_roles_array
    end
  end

  def invention_roles
    manage_organizations = instance_options[:manage_organizations]
    if manage_organizations
      object.invention_roles_array_in_organizations(manage_organizations)
    else
      object.invention_roles_array
    end
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
    manage_organizations = instance_options[:manage_organizations]
    current_organizations = if manage_organizations
      manage_organizations.where.not(id: object.organizations.map(&:id))
    else
      object.organizations.uniq
    end
    OrganizationListSerializer.build_array(current_organizations)
  end

  def expires_time
    object.expires_at.to_i
  end

end
