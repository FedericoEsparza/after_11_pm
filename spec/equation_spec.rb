require './models/equation'
require './models/factory'

describe Equation do
  describe '#initialize' do
    it 'initialise with a left hand side and a right hand side' do
      eqn = eqn('x',3)
      expect(eqn.ls).to eq 'x'
      expect(eqn.rs).to eq 3
    end
  end
end
