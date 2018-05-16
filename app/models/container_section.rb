class ContainerSection < ApplicationRecord
  belongs_to :invention

  has_many :container_section_comments, dependent: :destroy
  has_many :comments, through: :container_section_comments
  has_many :c_constructions
  has_many :c_comparativeadvantage

  has_many :summary_container_section_comments,
    -> { where(section_name: 'summary') }, class_name: 'ContainerSectionComment'
  has_many :summary_comments, through: :summary_container_section_comments, source: :comment

  has_many :draw_container_section_comments,
    -> { where(section_name: 'draw') }, class_name: 'ContainerSectionComment'
  has_many :draw_comments, through: :draw_container_section_comments, source: :comment

  has_many :significance_container_section_comments,
    -> { where(section_name: 'significance') }, class_name: 'ContainerSectionComment'
  has_many :significance_comments, through: :significance_container_section_comments, source: :comment

  has_many :landscape_container_section_comments,
    -> { where(section_name: 'landscape') }, class_name: 'ContainerSectionComment'
  has_many :landscape_comments, through: :landscape_container_section_comments, source: :comment

  has_many :problem_summary_container_section_comments,
    -> { where(section_name: 'problem_summary') }, class_name: 'ContainerSectionComment'
  has_many :problem_summary_comments, through: :problem_summary_container_section_comments, source: :comment

  has_many :gap_container_section_comments,
    -> { where(section_name: 'gap') }, class_name: 'ContainerSectionComment'
  has_many :gap_comments, through: :gap_container_section_comments, source: :comment

  has_many :problem_significance_container_section_comments,
    -> { where(section_name: 'problem_significance') }, class_name: 'ContainerSectionComment'
  has_many :problem_significance_comments, through: :problem_significance_container_section_comments, source: :comment

  has_many :construction_howused_container_section_comments,
    -> { where(section_name: 'construction_howused') }, class_name: 'ContainerSectionComment'
  has_many :construction_howused_comments, through: :construction_howused_container_section_comments, source: :comment

  has_many :construction_prototype_container_section_comments,
    -> { where(section_name: 'construction_prototype') }, class_name: 'ContainerSectionComment'
  has_many :construction_prototype_comments, through: :construction_prototype_container_section_comments, source: :comment

  has_many :comparativeadvantages_innovativeaspects_container_section_comments,
    -> { where(section_name: 'comparativeadvantages_innovativeaspects') }, class_name: 'ContainerSectionComment'
  has_many :comparativeadvantages_innovativeaspects_comments, through: :comparativeadvantages_innovativeaspects_container_section_comments, source: :comment

  has_many :comparativeadvantages_advantagessummary_container_section_comments,
    -> { where(section_name: 'comparativeadvantages_advantagessummary') }, class_name: 'ContainerSectionComment'
  has_many :comparativeadvantages_advantagessummary_comments, through: :comparativeadvantages_advantagessummary_container_section_comments, source: :comment

  has_many :comparativeadvantages_relevantbackground_container_section_comments,
    -> { where(section_name: 'comparativeadvantages_relevantbackground') }, class_name: 'ContainerSectionComment'
  has_many :comparativeadvantages_relevantbackground_comments, through: :comparativeadvantages_relevantbackground_container_section_comments, source: :comment

has_many :economics_need_container_section_comments,
  -> { where(section_name: 'economics_need') }, class_name: 'ContainerSectionComment'
has_many :economics_need_comments, through: :economics_need_container_section_comments, source: :comment

has_many :economics_enduser_container_section_comments,
  -> { where(section_name: 'economics_enduser') }, class_name: 'ContainerSectionComment'
has_many :economics_enduser_comments, through: :economics_enduser_container_section_comments, source: :comment

has_many :economics_keyresources_container_section_comments,
  -> { where(section_name: 'economics_keyresources') }, class_name: 'ContainerSectionComment'
has_many :economics_keyresources_comments, through: :economics_keyresources_container_section_comments, source: :comment

has_many :economics_capitalexpenditure_container_section_comments,
  -> { where(section_name: 'economics_capitalexpenditure') }, class_name: 'ContainerSectionComment'
has_many :economics_capitalexpenditure_comments, through: :economics_capitalexpenditure_container_section_comments, source: :comment

has_many :references_container_section_comments,
  -> { where(section_name: 'references') }, class_name: 'ContainerSectionComment'
has_many :references_comments, through: :references_container_section_comments, source: :comment

  SECTION_NAMES = [
    'summary',
    'draw',
    'significance',
    'landscape',
    'problem_summary',
    'gap',
    'problem_significance',
    'construction_howused',
    'construction_prototype',
    'comparativeadvantages_innovativeaspects',
    'comparativeadvantages_advantagessummary',
    'comparativeadvantages_relevantbackground',

    'economics_need',
    'economics_enduser',
    'economics_keyresources',
    'economics_capitalexpenditure',
    'references',
  ]

  has_many :c_construction_container_section_comments,
    -> { where(section_name: 'c_construction') }, class_name: 'ContainerSectionComment'
  has_many :c_construction_comments, through: :c_construction_container_section_comments, source: :comment

  has_many :c_comparativeadvantage_container_section_comments,
    -> { where(section_name: 'c_comparativeadvantage') }, class_name: 'ContainerSectionComment'
  has_many :c_comparativeadvantage_comments, through: :c_comparativeadvantage_container_section_comments, source: :comment

  COMPONENT_NAMES = [
    'c_construction',
    'c_comparativeadvantage',
  ]

end
