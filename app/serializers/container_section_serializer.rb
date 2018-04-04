class ContainerSectionSerializer < ActiveModel::Serializer
  attributes :id, :invention_id, :draw, :significance,
    :landscape, :problem_summary, :gap, :problem_significance,
    :created_time, :updated_time

  def draw
    {
      completion: object.draw_completion,
      content: object.draw || "",
      comments: CommentSerializer.build_array(object.draw_comments)
    }
  end

  def significance
    {
      completion: object.significance_completion,
      content: object.significance || "",
      comments: CommentSerializer.build_array(object.significance_comments)
    }
  end

  def landscape
    {
      completion: object.landscape_completion,
      content: object.landscape || "",
      comments: CommentSerializer.build_array(object.landscape_comments)
    }
  end

  def problem_summary
    {
      completion: object.problem_summary_completion,
      content: object.problem_summary || "",
      comments: CommentSerializer.build_array(object.problem_summary_comments)
    }
  end

  def gap
    {
      completion: object.gap_completion,
      content: object.gap || "",
      comments: CommentSerializer.build_array(object.gap_comments)
    }
  end

  def problem_significance
    {
      completion: object.problem_significance_completion,
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
