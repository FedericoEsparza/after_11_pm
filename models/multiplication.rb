class Multiplication
  attr_accessor :args

  def initialize(*args)
    @args = args
  end

  def ==(exp)
    args = exp.args
  end

  def evaluate
    args.inject(1){|r,e| r * e}
  end

  def simplify
    mtp_1 = args[0]
    mtp_2 = args[1]
    combined_args = mtp_1.args + mtp_2.args
    result_args = []
    prod = combined_args.inject(1) { |r,e| e.class == Fixnum ? r * e : r }
    result_args << prod
    combined_args.each do |a|
      result_args << a if a.class == String
    end
    result_args
  end
end
