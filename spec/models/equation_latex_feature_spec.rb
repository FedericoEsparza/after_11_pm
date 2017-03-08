## GO TO spec_helper for required files
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
      expect(eq_solution).to eq "\\begin{align*}\n &&  && \\sin \\left(2x-10\\right)&=0.5 &&  && \\\\[10pt]\n && &(1)&\\sin \\left(2x-10\\right)&=0.5 && \\\\\n &&  && 2x-10&=\\arcsin 0.5 &&  && \\\\\n &&  && 2x-10&=30 &&  && \\\\\n &&  && 2x&=30+10 &&  && \\\\\n &&  && 2x&=40 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{40}{2} &&  && \\\\\n &&  && x&=20\\pm 180n &&  && \\\\[10pt]\n && &(2)&\\sin \\left(180-\\left(2x-10\\right)\\right)&=0.5 && \\\\\n &&  && 180-\\left(2x-10\\right)&=\\arcsin 0.5 &&  && \\\\\n &&  && 180-\\left(2x-10\\right)&=30 &&  && \\\\\n &&  && 2x-10&=180-30 &&  && \\\\\n &&  && 2x-10&=150 &&  && \\\\\n &&  && 2x&=150+10 &&  && \\\\\n &&  && 2x&=160 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{160}{2} &&  && \\\\\n &&  && x&=80\\pm 180n &&  && \n\\end{align*}\n$x= 20,200,80,260$"
    end

    scenario 'cosine equation' do
      equation = cos_eqn(sbt(mtp(2, 'x'), 10), 0.5)
      eq_solution = equation.latex_solution
      expect(eq_solution).to eq "\\begin{align*}\n &&  && \\cos \\left(2x-10\\right)&=0.5 &&  && \\\\[10pt]\n && &(1)&\\cos \\left(2x-10\\right)&=0.5 && \\\\\n &&  && 2x-10&=\\arccos 0.5 &&  && \\\\\n &&  && 2x-10&=60 &&  && \\\\\n &&  && 2x&=60+10 &&  && \\\\\n &&  && 2x&=70 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{70}{2} &&  && \\\\\n &&  && x&=35\\pm 180n &&  && \\\\[10pt]\n && &(2)&\\cos \\left(-\\left(2x-10\\right)\\right)&=0.5 && \\\\\n &&  && -\\left(2x-10\\right)&=\\arccos 0.5 &&  && \\\\\n &&  && -\\left(2x-10\\right)&=60 &&  && \\\\\n &&  && 2x-10&=\\displaystyle\\frac{60}{-1} &&  && \\\\\n &&  && 2x-10&=-60 &&  && \\\\\n &&  && 2x&=-60+10 &&  && \\\\\n &&  && 2x&=-50 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{-50}{2} &&  && \\\\\n &&  && x&=-25\\pm 180n &&  && \n\\end{align*}\n$x= 35,215,155,335$"
    end

    scenario 'tangent equation' do
      equation = tan_eqn(sbt(mtp(2, 'x'), 10), Math.sqrt(3)/3)
      eq_solution = equation.latex_solution
      expect(eq_solution).to eq "\\begin{align*}\n &&  && \\tan \\left(2x-10\\right)&=0.5773502691896257 &&  && \\\\[10pt]\n && &(1)&\\tan \\left(2x-10\\right)&=0.5773502691896257 && \\\\\n &&  && 2x-10&=\\arctan 0.5773502691896257 &&  && \\\\\n &&  && 2x-10&=30 &&  && \\\\\n &&  && 2x&=30+10 &&  && \\\\\n &&  && 2x&=40 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{40}{2} &&  && \\\\\n &&  && x&=20\\pm 90n &&  && \n\\end{align*}\n$x= 20,110,200,290$"
    end

    scenario 'tangent equation with fractiona and sqrt as Right Side' do
      equation = tan_eqn(sbt(mtp(2, 'x'), 10), frac(sqrt(3), 3))
      eq_solution = equation.latex_solution
      expect(eq_solution).to eq "\\begin{align*}\n &&  && \\tan \\left(2x-10\\right)&=\\frac{\\sqrt{3}}{3} &&  && \\\\[10pt]\n && &(1)&\\tan \\left(2x-10\\right)&=\\frac{\\sqrt{3}}{3} && \\\\\n &&  && 2x-10&=\\arctan \\frac{\\sqrt{3}}{3} &&  && \\\\\n &&  && 2x-10&=30 &&  && \\\\\n &&  && 2x&=30+10 &&  && \\\\\n &&  && 2x&=40 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{40}{2} &&  && \\\\\n &&  && x&=20\\pm 90n &&  && \n\\end{align*}\n$x= 20,110,200,290$"
    end
  end
end
