require 'test_helper'

class UserRoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "god number" do
    gods = UserRole.where(role: Role.find_by(code: 'god'))
    assert gods.size > 0
  end
end
