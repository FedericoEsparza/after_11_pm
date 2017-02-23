require 'deep_clone'
require './models/class_names'
require './lib/array'
require './lib/string'
require './lib/numeric'
require './models/multiplication'
require './models/power'
require './models/addition'
# require './models/variables'
require './models/numerals'
require './models/factory'

class Array
  def equalise_array_lengths
    max_length = inject(0) { |curr_max,arr| [arr.length,curr_max].max }
    each{ |arr| (max_length - arr.length).times{ arr << arr.last } }
    self
  end

  # def select_powers
  #   array = self
  #   powers = []
  #   non_powrs = []
  #   array.each do |a|
  #     if a.is_a?(Power)
  #       powers << a
  #     else
  #       non_powers << a
  #     end
  #   end
  #   return [powers,non_powers]
  # end

#only use for two arrays

  def ==(exp)
    if self.class == exp.class && self.length == exp.length
      self.each_with_index{|a,i| return false if !(a==exp[i])}
    end
  end

  def >(exp)
    array = self
    i = 0
    a_1 = []
    a_2 = []
    array.each{|a| a_1 << a if !(a.is_a?(Numeric))}
    exp.each{|a| a_2 << a if !(a.is_a?(Numeric))}
    while i < [a_1.length,a_2.length].min

      if a_1[i] > a_2[i]
        return true
      elsif !(a_1[i] == a_2[i])
        return false
      end
      i = i+1
    end
    a_1.length > a_2.length
  end

  def sort_elements
      old_array = self
      array = []
      old_array.each{|a| array << a.sort_elements}
        number_of_items = array.length
        number_of_swaps = 0
        for x in 0...(number_of_items-1)
          if  array[x+1] > array[x]
            array[x+1],array[x] = array[x],array[x+1]
            number_of_swaps += 1
          end
        end
        if number_of_swaps == 0
            return array
        else
            array.sort_elements
        end
  end

  # def ==(exp)
  #   same = 1
  #   a1 = self
  #   a2 = exp
  #   a1.each do |a|
  #     a2.each do |b|
  #       if a == b
  #         a1.delete(a)
  #         a2.delete(a)
  #         if a1 == a2
  #           return true
  #         end
  #       end
  #     end
  #   end
  #   return false
  # end

  # def same_elements(exp)
  #   b1 = []
  #   self.each do |a|
  #     if a.is_a?(Power)
  #       b1 << [a.base,a.index]
  #     else
  #       b1 << a
  #     end
  #   end
  #   b2 = []
  #   exp.each do |a|
  #     if a.is_a?(Power)
  #       b2 << [a.base,a.index]
  #     else
  #       b2 << a
  #     end
  #   end
  #   b1.to_set == b2.to_set
  # end




end
