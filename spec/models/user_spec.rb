require 'spec_helper'

describe User do
  let(:user) { User.make! }

  describe 'callbacks' do
    it 'sets basic entry types for new user' do
      expect(user.entry_types.count).to be 2
    end
  end

  describe 'balance calculations' do
    describe 'current month' do
      let(:type_expense) { user.entry_types.find_by(name: 'Other expense') }
      let(:type_income) { user.entry_types.find_by(name: 'Other income') }

      it 'returns total of one expense' do
        type_expense.entries << Entry.make!
        expect(user.current_month_expenses).to eq 2500
      end

      it 'returns total of four expenses' do
        type_expense.entries << Entry.make!(4)
        expect(user.current_month_expenses).to eq 10_000
      end

      it 'returns total of zero expenses' do
        expect(user.current_month_expenses).to eq 0
      end

      it 'returns total of one income' do
        type_income.entries << Entry.make!
        expect(user.current_month_incomes).to eq 2500
      end

      it 'returns total of four incomes' do
        type_income.entries << Entry.make!(4)
        expect(user.current_month_incomes).to eq 10_000
      end

      it 'returns total of zero incomes' do
        expect(user.current_month_incomes).to eq 0
      end

      it 'returns positive balance' do
        type_income.entries << Entry.make!
        type_expense.entries << Entry.make!(amount: 500)
        expect(user.current_month_balance).to eq 2000
      end

      it 'returns negative balance' do
        type_expense.entries << Entry.make!
        type_income.entries << Entry.make!(amount: 500)
        expect(user.current_month_balance).to eq(-2000)
      end

      it 'returns zero balance' do
        type_expense.entries << Entry.make!
        type_income.entries << Entry.make!
        expect(user.current_month_balance).to eq 0
      end

      describe 'chart data' do
        it 'returns an array' do
          expect(user.chart_data.is_a?(Array)).to be true
        end

        it 'each element is array' do
          user.chart_data.each do |x|
            expect(x.is_a?(Array)).to be true
          end
        end

        it 'returned array has two elements' do
          user.chart_data.each do |x|
            expect(x.count).to eq 2
          end
        end

        it 'returns a string and a number' do
          user.chart_data.each do |x|
            expect(x[0].is_a?(String)).to be true
            expect(x[1].is_a?(Numeric)).to be true
          end
        end

        it 'returns a spare amount if balance is positive' do
          type_income.entries << Entry.make!
          expect(user.chart_data.flatten.include?('Spare Amount')).to be true
        end

        it 'doesnt return a spare amount if balance is negative' do
          type_expense.entries << Entry.make!
          expect(user.chart_data.flatten.include?('Spare Amount')).to be false
        end

        it 'doesnt return a spare amount if balance is zero' do
          expect(user.chart_data.flatten.include?('Spare Amount')).to be false
        end

        it 'returns total amount of each expense type' do
          type_expense.entries << Entry.make!(amount: 300)
          expect(user.chart_data[0][0]).to eq 'Other expense'
          expect(user.chart_data[0][1]).to eq 300
        end
      end
    end
  end
end
