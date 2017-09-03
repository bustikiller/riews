require 'spec_helper'

describe Riews::ColumnPattern do
  describe '#format' do
    it 'displays the original value if no pattern is found' do
      pattern = Riews::ColumnPattern.new('Helloworld')
      expect(pattern.format []).to eq 'Helloworld'
    end
    it 'replaces a single pattern from the values provided' do
      pattern = Riews::ColumnPattern.new('Hello [[column:45]] world')
      replacements = { 45 => 'wonderful' }
      expect(pattern.format replacements).to eq 'Hello wonderful world'
    end
    it 'replaces several patterns from the values provided' do
      pattern = Riews::ColumnPattern.new('Hello [[column:45]] and [[column:46]] world')
      replacements = { 45 => 'wonderful', 46 => 'marvelous' }
      expect(pattern.format replacements).to eq 'Hello wonderful and marvelous world'
    end
    it 'replaces the same pattern several times if needed' do
      pattern = Riews::ColumnPattern.new('Hello [[column:45]], [[column:45]] world')
      replacements = { 45 => 'wonderful' }
      expect(pattern.format replacements).to eq 'Hello wonderful, wonderful world'
    end

    it 'ignores a pattern if the column referenced is not present' do
      pattern = Riews::ColumnPattern.new('Hello [[column:46]] world')
      replacements = { 45 => 'wonderful' }
      expect(pattern.format replacements).to eq 'Hello [[column:46]] world'
    end

    it 'calls the method #apply_math_operations with the result of the replacements' do
      pattern = Riews::ColumnPattern.new('Hello [[column:45]] world')
      expect(pattern.class).to receive(:apply_math_operations).with('Hello wonderful world')
      replacements = { 45 => 'wonderful' }
      pattern.format replacements
    end

    it 'calls the method #replace_glyphicons with the result of the replacements' do
      pattern = Riews::ColumnPattern.new('Hello [[column:45]] world')
      expect(pattern.class).to receive(:replace_glyphicons).with('Hello wonderful world')
      replacements = { 45 => 'wonderful' }
      pattern.format replacements
    end
  end

  describe '#apply_math_operations' do
    it 'returns the original value if no operation was found' do
      expect(Riews::ColumnPattern.apply_math_operations('Helloworld')).to eq 'Helloworld'
    end
    it 'performs a single operation if found' do
      expect(Riews::ColumnPattern.apply_math_operations('[[calc:(3+2)]]')).to eq '5'
    end
    it 'performs several operations' do
      expect(Riews::ColumnPattern.apply_math_operations('[[calc:(3+2)]] out of [[calc:(8*2)]]')).to eq '5 out of 16'
    end
    it 'returns [MATH ERROR] if the operation returns any error' do
      expect(Riews::ColumnPattern.apply_math_operations('[[calc:(3/0)]]')).to eq '[MATH ERROR]'
    end
  end

  describe '#replace_glyphicons' do
    it 'uses BH gem to render a glyphicon of a user' do
      expect(Riews::ColumnPattern.replace_glyphicons('[[icon:user]]')).to eq '<span class="glyphicon glyphicon-user"></span>'
    end
  end
end
