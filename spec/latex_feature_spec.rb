require 'capybara/rspec'
require './models/expression'
require './models/power'
require './models/addition'
require './models/string'
require './models/fixnum'
require './models/subtraction'
require './models/division'
require './models/multiplication'

#no order switching is allowed!!  so x2 stays x2...for now and a long while

feature '#latex' do
  context 'one_step' do
    context 'addition' do
      scenario '' do
        exp = add('x',2)
        expect(exp.latex).to eq 'x+2'
      end

      scenario '' do
        exp = add(15,'x','y')
        expect(exp.latex).to eq '15+x+y'
      end
    end

    context 'multiplication' do
      scenario '' do
        exp = mtp(2,3)
        expect(exp.latex).to eq '2\times3'
      end

      scenario '' do
        exp = mtp(2,'x')
        expect(exp.latex).to eq '2x'
      end

      scenario '' do
        exp = mtp(2,3,'x')
        expect(exp.latex).to eq '2\times3x'
      end

      scenario '' do
        exp = mtp(2,3,'x','y')
        expect(exp.latex).to eq '2\times3xy'
      end
    end

    context 'subtraction' do
      scenario '' do
        exp = sbt('x',2)
        expect(exp.latex).to eq 'x-2'
      end

      scenario '' do
        exp = sbt(5,4)
        expect(exp.latex).to eq '5-4'
      end
    end

    context 'division' do
      scenario '' do
        exp = div('x',2)
        expect(exp.latex).to eq '\displaystyle\frac{x}{2}'
      end

      scenario '' do
        exp = div(5,4)
        expect(exp.latex).to eq '\displaystyle\frac{5}{4}'
      end
    end
  end

  context 'two_steps' do
    context 'add first' do
      scenario '' do
        exp = add(add(2,'x'),3)
        expect(exp.latex).to eq '2+x+3'
      end

      scenario '' do
        exp = add(2,add('x',3))
        expect(exp.latex).to eq '2+\left(x+3\right)'
      end

      scenario '' do
        exp = add(sbt('x',2),3)
        expect(exp.latex).to eq 'x-2+3'
      end

      scenario '' do
        exp = add(2,sbt('x',3))
        expect(exp.latex).to eq '2+\left(x-3\right)'
      end

      scenario '' do
        exp = add(mtp(2,'x'),3)
        expect(exp.latex).to eq '2x+3'
      end

      scenario '' do
        exp = add(3,mtp(2,'x'))
        expect(exp.latex).to eq '3+2x'
      end

      scenario '' do
        exp = add(div('x',2),3)
        expect(exp.latex).to eq '\displaystyle\frac{x}{2}+3'
      end

      scenario '' do
        exp = add(3,div(2,'x'))
        expect(exp.latex).to eq '3+\displaystyle\frac{2}{x}'
      end
    end

    context 'multiplication first' do
      scenario '' do
        exp = mtp(add(2,'x'),3)
        expect(exp.latex).to eq '\left(2+x\right)3'
      end

      scenario '' do
        exp = mtp(3,add(2,'x'))
        expect(exp.latex).to eq '3\left(2+x\right)'
      end
    end
  end
end
