```ruby
class Condition
  def initialize(name, args: nil)
  end

  def evaluate(user, context)
  end
end

class Permission
  attr_reader :role, :object, :action, :conditions

  def evaluate(user, context)
    conditions.all? { |condition| condition.evaluate(user, context) }
  end
end

class Operation
  attr_reader :user, :name

  def object
  end

  def action
  end

  def roles
    Repository.read_roles(user: user)
  end

  def relevant_permissions
    Repository.read_permissions(object: object, action: action, role: roles).select do |permission|
      permission.object == object && permission.action == permission.action
    end
  end
end

class Policy
  attr_reader :user, :operation_name, **options

  def intialize(user, operation_name, **options)
    @errors = []
  end

  def self.for(user, :operation_name, **options)
    policy_mapping[:operation_name].new(user, :operation_name, **options)
  end

  def evaluate
    access_control_result
  end

  def operation
    Operation.new(user, operation_name)
  end

  def access_control_result
    operation.relevant_permissions.any? do |permission|
      permission.evaluate? user, context
    end.tap do |authorized|
      add_error("Inadequate permissions to #{operation.action} #{operation.object}")
    end
  end

  def add_error(message, **options)
    @errors << { :message => message, **options }
  end
end

module Rubac
  def policy(user, operation_name, **options)
    Policy.for(user, :operation_name, **options)
  end

  def authorized?(user, operation_name, **options)
    policy(user, :operation_name, **options).evaluate
  end

  def authorize!(user, operation_name, **options)
    policy(user, :operation_name, **options).tap do |policy|
      raise Unauthorized, policy  unless policy.evaluate
    end
  end
end

Rubac.authorized? current_user, "cake:bake", kitchen_id: 5
```

consumer of gem needs to

1. define conditions
SpecialCondition < Rubac::Condition
end

2. operation_name ~> object:action mapping table

3. Repository
  def read_roles(user: user)
    return some kind of collection of "Role" objects
  end

  def read_permissions(object: object, action: action, roles: roles)
    return [Rubac::Permission objects]
  end
end

4. policy routing table
operation_name ~> policy
CustomPolicy < Rubac::Policy
  def evaluate
    # combine access_control_result with whatever you like
  end
end

- compound operations seem useful
- bulk policy


