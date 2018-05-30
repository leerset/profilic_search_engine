class ContainerSection < ApplicationRecord
  belongs_to :invention

  has_many :container_section_comments, dependent: :destroy
  has_many :comments, through: :container_section_comments
  has_many :c_constructions
  alias_attribute :c_construction, :c_constructions
  has_many :c_comparativeadvantages

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
    'comparativeadvantages_specificrelevantbackground',

    'economics_need',
    'economics_enduser',
    'economics_keyresources',
    'economics_capitalexpenditure',
    'references',

    'economics_estimatedincrementalcost',
    'economics_feasiblyeconomical',
    'economics_whomake',
    'economics_howmakemoney',
    'economics_howdelivered',
    'economics_economicburden',
    'economics_currentsolutioncosts',
    'economics_consumercosts',
  ]

  SECTION_NAMES.each do |name|
    has_many "#{name}_container_section_comments".to_sym,
      -> { where(section_name: name) }, class_name: 'ContainerSectionComment'
    has_many "#{name}_comments".to_sym, through: "#{name}_container_section_comments".to_sym, source: :comment
  end

  # has_many :summary_container_section_comments,
  #   -> { where(section_name: 'summary') }, class_name: 'ContainerSectionComment'
  # has_many :summary_comments, through: :summary_container_section_comments, source: :comment

  COMPONENT_NAMES = [
    'c_construction',
    'c_comparativeadvantages',
  ]

  COMPONENT_NAMES.each do |name|
    has_many "#{name}_container_section_comments".to_sym,
      -> { where(section_name: name) }, class_name: 'ContainerSectionComment'
    has_many "#{name}_comments".to_sym, through: "#{name}_container_section_comments".to_sym, source: :comment
  end

  # has_many :c_construction_container_section_comments,
  #   -> { where(section_name: 'c_construction') }, class_name: 'ContainerSectionComment'
  # has_many :c_construction_comments, through: :c_construction_container_section_comments, source: :comment
  #
  # has_many :c_comparativeadvantages_container_section_comments,
  #   -> { where(section_name: 'c_comparativeadvantages') }, class_name: 'ContainerSectionComment'
  # has_many :c_comparativeadvantages_comments, through: :c_comparativeadvantages_container_section_comments, source: :comment

  COMPONENT_CLASS_MAPPING = {
    'c_construction' => CConstruction,
    'c_comparativeadvantages' => CComparativeadvantage
  }

  SERIALIZER_CLASS_MAPPING = {
    'c_construction' => CConstructionSerializer,
    'c_comparativeadvantages' => CComparativeadvantageSerializer
  }
end
