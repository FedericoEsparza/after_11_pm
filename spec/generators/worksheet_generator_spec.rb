describe WorksheetGenerator do
  context '#generate_worksheet' do
    it 'returns worksheet in string format' do
      params = { options: { single_var_qs: [2, {}] } }
      gen = described_class.new().generate_worksheet(params)
      puts gen
    end
  end

  context '#generate_questions' do
    it 'generates 2 questions of type single variable linear eq' do
      gen = described_class.new()
      options = { single_var_qs: [2, {}] }
      result = gen.generate_questions(options)
      expect(result[:single_var_qs].length).to eq 2
      expect(result[:single_var_qs].first).to be_a(SingleVariableQuestion)
    end

    it 'generate one of each sin_eqn_qs and sim_eqn_qs' do
      gen = described_class.new
      options = { sin_eqn_qs: [1, {}], sim_eqn_qs: [1, {}] }
      result = gen.generate_questions(options)
      expect(result.length).to eq 2
      expect(result.values.flatten.first).to be_a(SineEquationQuestion)
      expect(result.values.flatten.last).to be_a(SimultaneousEquationQuestion)
    end
  end

  context '#test' do
    it "test" do
      # p ClassName.send(:single_var_qs).new
      # p SerialGenerator::generate_serial
    end

  end

end
