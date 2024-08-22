RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "#create" do
    context 'in case of invalid value' do
      it 'should require error message show in display' do
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'user@invalid'
        fill_in 'Password', with: 'foo'
        fill_in 'Confirmation', with: 'bar'
        click_button 'Create my account'

        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.alert-danger'
      end
    end
  end
end