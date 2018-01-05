class UserOrganization < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  belongs_to :role, optional: true

  def status
    user.user_organization_statuses.find_by(organization: organization)
  end
end
