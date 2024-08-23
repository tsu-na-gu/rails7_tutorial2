require 'rails_helper'

RSpec.describe 'Session', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '#new' do
    context 'in case of invalid value' do
      it 'should be shown flash message' do
        visit login_path

        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        click_button "Log in"

        expect(page).to have_selector 'div.alert.alert-danger'

        visit root_path
        expect(page).to_not have_selector 'div.alert.alert-danger'
      end
    end

    context 'in case of valid value' do
      let(:user) { FactoryBot.create(:user) }

      it "should be shown login page" do
         visit login_path

          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button 'Log in'

         expect(page).not_to have_selector "a[href=\"#{login_path}\"]"
         expect(page).to have_selector "a[href=\"#{logout_path}\"]"
         expect(page).to have_selector "a[href=\"#{user_path(user)}\"]"
      end
    end
  end
  describe 'DELETE /logout' do
    it 'could be possible to logout' do
      user = FactoryBot.create(:user)
      post login_path, params: { session: { email: user.email,
                                            password: user.password}}
      expect(logged_in?).to be_truthy

      delete logout_path
      expect(logged_in?).to_not be_truthy
    end
  end
end