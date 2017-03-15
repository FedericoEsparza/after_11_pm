class WorksheetGenerator

  def generate_worksheet(params)
    # params = {}
    gen_instance = self
    questions = gen_instance.generate_questions(params[:options])
    questions = questions.values.flatten
    questions_latex = []
    questions.each_with_index do |question, index|
      index = index + 1
      question_latex = question.question_latex
      question_latex = add_question_num(latex: question_latex, question_num: index)
      question_latex = add_minipage(latex: question_latex, questions_per_row: 1)
      questions_latex << question_latex
    end

    add_page(latex: questions_latex.join, type: :question, title: 'Single Variable Questions')
  end

  def generate_questions(options)
    # options = { question_type: [2, {number_of_steps: 4}] }
    response = to_hash(options.keys)
    options.each do |question_type, params|
      params[0].times do
        response[question_type] << ClassName.send(question_type).generate_question(params[1])
      end
    end
    response
  end

  private

  def to_hash(array_hash_keys)
    response = {}
    array_hash_keys.each do |key|
      response[key] = []
    end
    response
  end

  def add_question_num(latex:, question_num:)
    matcher = "\\begin{align*}\n"
    num_latex = question_num.to_s + '.\\hspace{30pt}' + "\n"
    index = latex.index(matcher) + matcher.length
    latex = latex.dup

    latex.insert(index, num_latex)
  end
end
