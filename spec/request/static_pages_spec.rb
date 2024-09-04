require 'rails_helper'

RSpec.describe "Static Pages", type: :request do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe 'root' do
    it 'should return collect response' do
      get root_path
      expect(response).to have_http_status :ok
    end
  end

  describe "#home" do
    it 'should return collect response' do
      get home_path
      expect(response).to have_http_status :ok
      assert_select 'title', "Home | #{base_title}"
    end
  end

  describe '#help' do
    it 'should return collect response' do
      get help_path
      expect(response).to have_http_status :ok
      assert_select 'title', "Help | #{base_title}"
    end
  end

    describe '#about' do
      it 'should return collect response' do
        get about_path
        expect(response).to have_http_status :ok
        assert_select 'title', "About | #{base_title}"
      end
    end

  describe '#contact' do
    it 'should return collect response' do
      get contact_path
      expect(response).to have_http_status :ok
    end

    it "should include 'contact | Ruby on Rails Tutorial Sample App'" do
      get contact_path
      expect(response.body).to include "contact | #{base_title}"
    end
  end
end
