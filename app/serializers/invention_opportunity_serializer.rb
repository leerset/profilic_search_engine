class InventionOpportunitySerializer < ActiveModel::Serializer
  attributes :id, :title, :street, :expires, :status, :uploaded_filename, :organization

  def street
    object.short_description
  end

  def expires
    object.closing_date.strftime('%b %d, %Y')
  end

  def uploaded_filename
    if object.upload_file.present?
      object.upload_file.upload_file_name
    else
      nil
    end
  end

  def organization
    OrganizationSerializer.new(object.organization)
  end

end
