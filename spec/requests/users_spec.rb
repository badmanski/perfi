require 'spec_helper'

describe 'Users' do
  describe 'Admin logged in' do
    before(:all) do
      DatabaseCleaner.clean
      @user = User.make!(admin: true)
    end

    describe 'Index view' do
      before(:each) do
        visit users_path
      end

      it 'visits users index' do
        expect(current_path).to eq users_path
      end

      it 'views users list on index' do
        within 'table' do
          ensure_has(@user.name, @user.email)
        end
      end

      it 'clicks on user name' do
        within 'table' do
          click_link @user.name
        end
        expect(current_path).to eq user_path(@user)
      end
    end

    describe 'Show view' do
      before(:each) do
        visit user_path(@user)
      end

      it 'visits show view' do
        expect(current_path).to eq user_path(@user)
      end

      it 'sees user details' do
        ensure_has(@user.name, @user.email)
      end
    end
  end
end
