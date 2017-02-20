require './models/equation'
require './models/factory'
require './models/class_names'
require './models/addition'
require './models/subtraction'
require './models/multiplication'
require './models/division'
require './models/array'

include Factory

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

      it 'reverses one step left addition' do
        eqn = eqn(add('x',3),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add('x',3),5),
          eqn('x',sbt(5,3)),
          eqn('x',2)
        ]
      end

      it 'reverses one step right multiplication' do
        eqn = eqn(mtp('x',3),15)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(mtp('x',3),15),
          eqn('x',div(15,3)),
          eqn('x',5)
        ]
      end

      it 'reverses one step left multiplication' do
        eqn = eqn(mtp(3,'x'),15)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(mtp(3,'x'),15),
          eqn('x',div(15,3)),
          eqn('x',5)
        ]
      end
    end
  end
end
