require 'capybara/rspec'
require './models/expression'
require './models/power'
require './models/addition'
require './models/string'
require './models/fixnum'
require './models/subtraction'
require './models/division'
require './models/multiplication'
require './models/fraction'
require './models/square_root'
require './models/sine'
require './models/equation'
require './models/sine_equation'
require './models/cosine'
require './models/cosine_equation'
require './models/tangent'
require './models/tangent_equation'
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
      expect(eq_solution).to eq "\\begin{align*}\n &&  && \\cos \\left(2x-10\\right)&=0.5 &&  && \\\\[10pt]\n && &(1)&\\cos \\left(2x-10\\right)&=0.5 && \\\\\n &&  && 2x-10&=\\arccos 0.5 &&  && \\\\\n &&  && 2x-10&=60.0 &&  && \\\\\n &&  && 2x&=60.0+10 &&  && \\\\\n &&  && 2x&=70.0 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{70.0}{2} &&  && \\\\\n &&  && x&=35.0\\pm 180.0n &&  && \\\\[10pt]\n && &(2)&\\cos -1\\left(2x-10\\right)&=0.5 && \\\\\n &&  && -1\\left(2x-10\\right)&=\\arccos 0.5 &&  && \\\\\n &&  && -1\\left(2x-10\\right)&=60.0 &&  && \\\\\n &&  && 2x-10&=\\displaystyle\\frac{60.0}{-1} &&  && \\\\\n &&  && 2x-10&=-60.0 &&  && \\\\\n &&  && 2x&=-60.0+10 &&  && \\\\\n &&  && 2x&=-50.0 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{-50.0}{2} &&  && \\\\\n &&  && x&=-25.0\\pm 180.0n &&  && \n\\end{align*}\n$x= 35.0,215.0,155.0,335.0$"
    end

    scenario 'tangent equation' do
      equation = tan_eqn(sbt(mtp(2, 'x'), 10), Math.sqrt(3)/3)
      eq_solution = equation.latex_solution
      expect(eq_solution).to eq "\\begin{align*}\n &&  && \\tan \\left(2x-10\\right)&=0.5773502691896257 &&  && \\\\[10pt]\n && &(1)&\\tan \\left(2x-10\\right)&=0.5773502691896257 && \\\\\n &&  && 2x-10&=\\arctan 0.5773502691896257 &&  && \\\\\n &&  && 2x-10&=30.0 &&  && \\\\\n &&  && 2x&=30.0+10 &&  && \\\\\n &&  && 2x&=40.0 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{40.0}{2} &&  && \\\\\n &&  && x&=20.0\\pm 90.0n &&  && \n\\end{align*}\n$x= 20.0,110.0,200.0,290.0$"
    end

    scenario 'tangent equation with fractiona and sqrt as Right Side' do
      equation = tan_eqn(sbt(mtp(2, 'x'), 10), frac(sqrt(3), 3))
      eq_solution = equation.latex_solution
      expect(eq_solution).to eq "\\begin{align*}\n &&  && \\tan \\left(2x-10\\right)&=\\frac{\\sqrt{3}}{3} &&  && \\\\[10pt]\n && &(1)&\\tan \\left(2x-10\\right)&=\\frac{\\sqrt{3}}{3} && \\\\\n &&  && 2x-10&=\\arctan \\frac{\\sqrt{3}}{3} &&  && \\\\\n &&  && 2x-10&=30.0 &&  && \\\\\n &&  && 2x&=30.0+10 &&  && \\\\\n &&  && 2x&=40.0 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{40.0}{2} &&  && \\\\\n &&  && x&=20.0\\pm 90.0n &&  && \n\\end{align*}\n$x= 20.0,110.0,200.0,290.0$"
    end
  end
end
