class InventionListSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :keywords, :created_time, :updated_time,
    :phase, :role, :bulk_read_access,
    :inventor, :organization, :opportunity, :comments_count
  attribute :archived, if: :owner?

  def self.eager_load_array(array)
    array.includes(
      [comments: :user],
      :organization,
      :invention_opportunity,
      [invention_opportunity: :upload_file],
      [invention_opportunity: {organization: :addresses}],
      [user_inventions: :role]
    )
  end

  def owner?
    (user_id = instance_options[:user_id]).present? && object.owner?(user_id)
  end

  def comments_count
    object.comments.size
  end

  def inventor
    return nil if object.inventor.nil?
    UserInventionSerializer.new(object.inventor)
  end

  def role
    if (user_id = instance_options[:user_id]).present?
      return object.user_role(user_id)
    else
      nil
    end
  end

  def organization
    return nil if object.organization.nil?
    OrganizationSimpleSerializer.new(object.organization)
  end

  def opportunity
    return nil if object.invention_opportunity.nil?
    InventionOpportunitySerializer.new(object.invention_opportunity)
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
