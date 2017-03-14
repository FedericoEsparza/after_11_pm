describe SingleVariableQuestion do
  context '#initialize' do
    it 'with default options hash' do
      obj = described_class.new
      defaults = { variable: 'x',
                   number_of_steps: 2,
                   solution_max: 10,
                   negative_allowed: false,
                   multiple_division: false
                 }

      expect(obj.options).to eq defaults
    end

    it 'with mixed default and user provided values' do
      obj = described_class.new(solution_max: 20, multiple_division: true, variable: 'j')
      options = { variable: 'j',
                  number_of_steps: 2,
                  solution_max: 20,
                  negative_allowed: false,
                  multiple_division: true
                }
      expect(obj.options).to eq options
    end
  end

  context '#generate_question' do
    it 'sample equation 1 default options (2 step)' do
      srand(100)
      obj = described_class.generate_question
      expect(obj.question).to eq eqn(add(62, mtp(-1, add(mtp(1, 'x'), 2))), 50)
    end

    it 'sample equation 2 custom options (4 step)' do
      srand(105)
      obj = described_class.generate_question(number_of_steps: 4)
      expect(obj.question).to eq eqn(add(div(174, add(46, mtp(6, mtp(1, 'x')))), 83), 86)
    end
  end

  context '#generate_solution' do
    it 'srand(100) returns solution for 62 - (x+2)' do
      srand(100)
      obj = described_class.generate_question
      expect(obj.generate_solution).to eq eqn(add(62, mtp(-1, add(mtp(1, 'x'), 2))), 50).solve_one_var_eqn
    end
  end

  context '#question_latex' do
    it 'returns 62 - (x+2)' do
      obj = described_class.new
      allow(obj).to receive(:question).and_return(eqn(add(62, mtp(-1, add(mtp(1, 'x'), 2))), 50))
      response = eqn(add(62, mtp(-1, add(mtp(1, 'x'), 2))), 50).latex
      expect(obj.question_latex).to eq LatexUtilities::add_align_env(response)
    end
  end

  context '#solution_latex' do
    it 'returns formated solution for 62 - (x+2)' do
      srand(100)
      obj = described_class.generate_question
      # p obj.solution_latex
      expect(obj.solution_latex).to eq "\\begin{align*}\n &&  && 62-\\left(x+2\\right)&=50 &&  && \\\\[15pt]\n &&  && x+2&=62-50 &&  && \\\\[5pt]\n &&  && x+2&=12 &&  && \\\\[5pt]\n &&  && x&=12-2 &&  && \\\\[5pt]\n &&  && x&=10 &&  && \\\\[5pt]\n &&  && x&=\\displaystyle\\frac{10}{1} &&  && \\\\[5pt]\n &&  && x&=10 &&  && \n\\end{align*}\n$ x&=10 $"
    end
  end

end
