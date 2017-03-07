# Question Generators and Solution Engines for OneMaths

[One Maths Beta Site](https://postimg.org/image/es2tmx4rh/)

This project aims to produce question generators to generator A-level mathematics questions in [MathJax](https://github.com/mathjax/MathJax) LaTeX format.  In addition, generators of each type of question will be accompanied by a solution engine, which will return a fully detailed solution in MathJax compatible LaTex, if a solution exists for the generated question.

--------
## Modelling mathematical expressions

Mathematical objects are modelled as objects which takes a number of arguments.  

'3+4+x' is modelled as
```ruby
Addition.new(3,4,'x')
#or by shortcut factory method
add.new(3,4,'x')
```

'x-3' is modelled as
```ruby
Subtraction.new('x',3)
#or by shortcut factory method
sbt('x',3)
```

'\frac{x}{3}' which is the LaTeX for 'x' divided by 3 is modelled as
```ruby
Division.new('x',3)
#or by shortcut factory method
div('x',3)
```

'5x' is modelled as
```ruby
Multiplication.new(5,'x')
#or by shortcut factory method
mtp(5,'x')
```

--------
## Super-factory: objectify a string into mathematical objects

'x^2=5' can be created by:
```ruby
Equation.new(Power.new('x',2),5)
#or by shortcut factory method
eqn(pow('x',2),5)
#or by our super-factory shortcut, objectify string method
'x^2=5'.objectify  #this will return the same object as line 1
```

'13-\frac{2x+1}{5-4x^2}' is modelled
```ruby
#by shortcut factory methods
sbt(13,div(add(mtp(2,'x'),1),sbt(5,mtp(4,pow('x',2)))))
#or by our super-factory shortcut, objectify string method
'13-\frac{2x+1}{5-4x^2}'.objectify  #this will return the same object as line 2
```

Objectify is essentially a factory method which allow us to create these mathematical objects in a way that's more natural and simpler.  However, we need to create many such objects, in both the code and the tests, this shortcut is very important.  In addition, it means we can parse string as our model objects.

--------
## Expand Brackets Recursively

Many expressions in mathematics requires expanding of brackets such as (2x-3)(x+5), or much more complex expressions such as (2+3x^2-4x)(3x-1)(2+3(x^4-2)).  We have built an expand brackets method which returns the step-by-step solution to expanding brackets, through recursion, in any level of complexity.

Here is an example of the output of expanding the object of '(x+y)(x+z)(y+z)'
```ruby
expression = '(x+y)(x+z)(y+z)'.objectify
result = expression.combine_brackets
#the captured return value above is an array of expressions (ruby objects) which are the steps in involved in the expansion steps
expect(result[0]).to eq '(x+y)(x+z)(y+z)'.objectify
expect(result[1]).to eq '(xx+xz+yx+yz)(y+z)'.objectify
expect(result[2]).to eq '(x^1x^1+xz+yx+yz)(y+z)'.objectify
expect(result[3]).to eq '(x^{1+1}+xz+yx+yz)(y+z)'.objectify
expect(result[4]).to eq '(x^2+xz+yx+yz)(y+z)'.objectify
expect(result[5]).to eq '(x^2+xz+xy+yz)(y+z)'.objectify
expect(result[6]).to eq '(x^2+xy+xz+yz)(y+z)'.objectify
expect(result[7]).to eq 'x^2y+x^2z+xyy+xyz+xzy+xzz+yzy+yzz'.objectify
expect(result[8]).to eq 'x^2y+x^2z+xyy+xyz+xzy+xzz+yyz+yzz'.objectify
expect(result[9]).to eq 'x^2y+x^2z+xy^1y^1+xyz+xzy+xz^1z^1+y^1y^1z+yz^1z^1'.objectify
expect(result[10]).to eq 'x^2y+x^2z+xy^{1+1}+xyz+xzy+xz^{1+1}+y^{1+1}z+yz^{1+1}'.objectify
expect(result[11]).to eq 'x^2y+x^2z+xy^2+xyz+xzy+xz^2+y^2z+yz^2'.objectify
expect(result[12]).to eq 'x^2y+x^2z+xy^2+xyz+xyz+xz^2+y^2z+yz^2'.objectify
expect(result[13]).to eq 'x^2y+x^2z+xy^2+2xyz+xz^2+y^2z+yz^2'.objectify
```

The 'combine_brackets' method will be used in many classes for solution generation.

--------
## LaTeX of a mathematical expression

Every object (mathematical expression) in our models will respond to '.latex' method and return a string of the LaTeX for that expression.

Example 1
```ruby
expression = add(3,mtp(4,'x'))
expect(expression.latex).to eq '3+4x'
```

Example 2
```ruby
expression = sbt(2,mtp(5,add(div(3,sbt('x',4)),'y')))
expect(expression.latex).to eq '2-5\left(\displaystyle\frac{3}{x-4}+y\right)'
expect(expression.latex.shorten).to eq '2-5(\frac{3}{x-4}+y)'
# The expression can be made with objectify instead:
expression = '2-5(\frac{3}{x-4}+y)'.objectify
expect(expression.latex.shorten).to eq '2-5(\frac{3}{x-4}+y)'
# objectify and latex.shorten are inverse of each other:
latex_string = '2-5(\frac{3}{x-4}+y)'
expect(latex_string.objectify.latex.shorten).to eq latex_string
```
