class CConstructionSerializer < ActiveModel::Serializer
  attributes :id, :type, :completion, :items, :created_time, :updated_time

  def type
    object.c_type
  end

  def items
    result = {}
    CConstruction::ItemNames.each do |item_name|
      result[item_name.to_sym] = {content: object.send(item_name)}
    end
    result
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end
end
