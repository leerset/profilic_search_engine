class InventionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_time, :updated_time,
    :action, :action_note, :phase, :role, :uploaded_filename, :scratchpad,
    :comment_status, :archived,
    :inventor, :co_inventors,
    :upload_files, :container_sections,
    :organization, :opportunity, :comments, :searches

  def self.eager_load_array(array)
    array.includes(
      :scratchpad,
      :upload_files,
      [comments: :user],
      :organization,
      :searches,
      :container_sections,
      :invention_opportunity,
      [invention_opportunity: :upload_file],
      [invention_opportunity: {organization: :addresses}],
      [user_inventions: :role]
    )
  end

  def scratchpad
    scratchpad = object.scratchpad || object.create_scratchpad
    ScratchpadSerializer.new(scratchpad)
  end

  def container_sections
    ContainerSectionSerializer.build_array(object.container_sections)
  end

  def searches
    SearchSerializer.build_array(object.searches)
  end

  def comments
    CommentSerializer.build_array(object.comments)
  end

  def inventor
    UserInventionSerializer.new(object.inventor)
  end

  def co_inventors
    UserInventionSerializer.build_array(object.co_inventors)
  end

  def role
    if (user_id = instance_options[:user_id]).present?
      return object.user_role(user_id)
    else
      nil
    end
  end

  def uploaded_filename
    nil
  end

  def upload_files
    UploadFileSerializer.build_array(object.upload_files)
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
