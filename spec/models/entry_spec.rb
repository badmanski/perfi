require 'spec_helper'

describe Entry do
  describe 'Shortenings' do
    before(:all) do
      DatabaseCleaner.clean
      @entry = Entry.make!
    end

    it 'returns entry type' do
      expect(@entry.type).to be @entry.entry_type
    end
  end

  describe 'Set default values' do
    before(:all) do
      DatabaseCleaner.clean
    end

    it 'sets entry type value as default' do
      @entry = Entry.make!
      expect(@entry.name).to eq @entry.type_name
    end

    it 'overrides entry type name with its own name' do
      @entry = Entry.make!(name: 'Own name')
      expect(@entry.name).not_to eq @entry.type_name
      expect(@entry.name).to eq 'Own name'
    end
  end
end
