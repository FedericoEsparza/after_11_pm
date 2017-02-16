require './models/class_names'
require './models/array'

describe Array do
  describe '#equalise_array_lengths' do
    it 'change [[1,2],[1,2,3]] to [[1,2,2],[1,2,3]]' do
      arrays = [[1,2],[1,2,3]]
      new_arrays = arrays.equalise_array_lengths
      expect(new_arrays).to eq [[1,2,2],[1,2,3]]
    end
    it 'change [[1],[1,2],[1,2,3]] to [[1,1,1],[1,2,2],[1,2,3]]' do
      arrays = [[1],[1,2],[1,2,3]]
      new_arrays = arrays.equalise_array_lengths
      expect(new_arrays).to eq [[1,1,1],[1,2,2],[1,2,3]]
      test_a = [[1,2,3],[4,5,6],[7,8,9]]
      expect(test_a.transpose).to eq [[1,4,7],[2,5,8],[3,6,9]]
    end
  end


  #
  # describe '#simplify' do
  #   it 'simplifies 2x * 3x' do
  #     exp = mtp(mtp(2,'x'),mtp(3,'x'))
  #     # expect(exp.simplify).to eq mtp(6,mtp('x','x'))
  #     expect(exp.simplify).to eq mtp(6,'x','x')
  #   end
  # end
  #
  # describe '#collect_same_base' do
  #   it 'collects powers of the same base while deleting them from self' do
  #     exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
  #     result = exp.collect_same_base('x')
  #     expect(exp).to eq mtp(mtp(pow('y',3)),mtp(pow('y',5)))
  #     expect(result).to eq [pow('x',2),pow('x',4)]
  #   end
  # end

end
