require 'deep_clone'
require './models/class_names'
require './lib/array'
require './lib/string'
require './models/multiplication'
require './models/power'
require './models/addition'
require './models/variables'
require './models/numerals'
require './models/factory'

class Fixnum

  def greater? (exp)
    if exp.is_a?(Fixnum)
      self > exp
    else
      false
    end
  end

  def sort_elements
    self
  end

  # def <(exp)
  #   if exp.is_a?(String)
  #     self > exp
  #   else
  #     self < exp.args.first
  #   end
  # end


end
