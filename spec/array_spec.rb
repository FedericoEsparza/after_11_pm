require './lib/array'

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

  describe '#==' do
    it 'equates [x^2,3y^3]' do
      a_1 = [pow('x',2),mtp(3,pow('y',3))]
      a_2 = [pow('x',2),mtp(3,pow('y',3))]
      expect(a_1).to eq a_2
    end

    # it 'test unique' do
    #   a = [pow('x',2),pow('x',2)]
    #   result = a.uniq
    #   expect(result).to eq [pow('x',2)]
    # end
  end

  describe '#>' do

    it 'checks [x,y,z] > [x,y]' do
      a_1 = ['x','y','z']
      a_2 = ['x','y']
      result = a_1.greater?(a_2)
      expect(result).to eq true
    end

    it 'checks [x,y] > [x,y,z]' do
      a_1 = ['x','y']
      a_2 = ['x','y','z']
      result = a_1.greater?(a_2)
      expect(result).to eq false
    end

    it 'checks [x] > [4]' do
      a_1 = ['x']
      a_2 = [4]
      result = a_1.greater?(a_2)
      expect(result).to eq true
    end
  end

  describe '#sort_elements' do


    it 'sorts [y,z,x]' do
      exp = ['y','z','x']
      result = exp.sort_elements
      expect(result).to eq ['x','y','z']
    end

    it 'sorts [x^2,x^3]' do
      exp = [pow('x',2),pow('x',3)]
      result = exp.sort_elements
      expect(result).to eq [pow('x',3),pow('x',2)]
    end

    it 'sorts [x,4]' do
      exp = [4,'x']
      result = exp.sort_elements
      expect(result).to eq ['x',4]
    end

    it 'sorts [5x,4,x^3,7x^2]' do
      exp = [mtp(5,'x'),4,pow('x',3),mtp(7,pow('x',2))]
      result = exp.sort_elements
      expect(result).to eq [pow('x',3),mtp(pow('x',2),7),mtp('x',5),4]
    end

    it 'sorts [xy,x^2,yx,y^2]' do
      exp = [mtp('x','y'),pow('x',2),mtp('y','x'),pow('y',2)]
      result = exp.sort_elements
      expect(result).to eq [pow('x',2),mtp('x','y'),mtp('x','y'),pow('y',2)]
    end

    it 'sorts x^x+x^2+y2x+4y^4x^2+x^(y^2)+x^(x^2)' do
      exp = add(pow('x','x'),pow('x',2),mtp('y',2,'x'),mtp(4,pow('y',4),pow('x',2)),pow('x',pow('y',2)),pow('x',pow('x',2)))
      result = exp.sort_elements
      expect(result).to eq add(pow('x',pow('x',2)),pow('x','x'),pow('x',pow('y',2)),mtp(pow('x',2),pow('y',4),4),pow('x',2),mtp('x','y',2))
    end

    it 'sorts[x^2,y^4x^2]' do
      exp = [pow('x',2),mtp(4,pow('y',4),pow('x',2))]
      result = exp.sort_elements
      expect(result).to eq [mtp(pow('x',2),pow('y',4),4),pow('x',2)]
    end

  end

  # describe '#==' do
  #   it 'checks [1,2] == [1,2]' do
  #     a_1 = [1,2]
  #     a_2 = [1,2]
  #     expect(a_1).to eq a_2
  #   end
  #
  #   it 'checks [xy,x,x^3z^2,3y] == [x,xy,x^3z^2,3y]' do
  #     a_1 = [mtp('x','y'),'x',mtp(pow('x',3),pow('z',2)),mtp(3,'y')]
  #     a_2 = ['x',mtp('x','y'),mtp(pow('x',3),pow('z',2)),mtp(3,'y')]
  #     result = a_1.same_elements(a_2)
  #     expect(result).to eq true
  #   end
  #
  #   it 'checks [xy,x,x^3z^2,3y] == [xy,x,x^3z^2,4y]' do
  #     a_1 = [mtp('x','y'),'x',mtp(pow('x',3),pow('z',2)),mtp(3,'y')]
  #     a_2 = [mtp('x','y'),'x',mtp(pow('x',3),pow('z',2)),mtp(4,'y')]
  #     result = a_1.same_elements(a_2)
  #     expect(result).to eq false
  #     puts a_1
  #   end
  #
  #   it 'checks [x^(3+y^2),(a+b)^c] = [x^(3+y^2),(a+b)^c]' do
  #     a_1 = [pow('x',add(3,pow('y',2))),pow(add('a','b'),'c')]
  #     a_2 = [pow('x',add(3,pow('y',2))),pow(add('a','b'),'c')]
  #     result = a_1.same_elements(a_2)
  #     expect(result).to eq true
  #   end
  # end
  #
  # describe '#same_elements' do
  #   it 'checks equality' do
  #     a_1 = [pow('x',2),'y']
  #     a_2 = [pow('x',2),'y']
  #     result = a_1.same_elements(a_2)
  #     expect(result).to eq true
  #   end
  # end
end
