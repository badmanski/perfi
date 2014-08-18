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
end
