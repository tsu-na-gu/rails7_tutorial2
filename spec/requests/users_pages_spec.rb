require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:ok)
    end

    it 'should contain Sign up | Ruby on Rails Tutorial Sample App' do
      get signup_path
      expect(response.body).to include full_title('Sign up')
    end
  end

  describe "POST /users #create" do
    it 'should not register if the value is invalid' do
      expect {
        post users_path, params: { user: { name: '',
                                           email: 'user@invalid',
                                           password: 'foo',
                                           password_confirmation: 'bar' } }
      }.to_not change(User, :count)
    end
  end

  context 'in case of valid values' do
    let(:user_params) { {user: {name: "Sample User",
                                email: "sample@example.com",
                                password: "password",
                                password_confirmation: "password"} } }

    it 'should register successfully' do
      expect {
        post users_path, params: user_params
      }.to change(User, :count).by(1)
    end

    it 'should redirect to users/show page' do
      post users_path, params: user_params
      user = User.last
      expect(response).to redirect_to user
    end

    it 'should show up the flash message' do
      post users_path, params: user_params
      expect(flash).to be_any
    end
  end
end
