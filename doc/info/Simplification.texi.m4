@c -*- Mode: texinfo -*-
@menu
* Introduction to Simplification::
* Functions and Variables for Simplification::  
@end menu

@c -----------------------------------------------------------------------------
@node Introduction to Simplification, Functions and Variables for Simplification,  , Simplification
@section Introduction to Simplification
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
Maxima performs a cycle of actions in response to each new user-typed command. This 
consists of four steps: reading or "parsing" the input, evaluation, simplification 
and output. Parsing converts a syntactically valid sequence of typed characters into 
a data structure to be used for the rest of the operations. Evaluation includes 
replacing names with their assigned values. Simplification means rewriting an 
expression to be easier for the user or other programs to understand. Output includes 
displaying computational results in a variety of different formats and notations.

Evaluation and simplification sometimes appear to have similar functionality as they 
both have the goal of removing "complexity" and system designers have sometimes divided a 
task so that it is performed partly in each. For example, @code{integrate(x,x)} evaluates 
the answer as @code{x*x/2}, which is then simplified to @code{x^2/2}.

Evaluation is always present: it is the consequence of having a programming system with 
functions, subroutines, variables, values, loops, assignments and so on. In the 
evaluation step, built-in or user-defined function names are replaced by their definitions, 
variables are replaced by their values. This is largely the same as activities of a 
conventional programming language, but extended to work with symbolic mathematical data. 
Because of the generality of the mathematics at hand, there are different possible models 
of evaluation and so the systems has optional "flags" that can steer the process of 
evaluation. @xref{Functions and Variables for Evaluation}.

By contrast, the intent of simplification is to maintain the value of an expression 
while re-formulating its representation to be smaller, simpler to understand, or to 
conform to particular specifications (like factored, expanded). For
example, @code{sin(0)} to @code{0} or @code{x+x to 2*x}.
There are several powerful tools to alter the results 
of simplification, since it is largely in this part of the system that a user can 
incorporate knowledge of newly introduced functions or symbolic notation into Maxima.

Simplification is generally done at four different levels:
@itemize @bullet
@item The internal, built-in automated simplifier,
@item Built-in simplification routines that can be explicitly called by the user
      at selected places in a program or command sequence,
@item User-written simplification routines, linked to the simplifier by using
      "tellsimp" or "tellsimpafter" and called automatically,
@item User-written routines that can be explicitly called by the user at selected 
      places in a program or command sequence.
