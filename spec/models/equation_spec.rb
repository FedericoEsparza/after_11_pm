describe Equation do
  describe '#initialize' do
    it 'initialise with a left hand side and a right hand side' do
      eqn = eqn('x',3)
      expect(eqn.ls).to eq 'x'
      expect(eqn.rs).to eq 3
    end
  end

  describe '#solve_one_var_eqn' do
    context '#one-step' do
      it 'reverses one step right addition' do
        eqn = eqn(add(3,'x'),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(3,'x'),5),
          eqn('x',sbt(5,3)),
          eqn('x',2)
        ]
      end

      it 'reverses one step left addition' do
        eqn = eqn(add('x',3),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add('x',3),5),
          eqn('x',sbt(5,3)),
          eqn('x',2)
        ]
      end

      it 'reverses one step right multiplication' do
        eqn = eqn(mtp('x',3),15)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(mtp('x',3),15),
          eqn('x',div(15,3)),
          eqn('x',5)
        ]
      end

      it 'reverses one step left multiplication' do
        eqn = eqn(mtp(3,'x'),15)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(mtp(3,'x'),15),
          eqn('x',div(15,3)),
          eqn('x',5)
        ]
      end

      it 'reverses one step right subtraction' do
        eqn = eqn(sbt('x',3),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(sbt('x',3),5),
          eqn('x',add(5,3)),
          eqn('x',8)
        ]
      end

      it 'reverse conventionalised right subtraction' do
        equation = eqn(add('x',-3),5)
        result = equation.solve_one_var_eqn
        expect(result).to eq [
          eqn(add('x',-3),5),
          eqn('x',add(5,3)),
          eqn('x',8)
        ]
      end

      it 'reverses one step left subtraction' do
        eqn = eqn(sbt(5,'x'),3)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(sbt(5,'x'),3),
          eqn('x',sbt(5,3)),
          eqn('x',2)
        ]
      end

      it 'reverses conventionalised one step left subtraction' do
        equation = eqn(add(9,mtp(-1,'x')),3)
        result = equation.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(9,mtp(-1,'x')),3),
          eqn('x',sbt(9,3)),
          eqn('x',6)
        ]
      end

      it 'reverses one step right division' do
        eqn = eqn(div('x',3),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(div('x',3),5),
          eqn('x',mtp(5,3)),
          eqn('x',15)
        ]
      end

      it 'reverses one step left division' do
        eqn = eqn(div(6,'x'),3)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(div(6,'x'),3),
          eqn('x',div(6,3)),
          eqn('x',2)
        ]
      end
    end

    context '#two-steps' do
      it 'solves 2x + 3 = 15' do
        eqn = eqn(add(mtp(2,'x'),3),15)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(mtp(2,'x'),3),15),
          eqn(mtp(2,'x'),sbt(15,3)),
          eqn(mtp(2,'x'),12),
          eqn('x',div(12,2)),
          eqn('x',6)
        ]
      end

      it 'solves 20 - 3x = 5' do
        eqn = eqn(sbt(20,mtp('x',3)),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(sbt(20,mtp('x',3)),5),
          eqn(mtp('x',3),sbt(20,5)),
          eqn(mtp('x',3),15),
          eqn('x',div(15,3)),
          eqn('x',5)
        ]
      end
    end

    context '#three-steps' do
      it 'solves 30/(16-2x) = 3' do
        eqn = eqn(div(30,sbt(16,mtp(2,'x'))),3)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(div(30,sbt(16,mtp(2,'x'))),3),
          eqn(sbt(16,mtp(2,'x')),div(30,3)),
          eqn(sbt(16,mtp(2,'x')),10),
          eqn(mtp(2,'x'),sbt(16,10)),
          eqn(mtp(2,'x'),6),
          eqn('x',div(6,2)),
          eqn('x',3)
        ]
      end
    end

    context '#four-steps' do
      it 'solves 9 + 36 / (7x - 2) = 12' do
        eqn = eqn(add(9,div(36,sbt(mtp(7,'x'),2))),12)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(9,div(36,sbt(mtp(7,'x'),2))),12),
          eqn(div(36,sbt(mtp(7,'x'),2)),sbt(12,9)),
          eqn(div(36,sbt(mtp(7,'x'),2)),3),
          eqn(sbt(mtp(7,'x'),2),div(36,3)),
          eqn(sbt(mtp(7,'x'),2),12),
          eqn(mtp(7,'x'),add(12,2)),
          eqn(mtp(7,'x'),14),
          eqn('x',div(14,7)),
          eqn('x',2)
        ]
      end

      it 'solves conventionalised 9 + 36 / (7x - 2) = 12' do
        eqn = eqn(add(9,div(36,add(mtp(7,'x'),-2))),12)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(9,div(36,add(mtp(7,'x'),-2))),12),
          eqn(div(36,add(mtp(7,'x'),-2)),sbt(12,9)),
          eqn(div(36,add(mtp(7,'x'),-2)),3),
          eqn(add(mtp(7,'x'),-2),div(36,3)),
          eqn(add(mtp(7,'x'),-2),12),
          eqn(mtp(7,'x'),add(12,2)),
          eqn(mtp(7,'x'),14),
          eqn('x',div(14,7)),
          eqn('x',2)
        ]
      end
    end
  end

  describe '#change_subject_to' do
    it 'change subject to x for x+y=10' do
      equation = eqn(add('x','y'),10)
      result = equation.change_subject_to('x')
      expect(result).to eq [
        eqn(add('x','y'),10),
        eqn('x',sbt(10,'y'))
      ]
    end

    it 'change subject to y^2 of x+y^2=10' do
      equation = eqn(add('x',pow('y',2)),10)
      result = equation.change_subject_to(pow('y',2))
      expect(result).to eq [
        eqn(add('x',pow('y',2)),10),
        eqn(pow('y',2),sbt(10,'x'))
      ]
    end

    it 'change subject to z for x+y=10' do
      equation = eqn(add('x','y'),10)
      result = equation.change_subject_to('z')
      expect(result).to eq nil
    end

    it 'change subject to x for xy=5' do
      eqn = eqn(mtp('x','y'),5)
      result = eqn.change_subject_to('x')
      expect(result).to eq [
        eqn(mtp('x','y'),5),
        eqn('x',div(5,'y'))
      ]
    end

    it 'change subject to y for x+y+2z = 6' do
      eqn = eqn(add('x','y',mtp(2,'z')),6)
      result = eqn.change_subject_to('y')

      expect(result).to eq [
        eqn(add('x','y',mtp(2,'z')),6),
        eqn('y',sbt(6,add('x',mtp(2,'z'))))
      ]
    end

    it 'change subject to y^2 for x+2y^2 = 4z' do
      eqn = eqn(add('x',mtp(2,pow('y',2))),mtp(4,'z'))
      result = eqn.change_subject_to(pow('y',2))

      expect(result).to eq [
        eqn(add('x',mtp(2,pow('y',2))),mtp(4,'z')),
        eqn(mtp(2,pow('y',2)),sbt(mtp(4,'z'),'x')),
        eqn(pow('y',2),div(sbt(mtp(4,'z'),'x'),2))
      ]
    end

  end
end
