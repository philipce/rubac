module Rubac
  class Permission
    def initialize(object, action, conditions, roles)
      @object = object
      @action = action
      @conditions = conditions
      @olres = roles
    end

    def evaluate(user, context)
      @conditions.all? { |condition| condition.evaluate(user, context) }
    end
  end
end

