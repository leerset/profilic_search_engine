class InventionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_time, :updated_time,
    :inventor, :co_inventors,
    :organization, :opportunity

  def inventor
    UserSerializer.new(object.inventor)
  end

  def co_inventors
    UserSerializer.build_array(object.co_inventors)
  end

  def organization
    OrganizationSerializer.new(object.organization)
  end

  def opportunity
    InventionOpportunitySerializer.new(object.invention_opportunity)
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
