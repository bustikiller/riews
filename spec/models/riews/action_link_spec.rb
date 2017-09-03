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
end
