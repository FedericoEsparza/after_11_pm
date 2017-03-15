class WorksheetGenerator

  def generate_worksheet(params)
    # params = {}
    gen_instance = self
    questions = gen_instance.generate_questions(params[:options])
    questions = questions.values.flatten
    questions_latex = questions_sheet(questions)
    solutions_latex = solutions_sheet(questions)

    Response.new(question_sheet: questions_latex, solution_sheet: solutions_latex)
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

  def questions_sheet(questions_array)
    questions_latex = []
    questions_array.each_with_index do |question, index|
      index = index + 1
      question_latex = question.question_latex
      question_latex = add_question_num(latex: question_latex, question_num: index)
      question_latex = add_minipage(latex: question_latex, questions_per_row: 1)
      questions_latex << question_latex
    end

    questions_latex = add_page(latex: questions_latex.join, type: :question, title: 'Single Variable Questions')
  end

  def solutions_sheet(questions_array)
    solutions_latex = []
    questions_array.each_with_index do |question, index|
      index = index + 1
      solution_latex = question.solution_latex
      solution_latex = add_question_num(latex: solution_latex, question_num: index)
      solution_latex = add_minipage(latex: solution_latex, questions_per_row: 1)
      solutions_latex << solution_latex
    end

    solutions_latex = add_page(latex: solutions_latex.join, type: :solution, title: 'Single Variable Solutions')
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

  class Response
    attr_reader :question_sheet, :solution_sheet

    def initialize(question_sheet:, solution_sheet:)
      @question_sheet = question_sheet
      @solution_sheet = solution_sheet
    end

    def file
      response = []
      name = LatexUtilities::generate_serial + '_' + Time.now.strftime("%d_%m_%Y") + '_' + 'worksheet'
      response << GeneralUtilities::to_file(name: name + '_questions', content: question_sheet)
      response << GeneralUtilities::to_file(name: name + '_solutions', content: solution_sheet)
    end
  end
end
