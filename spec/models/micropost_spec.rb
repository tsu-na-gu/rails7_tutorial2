require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { user.microposts.build(content: "Lorem ipsum") }

  it 'should be valid' do
    expect(micropost).to be_valid
  end

  it 'should not be valid if user_id is undefined' do
    micropost.user_id = nil
    expect(micropost).to_not be_valid
  end

  describe 'content' do
    it 'should not be valid if content is empty' do
      micropost.content = '  '
      expect(micropost).to_not be_valid
    end

    it 'should not be valid if content length is over 140' do
      micropost.content = "a" * 141
      expect(micropost).to_not be_valid
    end
  end

  it 'should be new order' do
    FactoryBot.send(:user_with_posts)
    expect(FactoryBot.create(:most_recent)).to eq Micropost.first
  end

  it 'should delete microposts if user is deleted' do
    post = FactoryBot.create(:most_recent)
    user = post.user
    expect {
      user.destroy
    }.to change(Micropost, :count).by(-1)
  end
end
