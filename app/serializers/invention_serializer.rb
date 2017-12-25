class InventionSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_time, :updated_time, :organization

  def organization
    OrganizationSerializer.new(object.organization)
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
