describe Factory do
  let(:dummy_class){(Class.new{include Factory}).new}

  describe '#add' do
    it 'instantiates with plat argument' do
      expect(dummy_class.add(1,2,3)).to eq Addition.new(1,2,3)
    end

    it 'instantiates with array argument' do
      expect(dummy_class.add([1,2,3])).to eq Addition.new(1,2,3)
    end
  end

end
