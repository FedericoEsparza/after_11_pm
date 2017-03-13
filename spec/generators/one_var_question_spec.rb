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
    it 'generates question' do
      p GeneralUtilities::trie_depth(add('x'))
      p GeneralUtilities.deep([[], []])
    end
  end

  context '#generate_solution' do
    it 'generates question' do

    end
  end

  context '#question_latex' do
    it 'generates question' do

    end
  end

  context '#solution_latex' do
    it 'generates question' do

    end
  end

end
