require 'minitest/autorun'
require 'date'
require 'rubac/condition'

describe Rubac::Condition do
  describe "#evaluate" do
    let(:user) { OpenStruct.new name: "juniper" }
    let(:evaluation) { condition.evaluate user, context }

    describe "simple condition" do
      let(:condition) { cake_baker.new }
      let(:cake_baker) do
        Class.new(Rubac::Condition) do
          def evaluate(user, context)
            user == context.cake.baker
          end
        end
      end

      describe "when context cake baker is the user" do
        let(:context) { OpenStruct.new cake: OpenStruct.new(baker: user) }
        it { _(evaluation).must_equal true }
      end

      describe "when context cake baker is not the user" do
        let(:other_user) { OpenStruct.new name: "digby" }
        let(:context) { OpenStruct.new cake: OpenStruct.new(baker: other_user) }
        it { _(evaluation).must_equal false }
      end
    end

    describe "parametrized condition" do
      describe "without user comparison" do
        let(:condition) { before_expiration_date.new expiration_date: Date.parse('2020-10-31') }
        let(:before_expiration_date) do
          Class.new(Rubac::Condition) do
            def evaluate(_user, context)
              context.date < @options[:expiration_date]
            end
          end
        end

        describe "when context date is before the expiration date" do
          let(:context) { OpenStruct.new date: Date.parse('2015-10-31') }
          it { _(evaluation).must_equal true }
        end

        describe "when context date is after the expiration date" do
          let(:context) { OpenStruct.new date: Date.parse('2025-10-31') }
          it { _(evaluation).must_equal false }
        end
      end

      describe "with user comparison" do
        let(:condition) { user_kitchen_with_status.new status: 'active' }
        let(:user_kitchen_with_status) do
          Class.new(Rubac::Condition) do
            def evaluate(user, context)
              kitchens(user).include? context.kitchen
            end

            def kitchens(user)
              user.kitchens.select { |kitchen| kitchen.status == @options[:status] }
            end
          end
        end

        let(:user) { OpenStruct.new name: "juniper", kitchens: user_kitchens }
        let(:active_user_kitchen) { OpenStruct.new id: 1, status: 'active' }
        let(:inactive_user_kitchen) { OpenStruct.new id: 2, status: 'inactive' }
        let(:other_kitchen) { OpenStruct.new id: 3, status: 'active' }
        let(:user_kitchens) { [
          active_user_kitchen,
          inactive_user_kitchen,
        ] }

        describe "when the context kitchen is an active user kitchen" do
          let(:context) { OpenStruct.new kitchen: active_user_kitchen }
          it { _(evaluation).must_equal true }
        end

        describe "when the context kitchen is an inactive user kitchen" do
          let(:context) { OpenStruct.new kitchen: inactive_user_kitchen }
          it { _(evaluation).must_equal false }
        end

        describe "when the context kitchen is not a user kitchen" do
          let(:context) { OpenStruct.new kitchen: other_kitchen }
          it { _(evaluation).must_equal false }
        end
      end
    end
  end
end

