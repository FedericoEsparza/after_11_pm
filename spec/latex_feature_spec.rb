require 'capybara/rspec'
require './models/expression'
require './models/power'
require './models/addition'
require './models/string'
require './models/fixnum'

feature '#latex' do
  context 'one_step' do
    context 'addition' do
      scenario 'latex for x+2' do
        exp = add('x',2)
        expect(exp.latex).to eq 'x+2'
      end

      scenario 'latex for 15+x+y' do
        exp = add(15,'x','y')
        expect(exp.latex).to eq '15+x+y'
      end
    end

    context 'multiplication' do
      scenario 'latex for 2\times3' do
        exp = mtp(2,3)
        expect(exp.latex).to eq '2\times3'
      end

      scenario 'latex for 2x' do
        exp = mtp(2,'x')
        expect(exp.latex).to eq '2x'
      end

      scenario 'latex for 2\times3x' do
        exp = mtp(2,3,'x')
        expect(exp.latex).to eq '2\times3x'
      end

      scenario 'latex for 2\times3xy' do
        exp = mtp(2,3,'x','y')
        expect(exp.latex).to eq '2\times3xy'
      end
    end
  end
end
