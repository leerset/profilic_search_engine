class ContainerSectionSerializer < ActiveModel::Serializer
  attributes :id, :invention_id, :draw, :significance,
    :landscape, :problem_summary, :gap, :problem_significance,
    :created_time, :updated_time

  def draw
    {
      content: object.draw || "",
      comments: CommentSerializer.build_array(object.draw_comments)
    }
  end

  def significance
    {
      content: object.significance || "",
      comments: CommentSerializer.build_array(object.significance_comments)
    }
  end

  def landscape
    {
      content: object.landscape || "",
      comments: CommentSerializer.build_array(object.landscape_comments)
    }
  end

  def problem_summary
    {
      content: object.problem_summary || "",
      comments: CommentSerializer.build_array(object.problem_summary_comments)
    }
  end

  def gap
    {
      content: object.gap || "",
      comments: CommentSerializer.build_array(object.gap_comments)
    }
  end

  def problem_significance
    {
      content: object.problem_significance || "",
      comments: CommentSerializer.build_array(object.problem_significance_comments)
    }
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end
end
