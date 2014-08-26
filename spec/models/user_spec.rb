require 'spec_helper'

describe User do
  let(:user) { User.make! }

  describe 'callbacks' do
    it 'sets basic entry types for new user' do
      expect(user.entry_types.count).to be 2
    end
  end

  describe 'balance calculations' do
    let(:type_expense) { user.entry_types.find_by(name: 'Other expense') }
    let(:type_income) { user.entry_types.find_by(name: 'Other income') }

    describe 'at beginning of month' do
      it 'returns no balance' do
        expect(user.balance_at_beginning_of_month).to eq 0
      end

      it 'returns positive balance' do
        one_month_ago { type_expense.entries << Entry.make!(amount: 500) }
        expect(user.balance_at_beginning_of_month).to eq(-500)
      end

      it 'returns negative balance' do
        one_month_ago { type_income.entries << Entry.make!(amount: 500) }
        expect(user.balance_at_beginning_of_month).to eq 500
      end
    end

    describe 'current month' do
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
        let(:data) { user.chart_data }

        it 'returns a hash' do
          expect(data.is_a?(Hash)).to be true
        end

        it 'values are numbers' do
          data.values.each do |x|
            expect(x.is_a?(Numeric)).to be true
          end
        end

        it 'returns a spare amount if balance is positive' do
          type_income.entries << Entry.make!(amount: 200)
          expect(data['Spare Amount']).to eq 200
        end

        it 'doesnt return a spare amount if balance is negative' do
          type_expense.entries << Entry.make!
          expect(data['Spare Amount']).to be nil
        end

        it 'doesnt return a spare amount if balance is zero' do
          expect(data['Spare Amount']).to be nil
        end

        it 'returns total amount of each expense type' do
          type_expense.entries << Entry.make!(amount: 300)
          expect(data[type_expense.name]).to eq 300
        end
      end
    end
  end
end
