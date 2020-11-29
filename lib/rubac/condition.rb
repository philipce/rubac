module Rubac
  class Condition
    def initialize(**options)
      @options = options
    end

    def evaluate(user, context)
      raise NotImplementedError, "must be implemented in child class"
    end
  end
end

