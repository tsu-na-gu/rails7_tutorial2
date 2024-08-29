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

  describe '#index' do
    let!(:admin) { FactoryBot.create(:user) }
    let!(:not_admin) { FactoryBot.create(:archer) }

    it "should display delete link if admin user" do
      log_in admin
      visit users_path

      expect(page).to have_link 'delete'
    end

    it 'should not have link if not admin user' do
      log_in not_admin
      visit users_path

      expect(page).to_not have_link 'delete'
    end
  end
end