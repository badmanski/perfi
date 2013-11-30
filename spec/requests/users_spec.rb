require 'spec_helper'

def ensure_failure
  expect(current_path).to eq root_path
  within '.alert' do
    ensure_has 'You are not authorized to access other user accounts'
  end
end

describe 'Users' do
  describe 'Admin logged in' do
    before(:all) do
      DatabaseCleaner.clean
      @user = User.make!(admin: true)
    end

    before(:each) do
      login(@user)
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

  describe 'Regular user logged in' do
    before(:all) do
      DatabaseCleaner.clean
      @user = User.make!
      @other_user = User.make!
    end

    before(:each) do
      login(@user)
    end

    it 'can not access users path' do
      visit users_path
      ensure_failure
    end

    it 'can not access other user accounts' do
      visit user_path(@other_user)
      ensure_failure
    end

    it 'can not edit other user accounts' do
      visit edit_user_path(@other_user)
      ensure_failure
    end

    it 'can acceess own user account' do
      visit user_path(@user)
      expect(current_path).to eq user_path(@user)
      ensure_has(@user.name, @user.email)
    end

    it 'can edit own user account' do
      visit edit_user_path(@user)
      within 'form' do
        fill_in 'Name', with: 'New Name'
        fill_in 'Email', with: 'mynewemail@service.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password Confirmation', with: 'password'
        click_button 'Update Profile'
      end
      expect(current_path).to eq user_path(@user)
      ensure_has 'User was successfully updated'
    end
  end

  describe 'Sign up' do
    before(:all) do
      DatabaseCleaner.clean
    end

    before(:each) do
      visit signup_path
    end

    it 'signs up successfully' do
      within 'form' do
        fill_in 'Name', with: 'New User'
        fill_in 'Email', with: 'newuser@service.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password Confirmation', with: 'password'
        click_button 'Register'
      end
     expect(current_path).to eq root_path
     ensure_has 'User was successfully created'
    end

    it 'fails to sign up if required fields are not filled' do
      within 'form' do
        click_button 'Register'
      end
      ensure_has(
        "Name can't be blank",
        "Email can't be blank",
        "Password can't be blank",
        "Password confirmation can't be blank"
        )
    end

    it 'fails to sign up if password doesnt match confirmation' do
      within 'form' do
        fill_in 'Name', with: 'Another User'
        fill_in 'Email', with: 'anotheruser@service.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password Confirmation', with: 'notmatch'
        click_button 'Register'
      end
      ensure_has "Password confirmation doesn't match Password"
    end
  end
end
