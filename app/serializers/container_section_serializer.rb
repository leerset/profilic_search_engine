class ContainerSectionSerializer < ActiveModel::Serializer
  attributes :id, :invention_id
  attributes ContainerSection::SECTION_NAMES.map(&:to_sym)
  attributes ContainerSection::COMPONENT_NAMES.map(&:to_sym)
  attributes :created_time, :updated_time

  ContainerSection::SECTION_NAMES.each do |name|
    define_method(name){
      {
        completion: object.send("#{name}_completion"),
        content: object.send(name) || "",
        comments: CommentSerializer.build_array(object.send("#{name}_comments"))
      }
    }
  end

  ContainerSection::COMPONENT_NAMES.each do |name|
    define_method(name){
      {
        completion: object.send("#{name}_completion"),
        comments: CommentSerializer.build_array(object.send("#{name}_comments")),
        components: ContainerSection::SERIALIZER_CLASS_MAPPING[name].build_array(object.send(name))
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
