require 'spec_helper'

describe Entry do
  let(:entry) { Entry.make! }

  describe 'scopes' do
    describe 'negative and positive' do
      let(:positive) { Entry.make! }

      let(:negative) do
        Entry.make!(entry_type: EntryType.make!(positive: false))
      end

      describe '.positive' do
        it 'returns only positive entries' do
          expect(Entry.incomes.include?(positive)).to be true
          expect(Entry.incomes.include?(negative)).to be false
        end
      end

      describe '.negative' do
        it 'returns only negative entries' do
          expect(Entry.expenses.include?(negative)).to be true
          expect(Entry.expenses.include?(positive)).to be false
        end
      end
    end

    describe 'time ranges' do
      let!(:entry) { Entry.make! }

      describe '.current_month' do
        it 'includes entry in current month scope' do
          expect(Entry.current_month.include?(entry)).to be true
        end

        it 'doesnt include entry in current month scope' do
          Timecop.travel(Date.today + 60.days)
          expect(Entry.current_month.include?(entry)).to be false
          Timecop.return
        end
      end
    end
  end

  describe 'aliases' do
    context '#type' do
      it 'returns entry type' do
        expect(entry.type).to be entry.entry_type
      end
    end
  end

  describe 'delegates' do
    describe 'type' do
      context '#name' do
        it 'responds to #name' do
          expect(entry).to respond_to :name
        end

        it 'returns type name' do
          expect(entry.type_name).to eq entry.type.name
        end
      end

      context '#user' do
        it 'responds to #user' do
          expect(entry).to respond_to :user
        end

        it 'returns type user' do
          expect(entry.user).to eq entry.type.user
        end
      end
    end
  end

  describe 'default values' do
    describe '#set_name' do
      it 'sets entry type value as default' do
        expect(entry.name).to eq entry.type_name
      end

      it 'overrides entry type name with its own name' do
        entry = Entry.make!(name: 'Own name')
        expect(entry.name).not_to eq entry.type_name
        expect(entry.name).to eq 'Own name'
      end
    end
  end

  describe '#total_amount' do
    it 'returns total amount of one entries' do
      Entry.make!(amount: 2000)
      expect(Entry.total_amount).to eq 2000
    end

    it 'returns total amount of four entries' do
      Entry.make!(4, amount: 2000)
      expect(Entry.total_amount).to eq 8_000
    end

    it 'returns total amount of zero entries' do
      expect(Entry.total_amount).to eq 0
    end
  end

  describe '#update_user_balance!' do
    context 'success' do
      let(:entry) do
        Entry.make!(entry_type: EntryType.make!(user: User.make!(balance: 500)))
      end

      it 'responds to #update_user_balance!' do
        expect(entry).to respond_to :update_user_balance!
      end

      it 'sends :update_attributes to user' do
        entry.user.update_attributes(balance: 500)
        expect(entry.user)
          .to receive(:update_attributes).with(balance: 3_000.to_d)
        entry.update_user_balance!
      end
    end

    context 'failure' do
      it 'raises Module::DelegationError if no entry_type' do
        expect { Entry.new.update_user_balance! }
          .to raise_error Module::DelegationError
      end

      it 'raises TypeError if no amount' do
        entry = Entry.make(entry_type: EntryType.make!, amount: nil)
        expect { entry.update_user_balance! }.to raise_error TypeError
      end
    end
  end

  describe '#update_user_balance' do
    it 'calls #update_user_balance' do
      expect(entry).to receive :update_user_balance!
      entry.update_user_balance
    end

    it 'returns false in case of error' do
      expect(Entry.new.update_user_balance).to be false
    end
  end
end
