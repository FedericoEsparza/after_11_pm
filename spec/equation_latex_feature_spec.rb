require 'capybara/rspec'
require './models/expression'
require './models/power'
require './models/addition'
require './models/string'
require './models/fixnum'
require './models/subtraction'
require './models/division'
require './models/multiplication'
require './models/sine'
require './models/equation'
require './models/sine_equation'
require './lib/float'

#no order switching is allowed!!  so x2 stays x2...for now and a long while

feature '#latex' do
  context 'one_step' do
    scenario '' do
      equation = eqn(sin(sbt(mtp(2,'x'),10)),0.5)
      # puts equation.latex
      expect(equation.latex).to eq '\sin \left(2x-10\right)&=0.5\\\\'
    end
  end

  context 'all_steps' do
    scenario '' do
      equation = sin_eqn(sbt(mtp(2,'x'),10),0.5)
      eq_solution = equation.latex_solution
      puts eq_solution
      expect(eq_solution).to eq ''
    end
  end
end
