require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    before do
      user.activation_token = User.new_token
    end

    it 'should be titled Account activation' do
      expect(mail.subject).to eq('Account activation')
    end

    it 'should send to correct address' do
      expect(mail.to).to eq([ user.email ])
    end

    it 'should from correct address' do
      expect(mail.from).to eq([ 'hiroakisatou@outlook.com' ])
    end

    it 'should include user name' do
      expect(mail.body.encoded).to match(user.name)
    end

    it 'should include user\'s activation token' do
      expect(mail.body.encoded).to match(user.activation_token)
    end

    it 'should include user\'s mail address' do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end

  describe 'password_reset' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.password_reset(user) }

    before do
      user.reset_token = User.new_token
    end

    it 'should be titled Password reset' do
      expect(mail.subject).to eq('Password reset')
    end

    it 'should be sent to collect address' do
      expect(mail.to).to eq([ user.email ])
    end

    it 'should be sent from collect address' do
      expect(mail.from).to eq([ 'hiroakisatou@outlook.com' ])
    end

    it 'should be included collect reset token' do
      expect(mail.body.encoded).to match(user.reset_token)
    end

    it 'should be mail included user\'s mail address' do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end
