class CConstructionSerializer < ActiveModel::Serializer
  attributes :id, :type, :items, :created_time, :updated_time

  def type
    object.c_type
  end

  def items
    {
      ideal_example: {
        content: object.ideal_example
      },
      properties: {
        content: object.properties
      },
      how_made: {
        content: object.how_made
      },
      innovative_aspects: {
        content: object.innovative_aspects
      },
      why_hasnt_done_before: {
        content: object.why_hasnt_done_before
      }
    }
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end
end
