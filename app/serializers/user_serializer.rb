class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :access_token, :expires_time, :magic_link, :is_expired, :status,
    :firstname, :lastname, :citizenship, :screen_name, :employer, :time_zone, :personal_summary,
    :home_address, :work_address,
    # :citizenships, :languages,
    :resume, :resume_filepath,
    :global_roles, :organization_roles, :invention_roles

  def global_roles
    RoleSerializer.build_array(object.roles)
  end

  def organization_roles
    object.organization_roles_hash
  end

  def invention_roles
    object.invention_roles_hash
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
    OrganizationListSerializer.build_array(object.organizations)
  end

  # def citizenships
  #   CitizenshipSerializer.build_array(object.citizenships)
  # end
  #
  # def languages
  #   LanguageSerializer.build_array(object.languages)
  # end

  def expires_time
    object.expires_at.to_i
  end

end
