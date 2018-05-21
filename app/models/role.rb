class Role < ApplicationRecord

  ACCESS_ROLE_MAPPING = {
    1 => 'co_inventor',
    2 => 'mentor',
    3 => 'commenter',
  }

  scope :global_roles, -> { where(role_type: 'global').order(created_at: :desc) }
  scope :organization_roles, -> { where(role_type: 'organization').order(created_at: :desc) }
  scope :invention_roles, -> { where(role_type: 'invention').order(created_at: :desc) }

end
