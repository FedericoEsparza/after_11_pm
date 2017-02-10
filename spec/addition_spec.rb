require './models/addition'
require './models/factory'

include Factory

describe Addition do
  describe '#initialize/new' do
    it 'initialize with an array of values to add' do
      addition = add(1,2,3)
      expect(addition.class).to eq described_class
      expect(addition.args).to eq [1,2,3]
    end
  end

  describe '#evaluate' do
    it 'evaluates a sum of numbers' do
      addition = add(1,-2,3)
      expect(addition.evaluate).to eq 2
    end
  end
end
