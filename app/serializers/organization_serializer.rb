class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :time_zone, :summary, :created_time, :updated_time

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
