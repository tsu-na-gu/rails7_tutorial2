require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: "Example User",
                        email: "user@example.com",
                        password: "foobar",
                        password_confirmation: "foobar") }

  it "should valid the user" do
    expect(user).to be_valid
  end

  it "should require name" do
    user.name = ''
    expect(user).to_not be_valid
  end

  it "should require email" do
    user.email = ''
    expect(user).to_not be_valid
  end

  it "name is less than 50 letters" do
    user.name = "a" * 51
    expect(user).to_not be_valid
  end

  it 'email is less than 255 letters' do
    user.email = "#{'a' * 244}@example.com"
    expect(user).to_not be_valid
  end

  it 'should be failed with invalid email' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).to_not be_valid
    end
  end

  it 'should not register duplicate email' do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).to_not be_valid
  end

  it 'should convert email to lowercase' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    user.email = mixed_case_email
    user.save
    expect(user.reload.email).to eq(mixed_case_email.downcase)
  end

  it 'should require password' do
    user.password = user.password_confirmation = ' ' * 6
    expect(user).to_not be_valid
  end

  it 'should require password is more than 6 letter' do
    user.password = user.password_confirmation = 'a' * 5
    expect(user).to_not be_valid
  end
end
