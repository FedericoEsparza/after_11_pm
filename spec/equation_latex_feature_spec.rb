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
      expect(equation.latex).to eq '\sin \left(2x-10\right)&=0.5'
    end
  end

  context 'all_steps' do
    scenario 'sine equation' do
      equation = sin_eqn(sbt(mtp(2,'x'),10),0.5)
      eq_solution = equation.latex_solution
      expect(eq_solution).to eq "\\begin{align*}\n &&  && \\sin \\left(2x-10\\right)&=0.5 &&  && \\\\[10pt]\n && &(1)&\\sin \\left(2x-10\\right)&=0.5 && \\\\\n &&  && 2x-10&=\\arcsin 0.5 &&  && \\\\\n &&  && 2x-10&=30.0 &&  && \\\\\n &&  && 2x&=30.0+10 &&  && \\\\\n &&  && 2x&=40.0 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{40.0}{2} &&  && \\\\\n &&  && x&=20.0\\pm 180.0n &&  && \\\\[10pt]\n && &(2)&\\sin \\left(180-\\left(2x-10\\right)\\right)&=0.5 && \\\\\n &&  && 180-\\left(2x-10\\right)&=\\arcsin 0.5 &&  && \\\\\n &&  && 180-\\left(2x-10\\right)&=30.0 &&  && \\\\\n &&  && 2x-10&=180-30.0 &&  && \\\\\n &&  && 2x-10&=150.0 &&  && \\\\\n &&  && 2x&=150.0+10 &&  && \\\\\n &&  && 2x&=160.0 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{160.0}{2} &&  && \\\\\n &&  && x&=80.0\\pm 180.0n &&  && \n\\end{align*}\n$x= 20.0,200.0,80.0,260.0$"
    end

    scenario 'cosine equation' do
      equation = cos_eqn(sbt(mtp(2, 'x'), 10), 0.5)
      eq_solution = equation.latex_solution
      
    end
  end
end
