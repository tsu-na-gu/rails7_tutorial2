require 'rails_helper'

RSpec.describe 'MicroPosts', type: :system do

  let(:user) { FactoryBot.create(:user) }
  before do
    driven_by(:rack_test)
  end

  describe 'User#show' do

    before do
      FactoryBot.send(:user_with_posts, posts_count: 35)
      @user = Micropost.first.user
    end

    it 'should be displayed 30 items' do
      visit user_path @user

      posts_wrapper =
        within 'ol.microposts' do
          find_all('li')
        end
      expect(posts_wrapper.size).to eq 30
    end

    it 'should include pagination tags' do
      visit user_path @user
      expect(page).to have_selector 'div.pagination'
    end

    it "should be displayed micropost contents in the page" do
      visit user_path @user
      @user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end

    it 'should be displayed 1 pagination in a page' do
      visit user_path @user
      pagination = find_all('div.pagination')
      expect(pagination.size).to eq 1
    end
  end

  describe 'home' do
    before do
      FactoryBot.send(:user_with_posts, posts_count: 35)
      @user = Micropost.first.user
      @user.password = 'password'
      log_in @user
      visit root_path
    end

    it 'could attach a image to the post' do
      expect {
        fill_in 'micropost_content', with: "This micropost really ties the room together!"
        attach_file 'micropost[image]', "#{Rails.root}/spec/factories/kitten.jpg"
        click_button 'Post'
      }.to change(Micropost, :count).by(1)

      attached_post = Micropost.first
      expect(attached_post.image).to be_attached
    end

    it 'should displayed 35 microposts' do
      expect(page).to have_content '35 microposts'
    end

    it 'should be displayed 0 microposts if zero post and also 1 micropost if one post' do
      @user.microposts.destroy_all
      visit current_path
      expect(page).to have_content '0 microposts'

      fill_in 'micropost_content', with: 'test posts'
      click_button 'Post'
      expect(page).to have_content '1 micropost'
    end

    it 'should include pagination tags' do
      expect(page).to have_selector 'div.pagination'
    end

    context 'in case of valid send' do
      it 'should be contributed' do
        expect {
          fill_in 'micropost_content', with: 'This micropost really ties the room together'
          click_button 'Post'
        }.to change(Micropost, :count).by(1)

        expect(page).to have_content 'This micropost really ties the room together'
      end
    end

    context 'in case of invalid value send' do
      it 'should not contribute if the content is empty' do
        fill_in 'micropost_content', with: ''
        click_button 'Post'

        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_link '2', href: '/?page=2'
      end
    end
  end

  describe 'about delete function' do
    before do
      FactoryBot.send(:user_with_posts, posts_count: 35)
      @user = Micropost.first.user
      @user.password = 'password'
      log_in @user
      visit root_path
    end

    it 'should display delete button' do
      expect(page).to have_link 'delete'

      fill_in 'micropost_content', with: 'This micropost really ties the room together'
      click_button 'Post'

      post = Micropost.first

      expect {
        click_link 'delete', href: micropost_path(post)
      }.to change(Micropost, :count).by(-1)
      expect(page).to_not have_content 'This micropost really ties the room together'
    end

    it 'should not display delete button in other users profile' do
      @other_user = FactoryBot.create(:archer)
      visit user_path(@other_user)
      expect(page).to_not have_link 'delete'
    end
  end
end