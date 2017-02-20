class Array
  def equalise_array_lengths
    max_length = inject(0) { |curr_max,arr| [arr.length,curr_max].max }
    each{ |arr| (max_length - arr.length).times{ arr << arr.last } }
    self
  end
end
