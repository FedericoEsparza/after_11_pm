describe WorksheetGenerator do
  context '#generate_worksheet' do
    it 'returns worksheet in string format for question' do
      srand(100)
      params = { options: { single_var_qs: [2, {}] } }
      question = single_var_qs.new
      question.question = eqn(add(mtp(2, 'x'), 2), 10)

      gen = described_class.new()

      questions = { t: [question], g: [question]}
      allow(gen).to receive(:generate_questions).and_return(questions)
      result = gen.generate_worksheet(params)
      # p result.question_sheet
      expect(result.question_sheet).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{-IY377042-Q\\quad \\textcopyright\\, One Maths 2017}\n\\rfoot{\\textit{student:}\\quad }\n\\begin{document}\n\\section*{\\centerline{Single Variable Questions}}\n\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\n2x+2&=10\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}\n2x+2&=10\n\\end{align*}\n\\end{minipage}\n\\end{document}"
    end

    it 'returns worksheet in string format for question' do
      srand(100)
      params = { options: { single_var_qs: [2, {}] } }
      question = single_var_qs.new
      question.question = eqn(add(mtp(2, 'x'), 2), 10)

      gen = described_class.new()

      questions = { t: [question], g: [question]}
      allow(gen).to receive(:generate_questions).and_return(questions)
      result = gen.generate_worksheet(params)
      # p result.solution_sheet
      expect(result.solution_sheet).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{-VC221084-S\\quad \\textcopyright\\, One Maths 2017}\n\\rfoot{\\textit{student:}\\quad }\n\\begin{document}\n\\section*{\\centerline{Single Variable Solutions}}\n\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\n &&  && 2x+2&=10 &&  && \\\\[15pt]\n &&  && 2x&=10-2 &&  && \\\\[5pt]\n &&  && 2x&=8 &&  && \\\\[5pt]\n &&  && x&=\\displaystyle\\frac{8}{2} &&  && \\\\[5pt]\n &&  && x&=4 &&  && \n\\end{align*}\n$ x&=4 $\\end{minipage}\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}\n &&  && 2x+2&=10 &&  && \\\\[15pt]\n &&  && 2x&=10-2 &&  && \\\\[5pt]\n &&  && 2x&=8 &&  && \\\\[5pt]\n &&  && x&=\\displaystyle\\frac{8}{2} &&  && \\\\[5pt]\n &&  && x&=4 &&  && \n\\end{align*}\n$ x&=4 $\\end{minipage}\n\\end{document}"
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
      params = { options: { single_var_qs: [2, {}] } }
      result = described_class.new().generate_worksheet(params)
      # p result.file

      # p ClassName.send(:single_var_qs).new
      # p SerialGenerator::generate_serial
    end

  end

end
