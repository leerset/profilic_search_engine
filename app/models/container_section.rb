class ContainerSection < ApplicationRecord
  belongs_to :invention

  has_many :container_section_comments, dependent: :destroy
  has_many :comments, through: :container_section_comments

  has_many :draw_container_section_comments,
    -> { ContainerSectionComment.where(section_name: 'draw') },
    class_name: 'ContainerSectionComment'
  has_many :draw_comments, through: :draw_container_section_comments, source: :comment

  has_many :significance_container_section_comments,
    -> { ContainerSectionComment.where(section_name: 'significance') },
    class_name: 'ContainerSectionComment'
  has_many :significance_comments, through: :significance_container_section_comments, source: :comment

  has_many :landscape_container_section_comments,
    -> { ContainerSectionComment.where(section_name: 'landscape') },
    class_name: 'ContainerSectionComment'
  has_many :landscape_comments, through: :landscape_container_section_comments, source: :comment

  has_many :problem_summary_container_section_comments,
    -> { ContainerSectionComment.where(section_name: 'problem_summary') },
    class_name: 'ContainerSectionComment'
  has_many :problem_summary_comments, through: :problem_summary_container_section_comments, source: :comment

  has_many :gap_container_section_comments,
    -> { ContainerSectionComment.where(section_name: 'gap') },
    class_name: 'ContainerSectionComment'
  has_many :gap_comments, through: :gap_container_section_comments, source: :comment

  has_many :problem_significance_container_section_comments,
    -> { ContainerSectionComment.where(section_name: 'problem_significance') },
    class_name: 'ContainerSectionComment'
  has_many :problem_significance_comments, through: :problem_significance_container_section_comments, source: :comment

end
