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

--------
## Single variable equation step by step

Solving single variable equation step by steps.
```ruby
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
```
The latex to put the solutions together is not yet complete, but its very straight forward, involving calling latex on each element of the returned array and adding the latex strings together.

--------
## Standard sine equation step by step

Solving standard sine equation step by step.
```ruby
equation = SineEquation.new(sbt(mtp(2,'x'),10),0.5)
eq_solution = equation.latex_solution
expect(eq_solution).to eq "\\begin{align*}\n &&  ".... #the entire latex is rendered below
```
![Imgur](http://i.imgur.com/uPKlqYI.png)

--------
## Standard quadratic equation step by step

Solving standard quadratic equation by factorisation step by step full solution LaTeX.
```ruby
equation = QuadraticEquation.new(quad_term: 30, linear_term: -19, constant_term: -5, variable: 'x')
solution_latex = equation.latex
# solution_latex string is rendered below
```

![Imgur](http://i.imgur.com/z52G9MJ.png)

--------
# To Do List
> - Non-standard quadratic equation solver
> - Quadratic equation (standard and non-standard) question generator
> - Linear two variable simultaneous equation solver by elimination.
> - Linear two variable simultaneous equation solver by substitution.
> - Linear two variable simultaneous equation question generator.
> - One quadratic and one linear simultaneous equation solver by substitution.
> - One quadratic and one linear simultaneous equation question generator.
> - Non-standard Core 2 trigonometric equation solver.  (Machine learning see below)
> - Almost all A-level Maths topics!


--------
## Machine Learning

For topics such as general trigonometric equation solving, or integration, we would like to build machine learning engines.  The basic idea is that we will give the engine some basic rules like trigonometric identities, and some basic generic ideas of things it can try.  We then have an unintelligent question generator, which generates questions at random, and maybe most cannot be solved, the questions are passed to the solver engine, which will attempt to solve the question with all the rules and basic generic methods we gave to it at the beginning.  Every so often, the solver engine will encounter a question it can solve, and solved it in a particular way.  It then remembers this question type, as one which can be solved, and in this specific way.  So that in the future, should it encounter something which can be rearranged into something similar to the one it solved earlier, it will know that the question can be solved and how to do it.  

This is particularly powerful for integration, perhaps a little too hard for now.  We are planning to start building such an engine for non-standard core 2 trigonometric equations as a starting point.

--------
## Contributions are welcome and will be paid!

Anyone interested in contributing to this interesting project please contact me *joezhou@onemaths.com*, and if you are able to make contributions, we will pay you as a contractor appropriately.
