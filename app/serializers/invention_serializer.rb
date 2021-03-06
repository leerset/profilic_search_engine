class InventionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :keywords,
    :search_list, :search_results,
    :created_time, :updated_time,
    :action, :action_note, :phase, :role, :uploaded_filename, :scratchpad,
    :bulk_read_access, :archived,
    :inventor, :co_inventors, :collaborators,
    :upload_files, :container_section,
    :organization, :opportunity, :comments, :searches,
    :last_modifier, :last_modified_time
  attribute :archived, if: :owner?

  def self.eager_load_array(array)
    array.includes(
      :scratchpad,
      :upload_files,
      [comments: :user],
      :organization,
      :searches,
      :container_section,
      :invention_opportunity,
      [invention_opportunity: :upload_file],
      [invention_opportunity: {organization: :addresses}],
      [user_inventions: :role]
    )
  end

  def owner?
    (user_id = instance_options[:user_id]).present? && object.owner?(user_id)
  end

  def last_modifier
    return nil if object.last_modifier.nil?
    UserInventionSerializer.new(object.last_modifier)
  end

  def last_modified_time
    object.updated_at.to_i
  end

  def scratchpad
    scratchpad = object.scratchpad || object.create_scratchpad
    ScratchpadSerializer.new(scratchpad)
  end

  def container_section
    container_section = object.container_section
    return nil if container_section.nil?
    return ContainerSectionSerializer.new(container_section)
  end

  def searches
    SearchSerializer.build_array(object.searches)
  end

  def comments
    CommentSerializer.build_array(object.comments)
  end

  def inventor
    return nil if object.inventor.nil?
    UserInventionSerializer.new(object.inventor)
  end

  def collaborators
    UserInventionSerializer.build_array(object.collaborators)
  end

  def co_inventors
    UserInventionSerializer.build_array(object.collaborators)
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
