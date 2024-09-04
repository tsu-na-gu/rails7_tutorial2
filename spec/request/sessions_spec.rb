require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status :success
    end
  end
  describe "DELETE /logout" do
    before do
      user = FactoryBot.create(:user)
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
    end
    it "should not error if two times logged out" do
      delete logout_path
      delete logout_path
      expect(response).to redirect_to root_path
    end
  end

  describe "#create remember me" do
    let(:user) { FactoryBot.create(:user) }

    it 'should not cookies[:remember_token] is empty if checked' do
        post login_path params: { session: { email: user.email,
                                             password: user.password,
                                             remember_me: '1' } }
        expect(cookies[:remember_token]).to_not be_blank
      end

      it 'should be cookies[:remember_token] is blank if not checked' do
        post login_path params: { session: { email: user.email,
                                             password: user.password,
                                             remember_me: '0' } }
        expect(cookies[:remember_token]).to be_blank
      end
  end
end
