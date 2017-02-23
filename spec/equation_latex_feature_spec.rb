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
end
