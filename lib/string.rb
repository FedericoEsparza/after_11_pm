require 'deep_clone'
require './models/class_names'
require './lib/array'
require './lib/numeric'
require './models/multiplication'
require './models/power'
require './models/addition'
# require './models/variables'
require './models/numerals'
require './models/factory'

class String

  def >(exp)
    if exp.is_a?(String)
      self < exp
    elsif exp.is_a?(Numeric)
      true
    else
      self > exp.args.first
    end
  end

  def sort_elements
    self
  end


end
