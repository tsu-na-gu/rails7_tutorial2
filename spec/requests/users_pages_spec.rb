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
end
