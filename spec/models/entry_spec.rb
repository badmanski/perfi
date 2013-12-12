require 'spec_helper'

describe Entry do
  before(:all) do
    DatabaseCleaner.clean
  end

  describe 'Shortenings' do
    before(:all) do
      @entry = Entry.make!
    end

    it 'returns entry type' do
      expect(@entry.type).to be @entry.entry_type
    end
  end

  describe 'Set default values' do
    it 'sets entry type value as default' do
      @entry = Entry.make!
      expect(@entry.name).to eq @entry.type_name
    end

    it 'overrides entry type name with its own name' do
      @entry = Entry.make!(name: 'Own name')
      expect(@entry.name).not_to eq @entry.type_name
      expect(@entry.name).to eq 'Own name'
    end

    describe 'Scopes' do
      before(:all) do
        @positive = Entry.make!
        @negative = Entry.make!(entry_type: EntryType.make!(positive: false))
      end

      it 'returns only positive entries' do
        expect(Entry.incomes.include?(@positive)).to be true
        expect(Entry.incomes.include?(@negative)).to be false
      end

      it 'returns only negative entries' do
        expect(Entry.expenses.include?(@negative)).to be true
        expect(Entry.expenses.include?(@positive)).to be false
      end
    end

    describe 'Total amount' do
      before(:each) do
        DatabaseCleaner.clean
      end

      it 'returns total amount of one entries' do
        @entry = Entry.make!
        expect(Entry.total_amount).to eq 2500
      end

      it 'returns total amount of four entries' do
        @entries = Entry.make!(4)
        expect(Entry.total_amount).to eq 10_000
      end

      it 'returns total amount of zero entries' do
        expect(Entry.total_amount).to eq 0
      end
    end
  end
end
