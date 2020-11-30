require 'minitest/autorun'
require 'rubac/condition'
require 'rubac/permission'

describe Rubac::Permission do
  let(:object) { 'object' }
  let(:action) { 'action' }
  let(:roles) { [OpenStruct.new(name: 'role'), OpenStruct.new(name: 'other role')] }
  let(:permission) { Rubac::Permission.new(object, action, conditions, roles) }
  let(:user) { OpenStruct.new name: "juniper" }
  let(:context) { OpenStruct.new }

  let(:evaluation) { permission.evaluate(user, context) }

  let(:good_conditions) { 2.times.map { Class.new(Rubac::Condition) } }
  let(:bad_condition) { Class.new(Rubac::Condition) }

  before do
    good_conditions.each { |klass| klass.define_method(:evaluate) { |user, context| true } }
    bad_condition.define_method(:evaluate) { |user, context| false }
  end

  describe "when there are no conditions" do
    let(:conditions) { [] }
    it { _(evaluation).must_equal true }
  end

  describe "when all conditions evaluate to true" do
    let(:conditions) { good_conditions.map(&:new) }
    it { _(evaluation).must_equal true }
  end

  describe "when some condition evaluates to false" do
    let(:conditions) { [*good_conditions, bad_condition].map(&:new) }
    it { _(evaluation).must_equal false }
  end
end

