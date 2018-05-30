class ContainerSectionSerializer < ActiveModel::Serializer
  attributes :id, :invention_id,
    :summary, :draw, :significance,
    :landscape, :problem_summary, :gap, :problem_significance,
    :construction_howused,
    :construction_prototype,
    :comparativeadvantages_innovativeaspects,
    :comparativeadvantages_advantagessummary,
    :comparativeadvantages_relevantbackground,
    :comparativeadvantages_specificrelevantbackground,
    :economics_need,
    :economics_enduser,
    :economics_keyresources,
    :economics_capitalexpenditure,
    :references,
    :c_construction,
    :c_comparativeadvantages,
    :created_time, :updated_time

  def c_construction
    {
      completion: object.c_construction_completion,
      comments: CommentSerializer.build_array(object.c_construction_comments),
      components: CConstructionSerializer.build_array(object.c_constructions)
    }
  end

  def c_comparativeadvantages
    {
      completion: object.c_comparativeadvantages_completion,
      comments: CommentSerializer.build_array(object.c_comparativeadvantages_comments),
      components: CComparativeadvantageSerializer.build_array(object.c_comparativeadvantages)
    }
  end

  def summary
    {
      completion: object.summary_completion,
      content: object.summary || "",
      comments: CommentSerializer.build_array(object.summary_comments)
    }
  end

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

  def construction_howused
    {
      completion: object.construction_howused_completion,
      content: object.construction_howused || "",
      comments: CommentSerializer.build_array(object.construction_howused_comments)
    }
  end

  def construction_prototype
    {
      completion: object.construction_prototype_completion,
      content: object.construction_prototype || "",
      comments: CommentSerializer.build_array(object.construction_prototype_comments)
    }
  end

  def comparativeadvantages_innovativeaspects
    {
      completion: object.comparativeadvantages_innovativeaspects_completion,
      content: object.comparativeadvantages_innovativeaspects || "",
      comments: CommentSerializer.build_array(object.comparativeadvantages_innovativeaspects_comments)
    }
  end

  def comparativeadvantages_advantagessummary
    {
      completion: object.comparativeadvantages_advantagessummary_completion,
      content: object.comparativeadvantages_advantagessummary || "",
      comments: CommentSerializer.build_array(object.comparativeadvantages_advantagessummary_comments)
    }
  end

  def comparativeadvantages_relevantbackground
    {
      completion: object.comparativeadvantages_relevantbackground_completion,
      content: object.comparativeadvantages_relevantbackground || "",
      comments: CommentSerializer.build_array(object.comparativeadvantages_relevantbackground_comments)
    }
  end

  def comparativeadvantages_specificrelevantbackground
    {
      completion: object.comparativeadvantages_specificrelevantbackground_completion,
      content: object.comparativeadvantages_specificrelevantbackground || "",
      comments: CommentSerializer.build_array(object.comparativeadvantages_specificrelevantbackground_comments)
    }
  end

  def economics_need
    {
      completion: object.economics_need_completion,
      content: object.economics_need || "",
      comments: CommentSerializer.build_array(object.economics_need_comments)
    }
  end

  def economics_enduser
    {
      completion: object.economics_enduser_completion,
      content: object.economics_enduser || "",
      comments: CommentSerializer.build_array(object.economics_enduser_comments)
    }
  end

  def economics_keyresources
    {
      completion: object.economics_keyresources_completion,
      content: object.economics_keyresources || "",
      comments: CommentSerializer.build_array(object.economics_keyresources_comments)
    }
  end

  def economics_capitalexpenditure
    {
      completion: object.economics_capitalexpenditure_completion,
      content: object.economics_capitalexpenditure || "",
      comments: CommentSerializer.build_array(object.economics_capitalexpenditure_comments)
    }
  end

  def references
    {
      completion: object.references_completion,
      content: object.references || "",
      comments: CommentSerializer.build_array(object.references_comments)
    }
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end
end
