require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe '/account_activations/{id}/edit' do
    before do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
      @user = controller.instance_variable_get('@user')
    end

    context 'in case of token and email is valid' do
      it 'should activate the account' do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        @user.reload
        expect(@user).to be_activated
      end

      it 'should get state of login' do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(logged_in?).to be_truthy
      end

      it 'should redirect to user show page' do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(response).to redirect_to user_path(@user)
      end
    end

    context 'in case of token and email is invalid' do
      it 'should not get state of login if activation token is invalid' do
        get edit_account_activation_path('invalid token', email: @user.email)
        expect(logged_in?).to be_falsey
      end

      it 'should not get login state if invalid email' do
        get edit_account_activation_path(@user.activation_token, email: 'wrong')
        expect(logged_in?).to be_falsey
      end
    end
  end
end