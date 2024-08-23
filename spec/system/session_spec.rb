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
  end
end