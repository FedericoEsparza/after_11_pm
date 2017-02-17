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

  describe '#solve_one_var_eqn' do
    context '#one-step' do
      it 'reverses one step right addition' do
        eqn = eqn(add(3,'x'),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(3,'x'),5),
          eqn('x',sbt(5,3)),
          eqn('x',2)
        ]
      end
    end
  end
end
