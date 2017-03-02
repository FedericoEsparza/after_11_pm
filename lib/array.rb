class Array
  def equalise_array_lengths
    max_length = inject(0) { |curr_max,arr| [arr.length,curr_max].max }
    each{ |arr| (max_length - arr.length).times{ arr << arr.last } }
    self
  end


  def greater?(exp)
    array = self
    i = 0
    a_1 = []
    a_2 = []
    array.each{|a| a_1 << a if !(a.is_a?(Numeric))}
    exp.each{|a| a_2 << a if !(a.is_a?(Numeric))}
    while i < [a_1.length,a_2.length].min

      if a_1[i].greater?(a_2[i])
        return true
      elsif !(a_1[i] == a_2[i])
        return false
      end
      i = i+1
    end
    a_1.length.greater?(a_2.length)
  end

  def sort_elements
    old_array = self
    array = []
    old_array.each{|a| array << a.sort_elements}
      number_of_items = array.length
      number_of_swaps = 0
      for x in 0...(number_of_items-1)
        if  array[x+1].greater?(array[x])
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

    def evaluate_product
      array = self
      if array == []
        1
      else
        array.inject(:*)
      end
    end

    def evaluate_sum
      array = self
      if array == []
        0
      else
        array.inject(0){|sum,x| sum + x }
      end
    end



    ##is no longer needed, will keep if wanted later

    # def find_common(array_2)
    #   array_1 = self
    #   result = []
    #   done = 0
    #   while done ==0
    #     common = array_1 & array_2
    #     p common
    #     if common == []
    #       done = 1
    #     else
    #       result = result + common
    #       array_1 = array_1 - common
    #       array_2 = array_2 - common
    #     end
    #   end
    #   result
    # end

end
