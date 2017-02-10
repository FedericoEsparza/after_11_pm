require './models/power'
require './models/factory'

include Factory

describe Power do
  describe '#initialize/new' do
    it 'initialize with an array of two values take power' do
      power = pow(2,'x')
      expect(power.class).to eq described_class
      expect(power.args).to eq [2,'x']
    end
  end

  describe '#evaluate' do
    it 'evaluates to a product of the arguments' do
      power = pow(-2,3)
      expect(power.evaluate).to eq -8
    end
  end
end
