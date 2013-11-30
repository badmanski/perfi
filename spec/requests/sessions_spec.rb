require 'spec_helper'

describe 'Session management' do
  describe 'Logging in' do
    before(:all) do
      DatabaseCleaner.clean
      @user = User.make!(admin: true)
    end

    describe 'Successful log in' do
      before(:each) do
        login(@user)
      end

      it 'redirects to dashboard' do
        expect(current_path).to eq root_path
      end

      it 'shows greeting alert' do
        within '.alert' do
          ensure_has("Welcome, #{@user.name}!")
        end
      end
    end

    describe 'Login failures' do
      before(:each) do
        visit login_path
      end

      after(:each) do
        expect(current_path).to eq login_path
        within '.alert' do
          ensure_has('Log in failed!')
        end
      end

      it 'fails to log in if email doesnt exist' do
        within 'form' do
          fill_in 'Email', with: 'inerverexisted@finance.com'
          fill_in 'Password', with: 'password'
          click_button 'Log in'
        end
      end

      it 'fails to log in if wrong password provided' do
        within 'form' do
          fill_in 'Email', with: @user.email
          fill_in 'Password', with: 'wrongpass'
          click_button 'Log in'
        end
      end

      it 'fails to log in if no email provided' do
        within 'form' do
          fill_in 'Password', with: 'password'
          click_button 'Log in'
        end
      end

      it 'fails to log in if no password provided' do
        within 'form' do
          fill_in 'Email', with: 'inerverexisted@finance.com'
          click_button 'Log in'
        end
      end

      it 'fails to log in if nothing provided' do
        within 'form' do
          click_button 'Log in'
        end
      end
    end
  end
end
