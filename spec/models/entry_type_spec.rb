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
end
