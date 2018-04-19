class UserSimpleSerializer < ActiveModel::Serializer
  attributes :id, :email, :status, :created_time, :updated_time,
    :fullname, :firstname, :lastname, :citizenship, :screen_name, :employer, :time_zone

  def fullname
    [object.firstname, object.lastname].compact.join(' ')
  end

  def email
    if (manage_organizations = instance_options[:managed_organizations]).present?
      return object.email if (object.organizations & manage_organizations).any?
    end
    return nil
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
