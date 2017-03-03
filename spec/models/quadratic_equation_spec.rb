describe QuadraticEquation do

  # describe '#simplify' do
  #
  #   it 'simplifies 2x^2+10x+20' do
  #     exp = quad(2,10,20)
  #     result = exp.simplify
  #     expect(result).to eq quad(1,5,10)
  #   end
  # end

  describe '#get_method' do
    it 'gets 12x^2+17x-7' do
      exp = quad(12,17,-7,'x')
      result = exp.get_method
      expect(result[:Product]).to eq [mtp(12,-7),-84]
    end
  end

  describe '#factorisation' do
    it 'gets factors of 12' do
      exp = 12
      result = exp.factorisation
      expect(result).to eq [[1,12],[2,6],[3,4],[4,3],[6,2],[12,1]]
    end
  end

  describe '#get_factors' do
    it 'calculates factors for 12x^2+17x-7' do
      exp = quad(12,17,-7,'x')
      result = exp.get_factors
      expect(result).to eq [-4,21]
    end
  end

  describe '#write_factors' do
    it 'writes factors for 12x^2+17x-7' do
      exp = quad(12,17,-7,'x')
      result = exp.write_factors
      expect(result).to eq [
        [-4,21],
        [frac(-4,12),frac(21,12)],
        [frac(1,3,sign: :-),frac(7,4)]
      ]

    end
  end

  describe '#write_factorisation_solution' do
    it 'writes solution for 12x^2+17x-7' do
      exp = quad(12,17,-7,'x')
      result = exp.write_factorisation_solution

      expect(result).to eq [
        '12x^2+17x+-7'.objectify,
        mtp(add('x',frac(1,3,sign: :-)),add('x',frac(7,4))),
        [frac(1,3),frac(7,4,sign: :-)]
      ]
    end

    it 'write solutin for 8x^2+10x-7' do
      exp = quad(8,10,-7,'x')
      result = exp.write_factorisation_solution

      expect(result).to eq [
        '8x^2+10x+-7'.objectify,
        mtp(add('x',frac(1,2,sign: :-)),add('x',frac(7,4))),
        [frac(1,2),frac(7,4,sign: :-)]
      ]
    end

  end
  #
  # describe '#latex_method' do
  #   exp = quad(8,10,-7,'x')
  #   result = exp.latex_method
  #   puts result
  # end
  #
  # describe '#latex_factors' do
  #   exp = quad(8,10,-7,'x')
  #   result = exp.latex_factors
  #   puts result
  # end


  describe '#latex' do
    it 'latexes $8y^2+10y-7$' do
      exp = quad(8,10,-7,'y')
      result = exp.latex
      expect(result).to eq '\begin{align*}
    0&=8y^2+10y-7& && &P=8\times-7=-56 \hspace{30pt}S=10&\\\[5pt]
    0&=\left(y-\frac{1}{2}\right)\left(y+\frac{7}{4}\right)& && &\left(-4,\,\,14\right)\hspace{10pt}\left(\frac{-4}{8},\,\,\frac{14}{8}\right)\hspace{10pt}\left(-\frac{1}{2},\,\,\frac{7}{4}\right)\hspace{10pt}&\\\[5pt]
    y&=\frac{1}{2} ,\,\, -\frac{7}{4}\\\[5pt]
    \end{align*}'
    end

    it 'latexes $x^2+5x+6$' do
      exp = quad(1,5,6,'x')
      result = exp.latex
      expect(result).to eq '\begin{align*}
    0&=x^2+5x+6& && &P=6=6 \hspace{30pt}S=5&\\\[5pt]
    0&=\left(x+2\right)\left(x+3\right)& && &\left(2,\,\,3\right)\hspace{10pt}&\\\[5pt]
    x&=-2 ,\,\, -3\\\[5pt]
    \end{align*}'
    end

    it 'latexes $2x^2-9x+7$' do
      exp = quad(2,-9,7,'x')
      result = exp.latex
      expect(result).to eq '\begin{align*}
    0&=2x^2+-9x+7& && &P=2\times7=14 \hspace{30pt}S=-9&\\\[5pt]
    0&=\left(x-1\right)\left(x-\frac{7}{2}\right)& && &\left(-2,\,\,-7\right)\hspace{10pt}\left(\frac{-2}{2},\,\,\frac{-7}{2}\right)\hspace{10pt}\left(-1,\,\,-\frac{7}{2}\right)\hspace{10pt}&\\\[5pt]
    x&=1 ,\,\, \frac{7}{2}\\\[5pt]
    \end{align*}'
    end

    it 'latexes $30x^2-19x-5$' do
      exp = quad(30,-19,-5,'x')
      result = exp.latex
      expect(result).to eq '\begin{align*}
    0&=30x^2-19x-5& && &P=30\times-5=-150 \hspace{30pt}S=-19&\\\[5pt]
    0&=\left(x-\frac{5}{6}\right)\left(x+\frac{1}{5}\right)& && &\left(-25,\,\,6\right)\hspace{10pt}\left(\frac{-25}{30},\,\,\frac{6}{30}\right)\hspace{10pt}\left(-\frac{5}{6},\,\,\frac{1}{5}\right)\hspace{10pt}&\\\[5pt]
    x&=\frac{5}{6} ,\,\, -\frac{1}{5}\\\[5pt]
    \end{align*}'
    end

    it 'latexes $-6x^2+19x-8$' do
      exp = quad(-6,19,-8,'x')
      result = exp.latex
      expect(result).to eq '\begin{align*}
    0&=-6x^2+19x-8& && &P=-6\times-8=48 \hspace{30pt}S=19&\\\[5pt]
    0&=\left(x-\frac{1}{2}\right)\left(x-\frac{8}{3}\right)& && &\left(3,\,\,16\right)\hspace{10pt}\left(\frac{3}{-6},\,\,\frac{16}{-6}\right)\hspace{10pt}\left(-\frac{1}{2},\,\,-\frac{8}{3}\right)\hspace{10pt}&\\\[5pt]
    x&=\frac{1}{2} ,\,\, \frac{8}{3}\\\[5pt]
    \end{align*}'
    end

    it 'latexes $-56x^2+31x-3$' do
      exp = quad(-56,31,-3,'x')
      result = exp.latex
      expect(result).to eq '\begin{align*}
    0&=-56x^2+31x-3& && &P=-56\times-3=168 \hspace{30pt}S=31&\\\[5pt]
    0&=\left(x-\frac{1}{8}\right)\left(x-\frac{3}{7}\right)& && &\left(7,\,\,24\right)\hspace{10pt}\left(\frac{7}{-56},\,\,\frac{24}{-56}\right)\hspace{10pt}\left(-\frac{1}{8},\,\,-\frac{3}{7}\right)\hspace{10pt}&\\\[5pt]
    x&=\frac{1}{8} ,\,\, \frac{3}{7}\\\[5pt]
    \end{align*}'
    end

    it 'latexes $-16x^2-23x+18$' do
      exp = quad(-16,-23,18,'x')
      result = exp.latex
      expect(result).to eq '\begin{align*}
    0&=-16x^2+-23x+18& && &P=-16\times18=-288 \hspace{30pt}S=-23&\\\[5pt]
    0&=\left(x+2\right)\left(x-\frac{9}{16}\right)& && &\left(-32,\,\,9\right)\hspace{10pt}\left(\frac{-32}{-16},\,\,\frac{9}{-16}\right)\hspace{10pt}\left(2,\,\,-\frac{9}{16}\right)\hspace{10pt}&\\\[5pt]
    x&=-2 ,\,\, \frac{9}{16}\\\[5pt]
    \end{align*}'
    end

    it 'latexes $3x^2 - 8x -3$' do
      exp = quad(3,-8,-3,'x')
      result = exp.latex
      expect(result).to eq '\begin{align*}
    0&=3x^2-8x-3& && &P=3\times-3=-9 \hspace{30pt}S=-8&\\\[5pt]
    0&=\left(x+\frac{1}{3}\right)\left(x-3\right)& && &\left(1,\,\,-9\right)\hspace{10pt}\left(\frac{1}{3},\,\,\frac{-9}{3}\right)\hspace{10pt}\left(\frac{1}{3},\,\,-3\right)\hspace{10pt}&\\\[5pt]
    x&=-\frac{1}{3} ,\,\, 3\\\[5pt]
    \end{align*}'
    end

  end


end
