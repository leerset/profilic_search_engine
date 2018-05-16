class CComparativeadvantageSerializer < ActiveModel::Serializer
  attributes :id, :type, :completion, :items, :created_time, :updated_time

  def type
    object.c_type
  end

  def items
    {
      competing_howworks: {
        content: object.competing_howworks
      },
      shortcomings: {
        content: object.shortcomings
      },
      howovercomes_shortcomings: {
        content: object.howovercomes_shortcomings
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
