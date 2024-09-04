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
        post users_url, params: { user: { name: '',
                                           email: 'user@invalid',
                                           password: 'foo',
                                           password_confirmation: 'bar' } }
      }.to_not change(User, :count)
    end

    it 'should register successfully' do
      expect {
        post users_url, params: { user: { name: "Sample User",
                                         email: "sample@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
      }.to change(User, :count).by(1)
    end

    it 'should redirect to users/show page' do
      post users_url, params: { user: { name: "Sample User",
                                       email: "sample@example.com",
                                       password: "password",
                                       password_confirmation: "password" } }
      user = User.last
      expect(response).to redirect_to root_path
    end

    it 'should show up the flash message' do
      post users_url, params: { user: { name: "Sample User",
                                      email: "sample@example.com",
                                      password: "password",
                                      password_confirmation: "password" } }
      expect(flash).to be_any
    end

    it "should be login state" do
      post users_url, params: { user: { name: "Sample User",
                                       email: "sample@example.com",
                                       password: "password",
                                       password_confirmation: "password" } }
      expect(logged_in?).to be_falsey
    end
  end

  describe "PATCH /users" do
    context 'must logged in' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        post login_path params: { session: { email: user.email,
                                             password: user.password,
                                             remember_me: '1' } }
      end

      it "should be title include Edit user" do
        get edit_user_path user.id
        expect(response.body).to include full_title("User Edit")
      end
    end

    context 'in case of invalid value' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        post login_path params: { session: { email: user.email,
                                             password: user.password,
                                             remember_me: '1' } }
      end

      it 'could not update' do
        patch user_path(user), params: { user: { name: '',
                                        email: 'foo@invalid',
                                        password: 'foo',
                                        password_confirmation: 'bar' } }
        user.reload
        expect(user.name).to_not eq ''
        expect(user.email).to_not eq ''
        expect(user.password).to_not eq 'foo'
        expect(user.password_confirmation).to_not eq 'bar'
      end

      it 'should be shown edit page after edit action' do
        get edit_user_path(user)
        patch user_path(user), params: { user: { name: '',
                                                email: 'foo@invalid',
                                                password: 'foo',
                                                password_confirmation: 'bar' } }

        expect(response.body).to include full_title("User Edit")
      end

      it "should be showed 'the form contains 4 errors'" do
        patch user_path(user), params: { user: { name: '',
                                                email: 'foo@invalid',
                                                password: 'foo',
                                                password_confirmation: 'bar' } }
        expect(response.body).to include "3 errors"
      end
    end

    context 'in case of invalid value' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        post login_path params: { session: { email: user.email,
                                             password: user.password,
                                             remember_me: '1' } }
        @name = 'Foo Bar'
        @email = 'foo@bar.com'
        patch user_path(user), params: { user: { name: @name,
                                                  email: @email,
                                                  password: '',
                                                  password_confirmation: '' } }
      end

      it 'should refresh value' do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end

      it "should redirect to Users#show" do
        expect(response).to redirect_to user
      end

      it 'should show flash message' do
        expect(flash).to be_any
      end
    end

    context 'other user case' do
      let!(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:archer) }

      it 'should be empty of the flash' do
        log_in user
        get edit_user_path(other_user)
        expect(flash).to be_empty
      end

      it 'should redirect root_path' do
        log_in user
        get edit_user_path(other_user)
        expect(response).to redirect_to root_path
      end
    end

    context 'in case of before login' do
      let!(:user) { FactoryBot.create(:user) }

      it 'should redirect to edit_page after login' do
        get edit_user_path(user)
        log_in user
        expect(response).to redirect_to edit_user_path(user)
      end
    end
  end

  describe 'GET /users' do
    it 'should redirect to login if not login user' do
      get users_path
      expect(response).to redirect_to login_path
    end

    context 'pagination' do
      let(:user) { FactoryBot.create(:user) }

      before do
        30.times do
          FactoryBot.create(:continuous_user)
        end
        log_in user
        get users_url
      end

      it 'should div.pagination exists' do
        expect(response.body).to include '<div role="navigation" aria-label="Pagination" class="pagination">'
      end

      it 'should exists each users link' do
        User.paginate(page: 1).each do |user|
          expect(response.body).to include "<a href=\"#{user_path(user)}\">"
        end
      end

      it 'should not display not activated users' do
        not_activated_user = FactoryBot.create(:melony)
        log_in user
        get users_path
        expect(response.body).to_not include not_activated_user.name
      end
    end
  end

  describe 'PATCH /users' do
    let!(:user) { FactoryBot.create(:user) }

    it 'should not renew admin attribute' do
      log_in user = FactoryBot.create(:archer)
      expect(user).to_not be_admin

      patch user_path(user), params: { user: { password: 'password',
                                              password_confirmation: 'password',
                                              admin: true } }
      user.reload
      expect(user).to_not be_admin
    end
  end

  describe 'DELETE /users{id}' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:archer) }

    context 'not login state' do
      it 'could not delete' do
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end

      it "should redirect to login_path" do
        delete user_path(user)
        expect(response).to redirect_to login_path
      end

      context 'if not admin user' do
        it 'not deleted' do
          log_in other_user
          expect {
            delete user_path(user)
          }.to_not change(User, :count)
        end

        it 'should redirect to root_path' do
          log_in other_user
          delete user_path(user)
          expect(response).to redirect_to root_path
        end
      end
    end
  end
  describe 'POST /users #create' do
    context 'valid attributes' do
      before do
        ActionMailer::Base.deliveries.clear
      end

      it 'should exist one mail' do
        post users_path,  params: { user: { name: "Sample User",
                                          email: "sample@example.com",
                                          password: "password",
                                          password_confirmation: "password" } }
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it 'should not activated when registered' do
        post users_path,  params: { user: { name: "Sample User",
                                          email: "sample@example.com",
                                          password: "password",
                                                         password_confirmation: "password" } }
        expect(User.last).to_not be_activated
      end
    end
  end

  describe 'get /users/{id}' do
    it 'should redirect to root if user is not activated' do
      user = FactoryBot.create(:user)
      not_activated_user = FactoryBot.create(:melony)

      log_in user
      get user_path(not_activated_user)
      expect(response).to redirect_to root_path
    end
  end
end
