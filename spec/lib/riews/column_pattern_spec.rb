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
  end
end
