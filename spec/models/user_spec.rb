require 'spec_helper'

describe User do
  let(:user) { User.make! }

  describe 'callbacks' do
    it 'sets basic entry types for new user' do
      expect(user.entry_types.count).to be 2
    end
  end

  describe '#chart_data' do
    let(:data) { user.chart_data }

    it 'returns a hash' do
      expect(data.is_a?(Hash)).to be true
    end

    it 'values are numbers' do
      data.values.each do |x|
        expect(x.is_a?(Numeric)).to be true
      end
    end

    it 'includes user balance' do
      type_income = user.entry_types.incomes.first
      expect(data[I18n.t(:balance)]).to eq user.balance
    end

    it 'returns total amount of each expense type' do
      type_expense = user.entry_types.expenses.first
      type_expense.entries << Entry.make!(amount: 300)
      expect(data[type_expense.name]).to eq 300
    end
  end
end
