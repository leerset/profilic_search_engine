class PeopleSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :access_token, :expires_time, :magic_link, :is_expired, :status,
    :fullname, :firstname, :lastname, :citizenship, :screen_name, :employer, :time_zone, :personal_summary,
    :home_address, :work_address, :organizations,
    :resume, :resume_filepath,
    :global_roles, :organization_roles, :invention_roles,
    :user_organization_statuses
  attribute :global_status, if: :god?

  def myself?
    (myself = instance_options[:myself]).present? && myself
  end

  def god?
    (god = instance_options[:god]).present? && god
  end

  def manager?
    (user_id = instance_options[:user_id]).present? && object.manager?(User.find_by_id(user_id))
  end

  def global_status
    object.status
  end

  def fullname
    [object.firstname, object.lastname].compact.join(' ')
  end

  def user_organization_statuses
    manage_organizations = instance_options[:managed_organizations]
    current_user_organization_statuses = if manage_organizations
      object.user_organization_statuses.includes(:user, :organization).where(organization: manage_organizations)
    else
      object.user_organization_statuses.includes(:user, :organization)
    end
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
    AddressSerializer.new(object.home_address, show_phone_number: myself? || god? || manager?) if object.home_address
  end

  def work_address
    AddressSerializer.new(object.work_address, show_phone_number: myself? || god? || manager?) if object.work_address
  end

  def organizations
    OrganizationListSerializer.build_array(object.organizations, user: object)
  end

  def expires_time
    object.expires_at.to_i
  end

end
