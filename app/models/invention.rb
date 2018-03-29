class Invention < ApplicationRecord
  belongs_to :organization, optional: true
  belongs_to :invention_opportunity, optional: true
  has_many :user_inventions, dependent: :destroy
  has_many :users, through: :user_inventions
  has_many :invention_upload_files, dependent: :destroy
  has_many :upload_files, through: :invention_upload_files
  has_many :invention_comments, dependent: :destroy
  has_many :comments, through: :invention_comments
  has_many :invention_searches, dependent: :destroy
  has_many :searches, through: :invention_searches
  has_one :scratchpad, dependent: :destroy
  has_one :container_section, dependent: :destroy

  # enum bulk_read_access: [
  #   'anyone-organization',
  #   'only-inventors'
  # ]

  IN_CONTENT_TYPES = [
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/pdf'
  ]

  def inventor
    user_inventions.select {|ui| ui.role.code == "inventor"}.first
  end

  def co_inventors
    user_inventions.select {|ui| ui.role.code == "co_inventor"}
  end

  def mentors
    user_inventions.select {|ui| ui.role.code == "mentor"}
  end

  def user_role(user_id)
    user_inventions.select {|ui| ui.user_id == user_id}.first.try(:role).try(:name)
  end

end
