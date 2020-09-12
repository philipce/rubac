require 'minitest/autorun'
require 'rubac/permission'

class PermissionTest < MiniTest::Test
  def setup
    @permission = Permission.new('object', 'action')
  end

  def test_permission_has_roles
    assert_equal ['roles'], @permission.roles
  end

  def test_permission_has_conditions
    assert_equal ['conditions'], @permission.conditions
    assert_equal ['conditions for roles'], @permission.conditions(roles: 'roles')
  end
end

