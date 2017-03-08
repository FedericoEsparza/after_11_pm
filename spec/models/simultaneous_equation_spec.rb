describe SimultaneousEquation do
  context '#extract_coefficient' do
    it "extract 3 and 5 from 3x+5y=10" do
      equation = eqn(add(mtp(3, 'x'), mtp(5, 'y')), 10)
      # p mtp(3, 'x').fetch(object: :numeric)
      response = { 'x' => 3, 'y' => 5 }
      exp = described_class.new(equation, equation)
      expect(exp.extract_coefficient(equation)).to eq response
    end

    it "extract 3 and 1 from 3x+y=10" do
      equation = eqn(add(mtp(3, 'x'), 'y'), 10)
      # p mtp(3, 'x').fetch(object: :numeric)
      response = { 'x' => 3, 'y' => 1 }
      exp = described_class.new(equation, equation)
      expect(exp.extract_coefficient(equation)).to eq response
    end
  end

  context '#determine_multiplier' do
    it "return instruction on which equation to mtp by what factor example 1" do
      equation_1 = eqn(add(mtp(3, 'x'), mtp(5, 'y')), 10)
      equation_2 = eqn(sbt(mtp(6, 'x'), mtp(2, 'y')), 5)
      exp = described_class.new(equation_1, equation_2)
      response = { eq_1: 2 }
      expect(exp.determine_multiplier).to eq response
    end

    it "return instruction on which equation to mtp by what factor example 2" do
      equation_1 = eqn(add(mtp(4, 'x'), mtp(5, 'y')), 10)
      equation_2 = eqn(sbt(mtp(2, 'x'), mtp(2, 'y')), 5)
      exp = described_class.new(equation_1, equation_2)
      response = { eq_2: 2 }
      expect(exp.determine_multiplier).to eq response
    end

    it "return instruction on which equation to mtp by what factor example 3" do
      equation_1 = eqn(add(mtp(5, 'x'), mtp(2, 'y')), 10)
      equation_2 = eqn(sbt(mtp(2, 'x'), mtp(8, 'y')), 5)
      exp = described_class.new(equation_1, equation_2)
      response = { eq_1: 4 }
      expect(exp.determine_multiplier).to eq response
    end

    it "return instruction on which equation to mtp by what factor example 4" do
      equation_1 = eqn(add(mtp(5, 'x'), mtp(50, 'y')), 10)
      equation_2 = eqn(sbt(mtp(2, 'x'), mtp(5, 'y')), 5)
      exp = described_class.new(equation_1, equation_2)
      response = { eq_2: 10 }
      expect(exp.determine_multiplier).to eq response
    end

    context 'lcm' do
      it "return instruction on which equation to mtp by what factor example 1" do
        equation_1 = eqn(add(mtp(3, 'x'), mtp(7, 'y')), 10)
        equation_2 = eqn(sbt(mtp(2, 'x'), mtp(2, 'y')), 5)
        exp = described_class.new(equation_1, equation_2)
        response = { eq_1: 2, eq_2: 3 }
        expect(exp.determine_multiplier).to eq response
      end

      it "return instruction on which equation to mtp by what factor example 2" do
        equation_1 = eqn(add(mtp(3, 'x'), mtp(7, 'y')), 10)
        equation_2 = eqn(sbt(mtp(2, 'x'), mtp(2, 'y')), 5)
        exp = described_class.new(equation_1, equation_2)
        response = { eq_1: 2, eq_2: 3 }
        expect(exp.determine_multiplier).to eq response
      end

      it "return instruction on which equation to mtp by what factor example 3" do
        equation_1 = eqn(add(mtp(11, 'x'), mtp(7, 'y')), 10)
        equation_2 = eqn(sbt(mtp(2, 'x'), mtp(2, 'y')), 5)
        exp = described_class.new(equation_1, equation_2)
        response = { eq_1: 2, eq_2: 7 }
        expect(exp.determine_multiplier).to eq response
      end

      it "return instruction on which equation to mtp by what factor example 4" do
        equation_1 = eqn(add(mtp(4, 'x'), mtp(27, 'y')), 10)
        equation_2 = eqn(sbt(mtp(6, 'x'), mtp(2, 'y')), 5)
        exp = described_class.new(equation_1, equation_2)
        response = { eq_1: 3, eq_2: 2 }
        expect(exp.determine_multiplier).to eq response
      end
    end
  end

  context '#solve' do
    it "" do
      equation_1 = eqn(add(mtp(3, 'x'), mtp(5, 'y')), 10)
      equation_2 = eqn(sbt(mtp(6, 'x'), mtp(2, 'y')), 5)
      exp = described_class.new(equation_1, equation_2)
      response = 1
      puts exp.solve[0].latex
      expect(exp.solve).to eq response
    end
  end
end
