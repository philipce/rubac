require 'minitest/autorun'
require 'rubac/role'

class RoleTest < MiniTest::Test
  def test_role_has_users
    assert_equal ['users'], Role.new.users
  end

  def test_role_has_permissions
    assert_equal ['permissions'], Role.new.permissions
  end
end

