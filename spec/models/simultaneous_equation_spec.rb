describe SimultaneousEquation do
  # context '#extract_coefficient' do
  #   it "extract 3 and 5 from 3x+5y=10" do
  #     equation = eqn(add(mtp(3, 'x'), mtp(5, 'y')), 10)
  #     # p mtp(3, 'x').fetch(object: :numeric)
  #     response = { 'x' => 3, 'y' => 5 }
  #     exp = described_class.new(equation, equation)
  #     expect(exp.extract_coefficient(equation)).to eq response
  #   end
  #
  #   it "extract 3 and 1 from 3x+y=10" do
  #     equation = eqn(add(mtp(3, 'x'), 'y'), 10)
  #     # p mtp(3, 'x').fetch(object: :numeric)
  #     response = { 'x' => 3, 'y' => 1 }
  #     exp = described_class.new(equation, equation)
  #     expect(exp.extract_coefficient(equation)).to eq response
  #   end
  # end
  #
  # context '#determine_multiplier' do
  #   it "return instruction on which equation to mtp by what factor example 1" do
  #     equation_1 = eqn(add(mtp(3, 'x'), mtp(5, 'y')), 10)
  #     equation_2 = eqn(sbt(mtp(6, 'x'), mtp(2, 'y')), 5)
  #     exp = described_class.new(equation_1, equation_2)
  #     response = { eq_1: 2 }
  #     expect(exp.determine_multiplier).to eq response
  #   end
  #
  #   it "return instruction on which equation to mtp by what factor example 2" do
  #     equation_1 = eqn(add(mtp(4, 'x'), mtp(5, 'y')), 10)
  #     equation_2 = eqn(sbt(mtp(2, 'x'), mtp(2, 'y')), 5)
  #     exp = described_class.new(equation_1, equation_2)
  #     response = { eq_2: 2 }
  #     expect(exp.determine_multiplier).to eq response
  #   end
  #
  #   it "return instruction on which equation to mtp by what factor example 3" do
  #     equation_1 = eqn(add(mtp(5, 'x'), mtp(2, 'y')), 10)
  #     equation_2 = eqn(sbt(mtp(2, 'x'), mtp(8, 'y')), 5)
  #     exp = described_class.new(equation_1, equation_2)
  #     response = { eq_1: 4 }
  #     expect(exp.determine_multiplier).to eq response
  #   end
  #
  #   it "return instruction on which equation to mtp by what factor example 4" do
  #     equation_1 = eqn(add(mtp(5, 'x'), mtp(50, 'y')), 10)
  #     equation_2 = eqn(sbt(mtp(2, 'x'), mtp(5, 'y')), 5)
  #     exp = described_class.new(equation_1, equation_2)
  #     response = { eq_2: 10 }
  #     expect(exp.determine_multiplier).to eq response
  #   end
  #
  #   context 'lcm' do
  #     it "return instruction on which equation to mtp by what factor example 1" do
  #       equation_1 = eqn(add(mtp(3, 'x'), mtp(7, 'y')), 10)
  #       equation_2 = eqn(sbt(mtp(2, 'x'), mtp(2, 'y')), 5)
  #       exp = described_class.new(equation_1, equation_2)
  #       response = { eq_1: 2, eq_2: 3 }
  #       expect(exp.determine_multiplier).to eq response
  #     end
  #
  #     it "return instruction on which equation to mtp by what factor example 2" do
  #       equation_1 = eqn(add(mtp(3, 'x'), mtp(7, 'y')), 10)
  #       equation_2 = eqn(sbt(mtp(2, 'x'), mtp(2, 'y')), 5)
  #       exp = described_class.new(equation_1, equation_2)
  #       response = { eq_1: 2, eq_2: 3 }
  #       expect(exp.determine_multiplier).to eq response
  #     end
  #
  #     it "return instruction on which equation to mtp by what factor example 3" do
  #       equation_1 = eqn(add(mtp(11, 'x'), mtp(7, 'y')), 10)
  #       equation_2 = eqn(sbt(mtp(2, 'x'), mtp(2, 'y')), 5)
  #       exp = described_class.new(equation_1, equation_2)
  #       response = { eq_1: 2, eq_2: 7 }
  #       expect(exp.determine_multiplier).to eq response
  #     end
  #
  #     it "return instruction on which equation to mtp by what factor example 4" do
  #       equation_1 = eqn(add(mtp(4, 'x'), mtp(27, 'y')), 10)
  #       equation_2 = eqn(sbt(mtp(6, 'x'), mtp(2, 'y')), 5)
  #       exp = described_class.new(equation_1, equation_2)
  #       response = { eq_1: 3, eq_2: 2 }
  #       expect(exp.determine_multiplier).to eq response
  #     end
  #   end
  # end
  #
  # context '#generate_solution' do
  #   xit "" do
  #     equation_1 = eqn(add(mtp(3, 'x'), mtp(5, 'y')), 10)
  #     equation_2 = eqn(sbt(mtp(6, 'x'), mtp(2, 'y')), 5)
  #     exp = described_class.new(equation_1, equation_2)
  #     response = 1
  #     puts exp.generate_solution[0].latex
  #     expect(exp.generate_solution).to eq response
  #   end
  #
  #   it "" do
  #     equation_1 = eqn(add(mtp(2, 'x'), mtp(-3, 'y')), -15)
  #     equation_2 = eqn(add(mtp(-3, 'x'), mtp(-2, 'y')), -36)
  #     exp = described_class.new(equation_1, equation_2)
  #     response = 1
  #     # p exp.generate_solution[2].ls.flatit.simplify_add_m_forms
  #     # p exp.generate_solution.last.ls.expand.last.simplify_add_m_forms.latex
  #     # puts exp.generate_solution.last.latex
  #     p exp.generate_solution[:steps][4]
  #     expect(exp.generate_solution).to eq response
  #   end
  # end

  context '#solution_latex' do
    # xit "" do
    #   equation_1 = eqn(add(mtp(3, 'x'), mtp(5, 'y')), 10)
    #   equation_2 = eqn(sbt(mtp(6, 'x'), mtp(2, 'y')), 5)
    #   exp = described_class.new(equation_1, equation_2)
    #   response = 1
    #   puts exp.generate_solution[1]
    #   expect(exp.generate_solution).to eq response
    # end

    it "example 1" do
      equation_1 = eqn(add(mtp(2, 'x'), mtp(-3, 'y')), -15)
      equation_2 = eqn(add(mtp(-3, 'x'), mtp(-2, 'y')), -36)
      exp = described_class.new(equation_1, equation_2)
      expect(exp.solution_latex).to eq "\\begin{align*}\n &&  &&  && 2x-3y&=-15&(1)& &&  && \\\\\n &&  &&  && -3x-2y&=-36&(2)& &&  && \\\\[15pt]\n &&  && &(1)\\times3&6x-9y&=-45&(3)& &&  && \\\\\n &&  && &(2)\\times2&-6x-4y&=-72&(4)& &&  && \\\\[15pt]\n &&  && &(3)+(4)&6x-9y+\\left(-6x-4y\\right)&=-45+-72 &&  && \\\\\n &&  &&  && -13y&=-117 &&  && \\\\\n &&  &&  && y&=\\displaystyle\\frac{-117}{-13} &&  && \\\\\n &&  &&  && y&=9 &&  && \\\\[15pt]\n &&  && &\\text{Sub}\\hspace{5pt} y\\hspace{5pt} \\text{into}\\hspace{5pt} (1)&2x-3\\times9&=-15 &&  && \\\\\n &&  &&  && 2x-27&=-15 &&  && \\\\\n &&  &&  && 2x&=-15+27 &&  && \\\\\n &&  &&  && 2x&=12 &&  && \\\\\n &&  &&  && x&=\\displaystyle\\frac{12}{2} &&  && \\\\\n &&  &&  && x&=6 &&  && \n\\end{align*}\n$ y=9, x=6 $"
    end

    it "example 2" do
      equation_1 = eqn(add(mtp(-4, 'x'), mtp(-17, 'y')), -130)
      equation_2 = eqn(add(mtp(-9, 'x'), mtp(-2, 'y')), -75)
      exp = described_class.new(equation_2, equation_1)
      expect(exp.solution_latex).to eq "\\begin{align*}\n &&  &&  && -9x-2y&=-75&(1)& &&  && \\\\\n &&  &&  && -4x-17y&=-130&(2)& &&  && \\\\[15pt]\n &&  && &(1)\\times17&-153x-34y&=-1275&(3)& &&  && \\\\\n &&  && &(2)\\times2&-8x-34y&=-260&(4)& &&  && \\\\[15pt]\n &&  && &(3)-(4)&-153x+-34y-\\left(-8x+-34y\\right)&=-1275--260 &&  && \\\\\n &&  &&  && -145x&=-1015 &&  && \\\\\n &&  &&  && x&=\\displaystyle\\frac{-1015}{-145} &&  && \\\\\n &&  &&  && x&=7 &&  && \\\\[15pt]\n &&  && &\\text{Sub}\\hspace{5pt} x\\hspace{5pt} \\text{into}\\hspace{5pt} (1)&-9\\times7-2y&=-75 &&  && \\\\\n &&  &&  && -2y-63&=-75 &&  && \\\\\n &&  &&  && -2y&=-75+63 &&  && \\\\\n &&  &&  && -2y&=-12 &&  && \\\\\n &&  &&  && y&=\\displaystyle\\frac{-12}{-2} &&  && \\\\\n &&  &&  && y&=6 &&  && \n\\end{align*}\n$ x=7, y=6 $"
    end

    it "example 3" do
      equation_1 = eqn(add(mtp(3, 'x'), mtp(-2, 'y')), 2)
      equation_2 = eqn(add(mtp(-6, 'x'), mtp(2, 'y')), -20)
      exp = described_class.new(equation_2, equation_1)
      expect(exp.solution_latex).to eq "\\begin{align*}\n &&  &&  && 6x+2y&=-20&(1)& &&  && \\\\\n &&  &&  && 3x-2y&=2&(2)& &&  && \\\\[15pt]\n &&  && &(1)+(3)&-6x+2y+\\left(3x-2y\\right)&=-20+2 &&  && \\\\\n &&  &&  && -3x&=-18 &&  && \\\\\n &&  &&  && x&=\\displaystyle\\frac{-18}{-3} &&  && \\\\\n &&  &&  && x&=6 &&  && \\\\[15pt]\n &&  && &\\text{Sub}\\hspace{5pt} x\\hspace{5pt} \\text{into}\\hspace{5pt} (1)&-6\\times6+2y&=-20 &&  && \\\\\n &&  &&  && 2y-36&=-20 &&  && \\\\\n &&  &&  && 2y&=-20+36 &&  && \\\\\n &&  &&  && 2y&=16 &&  && \\\\\n &&  &&  && y&=\\displaystyle\\frac{16}{2} &&  && \\\\\n &&  &&  && y&=8 &&  && \n\\end{align*}\n$ x=6, y=8 $"
    end

    it "example 4" do
      equation_1 = eqn(add('x', 'y'), 13)
      equation_2 = eqn(add(mtp(-2, 'x'), mtp(3, 'y')), 4)
      exp = described_class.new(equation_2, equation_1)
      expect(exp.solution_latex).to eq "\\begin{align*}\n &&  &&  && -2x+3y&=4&(1)& &&  && \\\\\n &&  &&  && x+y&=13&(2)& &&  && \\\\[15pt]\n &&  && &(2)\\times3&3x+3y&=39&(3)& &&  && \\\\[15pt]\n &&  && &(1)-(3)&-2x+3y-\\left(3x+3y\\right)&=4-39 &&  && \\\\\n &&  &&  && -5x&=-35 &&  && \\\\\n &&  &&  && x&=\\displaystyle\\frac{-35}{-5} &&  && \\\\\n &&  &&  && x&=7 &&  && \\\\[15pt]\n &&  && &\\text{Sub}\\hspace{5pt} x\\hspace{5pt} \\text{into}\\hspace{5pt} (1)&-2\\times7+3y&=4 &&  && \\\\\n &&  &&  && 3y-14&=4 &&  && \\\\\n &&  &&  && 3y&=4+14 &&  && \\\\\n &&  &&  && 3y&=18 &&  && \\\\\n &&  &&  && y&=\\displaystyle\\frac{18}{3} &&  && \\\\\n &&  &&  && y&=6 &&  && \n\\end{align*}\n$ x=7, y=6 $"
    end
  end

  context '#extract_var' do
    it "extracts x = 2 from 'x&=2'" do
      exp = described_class.new()
      eqn = eqn('x', 2)
      response = { 'x' => 2 }
      expect(exp.extract_var(eqn)).to eq response
    end

    it "extracts x = 2 from 'yx&=3'" do
      exp = described_class.new()
      eqn = eqn('yx', 3)
      response = { 'yx' => 3 }
      expect(exp.extract_var(eqn)).to eq response
    end
  end
end
