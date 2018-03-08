class InventionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_time, :updated_time,
    :action, :action_note, :stage, :role, :uploaded_filename,
    :upload_files,
    :scratchpads,
    :inventor, :co_inventors,
    :organization, :opportunity, :comments, :searches

  def scratchpads
    ScratchpadSerializer.build_array(object.scratchpads)
  end

  def searches
    SearchSerializer.build_array(object.searches)
  end

  def comments
    CommentSerializer.build_array(object.comments)
  end

  def inventor
    UserSimpleSerializer.new(object.inventor)
  end

  def co_inventors
    UserSimpleSerializer.build_array(object.co_inventors)
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
    OrganizationSerializer.new(object.organization)
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
