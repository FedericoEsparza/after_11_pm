include Factory

class QuadraticEquation

  attr_accessor :quad_term, :linear_term, :constant_term, :variable

  def initialize(quad_term:, linear_term:, constant_term:, variable:)
    @quad_term = quad_term
    @linear_term = linear_term
    @constant_term = constant_term
    @variable = variable
  end

  def ==(exp)
    exp.class == self.class && quad_term == exp.quad_term && linear_term == exp.linear_term && constant_term == exp.constant_term
  end


  ##make this work later, don't get distracted


  # def simplify
  #   quad_factors = prime_factorisation(quad_term)
  #   linear_factors = prime_factorisation(linear_term)
  #   constant_factors = prime_factorisation(constant_term)
  #   common_factors = quad_factors & linear_factors & constant_factors
  #   common_powers = []
  #
  #   product = common_factors.evaluate_product
  #   self.quad_term = quad_term/product
  #   self.linear_term = linear_term/product
  #   self.constant_term = constant_term/product
  #   self
  # end

  def prime_factorisation(n)
    Prime.prime_division(n).flat_map { |factor, power| [factor] * power }
  end

  def get_method
    method = {
      Product:[mtp(quad_term,constant_term),mtp(quad_term,constant_term).evaluate_numeral],
      Sum:linear_term
    }
  end

  def latex_method
    method = get_method
    result = 'P=' + method[:Product][0].latex
    if quad_term != 1
      result += '=' + method[:Product][1].latex
    end
    result += ' \hspace{30pt}S=' + method[:Sum].latex
    result
  end

  def get_factors
    product = get_method[:Product][1]
    sum = get_method[:Sum]
    attempts = product.factorisation
    if product > 0
      new_attempts = []
      attempts.each{|factor| new_attempts << factor.map{|a| -a}}
      attempts += new_attempts
    end
    done = 0
    i = 1
    while done == 0
      if attempts[i].evaluate_sum == sum
        done = 1
        factors = attempts[i]
      else
        i = i+1
      end
    end
    factors
  end

  def write_factors
    steps = [get_factors]
    if quad_term != 1
      steps << steps.last.map{|a| frac(a,quad_term)}
      steps << steps.last.map{|a| a.simplify}
    end
    steps
  end

  def factors_used
    [write_factors.last[0],write_factors.last[1]]
  end

  def brackets_used
    mtp(
      add(variable,factors_used[0]),
      add(variable,factors_used[1])
    )
  end



  def write_factorisation_solution
    equa = [mtp(quad_term,pow(variable,2))]
    if linear_term == 1
      equa << variable
    elsif linear_term != 0
      equa << mtp(linear_term,variable)
    end

    if constant_term != 0
      equa << constant_term
    end

    equa = add(equa)
    steps = [equa]

    steps << brackets_used
    steps << factors_used.map do |a|
      if a.is_a?(Fraction)
        a.negative
      else
        -a
      end
    end
  end

  def latex_factors
    factors = write_factors
    result = ''
    factors.each do |factor|
      brackets = '\left(' + factor[0].latex + ',\,\,' +
      factor[1].latex + '\right)\hspace{10pt}'
      result += brackets
    end
    result
  end

  def write_whole_solution
    {method:latex_method, factors:latex_factors, steps:write_factorisation_solution}
  end

  def latex

    latex_steps = '\begin{align*}
    '
    solution = write_whole_solution
    solution_steps = solution[:steps]
    latex_steps += '0&=' + solution_steps[0].latex +
    '& && &' + solution[:method] + '&\\\[5pt]
    '


    latex_steps += '0&=' + solution_steps[1].latex  +
    '& && &' + solution[:factors] + '&\\\[5pt]
    '

    answer = variable + '&=' + solution_steps[2][0].latex +
    ' ,\,\, ' + solution_steps[2][1].latex + '\\\[5pt]
    '

    latex_steps += answer
    latex_steps += '\end{align*}'

  end

end
