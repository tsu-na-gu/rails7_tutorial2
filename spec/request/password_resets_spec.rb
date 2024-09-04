require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe "#new" do
    it 'should include password_reset[email] name attribute' do
      get new_password_reset_path
      expect(response.body).to include "name=\"password_reset[email]\""
    end
  end

  describe '#create' do
    it 'should get flash if invalid email address' do
      post password_resets_path, params: { password_reset: { email: 'invalid' } }
      expect(flash).to_not be_empty
    end

    context 'in case of valid email address' do
      it 'should be changed reset_digest' do
        post password_resets_path params: { password_reset: { email: user.email } }
        expect(user.reset_digest).to_not eq user.reload.reset_digest
      end

      it 'should plus one mail in sent mail' do
        expect {
          post password_resets_path, params: { password_reset: { email: user.email } }
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'should get flash message' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(flash).to_not be_empty
      end
    end
  end

  describe '#edit' do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get('@user')
    end

    it 'should get redirected to new if 2 hours left' do
      @user.update_attribute(:reset_sent_at, 3.hours.ago)
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response).to redirect_to new_password_reset_path
    end

    it 'should include hidden email field if valid email and token' do
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response.body).to include "<input type=\"hidden\" name=\"email\" id=\"email\" value=\"#{@user.email}\" autocomplete=\"off\" />"
    end

    it 'should redirect to root if mail address is not collect' do
      get edit_password_reset_path(@user.reset_token, email: '')
      expect(response).to redirect_to root_path
    end

    it 'should redirect to root if token is not collect' do
      get edit_password_reset_path('wrong_token', email: @user.email)
      expect(response).to redirect_to root_path
    end
  end

  describe '#update' do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get('@user')
    end

    context 'in case of over 2 hours left' do
      before do
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
      end

      it 'should redirect to new' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                        password_confirmation: 'foobaz' } }
        expect(response).to redirect_to new_password_reset_path
      end

      it 'should have displayed "password reset has expired"' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                        password_confirmation: 'foobaz' } }
        expect(response).to redirect_to new_password_reset_path
      end
    end

    context 'in case of valid password' do
      it 'should get log in state' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                            user: { password: 'foobaz',
                                                                   password_confirmation: 'foobaz' } }
        expect(logged_in?).to be_truthy
      end

      it 'should contain flash message' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                       password_confirmation: 'foobaz' } }
        expect(response).to redirect_to @user
      end

      it 'should redirect to user\'s profile page' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                       password_confirmation: 'foobaz' } }
        expect(response).to redirect_to @user
      end

      it 'should get reset_digest to nil' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                        password_confirmation: 'foobaz' } }
        @user.reload
        expect(@user.reset_digest).to be_nil
      end
    end

    it 'should get error message if password and confirmation are not match' do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                              user: { password: 'foobaz',
                                                                      password_confirmation: 'barquux' } }
      expect(response.body).to include "<div id='error_explanation'>"
    end
    it 'should get error message if password or confirmation is empty' do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                              user: { password: 'foobaz',
                                                                      password_confirmation: 'barquux' } }
      expect(response.body).to include "<div id='error_explanation'>"
    end
  end
end
