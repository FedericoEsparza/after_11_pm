require './models/addition'

describe Addition do
  describe '#initialize/new' do
    it 'initialize with an array of values to add' do
      addition = described_class.new(1,2,3)
      expect(addition.args).to eq [1,2,3]
    end
  end
end
