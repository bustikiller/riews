require 'spec_helper'

describe Riews::ActionLink, type: :model do
  describe 'validates' do
    describe 'arguments' do
      let(:action_link) do
        action_link = build :action_link, base_path: base_path
        action_link.save! validate: false
        action_link
      end
      describe 'if the base path has no parameters' do
        let(:base_path){ 'http://www.example.com' }
        it 'is valid if there are no parameters' do
          expect(action_link).to be_valid
        end
        it 'is not valid if there is a single parameter' do
          action_link.arguments.build value: 'one'
          expect(action_link).not_to be_valid
        end
        it 'is not valid if are two parameters' do
          2.times{ action_link.arguments.build value: 'one' }
          expect(action_link).not_to be_valid
        end
      end

      describe 'if there is a single optional parameter' do
        let(:base_path){ 'http://www.example.com/(:whatever)/index' }
        it 'is valid if there are no parameters' do
          expect(action_link).to be_valid
        end
        it 'is valid if there is a single paramter' do
          action_link.arguments.build value: 'one'
          expect(action_link).to be_valid
        end
        it 'is not valid if there are two parameters' do
          2.times{ action_link.arguments.build value: 'one' }
          expect(action_link).not_to be_valid
        end
      end

      describe 'if there is a single required parameter' do
        let(:base_path){ 'http://www.example.com/:whatever/index' }
        it 'is not valid if there are no parameters' do
          expect(action_link).not_to be_valid
        end
        it 'is valid if there is one parameter' do
          action_link.arguments.build value: 'one'
          expect(action_link).to be_valid
        end
        it 'is not valid if there are two parameters' do
          2.times{ action_link.arguments.build value: 'one' }
          expect(action_link).not_to be_valid
        end
      end

      describe 'if there are one required and one optional parameter' do
        let(:base_path){ 'http://www.example.com/:whatever/index/(:format)' }
        it 'is not valid if there are no parameters' do
          expect(action_link).not_to be_valid
        end
        it 'is valid if there is a single parameter' do
          action_link.arguments.build value: 'one'
          expect(action_link).to be_valid
        end
        it 'is valid if there are two parameters' do
          2.times{ action_link.arguments.build value: 'one' }
          expect(action_link).to be_valid
        end
        it 'is not valid if there are three parameters' do
          3.times{ action_link.arguments.build value: 'one' }
          expect(action_link).not_to be_valid
        end
      end
    end
  end

  describe '#base_path_with_replacements' do
    it 'returns the original path if no arguments are present' do
      action_link = build :action_link, base_path: 'www.example.com'
      expect(action_link.base_path_with_replacements).to eq 'www.example.com'
    end
    it 'replaces an argument if present' do
      action_link = build :action_link, base_path: 'www.example.com/items/:item_id'
      action_link.arguments.build value: 1
      expect(action_link.base_path_with_replacements).to eq 'www.example.com/items/1'
    end
    it 'replaces three arguments if present, one of them optional' do
      action_link = build :action_link, base_path: 'www.example.com/:locale/items/:item_id/(:format)'
      action_link.arguments.build value: 'es'
      action_link.arguments.build value: '4'
      action_link.arguments.build value: 'json'
      expect(action_link.base_path_with_replacements).to eq 'www.example.com/es/items/4/json'
    end
    it 'clears the optional parameters if not present' do
      action_link = build :action_link, base_path: 'www.example.com/:locale/items/:item_id/(:format)'
      action_link.arguments.build value: 'es'
      action_link.arguments.build value: '4'
      expect(action_link.base_path_with_replacements).to eq 'www.example.com/es/items/4/'
    end
  end
end
