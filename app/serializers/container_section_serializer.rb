class ContainerSectionSerializer < ActiveModel::Serializer
  attributes :id, :invention_id, :draw, :significance,
    :landscape, :problem_summary, :gap, :problem_significance,
    :created_time, :updated_time

  def draw
    {content: object.draw || ""}
  end

  def significance
    {content: object.significance || ""}
  end

  def landscape
    {content: object.landscape || ""}
  end

  def problem_summary
    {content: object.problem_summary || ""}
  end

  def gap
    {content: object.gap || ""}
  end

  def problem_significance
    {content: object.problem_significance || ""}
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end
end
