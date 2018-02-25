class Invention < ApplicationRecord
  belongs_to :organization
  belongs_to :invention_opportunity
  has_many :user_inventions
  has_many :users, through: :user_inventions
  has_many :invention_upload_files
  has_many :upload_files, through: :invention_upload_files

  IN_CONTENT_TYPES = [
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/pdf'
  ]

  def inventor
    user_inventions.joins(:role).where(roles: {code: 'inventor'}).map(&:user).first
  end

  def co_inventors
    user_inventions.joins(:role).where(roles: {code: 'co-inventor'}).map(&:user).uniq.sort
  end

end
