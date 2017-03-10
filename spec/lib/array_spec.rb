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

  context '#to_latex' do
    it "converts [eqn(mtp(2, 'x'), 2)] to ['2x=2']" do
      array = [eqn(mtp(2, 'x'), 2)]
      expect(array.to_latex).to eq ['2x&=2']
    end

    it "converts [[eqn(mtp(2, 'x'), 2)]] to [['2x=2']]" do
      array = [[eqn(mtp(2, 'x'), 2)]]
      expect(array.to_latex).to eq [['2x&=2']]
    end

    it "converts [eqn(add(mtp(2, 'x'), 2), 2), [eqn(mtp(2, 'x'), 2)]] to [['2x=2']]" do
      array = [eqn(add(mtp(2, 'x'), 2), 2), [eqn(mtp(2, 'x'), 2)]]
      expect(array.to_latex).to eq ['2x+2&=2',['2x&=2']]
    end

  end

  # describe '#find_common' do
  #   it 'finds common with [1,2,2,3] and [2,2,1,4]' do
  #     array_1 = [1,2,3]
  #     array_2 = [2,1,4]
  #     result = array_1.find_common(array_2)
  #     expect(result).to eq [1,2,2]
  #   end
  # end
end
