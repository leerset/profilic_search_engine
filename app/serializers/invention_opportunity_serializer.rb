class InventionOpportunitySerializer < ActiveModel::Serializer
  attributes :id, :title, :short_description, :closing_date, :closing_time,
    :created_time, :status, :uploaded_filename, :organization

  def self.eager_load_array(array)
    array.includes(
      [organization: :addresses]
    )
  end

  def short_description
    object.short_description
  end

  def created_time
    object.created_at.to_i
  end

  def closing_time
    return nil if object.closing_date.nil?
    object.closing_date.to_time.to_i
  end

  def uploaded_filename
    if object.upload_file.present?
      object.upload_file.upload_file_name
    else
      nil
    end
  end

  def organization
    OrganizationSimpleSerializer.new(object.organization)
  end

end
