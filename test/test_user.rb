require 'minitest/autorun'
require 'rubac/user'

class UserTest < MiniTest::Test
  def test_user_has_roles
    assert_equal ['roles'], User.new.roles
    assert_equal ['session roles'], User.new.roles(session: OpenStruct.new)
  end
end

