class Permission
  def initialize(object, action)
    @object = object
    @action = action
  end

  def roles
    ['roles']
  end

  def conditions(roles: nil)
    roles.nil? ? ['conditions'] : ['conditions for roles']
  end
end

