#no order switching is allowed!!  so x2 stays x2...for now and a long while

feature '#latex' do
  context 'one_step' do
    context 'addition' do
      scenario '' do
        exp = add('x',2)
        expect(exp.latex).to eq 'x+2'
      end

      scenario '' do
        exp = add(15,'x','y')
        expect(exp.latex).to eq '15+x+y'
      end
    end

    context 'multiplication' do
      scenario '' do
        exp = mtp(2,3)
        expect(exp.base_latex).to eq '2\times3'
      end

      scenario '' do
        exp = mtp(2,'x')
        expect(exp.latex).to eq '2x'
      end

      scenario '' do
        exp = mtp(2,3,'x')
        expect(exp.latex).to eq '2\times3x'
      end

      scenario '' do
        exp = mtp(2,3,'x','y')
        expect(exp.latex).to eq '2\times3xy'
      end
    end

    context 'subtraction' do
      scenario '' do
        exp = sbt('x',2)
        expect(exp.latex).to eq 'x-2'
      end

      scenario '' do
        exp = sbt(5,4)
        expect(exp.latex).to eq '5-4'
      end
    end

    context 'division' do
      scenario '' do
        exp = div('x',2)
        expect(exp.latex).to eq '\displaystyle\frac{x}{2}'
      end

      scenario '' do
        exp = div(5,4)
        expect(exp.latex).to eq '\displaystyle\frac{5}{4}'
      end
    end
  end

  context 'two_steps' do
    context 'addition first' do
      scenario '' do
        exp = add(add(2,'x'),3)
        expect(exp.latex).to eq '2+x+3'
      end

      scenario '' do
        exp = add(2,add('x',3))
        expect(exp.latex).to eq '2+\left(x+3\right)'
      end

      scenario '' do
        exp = add(sbt('x',2),3)
        expect(exp.latex).to eq 'x-2+3'
      end

      scenario '' do
        exp = add(2,sbt('x',3))
        expect(exp.latex).to eq '2+\left(x-3\right)'
      end

      scenario '' do
        exp = add(mtp(2,'x'),3)
        expect(exp.latex).to eq '2x+3'
      end

      scenario '' do
        exp = add(3,mtp(2,'x'))
        expect(exp.latex).to eq '3+2x'
      end

      scenario '' do
        exp = add(div('x',2),3)
        expect(exp.latex).to eq '\displaystyle\frac{x}{2}+3'
      end

      scenario '' do
        exp = add(3,div(2,'x'))
        expect(exp.latex).to eq '3+\displaystyle\frac{2}{x}'
      end
    end

    context 'subtraction first' do
      scenario '' do
        exp = sbt(add(2,'x'),3)
        expect(exp.latex).to eq '2+x-3'
      end

      scenario '' do
        exp = sbt(2,add('x',3))
        expect(exp.latex).to eq '2-\left(x+3\right)'
      end

      scenario '' do
        exp = sbt(sbt('x',2),3)
        expect(exp.latex).to eq 'x-2-3'
      end

      scenario '' do
        exp = sbt(2,sbt('x',3))
        expect(exp.latex).to eq '2-\left(x-3\right)'
      end

      scenario '' do
        exp = sbt(mtp(2,'x'),3)
        expect(exp.latex).to eq '2x-3'
      end

      scenario '' do
        exp = sbt(3,mtp(2,'x'))
        expect(exp.latex).to eq '3-2x'
      end

      scenario '' do
        exp = sbt(div('x',2),3)
        expect(exp.latex).to eq '\displaystyle\frac{x}{2}-3'
      end

      scenario '' do
        exp = sbt(3,div(2,'x'))
        expect(exp.latex).to eq '3-\displaystyle\frac{2}{x}'
      end
    end

    context 'multiplication first' do
      scenario '' do
        exp = mtp(add(2,'x'),3)
        expect(exp.latex).to eq '\left(2+x\right)3'
      end

      scenario '' do
        exp = mtp(3,add(2,'x'))
        expect(exp.latex).to eq '3\left(2+x\right)'
      end

      scenario '' do
        exp = mtp(sbt(2,'x'),3)
        expect(exp.latex).to eq '\left(2-x\right)3'
      end

      scenario '' do
        exp = mtp(3,sbt(2,'x'))
        expect(exp.latex).to eq '3\left(2-x\right)'
      end

      scenario '' do
        exp = mtp(mtp(2,'x'),3)
        expect(exp.latex).to eq '\left(2x\right)3'
      end

      scenario '' do
        exp = mtp(3,mtp(2,'x'))
        expect(exp.latex).to eq '3\left(2x\right)'
      end

      scenario '' do
        exp = mtp(div(2,'x'),3)
        expect(exp.latex).to eq '\displaystyle\frac{2}{x}3'
      end

      scenario '' do
        exp = mtp(3,div(2,'x'))
        expect(exp.latex).to eq '3\displaystyle\frac{2}{x}'
      end
    end

    context 'division first' do
      scenario '' do
        exp = div(add(2,'x'),3)
        expect(exp.latex).to eq '\displaystyle\frac{2+x}{3}'
      end

      scenario '' do
        exp = div(3,add(2,'x'))
        expect(exp.latex).to eq '\displaystyle\frac{3}{2+x}'
      end

      scenario '' do
        exp = div(sbt(2,'x'),3)
        expect(exp.latex).to eq '\displaystyle\frac{2-x}{3}'
      end

      scenario '' do
        exp = div(3,sbt(2,'x'))
        expect(exp.latex).to eq '\displaystyle\frac{3}{2-x}'
      end

      scenario '' do
        exp = div(mtp(2,'x'),3)
        expect(exp.latex).to eq '\displaystyle\frac{2x}{3}'
      end

      scenario '' do
        exp = div(3,mtp(2,'x'))
        expect(exp.latex).to eq '\displaystyle\frac{3}{2x}'
      end

      scenario '' do
        exp = div(div(2,'x'),3)
        expect(exp.latex).to eq '\displaystyle\frac{\displaystyle\frac{2}{x}}{3}'
      end

      scenario '' do
        exp = div(3,div(2,'x'))
        expect(exp.latex).to eq '\displaystyle\frac{3}{\displaystyle\frac{2}{x}}'
      end
    end
  end

  context 'three_step' do
    scenario '' do
      exp = add(3,div(2,'x'),mtp(4,sbt('y',5)))
      expect(exp.latex).to eq '3+\displaystyle\frac{2}{x}+4\left(y-5\right)'
    end

    scenario '' do
      exp = sbt(div(mtp(2,'a'),'x'),mtp(add('x',7),5))
      expect(exp.latex).to eq '\displaystyle\frac{2a}{x}-\left(x+7\right)5'
    end

    scenario '' do
      exp = mtp(add(3,sbt(2,'a'),'x'),mtp(mtp('x',7),'y'))
      expect(exp.latex).to eq '\left(3+\left(2-a\right)+x\right)\left(\left(x7\right)y\right)'
    end

    scenario '' do
      exp = div(mtp('x',add(4,'a','b')),sbt(11,mtp('y','z')))
      expect(exp.latex).to eq "\\displaystyle\\frac{x\\left(4+a+b\\right)}{11-"\
        "yz}"
    end
  end

  context 'four+steps' do
    scenario 'random crazy expression' do
      exp = add(3,mtp(2,sbt(3,div(3,'x')),'a'),div(mtp('x',add(4,div('a',sbt(2,'x')),'b')),sbt(11,mtp('y','z'))),sbt('x',5))
      expect(exp.latex).to eq "3+2\\left(3-\\displaystyle\\frac{3}{x}\\right)"\
        "a+\\displaystyle\\frac{x\\left(4+\\displaystyle\\frac{a}{2-x}+b\\right)}{11-yz}+\\left(x-5\\right)"
    end

    scenario 'repeated fractions' do
      exp = div(3,add(7,'h',div(mtp(2,'x'),sbt(div(add(4,div('a',2)),sbt(div(11,'x'),'b')),'y'))))
      # puts exp.latex
      expect(exp.latex).to eq "\\displaystyle\\frac{3}{7+h+\\displaystyle\\fra"\
        "c{2x}{\\displaystyle\\frac{4+\\displaystyle\\frac{a}{2}}{\\displaysty"\
        "le\\frac{11}{x}-b}-y}}"
    end
  end

  context 'sine' do
    scenario '' do
      exp = sin('x')
      expect(exp.latex).to eq '\sin x'
    end

    scenario '' do
      exp = sin(mtp(2,'x'))
      expect(exp.latex).to eq '\sin 2x'
    end

    scenario '' do
      exp = sin(sbt(mtp(2,'x'),10))
      expect(exp.latex).to eq '\sin \left(2x-10\right)'
    end

    scenario '' do
      exp = sin(add(mtp(2,'x'),10))
      expect(exp.latex).to eq '\sin \left(2x+10\right)'
    end
  end

  context 'power' do
    scenario '' do
      exp = pow('x',3)
      expect(exp.latex).to eq 'x^3'
    end

    scenario '' do
      exp = pow('x',mtp(3,'a'))
      expect(exp.latex).to eq 'x^{3a}'
    end

    scenario '' do
      exp = pow(add(2,'x'),mtp(3,'a'))
      expect(exp.latex).to eq '\left(2+x\right)^{3a}'
    end
  end

  context 'power and trig' do
    scenario '' do
      exp = div(add(mtp(2,'x'),3),sbt(mtp(3,pow('x',2)),mtp(4,pow('x',5))))
      expect(exp.latex).to eq '\displaystyle\frac{2x+3}{3x^2-4x^5}'
    end

    scenario '' do
      exp = add(10,mtp(-3,'x'))
      expect(exp.latex).to eq "10-3x"
    end
  end

  context 'conventionalised' do
    scenario '' do
      exp = add(mtp(1,pow('x',2)),mtp(-3,'x'),-4)
      expect(exp.latex).to eq "x^2-3x-4"
    end

    scenario '' do
      exp = add(mtp(-1,'x'),-2)
      expect(exp.latex).to eq "-x-2"
    end
  end
end

# feature '#shorten' do
#   context 'normal brackets' do
#     scenario '' do
#       expect('\left(2+x\right)^{3a}'.shorten).to eq '(2+x)^{3a}'
#     end
#   end
#
#   context 'displaystyle remove' do
#     scenario '' do
#       expect('\left(\displaystyle2+x\right)^{3a}'.shorten).to eq '(2+x)^{3a}'
#     end
#   end
# end
