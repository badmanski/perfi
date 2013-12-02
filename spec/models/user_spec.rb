require 'spec_helper'

describe User do
  before(:all) do
    DatabaseCleaner.clean
  end

  describe 'Callbacks' do
    it 'sets basic entry types for new user' do
      @user = User.make!
      expect(@user.entry_types.count).to be 2
    end
  end
end