@end itemize
The internal simplifier belongs to the heart of Maxima. It is a large and 
complicated collection of programs, and it has been refined over many years and by 
thousands of users. Nevertheless, especially if you are trying out novel ideas or 
unconventional notation, you may find it helpful to make small (or large) changes 
to the program yourself. For details see for example the paper at the end of
@url{https://people.eecs.berkeley.edu/~fateman/papers/intro5.txt}.

Maxima internally represents expressions as "trees" with operators or "roots"
like @code{+}, @code{*} , @code{=} and operands ("leaves") which are variables like
@var{x}, @var{y}, @var{z}, functions
or sub-trees, like @code{x*y}. Each operator has a simplification program
associated with it.  @code{+} (which also covers binary @code{-} since
@code{a-b = a+(-1)*b)} and @code{*} (which also covers @code{/} 
since @code{a/b = a*b^(-1)}) have rather elaborate simplification programs. These 
simplification programs (simplus, simptimes, simpexpt, etc.) are called whenever 
the simplifier encounters the respective arithmetic operators in an expression 
tree to be analyzed. 

The structure of the simplifier dates back to 1965, and many hands have worked 
on it through the years. The structure turns out to be, in modern jargon, data-
directed, or object-oriented. The program dispatches to the appropriate routine 
depending on the root of some sub-tree of the expression, recursively. This general
notion means you can make modifications to the simplification process by very local 
changes to the program. In many cases it is conceptually straightforward to add an 
operator and add its simplification routine without disturbing existing code.

We note that in addition to this general simplifier operating on algebraic 
expression trees, there are several other representations of expressions in 
Maxima which have separate methods and simplifiers. For example, the
@mref{rat} function converts polynomials to vectors of coefficients to
assist in rapid manipulation of such forms. Other representations include
Taylor series and the (rarely used) Poisson series.

All operators introduced by the user initially have no simplification
programs associated with them.  Maxima does not know anything about
function "f"  and so typing @code{f(a,b)} will result in simplifying
@var{a},@var{b}, but not @code{f}. 
Even some built-in operators have no simplifications. For example,
@code{=} does not "simplify" -- it is a place-holder with no
simplification semantics other 
than to simplify its two arguments, in this case referred to as the left and 
right sides. Other parts of Maxima such as the solve program take special 
note of equations, that is, trees with @code{=} as the root. 
(Note -- in Maxima, the assignment operation is @code{:} . That is, @code{q: 4}
sets the value of the symbol @var{q} to @code{4}.
Function definition is done with @code{:=}. )

The general simplifier returns results with an internal flag indicating the 
expression and each sub-expression has been simplified. This does not 
guarantee that it is unique over all possible equivalent expressions. That's 
too hard (theoretically, not possible given the generality of what can be 
expressed in Maxima). However, some aspects of the expression, such as the 
ordering of terms in a sum or product, are made uniform. This is important 
for the other programs to work properly.

You can set a number of option variables which direct Maxima's processing to 
favor particular kinds of patterns as being goals. You can even use the most 
extreme option which is to turn the simplifier off by simp:false. We do not 
recommend this since many internal routines expect their arguments to be 
simplified. (About the only time it seems plausible to turn off the simplifier 
is in the rare case that you want to over-ride a built-in simplification. 
In that case  you might temporarily disable the simplifier, put in the new 
transformation via @mrefcomma{tellsimp} and then re-enable the simplifier
by @code{simp:true}.)

It is more plausible for you to associate user-defined symbolic function names 
or operators with properties (@mrefcomma{additive}
@mrefcomma{lassociative} @mrefcomma{oddfun} @mrefcomma{antisymmetric}
@mrefcomma{linear} @mrefcomma{outative} @mrefcomma{commutative} 
@mrefcomma{multiplicative} @mrefcomma{rassociative} @mrefcomma{evenfun}
@mref{nary} and @mref{symmetric}). These options steer 
the simplifier processing in systematic directions.

For example, @code{declare(f,oddfun)} specifies that @code{f} is an odd function.
Maxima will simplify @code{f(-x)} to @code{-f(x)}. In the case of an even
function, that is @code{declare(g,evenfun)}, 
Maxima will simplify @code{g(-x)} to @code{g(x)}. You can also associate a
programming function with a name such as @code{h(x):=x^2+1}. In that case the
evaluator will immediately replace 
@code{h(3)} by @code{10}, and @code{h(a+1)} by @code{(a+1)^2+1}, so any properties
of @code{h} will be ignored.

In addition to these directly related properties set up by the user, facts and 
properties from the actual context may have an impact on the simplifier's behavior, 
too. @xref{Introduction to Maximas Database}.

Example: @code{sin(n*%pi)} is simplified to zero, if @var{n} is an integer.

@c ===beg===
@c sin(n*%pi);
@c declare(n, integer);
@c sin(n*%pi);
@c ===end===
@example
@group
(%i1) sin(n*%pi);
(%o1)                      sin(%pi n)
@end group
@group
(%i2) declare(n, integer);
(%o2)                         done
@end group
@group
(%i3) sin(n*%pi);
(%o3)                           0
@end group
@end example

If automated simplification is not sufficient, you can consider a variety of 
built-in, but explicitly called simplfication functions (@mrefcomma{ratsimp}
@mrefcomma{expand} @mrefcomma{factor} @mref{radcan} and others). There are
also flags that will push simplification into one or another direction.
Given @code{demoivre:true} the simplifier rewrites 
complex exponentials as trigonometric forms. Given @code{exponentialize:true}
the  simplifier tries to do the reverse: rewrite trigonometric forms as complex 
exponentials.

As everywhere in Maxima, by writing your own functions (be it in the Maxima 
user language or in the implementation language Lisp) and explicitly calling them 
at selected places in the program, you can respond to your individual 
simplification needs. Lisp gives you a handle on all the internal mechanisms, but 
you rarely need this full generality. "Tellsimp" is designed to generate much 
of the Lisp internal interface into the simplifier automatically.
See @xref{Rules and Patterns}.

Over the years (Maxima/Macsyma's origins date back to about 1966!) users have 
contributed numerous application packages and tools to extend or alter its 
functional behavior. Various non-standard and "share" packages exist to modify 
or extend simplification as well. You are invited to look into this more 
experimental material where work is still in progress @xref{simplification-pkg}.

The following appended material is optional on a first reading, and reading it 
is not necessary for productive use of Maxima. It is for the curious user who 
wants to understand what is going on, or the ambitious programmer who might 
wish to change the (open-source) code. Experimentation with redefining Maxima 
Lisp code is easily possible: to change the definition of a Lisp program (say 
the one that simplifies @code{cos()}, named @code{simp%cos}), you simply
load into Maxima a text file that will overwrite the @code{simp%cos} function
from the maxima package.

@c -----------------------------------------------------------------------------
@node Functions and Variables for Simplification,  , Introduction to Simplification, Simplification
@section Functions and Variables for Simplification
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
m4_setcat(Operators, Declarations and inferences)
@anchor{additive}
@c @defvr {Property} additive
m4_defvr({Property}, additive)

If @code{declare(f,additive)} has been executed, then:

(1) If @code{f} is univariate, whenever the simplifier encounters @code{f}
applied to a sum, @code{f} will be distributed over that sum.  I.e.
@code{f(y+x)} will simplify to @code{f(y)+f(x)}.

(2) If @code{f} is a function of 2 or more arguments, additivity is defined as
additivity in the first argument to @code{f}, as in the case of @code{sum} or
@code{integrate}, i.e.  @code{f(h(x)+g(x),x)} will simplify to
@code{f(h(x),x)+f(g(x),x)}.  This simplification does not occur when @code{f} is
applied to expressions of the form @code{sum(x[i],i,lower-limit,upper-limit)}.

Example:

@c ===beg===
@c F3 (a + b + c);
@c declare (F3, additive);
@c F3 (a + b + c);
@c ===end===
@example
@group
(%i1) F3 (a + b + c);
(%o1)                     F3(c + b + a)
@end group
@group
(%i2) declare (F3, additive);
(%o2)                         done
@end group
@group
(%i3) F3 (a + b + c);
(%o3)                 F3(c) + F3(b) + F3(a)
@end group
@end example

@c @opencatbox
@c @category{Operators}
@c @category{Declarations and inferences}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
@anchor{antisymmetric}
@c @defvr {Property} antisymmetric
m4_defvr({Property}, antisymmetric)

If @code{declare(h,antisymmetric)} is done, this tells the simplifier that
@code{h} is antisymmetric.  E.g.  @code{h(x,z,y)} will simplify to 
@code{- h(x, y, z)}.  That is, it will give (-1)^n times the result given by
@code{symmetric} or @code{commutative}, where n is the number of interchanges
of two arguments necessary to convert it to that form.

Examples:

@c ===beg===
@c S (b, a);
@c declare (S, symmetric);
@c S (b, a);
@c S (a, c, e, d, b);
@c T (b, a);
@c declare (T, antisymmetric);
@c T (b, a);
@c T (a, c, e, d, b);
@c ===end===
@example
@group
(%i1) S (b, a);
(%o1)                        S(b, a)
@end group
@group
(%i2) declare (S, symmetric);
(%o2)                         done
@end group
@group
(%i3) S (b, a);
(%o3)                        S(a, b)
@end group
@group
(%i4) S (a, c, e, d, b);
(%o4)                   S(a, b, c, d, e)
@end group
@group
(%i5) T (b, a);
(%o5)                        T(b, a)
@end group
@group
(%i6) declare (T, antisymmetric);
(%o6)                         done
@end group
@group
(%i7) T (b, a);
(%o7)                       - T(a, b)
@end group
@group
(%i8) T (a, c, e, d, b);
(%o8)                   T(a, b, c, d, e)
@end group
@end example

@c @opencatbox
@c @category{Operators}
@c @category{Declarations and inferences}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@c @deffn {Function} combine (@var{expr})
m4_deffn({Function}, combine, <<<(@var{expr})>>>)

Simplifies the sum @var{expr} by combining terms with the same
denominator into a single term.

Example:

@c ===beg===
@c 1*f/2*b + 2*c/3*a + 3*f/4*b +c/5*b*a;
@c combine (%);
@c ===end===
@example
@group
(%i1) 1*f/2*b + 2*c/3*a + 3*f/4*b +c/5*b*a;
                      5 b f   a b c   2 a c
(%o1)                 ----- + ----- + -----
                        4       5       3
@end group
@group
(%i2) combine (%);
                  75 b f + 4 (3 a b c + 10 a c)
(%o2)             -----------------------------
                               60
@end group
@end example

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{commutative}
@c @defvr {Property} commutative
m4_defvr({Property}, commutative)

If @code{declare(h, commutative)} is done, this tells the simplifier that
@code{h} is a commutative function.  E.g.  @code{h(x, z, y)} will simplify to
@code{h(x, y, z)}.  This is the same as @code{symmetric}.

Exemplo:

@c ===beg===
@c S (b, a);
@c S (a, b) + S (b, a);
@c declare (S, commutative);
@c S (b, a);
@c S (a, b) + S (b, a);
@c S (a, c, e, d, b);
@c ===end===
@example
@group
(%i1) S (b, a);
(%o1)                        S(b, a)
@end group
@group
(%i2) S (a, b) + S (b, a);
(%o2)                   S(b, a) + S(a, b)
@end group
@group
(%i3) declare (S, commutative);
(%o3)                         done
@end group
@group
(%i4) S (b, a);
(%o4)                        S(a, b)
@end group
@group
(%i5) S (a, b) + S (b, a);
(%o5)                       2 S(a, b)
@end group
@group
(%i6) S (a, c, e, d, b);
(%o6)                   S(a, b, c, d, e)
@end group
@end example

@c @opencatbox
@c @category{Operators}
@c @category{Declarations and inferences}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS CLARIFICATION, EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Complex variables, Trigonometric functions, Hyperbolic functions)
@anchor{demoivre}
@c @deffn  {Function} demoivre (@var{expr})
m4_deffn( {Function}, demoivre, <<<(@var{expr})>>>)
@deffnx {Option variable} demoivre

The function @code{demoivre (expr)} converts one expression
without setting the global variable @code{demoivre}.

When the variable @code{demoivre} is @code{true}, complex exponentials are
converted into equivalent expressions in terms of circular functions:
@code{exp (a + b*%i)} simplifies to @code{%e^a * (cos(b) + %i*sin(b))}
if @code{b} is free of @code{%i}.  @code{a} and @code{b} are not expanded.

The default value of @code{demoivre} is @code{false}.

@code{exponentialize} converts circular and hyperbolic functions to exponential
form.  @code{demoivre} and @code{exponentialize} cannot both be true at the same
time.

@c @opencatbox
@c @category{Complex variables}
@c @category{Trigonometric functions}
@c @category{Hyperbolic functions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c NEEDS WORK

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@anchor{function_distrib}
@c @deffn {Function} distrib (@var{expr})
m4_deffn({Function}, distrib, <<<(@var{expr})>>>)

Distributes sums over products.  It differs from @code{expand} in that it works
at only the top level of an expression, i.e., it doesn't recurse and it is
faster than @code{expand}.  It differs from @code{multthru} in that it expands
all sums at that level.

Examples:

@c ===beg===
@c distrib ((a+b) * (c+d));
@c multthru ((a+b) * (c+d));
@c distrib (1/((a+b) * (c+d)));
@c expand (1/((a+b) * (c+d)), 1, 0);
@c ===end===
@example
(%i1) distrib ((a+b) * (c+d));
(%o1)                 b d + a d + b c + a c
(%i2) multthru ((a+b) * (c+d));
(%o2)                 (b + a) d + (b + a) c
(%i3) distrib (1/((a+b) * (c+d)));
                                1
(%o3)                    ---------------
                         (b + a) (d + c)
(%i4) expand (1/((a+b) * (c+d)), 1, 0);
                                1
(%o4)                 ---------------------
                      b d + a d + b c + a c
@end example

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Simplification flags and variables)
@anchor{distribute_over}
@c @defvr {Option variable} distribute_over
m4_defvr({Option variable}, distribute_over)
Default value: @code{true}

@code{distribute_over} controls the mapping of functions over bags like lists, 
matrices, and equations.  At this time not all Maxima functions have this 
property.  It is possible to look up this property with the command
@code{properties}.

The mapping of functions is switched off, when setting @code{distribute_over} 
to the value @code{false}.

Examples:

The @code{sin} function maps over a list:

@c ===beg===
@c sin([x,1,1.0]);
@c ===end===
@example
@group
(%i1) sin([x,1,1.0]);
(%o1)         [sin(x), sin(1), 0.8414709848078965]
@end group
@end example

@code{mod} is a function with two arguments which maps over lists.  Mapping over 
nested lists is possible too:

@c ===beg===
@c mod([x,11,2*a],10);
@c mod([[x,y,z],11,2*a],10);
@c ===end===
@example
@group
(%i1) mod([x,11,2*a],10);
(%o1)             [mod(x, 10), 1, 2 mod(a, 5)]
@end group
@group
(%i2) mod([[x,y,z],11,2*a],10);
(%o2) [[mod(x, 10), mod(y, 10), mod(z, 10)], 1, 2 mod(a, 5)]
@end group
@end example

Mapping of the @code{floor} function over a matrix and an equation:

@c ===beg===
@c floor(matrix([a,b],[c,d]));
@c floor(a=b);
@c ===end===
@example
@group
(%i1) floor(matrix([a,b],[c,d]));
                     [ floor(a)  floor(b) ]
(%o1)                [                    ]
                     [ floor(c)  floor(d) ]
@end group
@group
(%i2) floor(a=b);
(%o2)                  floor(a) = floor(b)
@end group
@end example

Functions with more than one argument map over any of the arguments or all
arguments:

@c ===beg===
@c expintegral_e([1,2],[x,y]);
@c ===end===
@example
@group
(%i1) expintegral_e([1,2],[x,y]);
(%o1) [[expintegral_e(1, x), expintegral_e(1, y)], 
                      [expintegral_e(2, x), expintegral_e(2, y)]]
@end group
@end example

Check if a function has the property distribute_over:

@c ===beg===
@c properties(abs);
@c ===end===
@example
@group
(%i1) properties(abs);
(%o1) [integral, rule, distributes over bags, noun, gradef, 
                                                 system function]
@end group
@end example

The mapping of functions is switched off, when setting @code{distribute_over} 
to the value @code{false}.

@c ===beg===
@c distribute_over;
@c sin([x,1,1.0]);
@c distribute_over : not distribute_over;
@c sin([x,1,1.0]);
@c ===end===
@example
@group
(%i1) distribute_over;
(%o1)                         true
@end group
@group
(%i2) sin([x,1,1.0]);
(%o2)         [sin(x), sin(1), 0.8414709848078965]
@end group
@group
(%i3) distribute_over : not distribute_over;
(%o3)                         false
@end group
@group
(%i4) sin([x,1,1.0]);
(%o4)                   sin([x, 1, 1.0])
@end group
@end example

@c @opencatbox
@c @category{Simplification flags and variables}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
@anchor{domain}
@c @defvr {Option variable} domain
m4_defvr({Option variable}, domain)
Default value: @code{real}

When @code{domain} is set to @code{complex}, @code{sqrt (x^2)} will remain
@code{sqrt (x^2)} instead of returning @code{abs(x)}.

@c PRESERVE EDITORIAL COMMENT -- MAY HAVE SOME SIGNIFICANCE NOT YET UNDERSTOOD !!!
@c The notion of a "domain" of simplification is still in its infancy,
@c and controls little more than this at the moment.

@c @opencatbox
@c @category{Simplification flags and variables}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat()
@anchor{evenfun}
@anchor{oddfun}
@c @defvr  {Property} evenfun
m4_defvr( {Property}, evenfun)
@c @defvrx {Property} oddfun
m4_defvrx({Property}, oddfun)

@code{declare(f, evenfun)} or @code{declare(f, oddfun)} tells Maxima to recognize
the function @code{f} as an even or odd function.

Examples:

@c ===beg===
@c o (- x) + o (x);
@c declare (o, oddfun);
@c o (- x) + o (x);
@c e (- x) - e (x);
@c declare (e, evenfun);
@c e (- x) - e (x);
@c ===end===
@example
(%i1) o (- x) + o (x);
(%o1)                     o(x) + o(- x)
(%i2) declare (o, oddfun);
(%o2)                         done
(%i3) o (- x) + o (x);
(%o3)                           0
(%i4) e (- x) - e (x);
(%o4)                     e(- x) - e(x)
(%i5) declare (e, evenfun);
(%o5)                         done
(%i6) e (- x) - e (x);
(%o6)                           0
@end example
@end defvr

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@anchor{expand}
@c @deffn  {Function} expand @
m4_deffn( {Function}, expand, <<<>>>) @
@fname{expand} (@var{expr}) @
@fname{expand} (@var{expr}, @var{p}, @var{n})

Expand expression @var{expr}.
Products of sums and exponentiated sums are
multiplied out, numerators of rational expressions which are sums are
split into their respective terms, and multiplication (commutative
and non-commutative) are distributed over addition at all levels of
@var{expr}.

For polynomials one should usually use @code{ratexpand} which uses a
more efficient algorithm.

@code{maxnegex} and @code{maxposex} control the maximum negative and
positive exponents, respectively, which will expand.

@code{expand (@var{expr}, @var{p}, @var{n})} expands @var{expr}, 
using @var{p} for @code{maxposex} and @var{n} for @code{maxnegex}.
This is useful in order to expand part but not all of an expression.

@code{expon} - the exponent of the largest negative power which is
automatically expanded (independent of calls to @code{expand}).  For example
if @code{expon} is 4 then @code{(x+1)^(-5)} will not be automatically expanded.

@code{expop} - the highest positive exponent which is automatically expanded.
Thus @code{(x+1)^3}, when typed, will be automatically expanded only if
@code{expop} is greater than or equal to 3.  If it is desired to have
@code{(x+1)^n} expanded where @code{n} is greater than @code{expop} then
executing @code{expand ((x+1)^n)} will work only if @code{maxposex} is not
less than @code{n}.

@code{expand(expr, 0, 0)} causes a resimplification of @code{expr}.  @code{expr}
is not reevaluated.  In distinction from @code{ev(expr, noeval)} a special
representation (e. g. a CRE form) is removed.  See also @mrefdot{ev}

The @code{expand} flag used with @code{ev} causes expansion.

The file @file{share/simplification/facexp.mac}
@c I should really use a macro which expands to something like
@c @uref{file://...,,simplification/facexp.mac}.  But texi2html
@c currently supports @uref only with one argument.
@c Worse, the `file:' scheme is OS and browser dependent.
contains several related functions (in particular @code{facsum},
@code{factorfacsum} and @code{collectterms}, which are autoloaded) and variables
(@code{nextlayerfactor} and @code{facsum_combine}) that provide the user with
the ability to structure expressions by controlled expansion.
@c MERGE share/simplification/facexp.usg INTO THIS FILE OR CREATE NEW FILE facexp.texi
Brief function descriptions are available in @file{simplification/facexp.usg}.
A demo is available by doing @code{demo("facexp")}.

Examples:

@c ===beg===
@c expr:(x+1)^2*(y+1)^3;
@c expand(expr);
@c expand(expr,2);
@c expr:(x+1)^-2*(y+1)^3;
@c expand(expr);
@c expand(expr,2,2);
@c ===end===
@example
@group
(%i1) expr:(x+1)^2*(y+1)^3;
                               2        3
(%o1)                   (x + 1)  (y + 1)
@end group
@group
(%i2) expand(expr);
       2  3        3    3      2  2        2      2      2
(%o2) x  y  + 2 x y  + y  + 3 x  y  + 6 x y  + 3 y  + 3 x  y
                                                      2
                                     + 6 x y + 3 y + x  + 2 x + 1
@end group
@group
(%i3) expand(expr,2);
               2        3              3          3
(%o3)         x  (y + 1)  + 2 x (y + 1)  + (y + 1)
@end group
@group
(%i4) expr:(x+1)^-2*(y+1)^3;
                                   3
                            (y + 1)
(%o4)                       --------
                                   2
                            (x + 1)
@end group
@group
(%i5) expand(expr);
            3               2
           y             3 y            3 y             1
(%o5) ------------ + ------------ + ------------ + ------------
       2              2              2              2
      x  + 2 x + 1   x  + 2 x + 1   x  + 2 x + 1   x  + 2 x + 1
@end group
@group
(%i6) expand(expr,2,2);
                                   3
                            (y + 1)
(%o6)                     ------------
                           2
                          x  + 2 x + 1
@end group
@end example

Resimplify an expression without expansion:

@c ===beg===
@c expr:(1+x)^2*sin(x);
@c exponentialize:true;
@c expand(expr,0,0);
@c ===end===
@example
@group
(%i1) expr:(1+x)^2*sin(x);
                                2
(%o1)                    (x + 1)  sin(x)
@end group
@group
(%i2) exponentialize:true;
(%o2)                         true
@end group
@group
(%i3) expand(expr,0,0);
                            2    %i x     - %i x
                  %i (x + 1)  (%e     - %e      )
(%o3)           - -------------------------------
                                 2
@end group
@end example

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c NEEDS EXAMPLES

@c -----------------------------------------------------------------------------
@anchor{expandwrt}
@c @deffn {Function} expandwrt (@var{expr}, @var{x_1}, @dots{}, @var{x_n})
m4_deffn({Function}, expandwrt, <<<(@var{expr}, @var{x_1}, @dots{}, @var{x_n})>>>)

Expands expression @code{expr} with respect to the 
variables @var{x_1}, @dots{}, @var{x_n}.
All products involving the variables appear explicitly.  The form returned
will be free of products of sums of expressions that are not free of
the variables.  @var{x_1}, @dots{}, @var{x_n}
may be variables, operators, or expressions.

By default, denominators are not expanded, but this can be controlled by
means of the switch @code{expandwrt_denom}.

This function is autoloaded from
@file{simplification/stopex.mac}.

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@anchor{expandwert_denom}
@c @defvr {Option variable} expandwrt_denom
m4_defvr({Option variable}, expandwrt_denom)
Default value: @code{false}

@code{expandwrt_denom} controls the treatment of rational
expressions by @code{expandwrt}.  If @code{true}, then both the numerator and
denominator of the expression will be expanded according to the
arguments of @code{expandwrt}, but if @code{expandwrt_denom} is @code{false},
then only the numerator will be expanded in that way.

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS A STAND-ALONE DESCRIPTION (NOT "IS SIMILAR TO")
@c NEEDS EXAMPLES

@c -----------------------------------------------------------------------------
@anchor{expandwrt_factored}
@c @deffn {Function} expandwrt_factored (@var{expr}, @var{x_1}, @dots{}, @var{x_n})
m4_deffn({Function}, expandwrt_factored, <<<(@var{expr}, @var{x_1}, @dots{}, @var{x_n})>>>)

is similar to @code{expandwrt}, but treats expressions that are products
somewhat differently.  @code{expandwrt_factored} expands only on those factors
of @code{expr} that contain the variables @var{x_1}, @dots{}, @var{x_n}.

@c NOT SURE WHY WE SHOULD MENTION THIS HERE
This function is autoloaded from @file{simplification/stopex.mac}.

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{expon}
@c @defvr {Option variable} expon
m4_defvr({Option variable}, expon)
Default value: 0

@code{expon} is the exponent of the largest negative power which
is automatically expanded (independent of calls to @code{expand}).  For
example, if @code{expon} is 4 then @code{(x+1)^(-5)} will not be automatically
expanded.

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Complex variables, Trigonometric functions, Hyperbolic functions)
@anchor{exponentialize}
@c @deffn  {Function} exponentialize (@var{expr})
m4_deffn( {Function}, exponentialize, <<<(@var{expr})>>>)
@deffnx {Option variable} exponentialize

The function @code{exponentialize (expr)} converts 
circular and hyperbolic functions in @var{expr} to exponentials,
without setting the global variable @code{exponentialize}.

When the variable @code{exponentialize} is @code{true},
all circular and hyperbolic functions are converted to exponential form.
The default value is @code{false}.

@code{demoivre} converts complex exponentials into circular functions.
@code{exponentialize} and @code{demoivre} cannot
both be true at the same time.

@c @opencatbox
@c @category{Complex variables}
@c @category{Trigonometric functions}
@c @category{Hyperbolic functions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c NEEDS CLARIFICATION
@c NEEDS EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@anchor{expop}
@c @defvr {Option variable} expop
m4_defvr({Option variable}, expop)
Default value: 0

@code{expop} is the highest positive exponent which is automatically expanded.
Thus @code{(x + 1)^3}, when typed, will be automatically expanded only if
@code{expop} is greater than or equal to 3.  If it is desired to have
@code{(x + 1)^n} expanded where @code{n} is greater than @code{expop} then
executing @code{expand ((x + 1)^n)} will work only if @code{maxposex} is not
less than n.

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS CLARIFICATION, EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Declarations and inferences, Operators, Simplification)
@anchor{lassociative}
@c @defvr {Property} lassociative
m4_defvr({Property}, lassociative)

@code{declare (g, lassociative)} tells the Maxima simplifier that @code{g} is
left-associative.  E.g., @code{g (g (a, b), g (c, d))} will simplify to
@code{g (g (g (a, b), c), d)}.

@c @opencatbox
@c @category{Declarations and inferences}
@c @category{Operators}
@c @category{Simplification}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS CLARIFICATION, EXAMPLES
@c WHAT'S UP WITH THE QUOTE MARKS ??

@c -----------------------------------------------------------------------------
m4_setcat(Declarations and inferences, Operators, Simplification)
@anchor{linear}
@c @defvr {Property} linear
m4_defvr({Property}, linear)

One of Maxima's operator properties.  For univariate @code{f} so
declared, "expansion" @code{f(x + y)} yields @code{f(x) + f(y)},
@code{f(a*x)} yields @code{a*f(x)} takes
place where @code{a} is a "constant".  For functions of two or more arguments,
"linearity" is defined to be as in the case of @code{sum} or @code{integrate},
i.e., @code{f (a*x + b, x)} yields @code{a*f(x,x) + b*f(1,x)}
for @code{a} and @code{b} free of @code{x}.

Example:

@c ===beg===
@c declare (f, linear);
@c f(x+y);
@c declare (a, constant);
@c f(a*x);
@c ===end===
@example
@group
(%i1) declare (f, linear);
(%o1)                         done
@end group
@group
(%i2) f(x+y);
(%o2)                      f(y) + f(x)
@end group
@group
(%i3) declare (a, constant);
(%o3)                         done
@end group
@group
(%i4) f(a*x);
(%o4)                        a f(x)
@end group
@end example

@code{linear} is equivalent to @code{additive} and @code{outative}.
See also @mrefdot{opproperties}

Example:

@c ===beg===
@c 'sum (F(k) + G(k), k, 1, inf);
@c declare (nounify (sum), linear);
@c 'sum (F(k) + G(k), k, 1, inf);
@c ===end===
@example
@group
(%i1) 'sum (F(k) + G(k), k, 1, inf);
                       inf
                       ====
                       \
(%o1)                   >    (G(k) + F(k))
                       /
                       ====
                       k = 1
@end group
@group
(%i2) declare (nounify (sum), linear);
(%o2)                         done
@end group
@group
(%i3) 'sum (F(k) + G(k), k, 1, inf);
                     inf          inf
                     ====         ====
                     \            \
(%o3)                 >    G(k) +  >    F(k)
                     /            /
                     ====         ====
                     k = 1        k = 1
@end group
@end example

@c @opencatbox
@c @category{Declarations and inferences}
@c @category{Operators}
@c @category{Simplification}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@anchor{maxnegex}
@c @defvr {Option variable} maxnegex
m4_defvr({Option variable}, maxnegex)
Default value: 1000

@code{maxnegex} is the largest negative exponent which will
be expanded by the @code{expand} command, see also @mrefdot{maxposex}

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS EXAMPLES

@c -----------------------------------------------------------------------------
@anchor{maxposex}
@c @defvr {Option variable} maxposex
m4_defvr({Option variable}, maxposex)
Default value: 1000

@code{maxposex} is the largest exponent which will be
expanded with the @code{expand} command, see also @mrefdot{maxnegex}

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Declarations and inferences, Expressions, Simplification)
@anchor{multiplicative}
@c @defvr {Property} multiplicative
m4_defvr({Property}, multiplicative)

@code{declare(f, multiplicative)} tells the Maxima simplifier that @code{f}
is multiplicative.

@enumerate
@item
If @code{f} is univariate, whenever the simplifier encounters @code{f} applied
to a product, @code{f} distributes over that product.  E.g., @code{f(x*y)}
simplifies to @code{f(x)*f(y)}.
This simplification is not applied to expressions of the form @code{f('product(...))}.
@item
If @code{f} is a function of 2 or more arguments, multiplicativity is
defined as multiplicativity in the first argument to @code{f}, e.g.,
@code{f (g(x) * h(x), x)} simplifies to @code{f (g(x) ,x) * f (h(x), x)}.
@end enumerate

@code{declare(nounify(product), multiplicative)} tells Maxima to simplify symbolic products.

Example:

@c ===beg===
@c F2 (a * b * c);
@c declare (F2, multiplicative);
@c F2 (a * b * c);
@c ===end===
@example
@group
(%i1) F2 (a * b * c);
(%o1)                       F2(a b c)
@end group
@group
(%i2) declare (F2, multiplicative);
(%o2)                         done
@end group
@group
(%i3) F2 (a * b * c);
(%o3)                   F2(a) F2(b) F2(c)
@end group
@end example

@code{declare(nounify(product), multiplicative)} tells Maxima to simplify symbolic products.

@c ===beg===
@c product (a[i] * b[i], i, 1, n);
@c declare (nounify (product), multiplicative);
@c product (a[i] * b[i], i, 1, n);
@c ===end===
@example
@group
(%i1) product (a[i] * b[i], i, 1, n);
                             n
                           /===\
                            ! !
(%o1)                       ! !  a  b
                            ! !   i  i
                           i = 1
@end group
@group
(%i2) declare (nounify (product), multiplicative);
(%o2)                         done
@end group
@group
(%i3) product (a[i] * b[i], i, 1, n);
                          n         n
                        /===\     /===\
                         ! !       ! !
(%o3)                  ( ! !  a )  ! !  b
                         ! !   i   ! !   i
                        i = 1     i = 1
@end group
@end example

@c @opencatbox
@c @category{Declarations and inferences}
@c @category{Expressions}
@c @category{Simplification}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS WORK

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@anchor{multthru}
@c @deffn  {Function} multthru @
m4_deffn( {Function}, multthru, <<<>>>) @
@fname{multthru} (@var{expr}) @
@fname{multthru} (@var{expr_1}, @var{expr_2})

Multiplies a factor (which should be a sum) of @var{expr} by the other factors
of @var{expr}.  That is, @var{expr} is @code{@var{f_1} @var{f_2} ... @var{f_n}}
where at least one factor, say @var{f_i}, is a sum of terms.  Each term in that
sum is multiplied by the other factors in the product.  (Namely all the factors
except @var{f_i}).  @code{multthru} does not expand exponentiated sums.
This function is the fastest way to distribute products (commutative or
noncommutative) over sums.  Since quotients are represented as products
@code{multthru} can be used to divide sums by products as well.

@code{multthru (@var{expr_1}, @var{expr_2})} multiplies each term in
@var{expr_2} (which should be a sum or an equation) by @var{expr_1}.  If
@var{expr_1} is not itself a sum then this form is equivalent to
@code{multthru (@var{expr_1}*@var{expr_2})}.

@c ===beg===
@c x/(x-y)^2 - 1/(x-y) - f(x)/(x-y)^3;
@c multthru ((x-y)^3, %);
@c ratexpand (%);
@c ((a+b)^10*s^2 + 2*a*b*s + (a*b)^2)/(a*b*s^2);
@c multthru (%);  /* note that this does not expand (b+a)^10 */
@c multthru (a.(b+c.(d+e)+f));
@c expand (a.(b+c.(d+e)+f));
@c ===end===
@example
(%i1) x/(x-y)^2 - 1/(x-y) - f(x)/(x-y)^3;
                      1        x         f(x)
(%o1)             - ----- + -------- - --------
                    x - y          2          3
                            (x - y)    (x - y)
(%i2) multthru ((x-y)^3, %);
                           2
(%o2)             - (x - y)  + x (x - y) - f(x)
(%i3) ratexpand (%);
                           2
(%o3)                   - y  + x y - f(x)
(%i4) ((a+b)^10*s^2 + 2*a*b*s + (a*b)^2)/(a*b*s^2);
                        10  2              2  2
                 (b + a)   s  + 2 a b s + a  b
(%o4)            ------------------------------
                                  2
                             a b s
(%i5) multthru (%);  /* note that this does not expand (b+a)^10 */
                                        10
                       2   a b   (b + a)
(%o5)                  - + --- + ---------
                       s    2       a b
                           s
(%i6) multthru (a.(b+c.(d+e)+f));
(%o6)            a . f + a . c . (e + d) + a . b
(%i7) expand (a.(b+c.(d+e)+f));
(%o7)         a . f + a . c . e + a . c . d + a . b
@end example

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat()
@anchor{property_nary}
@c @defvr {Property} nary
m4_defvr({Property}, nary)

@code{declare(f, nary)} tells Maxima to recognize the function @code{f} as an
n-ary function.

The @code{nary} declaration is not the same as calling the
@mxref{function_nary, nary} function.  The sole effect of
@code{declare(f, nary)} is to instruct the Maxima simplifier to flatten nested
expressions, for example, to simplify @code{foo(x, foo(y, z))} to
@code{foo(x, y, z)}.  See also @mrefdot{declare}

Example:

@c ===beg===
@c H (H (a, b), H (c, H (d, e)));
@c declare (H, nary);
@c H (H (a, b), H (c, H (d, e)));
@c ===end===
@example
(%i1) H (H (a, b), H (c, H (d, e)));
(%o1)               H(H(a, b), H(c, H(d, e)))
(%i2) declare (H, nary);
(%o2)                         done
(%i3) H (H (a, b), H (c, H (d, e)));
(%o3)                   H(a, b, c, d, e)
@end example
@end defvr

@c NEEDS CLARIFICATION, EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Simplification flags and variables)
@anchor{negdistrib}
@c @defvr {Option variable} negdistrib
m4_defvr({Option variable}, negdistrib)
Default value: @code{true}

When @code{negdistrib} is @code{true}, -1 distributes over an expression.
E.g., @code{-(x + y)} becomes @code{- y - x}.  Setting it to @code{false}
will allow @code{- (x + y)} to be displayed like that.  This is sometimes useful
but be very careful: like the @code{simp} flag, this is one flag you do not
want to set to @code{false} as a matter of course or necessarily for other
than local use in your Maxima.

Example:

@c ===beg===
@c negdistrib;
@c -(x+y);
@c negdistrib : not negdistrib ;
@c -(x+y);
@c ===end===
@example
@group
(%i1) negdistrib;
(%o1)                         true
@end group
@group
(%i2) -(x+y);
(%o2)                       (- y) - x
@end group
@group
(%i3) negdistrib : not negdistrib ;
(%o3)                         false
@end group
@group
(%i4) -(x+y);
(%o4)                       - (y + x)
@end group
@end example

@c @opencatbox
@c @category{Simplification flags and variables}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Global variables, Operators, Simplification)
@anchor{opproperties}
@c @defvr {System variable} opproperties
m4_defvr({System variable}, opproperties)

@code{opproperties} is the list of the special operator properties recognized
by the Maxima simplifier.

Items are added to the @code{opproperties} list by the function @code{define_opproperty}.

Example:

@c ===beg===
@c opproperties;
@c ===end===
@example
@group
(%i1) opproperties;
(%o1) [linear, additive, multiplicative, outative, evenfun, 
oddfun, commutative, symmetric, antisymmetric, nary, 
lassociative, rassociative]
@end group
@end example

@c @opencatbox
@c @category{Global variables}
@c @category{Operators}
@c @category{Simplification}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Operators, Simplification)
@anchor{define_opproperty}
@c @deffn {Function} define_opproperty (@var{property_name}, @var{simplifier_fn})
m4_deffn({Function}, define_opproperty, <<<(@var{property_name}, @var{simplifier_fn})>>>)

Declares the symbol @var{property_name} to be an operator property,
which is simplified by @var{simplifier_fn},
which may be the name of a Maxima or Lisp function or a lambda expression.
After @code{define_opproperty} is called,
functions and operators may be declared to have the @var{property_name} property,
and @var{simplifier_fn} is called to simplify them.

@var{simplifier_fn} must be a function of one argument,
which is an expression in which the main operator is declared to have the @var{property_name} property.

@var{simplifier_fn} is called with the global flag @code{simp} disabled.
Therefore @var{simplifier_fn} must be able to carry out its simplification
without making use of the general simplifier.

@code{define_opproperty} appends @var{property_name} to the
global list @code{opproperties}.

@code{define_opproperty} returns @code{done}.

Example:

Declare a new property, @code{identity}, which is simplified by @code{simplify_identity}.
Declare that @code{f} and @code{g} have the new property.

@c ===beg===
@c define_opproperty (identity, simplify_identity);
@c simplify_identity(e) := first(e);
@c declare ([f, g], identity);
@c f(10 + t);
@c g(3*u) - f(2*u);
@c ===end===
@example
@group
(%i1) define_opproperty (identity, simplify_identity);
(%o1)                         done
@end group
@group
(%i2) simplify_identity(e) := first(e);
(%o2)           simplify_identity(e) := first(e)
@end group
@group
(%i3) declare ([f, g], identity);
(%o3)                         done
@end group
@group
(%i4) f(10 + t);
(%o4)                        t + 10
@end group
@group
(%i5) g(3*u) - f(2*u);
(%o5)                           u
@end group
@end example

@c @opencatbox
@c @category{Operators}
@c @category{Simplification}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Declarations and inferences, Operators)
@anchor{outative}
@c @defvr {Property} outative
m4_defvr({Property}, outative)

@code{declare(f, outative)} tells the Maxima simplifier that constant factors
in the argument of @code{f} can be pulled out.

@enumerate
@item
If @code{f} is univariate, whenever the simplifier encounters @code{f} applied
to a product, that product will be partitioned into factors that are constant
and factors that are not and the constant factors will be pulled out.  E.g.,
@code{f(a*x)} will simplify to @code{a*f(x)} where @code{a} is a constant.
Non-atomic constant factors will not be pulled out.
@item
If @code{f} is a function of 2 or more arguments, outativity is defined as in
the case of @code{sum} or @code{integrate}, i.e., @code{f (a*g(x), x)} will
simplify to @code{a * f(g(x), x)} for @code{a} free of @code{x}.
@end enumerate

@code{sum}, @code{integrate}, and @code{limit} are all @code{outative}.

Example:

@c ===beg===
@c F1 (100 * x);
@c declare (F1, outative);
@c F1 (100 * x);
@c declare (zz, constant);
@c F1 (zz * y);
@c ===end===
@example
@group
(%i1) F1 (100 * x);
(%o1)                       F1(100 x)
@end group
@group
(%i2) declare (F1, outative);
(%o2)                         done
@end group
@group
(%i3) F1 (100 * x);
(%o3)                       100 F1(x)
@end group
@group
(%i4) declare (zz, constant);
(%o4)                         done
@end group
@group
(%i5) F1 (zz * y);
(%o5)                       zz F1(y)
@end group
@end example

@c @opencatbox
@c @category{Declarations and inferences}
@c @category{Operators}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Simplification functions)
@anchor{radcan}
@c @deffn {Function} radcan (@var{expr})
m4_deffn({Function}, radcan, <<<(@var{expr})>>>)

Simplifies @var{expr}, which can contain logs, exponentials, and radicals, by 
converting it into a form which is canonical over a large class of expressions 
and a given ordering of variables; that is, all functionally equivalent forms 
are mapped into a unique form.  For a somewhat larger class of expressions, 
@code{radcan} produces a regular form.  Two equivalent expressions in this class 
do not necessarily have the same appearance, but their difference can be 
simplified by @code{radcan} to zero.

For some expressions @code{radcan} is quite time consuming.  This is the cost 
of exploring certain relationships among the components of the expression for 
simplifications based on factoring and partial-fraction expansions of exponents.

@c %e_to_numlog NEEDS ITS OWN @defvar !!!

@c %e_to_numlog HAS NO EFFECT ON RADCAN. RADCAN ALWAYS SIMPLIFIES 
@c exp(a*log(x)) --> x^a. Commenting the following out. 11/2009
@c When @code{%e_to_numlog} is @code{true}, @code{%e^(r*log(expr))} simplifies 
@c to @code{expr^r} if @code{r} is a rational number.

@c RADEXPAND CONTROLS THE SIMPLIFICATION OF THE POWER FUNCTION, E.G.
@c (x*y)^a --> x^a*y^a AND (x^a)^b --> x^(a*b), IF RADEXPAND HAS THE VALUE 'ALL.
@c THE VALUE OF RADEXPAND HAS NO EFFECT ON RADCAN. RADCAN ALWAYS SIMPLIFIES
@c THE ABOVE EXPRESSIONS. COMMENTING THE FOLLOWING OUT. 11/2009
@c When @code{radexpand} is @code{false}, certain transformations are inhibited.
@c @code{radcan (sqrt (1-x))} remains @code{sqrt (1-x)} and is not simplified 
@c to @code{%i sqrt (x-1)}. @code{radcan (sqrt (x^2 - 2*x + 1))} remains 
@c @code{sqrt (x^2 - 2*x + 1)} and is not simplified to @code{x - 1}.

Examples:

@c ===beg===
@c radcan((log(x+x^2)-log(x))^a/log(1+x)^(a/2));
@c radcan((log(1+2*a^x+a^(2*x))/log(1+a^x)));
@c radcan((%e^x-1)/(1+%e^(x/2)));
@c ===end===
@example
@group
(%i1) radcan((log(x+x^2)-log(x))^a/log(1+x)^(a/2));
                                    a/2
(%o1)                     log(x + 1)
@end group
@group
(%i2) radcan((log(1+2*a^x+a^(2*x))/log(1+a^x)));
(%o2)                           2
@end group
@group
(%i3) radcan((%e^x-1)/(1+%e^(x/2)));
                              x/2
(%o3)                       %e    - 1
@end group
@end example

@c @opencatbox
@c @category{Simplification functions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c NEEDS CLARIFICATION, EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Simplification flags and variables)
@anchor{radexpand}
@c @defvr {Option variable} radexpand
m4_defvr({Option variable}, radexpand)
Default value: @code{true}

@code{radexpand} controls some simplifications of radicals.

When @code{radexpand} is @code{all}, causes nth roots of factors of a product
which are powers of n to be pulled outside of the radical.  E.g. if
@code{radexpand} is @code{all}, @code{sqrt (16*x^2)} simplifies to @code{4*x}.

@c EXPRESS SIMPLIFICATON RULES IN GENERAL CASE, NOT SPECIAL CASE
More particularly, consider @code{sqrt (x^2)}.
@itemize @bullet
@item
If @code{radexpand} is @code{all} or @code{assume (x > 0)} has been executed, 
@code{sqrt(x^2)} simplifies to @code{x}.
@item
If @code{radexpand} is @code{true} and @code{domain} is @code{real}
(its default), @code{sqrt(x^2)} simplifies to @code{abs(x)}.
@item
If @code{radexpand} is @code{false}, or @code{radexpand} is @code{true} and
@code{domain} is @code{complex}, @code{sqrt(x^2)} is not simplified.
@end itemize

@c CORRECT STATEMENT HERE ???
Note that @code{domain} only matters when @code{radexpand} is @code{true}.

@c @opencatbox
@c @category{Simplification flags and variables}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS CLARIFICATION, EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Declarations and inferences, Operators)
@anchor{rassociative}
@c @defvr {Property} rassociative
m4_defvr({Property}, rassociative)

@code{declare (g, rassociative)} tells the Maxima
simplifier that @code{g} is right-associative.  E.g.,
@code{g(g(a, b), g(c, d))} simplifies to @code{g(a, g(b, g(c, d)))}.

@c @opencatbox
@c @category{Declarations and inferences}
@c @category{Operators}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS CLARIFICATION, EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Simplification functions)
@anchor{scsimp}
@c @deffn {Function} scsimp (@var{expr}, @var{rule_1}, @dots{}, @var{rule_n})
m4_deffn({Function}, scsimp, <<<(@var{expr}, @var{rule_1}, @dots{}, @var{rule_n})>>>)

Sequential Comparative Simplification (method due to Stoute).
@code{scsimp} attempts to simplify @var{expr}
according to the rules @var{rule_1}, @dots{}, @var{rule_n}.
If a smaller expression is obtained, the process repeats.  Otherwise after all
simplifications are tried, it returns the original answer.

@c MERGE EXAMPLES INTO THIS FILE
@code{example (scsimp)} displays some examples.

@c @opencatbox
@c @category{Simplification functions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Evaluation flags)
@anchor{simp}
@c @defvr {Option variable} simp
m4_defvr({Option variable}, simp)
Default value: @code{true}

@code{simp} enables simplification.  This is the default.  @code{simp} is also
an @code{evflag}, which is recognized by the function @code{ev}.  See @mrefdot{ev}

When @code{simp} is used as an @code{evflag} with a value @code{false}, the 
simplification is suppressed only during the evaluation phase of an expression.
The flag does not suppress the simplification which follows the evaluation 
phase.

Many Maxima functions and operations require simplification to be enabled to work normally.
When simplification is disabled, many results will be incomplete,
and in addition there may be incorrect results or program errors.

Examples:

The simplification is switched off globally.  The expression @code{sin(1.0)} is
not simplified to its numerical value.  The @code{simp}-flag switches the
simplification on.

@c ===beg===
@c simp:false;
@c sin(1.0);
@c sin(1.0),simp;
@c ===end===
@example
@group
(%i1) simp:false;
(%o1)                         false
@end group
@group
(%i2) sin(1.0);
(%o2)                       sin(1.0)
@end group
@group
(%i3) sin(1.0),simp;
(%o3)                  0.8414709848078965
@end group
@end example

The simplification is switched on again.  The @code{simp}-flag cannot suppress
the simplification completely.  The output shows a simplified expression, but
the variable @code{x} has an unsimplified expression as a value, because the
assignment has occurred during the evaluation phase of the expression.

@c ===beg===
@c simp:true;
@c x:sin(1.0),simp:false;
@c :lisp $x
@c ===end===
@example
@group
(%i1) simp:true;
(%o1)                         true
@end group
@group
(%i2) x:sin(1.0),simp:false;
(%o2)                  0.8414709848078965
@end group
@group
(%i3) :lisp $x
((%SIN) 1.0)
@end group
@end example

@c @opencatbox
@c @category{Evaluation flags}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS CLARIFICATION, EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Declarations and inferences, Operators)
@anchor{symmetric}
@c @defvr {Property} symmetric
m4_defvr({Property}, symmetric)

@code{declare (h, symmetric)} tells the Maxima
simplifier that @code{h} is a symmetric function.  E.g., @code{h (x, z, y)} 
simplifies to @code{h (x, y, z)}.

@code{commutative} is synonymous with @code{symmetric}.

@c @opencatbox
@c @category{Declarations and inferences}
@c @category{Operators}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@anchor{xthru}
@c @deffn {Function} xthru (@var{expr})
m4_deffn({Function}, xthru, <<<(@var{expr})>>>)

Combines all terms of @var{expr} (which should be a sum) over a common
denominator without expanding products and exponentiated sums as @code{ratsimp}
does.  @code{xthru} cancels common factors in the numerator and denominator of
rational expressions but only if the factors are explicit.

@c REPHRASE IN NEUTRAL TONE (GET RID OF "IT IS BETTER")
Sometimes it is better to use @code{xthru} before @code{ratsimp}ing an
expression in order to cause explicit factors of the gcd of the numerator and
denominator to be canceled thus simplifying the expression to be
@code{ratsimp}ed.

Examples:

@c ===beg===
@c ((x+2)^20 - 2*y)/(x+y)^20 + (x+y)^(-19) - x/(x+y)^20;
@c xthru (%);
@c ===end===
@example
@group
(%i1) ((x+2)^20 - 2*y)/(x+y)^20 + (x+y)^(-19) - x/(x+y)^20;
                                20
                 1       (x + 2)   - 2 y       x
(%o1)        --------- + --------------- - ---------
                    19             20             20
             (y + x)        (y + x)        (y + x)
@end group
@group
(%i2) xthru (%);
                                 20
                          (x + 2)   - y
(%o2)                     -------------
                                   20
                            (y + x)
@end group
@end example

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()
