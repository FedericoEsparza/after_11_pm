describe SimultaneousEquationQuestion do
  context '#initialize' do
    it 'with default options hash' do
      obj = described_class.new()
      defaults = { solution_set: remove_zero((-4..4).to_a),
                   coef_range_1: remove_zero((-9..9).to_a),
                   coef_range_2: remove_zero((-9..9).to_a),
                   negative_solution_allowed: false,
                   vars: %w(x y)
                 }
      expect(obj.options).to eq defaults
    end

    it 'with mixed default and user provided values' do
      obj = described_class.new(solution_set: (-2..2).to_a,
                                vars: %w(k j))
      options = { solution_set: remove_zero((-2..2).to_a),
             coef_range_1: remove_zero((-9..9).to_a),
             coef_range_2: remove_zero((-9..9).to_a),
             negative_solution_allowed: false,
             vars: %w(k j)
           }
      expect(obj.options).to eq options
    end
  end

  context '#generate_question' do
    it 'equation sample 1' do
      srand(100)
      obj = described_class.generate_question
      response = [eqn(add(mtp(-6, 'x'), mtp(7, 'y')), -3), eqn(add(mtp(-2, 'x'), mtp(1, 'y')), -5)]
      expect(obj.question).to eq response
    end

  end

  context '#solution_latex' do
    it 'solve via elimination' do
      srand(100)
      obj = described_class.generate_question
      # puts obj.solution_latex
      expect(obj.solution_latex).not_to be nil
    end

    xit 'solve via substitution' do
      srand(1010)
      obj = described_class.generate_question
      puts obj.solution_latex(method: :sub)
      expect(obj.solution_latex).not_to be nil
    end
  end

  context '#question_latex' do
    it 'it generates latex for question' do
      srand(100)
      obj = described_class.generate_question
      expect(obj.question_latex).to eq "\\begin{align*}\n-6x+7y&=-3\\\\\n-2x+y&=-5\n\\end{align*}\n"
    end
  end
end
