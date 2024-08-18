require 'rails_helper'

RSpec::describe "Static Pages", type: :request do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe 'root' do
    it 'should return collect response' do
      get root_path
      expect(response).to have_http_status :ok
    end
  end

  describe "#home" do
    it 'should return collect response' do
      get static_pages_home_path
      expect(response).to have_http_status :ok
      assert_select 'title', "Home | #{base_title}"
    end
  end

  describe '#help' do
    it 'should return collect response' do
      get static_pages_help_path
      expect(response).to have_http_status :ok
      assert_select 'title', "Help | #{base_title}"
    end

    describe '#about' do
      it 'should return collect response' do
        get static_pages_about_path
        expect(response).to have_http_status :ok
        assert_select 'title', "About | #{base_title}"
      end
    end
  end
end