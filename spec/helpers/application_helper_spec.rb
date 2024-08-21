require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'full_title' do
    let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

    context 'argument is given' do
      it 'should return argument and base title' do
      expect(full_title('Page Title')).to eq "Page Title | #{base_title}"
    end
    end

    context 'argument is not given' do
      it 'should return base title' do
        expect(full_title).to eq "#{base_title}"
      end
    end
  end
end