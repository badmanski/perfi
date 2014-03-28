require 'spec_helper'

describe 'Session management' do
  describe 'Logging in' do
    let(:user) { User.make!(admin: true) }

    describe 'Successful log in' do
      before(:each) { login user }

      it 'redirects to dashboard' do
        expect(current_path).to eq root_path
      end

      it 'shows greeting alert' do
        within '.alert' do
          ensure_has('Signed in successfully.')
        end
      end
    end

    describe 'Login failures' do
      before(:each) { visit sign_in_path }

      after(:each) do
        click_button 'Sign in'
        expect(current_path).to eq sign_in_path
        ensure_has('Invalid email or password.')
      end

      it 'fails to log in if email doesnt exist' do
        within 'form' do
          fill_in 'Email', with: 'inerverexisted@finance.com'
          fill_in 'Password', with: 'password'
        end
      end

      it 'fails to log in if wrong password provided' do
        within 'form' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'wrongpass'
        end
      end

      it 'fails to log in if no email provided' do
        within 'form' do
          fill_in 'Password', with: 'password'
        end
      end

      it 'fails to log in if no password provided' do
        within 'form' do
          fill_in 'Email', with: 'inerverexisted@finance.com'
        end
      end
    end
  end
end
