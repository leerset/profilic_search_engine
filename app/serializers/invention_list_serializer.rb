class InventionListSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_time, :updated_time, :organization_name

  def organization_name
    object.organization.name
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
