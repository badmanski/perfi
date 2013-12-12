require 'spec_helper'

describe EntryType do
  before(:all) do
    DatabaseCleaner.clean
  end

  describe 'Set default values' do
    it 'sets current user id before validation' do
      @user = User.make!.make_current
      @type = EntryType.make!(user: nil)
      expect(@type.user).to eq @user
    end
  end

  describe 'Total amount' do
    before(:each) do
      DatabaseCleaner.clean
      @type = EntryType.make!
    end

    it 'returns total amount of type with one entry' do
      Entry.make!(entry_type: @type)
      expect(@type.total_amount).to eq 2500
    end

    it 'returns total amount of type with four entries' do
      Entry.make!(4, entry_type: @type)
      expect(@type.total_amount).to eq 10_000
    end

    it 'returns total amount of type with zero entries' do
      expect(@type.total_amount).to eq 0
    end
  end
end
