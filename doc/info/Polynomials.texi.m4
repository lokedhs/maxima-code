@c -*- Mode: texinfo -*-
@c FOR THE FUNCTIONS WHICH RETURN A CRE, BE SURE TO MENTION THAT
@menu
* Introduction to Polynomials::  
* Functions and Variables for Polynomials::  
@end menu

@c -----------------------------------------------------------------------------
@node Introduction to Polynomials, Functions and Variables for Polynomials, Polynomials, Polynomials
@section Introduction to Polynomials
@c -----------------------------------------------------------------------------

Polynomials are stored in Maxima either in General Form or as Canonical
Rational Expressions (CRE) form. The latter is a standard form, and is
used internally by operations such as @mref{factor}, @mref{ratsimp}, and
so on.

Canonical Rational Expressions constitute a kind of representation
which is especially suitable for expanded polynomials and rational
functions (as well as for partially factored polynomials and rational
functions when @mref{ratfac} is set to @code{true}). In this CRE form an
ordering of variables (from most to least main) is assumed for each
expression.

Polynomials are represented recursively by a list consisting of the main
variable followed by a series of pairs of expressions, one for each term
of the polynomial. The first member of each pair is the exponent of the
main variable in that term and the second member is the coefficient of
that term which could be a number or a polynomial in another variable
again represented in this form. Thus the principal part of the CRE form
of @code{3*x^2-1} is @code{(X 2 3 0 -1)} and that of @code{2*x*y+x-3}
is @code{(Y 1 (X 1 2) 0 (X 1 1 0 -3))} assuming @code{y} is the main
variable, and is @code{(X 1 (Y 1 2 0 1) 0 -3)} assuming @code{x} is the
main variable. "Main"-ness is usually determined by reverse alphabetical
order.

The "variables" of a CRE expression needn't be atomic. In fact any
subexpression whose main operator is not @code{+}, @code{-}, @code{*},
@code{/} or @code{^} with integer power will be considered a "variable"
of the expression (in CRE form) in which it occurs. For example the CRE
variables of the expression @code{x+sin(x+1)+2*sqrt(x)+1} are @code{x},
@code{sqrt(X)}, and @code{sin(x+1)}. If the user does not specify an
ordering of variables by using the @mref{ratvars} function Maxima will
choose an alphabetic one.

In general, CRE's represent rational expressions, that is, ratios of
polynomials, where the numerator and denominator have no common factors,
and the denominator is positive. The internal form is essentially a pair
of polynomials (the numerator and denominator) preceded by the variable
ordering list. If an expression to be displayed is in CRE form or if it
contains any subexpressions in CRE form, the symbol @code{/R/} will follow the
line label.

@c TODO: An example of some code that yields the /R/ form.

See the @mref{rat} function for converting an expression to CRE form.

An extended CRE form is used for the representation of Taylor
series. The notion of a rational expression is extended so that the
exponents of the variables can be positive or negative rational numbers
rather than just positive integers and the coefficients can themselves
be rational expressions as described above rather than just polynomials.
These are represented internally by a recursive polynomial form which is
similar to and is a generalization of CRE form, but carries additional
information such as the degree of truncation. As with CRE form, the
symbol @code{/T/} follows the line label of such expressions.

@c TODO: An example of some code that yields the /T/ form.

@opencatbox
@category{Polynomials}
@category{Rational expressions}
@closecatbox

@c end concepts Polynomials

@c -----------------------------------------------------------------------------
@node Functions and Variables for Polynomials,  , Introduction to Polynomials, Polynomials
@section Functions and Variables for Polynomials
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
m4_setcat(Simplification flags and variables)
@anchor{algebraic}
@c @defvr {Option variable} algebraic
m4_defvr({Option variable}, algebraic)
Default value: @code{false}

@code{algebraic} must be set to @code{true} in order for the simplification of
algebraic integers to take effect.

@c @opencatbox
@c @category{Simplification flags and variables}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials)
@anchor{berlefact}
@c @defvr {Option variable} berlefact
m4_defvr({Option variable}, berlefact)
Default value: @code{true}

When @code{berlefact} is @code{false} then the Kronecker factoring
algorithm will be used otherwise the Berlekamp algorithm, which is the
default, will be used.

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c WHAT IS THIS ABOUT EXACTLY ??

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials)
@anchor{bezout}
@c @deffn {Function} bezout (@var{p1}, @var{p2}, @var{x})
m4_deffn({Function}, bezout, <<<(@var{p1}, @var{p2}, @var{x})>>>)

an alternative to the @mref{resultant} command.  It
returns a matrix.  @code{determinant} of this matrix is the desired resultant.

Examples:

@c ===beg===
@c bezout(a*x+b, c*x^2+d, x);
@c determinant(%);
@c resultant(a*x+b, c*x^2+d, x);
@c ===end===
@example
(%i1) bezout(a*x+b, c*x^2+d, x);
                         [ b c  - a d ]
(%o1)                    [            ]
                         [  a     b   ]
(%i2) determinant(%);
                            2      2
(%o2)                      a  d + b  c
(%i3) resultant(a*x+b, c*x^2+d, x);
                            2      2
(%o3)                      a  d + b  c
@end example
@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c REWORD THIS ITEM -- COULD BE MORE CONCISE

@c -----------------------------------------------------------------------------
@c @deffn {Function} bothcoef (@var{expr}, @var{x})
m4_deffn({Function}, bothcoef, <<<(@var{expr}, @var{x})>>>)

Returns a list whose first member is the coefficient of @var{x} in @var{expr}
(as found by @code{ratcoef} if @var{expr} is in CRE form
otherwise by @code{coeff}) and whose second member is the remaining part of
@var{expr}.  That is, @code{[A, B]} where @code{@var{expr} = A*@var{x} + B}.

Example:

@c ===beg===
@c islinear (expr, x) := block ([c],
@c         c: bothcoef (rat (expr, x), x),
@c         is (freeof (x, c) and c[1] # 0))$
@c islinear ((r^2 - (x - r)^2)/x, x);
@c ===end===
@example
(%i1) islinear (expr, x) := block ([c],
        c: bothcoef (rat (expr, x), x),
        is (freeof (x, c) and c[1] # 0))$
(%i2) islinear ((r^2 - (x - r)^2)/x, x);
(%o2)                         true
@end example

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@c @deffn  {Function} coeff @
m4_deffn({Function}, coeff, <<<@>>>)
@fname{coeff} (@var{expr}, @var{x}, @var{n}) @
@fname{coeff} (@var{expr}, @var{x})

Returns the coefficient of @code{@var{x}^@var{n}} in @var{expr},
where @var{expr} is a polynomial or a monomial term in @var{x}.
Other than @mref{ratcoef} @code{coeff} is a strictly syntactical
operation and will only find literal instances of
@code{@var{x}^@var{n}} in the internal representation of @var{expr}.

@code{coeff(@var{expr}, @var{x}^@var{n})} is equivalent
to @code{coeff(@var{expr}, @var{x}, @var{n})}.
@code{coeff(@var{expr}, @var{x}, 0)} returns the remainder of @var{expr}
which is free of @var{x}.
If omitted, @var{n} is assumed to be 1.

@var{x} may be a simple variable or a subscripted variable,
or a subexpression of @var{expr} which
comprises an operator and all of its arguments.

It may be possible to compute coefficients of expressions which are equivalent
to @var{expr} by applying @code{expand} or @code{factor}.  @code{coeff} itself
does not apply @code{expand} or @code{factor} or any other function.

@code{coeff} distributes over lists, matrices, and equations.

See also @mrefdot{ratcoef}

Examples:

@code{coeff} returns the coefficient @code{@var{x}^@var{n}} in @var{expr}.

@c ===beg===
@c coeff (b^3*a^3 + b^2*a^2 + b*a + 1, a^3);
@c ===end===
@example
@group
(%i1) coeff (b^3*a^3 + b^2*a^2 + b*a + 1, a^3);
                                3
(%o1)                          b
@end group
@end example

@code{coeff(@var{expr}, @var{x}^@var{n})} is equivalent
to @code{coeff(@var{expr}, @var{x}, @var{n})}.

@c ===beg===
@c coeff (c[4]*z^4 - c[3]*z^3 - c[2]*z^2 + c[1]*z, z, 3);
@c coeff (c[4]*z^4 - c[3]*z^3 - c[2]*z^2 + c[1]*z, z^3);
@c ===end===
@example
@group
(%i1) coeff (c[4]*z^4 - c[3]*z^3 - c[2]*z^2 + c[1]*z, z, 3);
(%o1)                         - c
                                 3
@end group
@group
(%i2) coeff (c[4]*z^4 - c[3]*z^3 - c[2]*z^2 + c[1]*z, z^3);
(%o2)                         - c
                                 3
@end group
@end example

@code{coeff(@var{expr}, @var{x}, 0)} returns the remainder of @var{expr}
which is free of @var{x}.

@c ===beg===
@c coeff (a*u + b^2*u^2 + c^3*u^3, b, 0);
@c ===end===
@example
@group
(%i1) coeff (a*u + b^2*u^2 + c^3*u^3, b, 0);
                            3  3
(%o1)                      c  u  + a u
@end group
@end example

@var{x} may be a simple variable or a subscripted variable,
or a subexpression of @var{expr} which
comprises an operator and all of its arguments.

@c ===beg===
@c coeff (h^4 - 2*%pi*h^2 + 1, h, 2);
@c coeff (v[1]^4 - 2*%pi*v[1]^2 + 1, v[1], 2);
@c coeff (sin(1+x)*sin(x) + sin(1+x)^3*sin(x)^3, sin(1+x)^3);
@c coeff ((d - a)^2*(b + c)^3 + (a + b)^4*(c - d), a + b, 4);
@c ===end===
@example
@group
(%i1) coeff (h^4 - 2*%pi*h^2 + 1, h, 2);
(%o1)                        - 2 %pi
@end group
@group
(%i2) coeff (v[1]^4 - 2*%pi*v[1]^2 + 1, v[1], 2);
(%o2)                        - 2 %pi
@end group
@group
(%i3) coeff (sin(1+x)*sin(x) + sin(1+x)^3*sin(x)^3, sin(1+x)^3);
                                3
(%o3)                        sin (x)
@end group
@group
(%i4) coeff ((d - a)^2*(b + c)^3 + (a + b)^4*(c - d), a + b, 4);
(%o4)                         c - d
@end group
@end example

@code{coeff} itself does not apply @code{expand} or @code{factor} or any other
function.

@c ===beg===
@c coeff (c*(a + b)^3, a);
@c expand (c*(a + b)^3);
@c coeff (%, a);
@c coeff (b^3*c + 3*a*b^2*c + 3*a^2*b*c + a^3*c, (a + b)^3);
@c factor (b^3*c + 3*a*b^2*c + 3*a^2*b*c + a^3*c);
@c coeff (%, (a + b)^3);
@c ===end===
@example
@group
(%i1) coeff (c*(a + b)^3, a);
(%o1)                           0
@end group
@group
(%i2) expand (c*(a + b)^3);
                 3          2        2        3
(%o2)           b  c + 3 a b  c + 3 a  b c + a  c
@end group
@group
(%i3) coeff (%, a);
                                2
(%o3)                        3 b  c
@end group
@group
(%i4) coeff (b^3*c + 3*a*b^2*c + 3*a^2*b*c + a^3*c, (a + b)^3);
(%o4)                           0
@end group
@group
(%i5) factor (b^3*c + 3*a*b^2*c + 3*a^2*b*c + a^3*c);
                                  3
(%o5)                      (b + a)  c
@end group
@group
(%i6) coeff (%, (a + b)^3);
(%o6)                           c
@end group
@end example

@code{coeff} distributes over lists, matrices, and equations.

@c ===beg===
@c coeff ([4*a, -3*a, 2*a], a);
@c coeff (matrix ([a*x, b*x], [-c*x, -d*x]), x);
@c coeff (a*u - b*v = 7*u + 3*v, u);
@c ===end===
@example
@group
(%i1) coeff ([4*a, -3*a, 2*a], a);
(%o1)                      [4, - 3, 2]
@end group
@group
(%i2) coeff (matrix ([a*x, b*x], [-c*x, -d*x]), x);
                          [  a    b  ]
(%o2)                     [          ]
                          [ - c  - d ]
@end group
@group
(%i3) coeff (a*u - b*v = 7*u + 3*v, u);
(%o3)                         a = 7
@end group
@end example

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@c @deffn {Function} content (@var{p_1}, @var{x_1}, @dots{}, @var{x_n})
m4_deffn({Function}, content, <<<(@var{p_1}, @var{x_1}, @dots{}, @var{x_n})>>>)

Returns a list whose first element is
the greatest common divisor of the coefficients of the terms of the
polynomial @var{p_1} in the variable @var{x_n} (this is the content) and whose
second element is the polynomial @var{p_1} divided by the content.
@c APPEARS TO WORK AS ADVERTISED -- ONLY x_n HAS ANY EFFECT ON THE RESULT
@c WHAT ARE THE OTHER VARIABLES x_1 THROUGH x_{n-1} FOR ??

Examples:

@c ===beg===
@c content (2*x*y + 4*x^2*y^2, y);
@c ===end===
@example
(%i1) content (2*x*y + 4*x^2*y^2, y);
@group
                                   2
(%o1)                   [2 x, 2 x y  + y]
@end group
@end example

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{denom}
@c @deffn {Function} denom (@var{expr})
m4_deffn({Function}, denom, <<<(@var{expr})>>>)

Returns the denominator of the rational expression @var{expr}.

See also @mref{num}

@c ===beg===
@c g1:(x+2)*(x+1)/((x+3)^2);
@c denom(g1);
@c g2:sin(x)/10*cos(x)/y;
@c denom(g2);
@c ===end===
@example
@group
(%i1) g1:(x+2)*(x+1)/((x+3)^2);
                         (x + 1) (x + 2)
(%o1)                    ---------------
                                   2
                            (x + 3)
@end group
@group
(%i2) denom(g1);
                                   2
(%o2)                       (x + 3)
@end group
@group
(%i3) g2:sin(x)/10*cos(x)/y;
                          cos(x) sin(x)
(%o3)                     -------------
                              10 y
@end group
@group
(%i4) denom(g2);
(%o4)                         10 y
@end group
@end example

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{divide}
@c @deffn {Function} divide (@var{p_1}, @var{p_2}, @var{x_1}, @dots{}, @var{x_n})
m4_deffn({Function}, divide, <<<(@var{p_1}, @var{p_2}, @var{x_1}, @dots{}, @var{x_n})>>>)

computes the quotient and remainder
of the polynomial @var{p_1} divided by the polynomial @var{p_2}, in a main
polynomial variable, @var{x_n}.
@c SPELL OUT THE PURPOSE OF THE OTHER VARIABLES
The other variables are as in the @code{ratvars} function.
The result is a list whose first element is the quotient
and whose second element is the remainder.

Examples:

@c ===beg===
@c divide (x + y, x - y, x);
@c divide (x + y, x - y);
@c ===end===
@example
(%i1) divide (x + y, x - y, x);
(%o1)                       [1, 2 y]
(%i2) divide (x + y, x - y);
(%o2)                      [- 1, 2 x]
@end example

@noindent
Note that @code{y} is the main variable in the second example.

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials, Algebraic equations)
@anchor{eliminate}
@c @deffn {Function} eliminate ([@var{eqn_1}, @dots{}, @var{eqn_n}], [@var{x_1}, @dots{}, @var{x_k}])
m4_deffn({Function}, eliminate, <<<([@var{eqn_1}, @dots{}, @var{eqn_n}], [@var{x_1}, @dots{}, @var{x_k}])>>>)

Eliminates variables from equations (or expressions assumed equal to zero) by
taking successive resultants. This returns a list of @code{@var{n} - @var{k}}
expressions with the @var{k} variables @var{x_1}, @dots{}, @var{x_k} eliminated.
First @var{x_1} is eliminated yielding @code{@var{n} - 1} expressions, then
@code{x_2} is eliminated, etc.  If @code{@var{k} = @var{n}} then a single
expression in a list is returned free of the variables @var{x_1}, @dots{},
@var{x_k}.  In this case @code{solve} is called to solve the last resultant for
the last variable.

Example:

@c ===beg===
@c expr1: 2*x^2 + y*x + z;
@c expr2: 3*x + 5*y - z - 1;
@c expr3: z^2 + x - y^2 + 5;
@c eliminate ([expr3, expr2, expr1], [y, z]);
@c ===end===
@example
(%i1) expr1: 2*x^2 + y*x + z;
                                      2
(%o1)                    z + x y + 2 x
(%i2) expr2: 3*x + 5*y - z - 1;
(%o2)                  - z + 5 y + 3 x - 1
(%i3) expr3: z^2 + x - y^2 + 5;
                          2    2
(%o3)                    z  - y  + x + 5
(%i4) eliminate ([expr3, expr2, expr1], [y, z]);
             8         7         6          5          4
(%o4) [7425 x  - 1170 x  + 1299 x  + 12076 x  + 22887 x

                                    3         2
                            - 5154 x  - 1291 x  + 7688 x + 15376]
@end example

@c @opencatbox
@c @category{Polynomials}
@c @category{Algebraic equations}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials)
@anchor{ezgcd}
@c @deffn {Function} ezgcd (@var{p_1}, @var{p_2}, @var{p_3}, @dots{})
m4_deffn({Function}, ezgcd, <<<(@var{p_1}, @var{p_2}, @var{p_3}, @dots{})>>>)

Returns a list whose first element is the greatest common divisor of the
polynomials @var{p_1}, @var{p_2}, @var{p_3}, @dots{} and whose remaining
elements are the polynomials divided by the greatest common divisor.  This
always uses the @code{ezgcd} algorithm.

See also @mrefcomma{gcd} @mrefcomma{gcdex} @mrefcomma{gcdivide} and
@mrefdot{poly_gcd}

Examples:

The three polynomials have the greatest common divisor @code{2*x-3}.  The
gcd is first calculated with the function @code{gcd} and then with the function
@code{ezgcd}.

@c ===beg===
@c p1 : 6*x^3-17*x^2+14*x-3;
@c p2 : 4*x^4-14*x^3+12*x^2+2*x-3;
@c p3 : -8*x^3+14*x^2-x-3;
@c gcd(p1, gcd(p2, p3));
@c ezgcd(p1, p2, p3);
@c ===end===
@example
(%i1) p1 : 6*x^3-17*x^2+14*x-3;
                        3       2
(%o1)                6 x  - 17 x  + 14 x - 3
(%i2) p2 : 4*x^4-14*x^3+12*x^2+2*x-3;
                    4       3       2
(%o2)            4 x  - 14 x  + 12 x  + 2 x - 3
(%i3) p3 : -8*x^3+14*x^2-x-3;
                          3       2
(%o3)                - 8 x  + 14 x  - x - 3

(%i4) gcd(p1, gcd(p2, p3));
(%o4)                        2 x - 3

(%i5) ezgcd(p1, p2, p3);
                   2               3      2           2
(%o5) [2 x - 3, 3 x  - 4 x + 1, 2 x  - 4 x  + 1, - 4 x  + x + 1]
@end example

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@c @defvr {Option variable} facexpand
m4_defvr({Option variable}, facexpand)
Default value: @code{true}

@code{facexpand} controls whether the irreducible factors returned by
@code{factor} are in expanded (the default) or recursive (normal CRE) form.

@opencatbox
@category{Polynomials}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{factor}
@c @deffn  {Function} factor @
m4_deffn({Function}, factor, <<<>>>) @
@fname{factor} (@var{expr}) @
@fname{factor} (@var{expr}, @var{p})

Factors the expression @var{expr}, containing any number of variables or 
functions, into factors irreducible over the integers.
@code{factor (@var{expr}, @var{p})} factors @var{expr} over the field of 
rationals with an element adjoined whose minimum polynomial is @var{p}.

@code{factor} uses @mref{ifactors} function for factoring integers.

@mref{factorflag} if @code{false} suppresses the factoring of integer factors
of rational expressions.

@mref{dontfactor} may be set to a list of variables with respect to which
factoring is not to occur.  (It is initially empty).  Factoring also
will not take place with respect to any variables which are less
important (using the variable ordering assumed for CRE form) than
those on the @code{dontfactor} list.

@mref{savefactors} if @code{true} causes the factors of an expression which
is a product of factors to be saved by certain functions in order to
speed up later factorizations of expressions containing some of the
same factors.

@mref{berlefact} if @code{false} then the Kronecker factoring algorithm will
be used otherwise the Berlekamp algorithm, which is the default, will
be used.

@mref{intfaclim} if @code{true} maxima will give up factorization of
integers if no factor is found after trial divisions and Pollard's rho
method.  If set to @code{false} (this is the case when the user calls
@code{factor} explicitly), complete factorization of the integer will be
attempted.  The user's setting of @code{intfaclim} is used for internal
calls to @code{factor}.  Thus, @code{intfaclim} may be reset to prevent
Maxima from taking an inordinately long time factoring large integers.

@mref{factor_max_degree} if set to a positive integer @code{n} will
prevent certain polynomials from being factored if their degree in any
variable exceeds @code{n}.

See also @mrefdot{collectterms}

Examples:

@c ===beg===
@c factor (2^63 - 1);
@c factor (-8*y - 4*x + z^2*(2*y + x));
@c -1 - 2*x - x^2 + y^2 + 2*x*y^2 + x^2*y^2;
@c block ([dontfactor: [x]], factor (%/36/(1 + 2*y + y^2)));
@c factor (1 + %e^(3*x));
@c factor (1 + x^4, a^2 - 2);
@c factor (-y^2*z^2 - x*z^2 + x^2*y^2 + x^3);
@c (2 + x)/(3 + x)/(b + x)/(c + x)^2;
@c ratsimp (%);
@c partfrac (%, x);
@c map ('factor, %);
@c ratsimp ((x^5 - 1)/(x - 1));
@c subst (a, x, %);
@c factor (%th(2), %);
@c factor (1 + x^12);
@c factor (1 + x^99);
@c ===end===
@example
(%i1) factor (2^63 - 1);
                    2
(%o1)              7  73 127 337 92737 649657
(%i2) factor (-8*y - 4*x + z^2*(2*y + x));
(%o2)               (2 y + x) (z - 2) (z + 2)
(%i3) -1 - 2*x - x^2 + y^2 + 2*x*y^2 + x^2*y^2;
                2  2        2    2    2
(%o3)          x  y  + 2 x y  + y  - x  - 2 x - 1
(%i4) block ([dontfactor: [x]], factor (%/36/(1 + 2*y + y^2)));
@group
                       2
                     (x  + 2 x + 1) (y - 1)
(%o4)                ----------------------
                           36 (y + 1)
@end group
(%i5) factor (1 + %e^(3*x));
                      x         2 x     x
(%o5)              (%e  + 1) (%e    - %e  + 1)
(%i6) factor (1 + x^4, a^2 - 2);
                    2              2
(%o6)             (x  - a x + 1) (x  + a x + 1)
(%i7) factor (-y^2*z^2 - x*z^2 + x^2*y^2 + x^3);
                       2
(%o7)              - (y  + x) (z - x) (z + x)
(%i8) (2 + x)/(3 + x)/(b + x)/(c + x)^2;
                             x + 2
(%o8)               ------------------------
                                           2
                    (x + 3) (x + b) (x + c)
(%i9) ratsimp (%);
@group
                4                  3
(%o9) (x + 2)/(x  + (2 c + b + 3) x

     2                       2             2                   2
 + (c  + (2 b + 6) c + 3 b) x  + ((b + 3) c  + 6 b c) x + 3 b c )
@end group
(%i10) partfrac (%, x);
           2                   4                3
(%o10) - (c  - 4 c - b + 6)/((c  + (- 2 b - 6) c

     2              2         2                2
 + (b  + 12 b + 9) c  + (- 6 b  - 18 b) c + 9 b ) (x + c))

                 c - 2
 - ---------------------------------
     2                             2
   (c  + (- b - 3) c + 3 b) (x + c)

                         b - 2
 + -------------------------------------------------
             2             2       3      2
   ((b - 3) c  + (6 b - 2 b ) c + b  - 3 b ) (x + b)

                         1
 - ----------------------------------------------
             2
   ((b - 3) c  + (18 - 6 b) c + 9 b - 27) (x + 3)
(%i11) map ('factor, %);
@group
              2
             c  - 4 c - b + 6                 c - 2
(%o11) - ------------------------- - ------------------------
                2        2                                  2
         (c - 3)  (c - b)  (x + c)   (c - 3) (c - b) (x + c)

                       b - 2                        1
            + ------------------------ - ------------------------
                             2                          2
              (b - 3) (c - b)  (x + b)   (b - 3) (c - 3)  (x + 3)
@end group
(%i12) ratsimp ((x^5 - 1)/(x - 1));
                       4    3    2
(%o12)                x  + x  + x  + x + 1
(%i13) subst (a, x, %);
                       4    3    2
(%o13)                a  + a  + a  + a + 1
(%i14) factor (%th(2), %);
                       2        3        3    2
(%o14)   (x - a) (x - a ) (x - a ) (x + a  + a  + a + 1)
(%i15) factor (1 + x^12);
                       4        8    4
(%o15)               (x  + 1) (x  - x  + 1)
(%i16) factor (1 + x^99);
                 2            6    3
(%o16) (x + 1) (x  - x + 1) (x  - x  + 1)

   10    9    8    7    6    5    4    3    2
 (x   - x  + x  - x  + x  - x  + x  - x  + x  - x + 1)

   20    19    17    16    14    13    11    10    9    7    6
 (x   + x   - x   - x   + x   + x   - x   - x   - x  + x  + x

    4    3            60    57    51    48    42    39    33
 - x  - x  + x + 1) (x   + x   - x   - x   + x   + x   - x

    30    27    21    18    12    9    3
 - x   - x   + x   + x   - x   - x  + x  + 1)
@end example

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@anchor{factor_max_degree}


@c -----------------------------------------------------------------------------
@c @defvr {Option variable} factor_max_degree
m4_defvr({Option variable}, factor_max_degree)
Default value: @code{1000}

When factor_max_degree is set to a positive integer @code{n}, it will prevent
Maxima from attempting to factor certain polynomials whose degree in any
variable exceeds @code{n}. If @mref{factor_max_degree_print_warning} is true,
a warning message will be printed. @code{factor_max_degree} can be used to
prevent excessive memory usage and/or computation time and stack overflows.
Note that "obvious" factoring of polynomials such as @code{x^2000+x^2001} to
@code{x^2000*(x+1)} will still take place. To disable this behavior, set
@code{factor_max_degree} to @code{0}.

Example:
@c ===beg===
@c factor_max_degree : 100$
@c factor(x^100-1);
@c factor(x^101-1);
@c ===end===
@example
(%i1) factor_max_degree : 100$
@group
(%i2) factor(x^100-1);
                        2        4    3    2
(%o2) (x - 1) (x + 1) (x  + 1) (x  - x  + x  - x + 1)
   4    3    2            8    6    4    2
 (x  + x  + x  + x + 1) (x  - x  + x  - x  + 1)
   20    15    10    5        20    15    10    5
 (x   - x   + x   - x  + 1) (x   + x   + x   + x  + 1)
   40    30    20    10
 (x   - x   + x   - x   + 1)
@end group
@group
(%i3) factor(x^101-1);
                               101
Refusing to factor polynomial x    - 1
               because its degree exceeds factor_max_degree (100)
                             101
(%o3)                       x    - 1
@end group
@end example

See also: @mref{factor_max_degree_print_warning}

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@anchor{factor_max_degree_print_warning}
@c -----------------------------------------------------------------------------
@c @defvr {Option variable} factor_max_degree_print_warning
m4_defvr({Option variable}, factor_max_degree_print_warning)
Default value: @code{true}

When factor_max_degree_print_warning is true, then Maxima will print a
warning message when the factoring of a polynomial is prevented because
its degree exceeds the value of factor_max_degree.

See also: @mref{factor_max_degree}

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end defvr 
m4_end_defvr()

@anchor{factorflag}
@c -----------------------------------------------------------------------------
@c @defvr {Option variable} factorflag
m4_defvr({Option variable}, factorflag)
Default value: @code{false}

@c WHAT IS THIS ABOUT EXACTLY ??
When @code{factorflag} is @code{false}, suppresses the factoring of
integer factors of rational expressions.

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@c @deffn {Function} factorout (@var{expr}, @var{x_1}, @var{x_2}, @dots{})
m4_deffn({Function}, factorout, <<<(@var{expr}, @var{x_1}, @var{x_2}, @dots{})>>>)

Rearranges the sum @var{expr} into a sum of terms of the form 
@code{f (@var{x_1}, @var{x_2}, @dots{})*g} where @code{g} is a product of 
expressions not containing any @var{x_i} and @code{f} is factored.

Note that the option variable @code{keepfloat} is ignored by @code{factorout}.

Example:

@c ===beg===
@c expand (a*(x+1)*(x-1)*(u+1)^2);
@c factorout(%,x);
@c ===end===
@example
@group
(%i1) expand (a*(x+1)*(x-1)*(u+1)^2);
             2  2          2      2      2
(%o1)     a u  x  + 2 a u x  + a x  - a u  - 2 a u - a
@end group
@group
(%i2) factorout(%,x);
         2
(%o2) a u  (x - 1) (x + 1) + 2 a u (x - 1) (x + 1)
                                              + a (x - 1) (x + 1)
@end group
@end example

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@c @deffn {Function} factorsum (@var{expr})
m4_deffn({Function}, factorsum, <<<(@var{expr})>>>)

Tries to group terms in factors of @var{expr} which are sums into groups of
terms such that their sum is factorable.  @code{factorsum} can recover the
result of @code{expand ((x + y)^2 + (z + w)^2)} but it can't recover
@code{expand ((x + 1)^2 + (x + y)^2)} because the terms have variables in
common.

Example:

@c ===beg===
@c expand ((x + 1)*((u + v)^2 + a*(w + z)^2));
@c factorsum (%);
@c ===end===
@example
(%i1) expand ((x + 1)*((u + v)^2 + a*(w + z)^2));
           2      2                            2      2
(%o1) a x z  + a z  + 2 a w x z + 2 a w z + a w  x + v  x

                                     2        2    2            2
                        + 2 u v x + u  x + a w  + v  + 2 u v + u
(%i2) factorsum (%);
                                   2          2
(%o2)            (x + 1) (a (z + w)  + (v + u) )
@end example

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@c @deffn {Function} fasttimes (@var{p_1}, @var{p_2})
m4_deffn({Function}, fasttimes, <<<(@var{p_1}, @var{p_2})>>>)

Returns the product of the polynomials @var{p_1} and @var{p_2} by using a
special algorithm for multiplication of polynomials.  @code{p_1} and @code{p_2}
should be multivariate, dense, and nearly the same size.  Classical
multiplication is of order @code{n_1 n_2} where
@code{n_1} is the degree of @code{p_1}
and @code{n_2} is the degree of @code{p_2}.
@code{fasttimes} is of order @code{max (n_1, n_2)^1.585}.

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Simplification functions, Rational expressions)
@c @deffn {Function} fullratsimp (@var{expr})
m4_deffn({Function}, fullratsimp, <<<(@var{expr})>>>)

@code{fullratsimp} repeatedly
applies @code{ratsimp} followed by non-rational simplification to an
expression until no further change occurs,
and returns the result.

When non-rational expressions are involved, one call
to @code{ratsimp} followed as is usual by non-rational ("general")
simplification may not be sufficient to return a simplified result.
Sometimes, more than one such call may be necessary.
@code{fullratsimp} makes this process convenient.

@code{fullratsimp (@var{expr}, @var{x_1}, ..., @var{x_n})} takes one or more
arguments similar to @code{ratsimp} and @code{rat}.

Example:

@c ===beg===
@c expr: (x^(a/2) + 1)^2*(x^(a/2) - 1)^2/(x^a - 1);
@c ratsimp (expr);
@c fullratsimp (expr);
@c rat (expr);
@c ===end===
@example
(%i1) expr: (x^(a/2) + 1)^2*(x^(a/2) - 1)^2/(x^a - 1);
                       a/2     2   a/2     2
                     (x    - 1)  (x    + 1)
(%o1)                -----------------------
                              a
                             x  - 1
(%i2) ratsimp (expr);
                          2 a      a
                         x    - 2 x  + 1
(%o2)                    ---------------
                              a
                             x  - 1
(%i3) fullratsimp (expr);
                              a
(%o3)                        x  - 1
(%i4) rat (expr);
                       a/2 4       a/2 2
                     (x   )  - 2 (x   )  + 1
(%o4)/R/             -----------------------
                              a
                             x  - 1
@end example

@c @opencatbox
@c @category{Simplification functions}
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c SPELL OUT WHAT fullratsubst DOES INSTEAD OF ALLUDING TO ratsubst AND lratsubst
@c THIS ITEM NEEDS MORE WORK

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions)
@c @deffn {Function} fullratsubst (@var{a}, @var{b}, @var{c})
m4_deffn({Function}, fullratsubst, <<<(@var{a}, @var{b}, @var{c})>>>)

is the same as @code{ratsubst} except that it calls
itself recursively on its result until that result stops changing.
This function is useful when the replacement expression and the
replaced expression have one or more variables in common.

@code{fullratsubst} will also accept its arguments in the format of
@code{lratsubst}.  That is, the first argument may be a single substitution
equation or a list of such equations, while the second argument is the
expression being processed.

@code{load ("lrats")} loads @code{fullratsubst} and @code{lratsubst}.

Examples:

@c EXPRESSIONS ADAPTED FROM demo ("lrats")
@c CAN PROBABLY CUT OUT THE lratsubst STUFF (lratsubst HAS ITS OWN DESCRIPTION)
@c load ("lrats")$
@c subst ([a = b, c = d], a + c);
@c lratsubst ([a^2 = b, c^2 = d], (a + e)*c*(a + c));
@c lratsubst (a^2 = b, a^3);
@c ratsubst (b*a, a^2, a^3);
@c fullratsubst (b*a, a^2, a^3);
@c fullratsubst ([a^2 = b, b^2 = c, c^2 = a], a^3*b*c);
@c fullratsubst (a^2 = b*a, a^3);
@example
(%i1) load ("lrats")$
@end example
@itemize @bullet
@item
@code{subst} can carry out multiple substitutions.
@code{lratsubst} is analogous to @code{subst}.
@end itemize
@example
(%i2) subst ([a = b, c = d], a + c);
(%o2)                         d + b
(%i3) lratsubst ([a^2 = b, c^2 = d], (a + e)*c*(a + c));
(%o3)                (d + a c) e + a d + b c
@end example
@itemize @bullet
@item
If only one substitution is desired, then a single
equation may be given as first argument.
@end itemize
@example
(%i4) lratsubst (a^2 = b, a^3);
(%o4)                          a b
@end example
@itemize @bullet
@item
@code{fullratsubst} is equivalent to @code{ratsubst}
except that it recurses until its result stops changing.
@end itemize
@example
(%i5) ratsubst (b*a, a^2, a^3);
                               2
(%o5)                         a  b
(%i6) fullratsubst (b*a, a^2, a^3);
                                 2
(%o6)                         a b
@end example
@itemize @bullet
@item
@code{fullratsubst} also accepts a list of equations or a single
equation as first argument.
@end itemize
@example
(%i7) fullratsubst ([a^2 = b, b^2 = c, c^2 = a], a^3*b*c);
(%o7)                           b
(%i8) fullratsubst (a^2 = b*a, a^3);
                                 2
(%o8)                         a b
@end example
@itemize @bullet
@item
@c REWORD THIS SENTENCE
@code{fullratsubst} may cause an indefinite recursion.
@end itemize
@example
(%i9) errcatch (fullratsubst (b*a^2, a^2, a^3));

*** - Lisp stack overflow. RESET
@end example

@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c GCD IS A VARIABLE AND A FUNCTION
@c THIS ITEM NEEDS A LOT OF WORK

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials, Rational expressions)
@anchor{gcd}
@c @deffn {Function} gcd (@var{p_1}, @var{p_2}, @var{x_1}, @dots{})
m4_deffn({Function}, gcd, <<<(@var{p_1}, @var{p_2}, @var{x_1}, @dots{})>>>)

Returns the greatest common divisor of @var{p_1} and @var{p_2}.  The flag
@code{gcd} determines which algorithm is employed.  Setting @code{gcd} to
@code{ez}, @code{subres}, @code{red}, or @code{spmod} selects the @code{ezgcd},
subresultant @code{prs}, reduced, or modular algorithm, respectively.  If
@code{gcd} @code{false} then @code{gcd (@var{p_1}, @var{p_2}, @var{x})} always
returns 1 for all @var{x}.  Many functions (e.g. @mrefcomma{ratsimp}@w{}
@mrefcomma{factor} etc.) cause gcd's to be taken implicitly.  For homogeneous
polynomials it is recommended that @code{gcd} equal to @code{subres} be used.
To take the gcd when an algebraic is present, e.g.,
@code{gcd (@var{x}^2 - 2*sqrt(2)* @var{x} + 2, @var{x} - sqrt(2))}, the option
variable @mref{algebraic} must be @code{true} and @code{gcd} must not be
@code{ez}.

The @code{gcd} flag, default: @code{spmod}, if @code{false} will also prevent
the greatest common divisor from being taken when expressions are converted to
canonical rational expression (CRE) form.  This will sometimes speed the
calculation if gcds are not required.

See also @mrefcomma{ezgcd} @mrefcomma{gcdex} @mrefcomma{gcdivide} and
@mrefdot{poly_gcd}

Example:

@c ===beg===
@c p1:6*x^3+19*x^2+19*x+6; 
@c p2:6*x^5+13*x^4+12*x^3+13*x^2+6*x;
@c gcd(p1, p2);
@c p1/gcd(p1, p2), ratsimp;
@c p2/gcd(p1, p2), ratsimp;
@c ===end===
@example
(%i1) p1:6*x^3+19*x^2+19*x+6; 
                        3       2
(%o1)                6 x  + 19 x  + 19 x + 6
(%i2) p2:6*x^5+13*x^4+12*x^3+13*x^2+6*x;
                  5       4       3       2
(%o2)          6 x  + 13 x  + 12 x  + 13 x  + 6 x
(%i3) gcd(p1, p2);
                            2
(%o3)                    6 x  + 13 x + 6
(%i4) p1/gcd(p1, p2), ratsimp;
(%o4)                         x + 1
(%i5) p2/gcd(p1, p2), ratsimp;
                              3
(%o5)                        x  + x
@end example

@mref{ezgcd} returns a list whose first element is the greatest common divisor
of the polynomials @var{p_1} and @var{p_2}, and whose remaining elements are
the polynomials divided by the greatest common divisor.

@c ===beg===
@c ezgcd(p1, p2);
@c ===end===
@example
(%i6) ezgcd(p1, p2);
                    2                     3
(%o6)           [6 x  + 13 x + 6, x + 1, x  + x]
@end example

@c @opencatbox
@c @category{Polynomials}
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c IN NEED OF SERIOUS CLARIFICATION HERE

@c -----------------------------------------------------------------------------
@anchor{gcdex}
@c @deffn  {Function} gcdex @
m4_deffn({Function}, gcdex, <<<>>>) @
@fname{gcdex} (@var{f}, @var{g}) @
@fname{gcdex} (@var{f}, @var{g}, @var{x})

Returns a list @code{[@var{a}, @var{b}, @var{u}]} where @var{u} is the greatest
common divisor (gcd) of @var{f} and @var{g}, and @var{u} is equal to
@code{@var{a} @var{f} + @var{b} @var{g}}.  The arguments @var{f} and @var{g}
should be univariate polynomials, or else polynomials in @var{x} a supplied
main variable since we need to be in a principal ideal domain for this to
work.  The gcd means the gcd regarding @var{f} and @var{g} as univariate
polynomials with coefficients being rational functions in the other variables.

@code{gcdex} implements the Euclidean algorithm, where we have a sequence of
@code{L[i]: [a[i], b[i], r[i]]} which are all perpendicular to @code{[f, g, -1]}
and the next one is built as if @code{q = quotient(r[i]/r[i+1])} then
@code{L[i+2]: L[i] - q L[i+1]}, and it terminates at @code{L[i+1]} when the
remainder @code{r[i+2]} is zero.

The arguments @var{f} and @var{g} can be integers.  For this case the function
@mref{igcdex} is called by @code{gcdex}.

See also @mrefcomma{ezgcd} @mrefcomma{gcd} @mrefcomma{gcdivide} and
@mrefdot{poly_gcd}

Examples:

@c ===beg===
@c gcdex (x^2 + 1, x^3 + 4);
@c % . [x^2 + 1, x^3 + 4, -1];
@c ===end===
@example
@group
(%i1) gcdex (x^2 + 1, x^3 + 4);
                       2
                      x  + 4 x - 1  x + 4
(%o1)/R/           [- ------------, -----, 1]
                           17        17
@end group
@group
(%i2) % . [x^2 + 1, x^3 + 4, -1];
(%o2)/R/                        0
@end group
@end example

@c SORRY FOR BEING DENSE BUT WHAT IS THIS ABOUT EXACTLY
Note that the gcd in the following is @code{1} since we work in @code{k(y)[x]},
not the  @code{y+1} we would expect in @code{k[y, x]}.

@c ===beg===
@c gcdex (x*(y + 1), y^2 - 1, x);
@c ===end===
@example
@group
(%i1) gcdex (x*(y + 1), y^2 - 1, x);
                               1
(%o1)/R/                 [0, ------, 1]
                              2
                             y  - 1
@end group
@end example

@c @opencatbox
@c @category{Polynomials}
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c CHOOSE ONE CHARACTERIZATION OF "GAUSSIAN INTEGERS" AND USE IT WHERE GAUSSIAN INTEGERS ARE REFERENCED

@c -----------------------------------------------------------------------------
m4_setcat(Integers)
@c @deffn {Function} gcfactor (@var{n})
m4_deffn({Function}, gcfactor, <<<(@var{n})>>>)

Factors the Gaussian integer @var{n} over the Gaussian integers, i.e., numbers
of the form @code{@var{a} + @var{b} @code{%i}} where @var{a} and @var{b} are
rational integers (i.e.,  ordinary integers).  Factors are normalized by making
@var{a} and @var{b} non-negative.
@c NEED EXAMPLES HERE

@c @opencatbox
@c @category{Integers}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c CHOOSE ONE CHARACTERIZATION OF "GAUSSIAN INTEGERS" AND USE IT WHERE GAUSSIAN INTEGERS ARE REFERENCED

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials)
@c @deffn {Function} gfactor (@var{expr})
m4_deffn({Function}, gfactor, <<<(@var{expr})>>>)

Factors the polynomial @var{expr} over the Gaussian integers
(that is, the integers with the imaginary unit @code{%i} adjoined).
@c "This is like" -- IS IT THE SAME OR NOT ??
This is like @code{factor (@var{expr}, @var{a}^2+1)} where @var{a} is @code{%i}.

Example:

@c ===beg===
@c gfactor (x^4 - 1);
@c ===end===
@example
(%i1) gfactor (x^4 - 1);
(%o1)           (x - 1) (x + 1) (x - %i) (x + %i)
@end example

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c DESCRIBE THIS INDEPENDENTLY OF factorsum
@c THIS ITEM NEEDS MORE WORK

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@c @deffn {Function} gfactorsum (@var{expr})
m4_deffn({Function}, gfactorsum, <<<(@var{expr})>>>)

is similar to @code{factorsum} but applies @code{gfactor} instead
of @code{factor}.

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@c @deffn {Function} hipow (@var{expr}, @var{x})
m4_deffn({Function}, hipow, <<<(@var{expr}, @var{x})>>>)

Returns the highest explicit exponent of @var{x} in @var{expr}.
@var{x} may be a variable or a general expression.
If @var{x} does not appear in @var{expr},
@code{hipow} returns @code{0}.

@code{hipow} does not consider expressions equivalent to @code{expr}.  In
particular, @code{hipow} does not expand @code{expr}, so 
@code{hipow (@var{expr}, @var{x})} and
@code{hipow (expand (@var{expr}, @var{x}))} may yield different results.

Examples:

@c ===beg===
@c hipow (y^3 * x^2 + x * y^4, x);
@c hipow ((x + y)^5, x);
@c hipow (expand ((x + y)^5), x);
@c hipow ((x + y)^5, x + y);
@c hipow (expand ((x + y)^5), x + y);
@c ===end===
@example
(%i1) hipow (y^3 * x^2 + x * y^4, x);
(%o1)                           2
(%i2) hipow ((x + y)^5, x);
(%o2)                           1
(%i3) hipow (expand ((x + y)^5), x);
(%o3)                           5
(%i4) hipow ((x + y)^5, x + y);
(%o4)                           5
(%i5) hipow (expand ((x + y)^5), x + y);
(%o5)                           0
@end example

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c I SUSPECT THE FOLLOWING TEXT IS OUTDATED DUE TO CHANGES IN INTEGER FACTORING CODE

@c -----------------------------------------------------------------------------
m4_setcat(Integers)
@anchor{intfaclim}
@c @defvr {Option variable} intfaclim
m4_defvr({Option variable}, intfaclim)
Default value: true

If @code{true}, maxima will give up factorization of
integers if no factor is found after trial divisions and Pollard's rho
method and factorization will not be complete.

When @code{intfaclim} is @code{false} (this is the case when the user
calls @code{factor} explicitly), complete factorization will be
attempted.  @code{intfaclim} is set to @code{false} when factors are
computed in @code{divisors}, @code{divsum} and @code{totient}.
@c ANY OTHERS ??

@c WHAT ARE THESE MYSTERIOUS INTERNAL CALLS ?? (LET'S JUST LIST THE FUNCTIONS INVOLVED)
Internal calls to @code{factor} respect the user-specified value of
@code{intfaclim}.  Setting @code{intfaclim} to @code{true} may reduce
the time spent factoring large integers.
@c NEED EXAMPLES HERE

@c @opencatbox
@c @category{Integers}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Numerical evaluation)
@c @defvr {Option variable} keepfloat
m4_defvr({Option variable}, keepfloat)
Default value: @code{false}

When @code{keepfloat} is @code{true}, prevents floating
point numbers from being rationalized when expressions which contain
them are converted to canonical rational expression (CRE) form.

Note that the function @code{solve} and those functions calling it 
(@code{eigenvalues}, for example) currently ignore this flag, converting 
floating point numbers anyway.

Examples:

@c ===beg===
@c rat(x/2.0);
@c rat(x/2.0), keepfloat;
@c ===end===
@example
@group
(%i1) rat(x/2.0);

rat: replaced 0.5 by 1/2 = 0.5
                                x
(%o1)/R/                        -
                                2
@end group
@group
(%i2) rat(x/2.0), keepfloat;
(%o2)/R/                      0.5 x
@end group
@end example

@code{solve} ignores @code{keepfloat}:

@c ===beg===
@c solve(1.0-x,x), keepfloat;
@c ===end===
@example
@group
(%i1) solve(1.0-x,x), keepfloat;

rat: replaced 1.0 by 1/1 = 1.0
(%o1)                        [x = 1]
@end group
@end example

@c @opencatbox
@c @category{Numerical evaluation}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@anchor{lowpow}
@c @deffn {Function} lopow (@var{expr}, @var{x})
m4_deffn({Function}, lopow, <<<(@var{expr}, @var{x})>>>)

Returns the lowest exponent of @var{x} which explicitly appears in
@var{expr}.  Thus

@c ===beg===
@c lopow ((x+y)^2 + (x+y)^a, x+y);
@c ===end===
@example
(%i1) lopow ((x+y)^2 + (x+y)^a, x+y);
(%o1)                       min(a, 2)
@end example

@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c DESCRIBE lratsubst INDEPENDENTLY OF subst
@c THIS ITEM NEEDS MORE WORK

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials, Rational expressions)
@c @deffn {Function} lratsubst (@var{L}, @var{expr})
m4_deffn({Function}, lratsubst, <<<(@var{L}, @var{expr})>>>)

is analogous to @code{subst (@var{L}, @var{expr})}
except that it uses @code{ratsubst} instead of @code{subst}.

The first argument of
@code{lratsubst} is an equation or a list of equations identical in
format to that accepted by @code{subst}.  The
substitutions are made in the order given by the list of equations,
that is, from left to right.

@code{load ("lrats")} loads @code{fullratsubst} and @code{lratsubst}.

Examples:

@c EXPRESSIONS ADAPTED FROM demo ("lrats")
@c THIS STUFF CAN PROBABLY STAND REVISION -- EXAMPLES DON'T SEEM VERY ENLIGHTENING
@c load ("lrats")$
@c subst ([a = b, c = d], a + c);
@c lratsubst ([a^2 = b, c^2 = d], (a + e)*c*(a + c));
@c lratsubst (a^2 = b, a^3);
@example
(%i1) load ("lrats")$
@end example
@itemize @bullet
@item
@code{subst} can carry out multiple substitutions.
@code{lratsubst} is analogous to @code{subst}.
@end itemize
@example
(%i2) subst ([a = b, c = d], a + c);
(%o2)                         d + b
(%i3) lratsubst ([a^2 = b, c^2 = d], (a + e)*c*(a + c));
(%o3)                (d + a c) e + a d + b c
@end example
@itemize @bullet
@item
If only one substitution is desired, then a single
equation may be given as first argument.
@end itemize
@example
(%i4) lratsubst (a^2 = b, a^3);
(%o4)                          a b
@end example

@c @opencatbox
@c @category{Polynomials}
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Integers)
@anchor{modulus}
@c @defvr {Option variable} modulus
m4_defvr({Option variable}, modulus)
Default value: @code{false}

When @code{modulus} is a positive number @var{p}, operations on canonical rational
expressions (CREs, as returned by @code{rat} and related functions) are carried out
modulo @var{p}, using the so-called "balanced" modulus system in which @code{@var{n}
modulo @var{p}} is defined as an integer @var{k} in
@code{[-(@var{p}-1)/2, ..., 0, ..., (@var{p}-1)/2]} when @var{p} is odd, or
@code{[-(@var{p}/2 - 1), ..., 0, ...., @var{p}/2]} when @var{p} is even, such
that @code{@var{a} @var{p} + @var{k}} equals @var{n} for some integer @var{a}.
@c NEED EXAMPLES OF "BALANCED MODULUS" HERE

@c WHAT CAN THIS MEAN ?? IS THE MODULUS STORED WITH THE EXPRESSION ??
@c "... in order to get correct results" -- WHAT DO YOU GET IF YOU DON'T RE-RAT ??
If @var{expr} is already in canonical rational expression (CRE) form when
@code{modulus} is reset, then you may need to re-rat @var{expr}, e.g.,
@code{expr: rat (ratdisrep (expr))}, in order to get correct results.

Typically @code{modulus} is set to a prime number.  If @code{modulus} is set to
a positive non-prime integer, this setting is accepted, but a warning message is
displayed.  Maxima signals an error, when zero or a negative integer is
assigned to @code{modulus}.

Examples:

@c ===beg===
@c modulus:7;
@c polymod([0,1,2,3,4,5,6,7]);
@c modulus:false;
@c poly:x^6+x^2+1;
@c factor(poly);
@c modulus:13;
@c factor(poly);
@c polymod(%);
@c ===end===
@example
(%i1) modulus:7;
(%o1)                           7
(%i2) polymod([0,1,2,3,4,5,6,7]);
(%o2)            [0, 1, 2, 3, - 3, - 2, - 1, 0]
(%i3) modulus:false;
(%o3)                         false
(%i4) poly:x^6+x^2+1;
                            6    2
(%o4)                      x  + x  + 1
(%i5) factor(poly);
                            6    2
(%o5)                      x  + x  + 1
(%i6) modulus:13;
(%o6)                          13
(%i7) factor(poly);
                      2        4      2
(%o7)               (x  + 6) (x  - 6 x  - 2)
(%i8) polymod(%);
                            6    2
(%o8)                      x  + x  + 1
@end example
@c @opencatbox
@c @category{Integers}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c APPARENTLY OBSOLETE: ONLY EFFECT OF $newfac COULD BE TO CAUSE NONEXISTENT FUNCTION NMULTFACT
@c TO BE CALLED (IN FUNCTION FACTOR72 IN src/factor.lisp CIRCA LINE 1400)
@c $newfac NOT USED IN ANY OTHER CONTEXT (ASIDE FROM DECLARATIONS)
@c COMMENT IT OUT NOW, CUT IT ON THE NEXT PASS THROUGH THIS FILE
@c @defvar newfac
@c Default value: @code{false}
@c 
@c When @code{newfac} is @code{true}, @code{factor} will use the new factoring
@c routines.
@c 
@c @end defvar

@c -----------------------------------------------------------------------------
m4_setcat(Expressions)
@anchor{num}
@c @deffn {Function} num (@var{expr})
m4_deffn({Function}, num, <<<(@var{expr})>>>)

Returns the numerator of @var{expr} if it is a ratio.
If @var{expr} is not a ratio, @var{expr} is returned.

@code{num} evaluates its argument.

See also @mref{denom}

@c ===beg===
@c g1:(x+2)*(x+1)/((x+3)^2);
@c num(g1);
@c g2:sin(x)/10*cos(x)/y;
@c num(g2);
@c ===end===
@example
@group
(%i1) g1:(x+2)*(x+1)/((x+3)^2);
                         (x + 1) (x + 2)
(%o1)                    ---------------
                                   2
                            (x + 3)
@end group
@group
(%i2) num(g1);
(%o2)                    (x + 1) (x + 2)
@end group
@group
(%i3) g2:sin(x)/10*cos(x)/y;
                          cos(x) sin(x)
(%o3)                     -------------
                              10 y
@end group
@group
(%i4) num(g2);
(%o4)                     cos(x) sin(x)
@end group
@end example

@c NEED SOME EXAMPLES HERE
@c @opencatbox
@c @category{Expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials)
@anchor{polydecomp}
@c @deffn {Function} polydecomp (@var{p}, @var{x})
m4_deffn({Function}, polydecomp, <<<(@var{p}, @var{x})>>>)

Decomposes the polynomial @var{p} in the variable @var{x}
into the functional composition of polynomials in @var{x}.
@code{polydecomp} returns a list @code{[@var{p_1}, ..., @var{p_n}]} such that

@example
lambda ([x], p_1) (lambda ([x], p_2) (... (lambda ([x], p_n) (x))
  ...))
@end example

is equal to @var{p}.
The degree of @var{p_i} is greater than 1 for @var{i} less than @var{n}.

Such a decomposition is not unique.

Examples:

@c ===beg===
@c polydecomp (x^210, x);
@c p : expand (subst (x^3 - x - 1, x, x^2 - a));
@c polydecomp (p, x);
@c ===end===
@example
@group
(%i1) polydecomp (x^210, x);
                          7   5   3   2
(%o1)                   [x , x , x , x ]
@end group
@group
(%i2) p : expand (subst (x^3 - x - 1, x, x^2 - a));
                6      4      3    2
(%o2)          x  - 2 x  - 2 x  + x  + 2 x - a + 1
@end group
@group
(%i3) polydecomp (p, x);
                        2       3
(%o3)                 [x  - a, x  - x - 1]
@end group
@end example

The following function composes @code{L = [e_1, ..., e_n]} as functions in
@code{x}; it is the inverse of polydecomp:

@c ===beg===
@c compose (L, x) :=
@c   block ([r : x], for e in L do r : subst (e, x, r), r) $
@c ===end===
@example
@group
(%i1) compose (L, x) :=
  block ([r : x], for e in L do r : subst (e, x, r), r) $
@end group
@end example

Re-express above example using @code{compose}:

@c ===beg===
@c polydecomp (compose ([x^2 - a, x^3 - x - 1], x), x);
@c ===end===
@example
@group
(%i1) polydecomp (compose ([x^2 - a, x^3 - x - 1], x), x);
                          2       3
(%o1)          [compose([x  - a, x  - x - 1], x)]
@end group
@end example

Note that though @code{compose (polydecomp (@var{p}, @var{x}), @var{x})} always
returns @var{p} (unexpanded), @code{polydecomp (compose ([@var{p_1}, ...,
@var{p_n}], @var{x}), @var{x})} does @i{not} necessarily return
@code{[@var{p_1}, ..., @var{p_n}]}:

@c ===beg===
@c polydecomp (compose ([x^2 + 2*x + 3, x^2], x), x);
@c polydecomp (compose ([x^2 + x + 1, x^2 + x + 1], x), x);
@c ===end===
@example
@group
(%i1) polydecomp (compose ([x^2 + 2*x + 3, x^2], x), x);
                           2             2
(%o1)           [compose([x  + 2 x + 3, x ], x)]
@end group
@group
(%i2) polydecomp (compose ([x^2 + x + 1, x^2 + x + 1], x), x);
                        2           2
(%o2)        [compose([x  + x + 1, x  + x + 1], x)]
@end group
@end example

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{polymod}
@c @deffn  {Function} polymod @
m4_deffn({Function}, polymod, <<<>>>) @
@fname{polymod} (@var{p}) @
@fname{polymod} (@var{p}, @var{m})

Converts the polynomial @var{p} to a modular representation with respect to the
current modulus which is the value of the variable @code{modulus}.

@code{polymod (@var{p}, @var{m})} specifies a modulus @var{m} to be used 
instead of the current value of @code{modulus}.

See @mrefdot{modulus}

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c ISN'T THERE AN EQUIVALENT FUNCTION SOMEWHERE ??
@c NEEDS WORK (IF KEPT)

@c -----------------------------------------------------------------------------
@anchor{quotient}
@c @deffn  {Function} quotient @
m4_deffn({Function}, quotient, <<<>>>) @
@fname{quotient} (@var{p_1}, @var{p_2}) @
@fname{quotient} (@var{p_1}, @var{p_2}, @var{x_1}, @dots{}, @var{x_n})

Returns the polynomial @var{p_1} divided by the polynomial @var{p_2}.  The
arguments @var{x_1}, @dots{}, @var{x_n} are interpreted as in @code{ratvars}.

@code{quotient} returns the first element of the two-element list returned by
@mref{divide}.

@c NEED SOME EXAMPLES HERE
@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c THIS ITEM CAN PROBABLY BE IMPROVED

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions)
@anchor{rat}
@c @deffn  {Function} rat @
m4_deffn({Function}, rat, <<<>>>) @
@fname{rat} (@var{expr}) @
@fname{rat} (@var{expr}, @var{x_1}, @dots{}, @var{x_n})

Converts @var{expr} to canonical rational expression (CRE) form by expanding and
combining all terms over a common denominator and cancelling out the
greatest common divisor of the numerator and denominator, as well as
converting floating point numbers to rational numbers within a
tolerance of @code{ratepsilon}.
The variables are ordered according
to the @var{x_1}, @dots{}, @var{x_n}, if specified, as in @code{ratvars}.

@code{rat} does not generally simplify functions other than addition @code{+},
subtraction @code{-}, multiplication @code{*}, division @code{/}, and
exponentiation to an integer power,
whereas @code{ratsimp} does handle those cases.
Note that atoms (numbers and variables) in CRE form are not the
same as they are in the general form.
For example, @code{rat(x)- x} yields 
@code{rat(0)} which has a different internal representation than 0.

@c WHAT'S THIS ABOUT EXACTLY ??
When @code{ratfac} is @code{true}, @code{rat} yields a partially factored
form for CRE.  During rational operations the expression is
maintained as fully factored as possible without an actual call to the
factor package.  This should always save space and may save some time
in some computations.  The numerator and denominator are still made
relatively prime
(e.g.,  @code{rat((x^2 - 1)^4/(x + 1)^2)} yields @code{(x - 1)^4 (x + 1)^2}
when @code{ratfac} is @code{true}),
but the factors within each part may not be relatively prime.

@code{ratprint} if @code{false} suppresses the printout of the message
informing the user of the conversion of floating point numbers to
rational numbers.

@code{keepfloat} if @code{true} prevents floating point numbers from being
converted to rational numbers.

See also @code{ratexpand} and  @code{ratsimp}.

Examples:
@c ===beg===
@c ((x - 2*y)^4/(x^2 - 4*y^2)^2 + 1)*(y + a)*(2*y + x) /
@c       (4*y^2 + x^2);
@c rat (%, y, a, x);
@c ===end===
@example
@group
(%i1) ((x - 2*y)^4/(x^2 - 4*y^2)^2 + 1)*(y + a)*(2*y + x) /
      (4*y^2 + x^2);
                                           4
                                  (x - 2 y)
              (y + a) (2 y + x) (------------ + 1)
                                   2      2 2
                                 (x  - 4 y )
(%o1)         ------------------------------------
                              2    2
                           4 y  + x
@end group
@group
(%i2) rat (%, y, a, x);
                            2 a + 2 y
(%o2)/R/                    ---------
                             x + 2 y
@end group
@end example

@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

m4_setcat(Simplification flags and variables)
@c @defvr {Option variable} ratalgdenom
m4_defvr({Option variable}, ratalgdenom)
Default value: @code{true}

When @code{ratalgdenom} is @code{true}, allows rationalization of denominators
with respect to radicals to take effect.  @code{ratalgdenom} has an effect only
when canonical rational expressions (CRE) are used in algebraic mode.

@c @opencatbox
@c @category{Simplification flags and variables}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c THIS ITEM NEEDS MORE WORK

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials, Rational expressions)
@anchor{ratcoef}
@c @deffn  {Function} ratcoef @
m4_deffn({Function}, ratcoef, <<<>>>) @
@fname{ratcoef} (@var{expr}, @var{x}, @var{n}) @
@fname{ratcoef} (@var{expr}, @var{x})

Returns the coefficient of the expression @code{@var{x}^@var{n}}
in the expression @var{expr}.
If omitted, @var{n} is assumed to be 1.

The return value is free
(except possibly in a non-rational sense) of the variables in @var{x}.
If no coefficient of this type exists, 0 is returned.

@code{ratcoef}
expands and rationally simplifies its first argument and thus it may
produce answers different from those of @code{coeff} which is purely
syntactic.
@c MOVE THIS TO EXAMPLES SECTION
Thus @code{ratcoef ((x + 1)/y + x, x)} returns @code{(y + 1)/y} whereas
@code{coeff} returns 1.

@code{ratcoef (@var{expr}, @var{x}, 0)}, viewing @var{expr} as a sum,
returns a sum of those terms which do not contain @var{x}.
@c "SHOULD NOT" -- WHAT DOES THIS MEAN ??
Therefore if @var{x} occurs to any negative powers, @code{ratcoef} should not
be used.

@c WHAT IS THE INTENT HERE ??
Since @var{expr} is rationally
simplified before it is examined, coefficients may not appear quite
the way they were envisioned.

Example:

@c ===beg===
@c s: a*x + b*x + 5$
@c ratcoef (s, a + b);
@c ===end===
@example
(%i1) s: a*x + b*x + 5$
(%i2) ratcoef (s, a + b);
(%o2)                           x
@end example
@c NEED MORE EXAMPLES HERE

@c @opencatbox
@c @category{Polynomials}
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions)
@anchor{ratdenom}
@c @deffn {Function} ratdenom (@var{expr})
m4_deffn({Function}, ratdenom, <<<(@var{expr})>>>)

Returns the denominator of @var{expr},
after coercing @var{expr} to a canonical rational expression (CRE).
The return value is a CRE.

@c ACTUALLY THE CONVERSION IS CARRIED OUT BY ratf BUT THAT'S WHAT $rat CALLS
@var{expr} is coerced to a CRE by @code{rat}
if it is not already a CRE.
This conversion may change the form of @var{expr} by putting all terms
over a common denominator.

@code{denom} is similar, but returns an ordinary expression instead of a CRE.
Also, @code{denom} does not attempt to place all terms over a common
denominator, and thus some expressions which are considered ratios by
@code{ratdenom} are not considered ratios by @code{denom}.

@c NEEDS AN EXAMPLE HERE
@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Simplification flags and variables, Rational expressions)
@c @defvr {Option variable} ratdenomdivide
m4_defvr({Option variable}, ratdenomdivide)
Default value: @code{true}

When @code{ratdenomdivide} is @code{true},
@code{ratexpand} expands a ratio in which the numerator is a sum 
into a sum of ratios,
all having a common denominator.
Otherwise, @code{ratexpand} collapses a sum of ratios into a single ratio,
the numerator of which is the sum of the numerators of each ratio.

Examples:

@c ===beg===
@c expr: (x^2 + x + 1)/(y^2 + 7);
@c ratdenomdivide: true$
@c ratexpand (expr);
@c ratdenomdivide: false$
@c ratexpand (expr);
@c expr2: a^2/(b^2 + 3) + b/(b^2 + 3);
@c ratexpand (expr2);
@c ===end===
@example
(%i1) expr: (x^2 + x + 1)/(y^2 + 7);
                            2
                           x  + x + 1
(%o1)                      ----------
                              2
                             y  + 7
(%i2) ratdenomdivide: true$
(%i3) ratexpand (expr);
                       2
                      x        x        1
(%o3)               ------ + ------ + ------
                     2        2        2
                    y  + 7   y  + 7   y  + 7
(%i4) ratdenomdivide: false$
(%i5) ratexpand (expr);
@group
                            2
                           x  + x + 1
(%o5)                      ----------
                              2
                             y  + 7
@end group
(%i6) expr2: a^2/(b^2 + 3) + b/(b^2 + 3);
                                     2
                           b        a
(%o6)                    ------ + ------
                          2        2
                         b  + 3   b  + 3
(%i7) ratexpand (expr2);
                                  2
                             b + a
(%o7)                        ------
                              2
                             b  + 3
@end example

@c @opencatbox
@c @category{Simplification flags and variables}
@c @category{Rational expressions}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions)
@c @deffn {Function} ratdiff (@var{expr}, @var{x})
m4_deffn({Function}, ratdiff, <<<(@var{expr}, @var{x})>>>)

Differentiates the rational expression @var{expr} with respect to @var{x}.
@var{expr} must be a ratio of polynomials or a polynomial in @var{x}.
The argument @var{x} may be a variable or a subexpression of @var{expr}.
@c NOT CLEAR (FROM READING CODE) HOW x OTHER THAN A VARIABLE IS HANDLED --
@c LOOKS LIKE (a+b), 10*(a+b), (a+b)^2 ARE ALL TREATED LIKE (a+b);
@c HOW TO DESCRIBE THAT ??

The result is equivalent to @code{diff}, although perhaps in a different form.
@code{ratdiff} may be faster than @code{diff}, for rational expressions.

@code{ratdiff} returns a canonical rational expression (CRE) if @code{expr} is
a CRE.  Otherwise, @code{ratdiff} returns a general expression.

@code{ratdiff} considers only the dependence of @var{expr} on @var{x},
and ignores any dependencies established by @code{depends}.

@c WHAT THIS IS ABOUT -- ratdiff (rat (factor (expr)), x) AND ratdiff (factor (rat (expr)), x) BOTH SUCCEED
@c COMMENTING THIS OUT UNTIL SOMEONE CAN ESTABLISH SOME CRE'S FOR WHICH ratdiff FAILS
@c However, @code{ratdiff} should not be used on factored CRE forms;
@c use @code{diff} instead for such expressions.

Example:

@c ===beg===
@c expr: (4*x^3 + 10*x - 11)/(x^5 + 5);
@c ratdiff (expr, x);
@c expr: f(x)^3 - f(x)^2 + 7;
@c ratdiff (expr, f(x));
@c expr: (a + b)^3 + (a + b)^2;
@c ratdiff (expr, a + b);
@c ===end===
@example
(%i1) expr: (4*x^3 + 10*x - 11)/(x^5 + 5);
@group
                           3
                        4 x  + 10 x - 11
(%o1)                   ----------------
                              5
                             x  + 5
@end group
(%i2) ratdiff (expr, x);
                    7       5       4       2
                 8 x  + 40 x  - 55 x  - 60 x  - 50
(%o2)          - ---------------------------------
                          10       5
                         x   + 10 x  + 25
(%i3) expr: f(x)^3 - f(x)^2 + 7;
                         3       2
(%o3)                   f (x) - f (x) + 7
(%i4) ratdiff (expr, f(x));
                           2
(%o4)                   3 f (x) - 2 f(x)
(%i5) expr: (a + b)^3 + (a + b)^2;
                              3          2
(%o5)                  (b + a)  + (b + a)
(%i6) ratdiff (expr, a + b);
                    2                    2
(%o6)            3 b  + (6 a + 2) b + 3 a  + 2 a
@end example

@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{ratdisrep}
@c @deffn {Function} ratdisrep (@var{expr})
m4_deffn({Function}, ratdisrep, <<<(@var{expr})>>>)

Returns its argument as a general expression.
If @var{expr} is a general expression, it is returned unchanged.

Typically @code{ratdisrep} is called to convert a canonical rational expression
(CRE) into a general expression.
@c NOT REALLY FOND OF YOU-CAN-DO-THIS-YOU-CAN-DO-THAT STATEMENTS
This is sometimes convenient if one wishes to stop the "contagion", or
use rational functions in non-rational contexts.

See also @mrefdot{totaldisrep}

@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions)
@anchor{ratexpand}
@c @deffn  {Function} ratexpand (@var{expr})
m4_deffn( {Function}, ratexpand, <<<(@var{expr})>>>)

Expands @var{expr} by multiplying out products of sums and
exponentiated sums, combining fractions over a common denominator,
cancelling the greatest common divisor of the numerator and
denominator, then splitting the numerator (if a sum) into its
respective terms divided by the denominator.

The return value of @code{ratexpand} is a general expression,
even if @var{expr} is a canonical rational expression (CRE).

When @code{ratdenomdivide} is @code{true},
@code{ratexpand} expands a ratio in which the numerator is a sum 
into a sum of ratios,
all having a common denominator.
Otherwise, @code{ratexpand} collapses a sum of ratios into a single ratio,
the numerator of which is the sum of the numerators of each ratio.

When @code{keepfloat} is @code{true}, prevents floating
point numbers from being rationalized when expressions which contain
them are converted to canonical rational expression (CRE) form.

Examples:

@c ===beg===
@c ratexpand ((2*x - 3*y)^3);
@c expr: (x - 1)/(x + 1)^2 + 1/(x - 1);
@c expand (expr);
@c ratexpand (expr);
@c ===end===
@example
(%i1) ratexpand ((2*x - 3*y)^3);
                     3         2       2        3
(%o1)          - 27 y  + 54 x y  - 36 x  y + 8 x
(%i2) expr: (x - 1)/(x + 1)^2 + 1/(x - 1);
                         x - 1       1
(%o2)                   -------- + -----
                               2   x - 1
                        (x + 1)
(%i3) expand (expr);
@group
                    x              1           1
(%o3)          ------------ - ------------ + -----
                2              2             x - 1
               x  + 2 x + 1   x  + 2 x + 1
@end group
(%i4) ratexpand (expr);
                        2
                     2 x                 2
(%o4)           --------------- + ---------------
                 3    2            3    2
                x  + x  - x - 1   x  + x  - x - 1
@end example

@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c @deffnx {Option variable} ratexpand
m4_defvr({Option variable}, ratexpand)
Default value: @code{true}

@c WHAT DOES THE FOLLOWING MEAN EXACTLY ??
The switch @code{ratexpand} if @code{true} will cause CRE
expressions to be fully expanded when they are converted back to
general form or displayed, while if it is @code{false} then they will be put
into a recursive form.
See also @mrefdot{ratsimp}

m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions)
@anchor{ratfac}
@c @defvr {Option variable} ratfac
m4_defvr({Option variable}, ratfac)
Default value: @code{false}

When @code{ratfac} is @code{true}, canonical rational expressions (CRE) are
manipulated in a partially factored form.

During rational operations the expression is maintained as fully factored as
possible without calling @code{factor}.
This should always save space and may save time in some computations.
The numerator and denominator are made relatively prime, for example
@code{factor ((x^2 - 1)^4/(x + 1)^2)} yields @code{(x - 1)^4 (x + 1)^2},
but the factors within each part may not be relatively prime.

In the @code{ctensr} (Component Tensor Manipulation) package,
Ricci, Einstein, Riemann, and Weyl tensors and the scalar curvature 
are factored automatically when @code{ratfac} is @code{true}.
@i{@code{ratfac} should only be
set for cases where the tensorial components are known to consist of
few terms.}

The @code{ratfac} and @code{ratweight} schemes are incompatible and may not
both be used at the same time.

@c NEED EXAMPLES HERE
@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
@c @deffn {Function} ratnumer (@var{expr})
m4_deffn({Function}, ratnumer, <<<(@var{expr})>>>)

Returns the numerator of @var{expr},
after coercing @var{expr} to a canonical rational expression (CRE).
The return value is a CRE.

@c ACTUALLY THE CONVERSION IS CARRIED OUT BY ratf BUT THAT'S WHAT $rat CALLS
@var{expr} is coerced to a CRE by @code{rat}
if it is not already a CRE.
This conversion may change the form of @var{expr} by putting all terms
over a common denominator.

@code{num} is similar, but returns an ordinary expression instead of a CRE.
Also, @code{num} does not attempt to place all terms over a common denominator,
and thus some expressions which are considered ratios by @code{ratnumer}
are not considered ratios by @code{num}.

@c NEEDS AN EXAMPLE HERE
@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Predicate functions, Rational expressions)
@c @deffn {Function} ratp (@var{expr})
m4_deffn({Function}, ratp, <<<(@var{expr})>>>)

Returns @code{true} if @var{expr} is a canonical rational expression (CRE) or
extended CRE, otherwise @code{false}.

CRE are created by @code{rat} and related functions.
Extended CRE are created by @code{taylor} and related functions.

@c @opencatbox
@c @category{Predicate functions}
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions, Numerical evaluation, Console interaction)
@c @defvr {Option variable} ratprint
m4_defvr({Option variable}, ratprint)
Default value: @code{true}

When @code{ratprint} is @code{true},
a message informing the user of the conversion of floating point numbers
to rational numbers is displayed.

@c @opencatbox
@c @category{Rational expressions}
@c @category{Numerical evaluation}
@c @category{Console interaction}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Simplification functions, Rational expressions)
@anchor{ratsimp}
@c @deffn  {Function} ratsimp (@var{expr})
m4_deffn( {Function}, ratsimp, <<<(@var{expr})>>>)
@c @deffnx {Function} ratsimp (@var{expr}, @var{x_1}, @dots{}, @var{x_n})
m4_deffnx({Function}, ratsimp, <<<(@var{expr}, @var{x_1}, @dots{}, @var{x_n})>>>)

Simplifies the expression @var{expr} and all of its subexpressions, including
the arguments to non-rational functions.  The result is returned as the quotient
of two polynomials in a recursive form, that is, the coefficients of the main
variable are polynomials in the other variables.  Variables may include
non-rational functions (e.g., @code{sin (x^2 + 1)}) and the arguments to any
such functions are also rationally simplified.

@code{ratsimp (@var{expr}, @var{x_1}, ..., @var{x_n})}
enables rational simplification with the
specification of variable ordering as in @code{ratvars}.

When @code{ratsimpexpons} is @code{true},
@code{ratsimp} is applied to the exponents of expressions during simplification.

See also @mrefdot{ratexpand}
Note that @code{ratsimp} is affected by some of the
flags which affect @code{ratexpand}.

Examples:

@c ===beg===
@c sin (x/(x^2 + x)) = exp ((log(x) + 1)^2 - log(x)^2);
@c ratsimp (%);
@c ((x - 1)^(3/2) - (x + 1)*sqrt(x - 1))/sqrt((x - 1)*(x + 1));
@c ratsimp (%);
@c x^(a + 1/a), ratsimpexpons: true;
@c ===end===
@example
(%i1) sin (x/(x^2 + x)) = exp ((log(x) + 1)^2 - log(x)^2);
@group
                                         2      2
                   x         (log(x) + 1)  - log (x)
(%o1)        sin(------) = %e
                  2
                 x  + x
@end group
(%i2) ratsimp (%);
                             1          2
(%o2)                  sin(-----) = %e x
                           x + 1
(%i3) ((x - 1)^(3/2) - (x + 1)*sqrt(x - 1))/sqrt((x - 1)*(x + 1));
@group
                       3/2
                (x - 1)    - sqrt(x - 1) (x + 1)
(%o3)           --------------------------------
                     sqrt((x - 1) (x + 1))
@end group
(%i4) ratsimp (%);
                           2 sqrt(x - 1)
(%o4)                    - -------------
                                 2
                           sqrt(x  - 1)
(%i5) x^(a + 1/a), ratsimpexpons: true;
                               2
                              a  + 1
                              ------
                                a
(%o5)                        x
@end example

@c @opencatbox
@c @category{Simplification functions}
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Simplification flags and variables, Rational expressions)
@c @defvr {Option variable} ratsimpexpons
m4_defvr({Option variable}, ratsimpexpons)
Default value: @code{false}

When @code{ratsimpexpons} is @code{true},
@code{ratsimp} is applied to the exponents of expressions during simplification.

@c NEED AN EXAMPLE HERE -- RECYCLE THE ratsimpexpons EXAMPLE FROM ratsimp ABOVE
@c @opencatbox
@c @category{Simplification flags and variables}
@c @category{Rational expressions}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Simplification flags and variables)
@anchor{radsubstflag}
@c @defvr {Option variable} radsubstflag
m4_defvr({Option variable}, radsubstflag)
Default value: @code{false}

@code{radsubstflag}, if @code{true}, permits @code{ratsubst} to make
substitutions such as @code{u} for @code{sqrt (x)} in @code{x}.

@c @opencatbox
@c @category{Simplification flags and variables}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions)
@anchor{ratsubst}
@c @deffn {Function} ratsubst (@var{a}, @var{b}, @var{c})
m4_deffn({Function}, ratsubst, <<<(@var{a}, @var{b}, @var{c})>>>)

Substitutes @var{a} for @var{b} in @var{c} and returns the resulting expression.
@c "ETC" SUGGESTS THE READER KNOWS WHAT ELSE GOES THERE -- NOT LIKELY THE CASE
@var{b} may be a sum, product, power, etc.

@c WHAT, EXACTLY, DOES ratsubst KNOW ??
@code{ratsubst} knows something of the meaning of expressions
whereas @code{subst} does a purely syntactic substitution.
Thus @code{subst (a, x + y, x + y + z)} returns @code{x + y + z}
whereas @code{ratsubst} returns @code{z + a}.

When @code{radsubstflag} is @code{true},
@code{ratsubst} makes substitutions for radicals in expressions
which don't explicitly contain them.

@code{ratsubst} ignores the value @code{true} of the option variable 
@code{keepfloat}.

Examples:

@c EXAMPLES BELOW ADAPTED FROM examples (ratsubst)
@c WITH SOME ADDITIONAL STUFF

@c ===beg===
@c ratsubst (a, x*y^2, x^4*y^3 + x^4*y^8);
@c cos(x)^4 + cos(x)^3 + cos(x)^2 + cos(x) + 1;
@c ratsubst (1 - sin(x)^2, cos(x)^2, %);
@c ratsubst (1 - cos(x)^2, sin(x)^2, sin(x)^4);
@c radsubstflag: false$
@c ratsubst (u, sqrt(x), x);
@c radsubstflag: true$
@c ratsubst (u, sqrt(x), x);
@c ===end===
@example
@group
(%i1) ratsubst (a, x*y^2, x^4*y^3 + x^4*y^8);
                              3      4
(%o1)                      a x  y + a
@end group
@group
(%i2) cos(x)^4 + cos(x)^3 + cos(x)^2 + cos(x) + 1;
               4         3         2
(%o2)       cos (x) + cos (x) + cos (x) + cos(x) + 1
@end group
@group
(%i3) ratsubst (1 - sin(x)^2, cos(x)^2, %);
            4           2                     2
(%o3)    sin (x) - 3 sin (x) + cos(x) (2 - sin (x)) + 3
@end group
@group
(%i4) ratsubst (1 - cos(x)^2, sin(x)^2, sin(x)^4);
                        4           2
(%o4)                cos (x) - 2 cos (x) + 1
@end group
(%i5) radsubstflag: false$
@group
(%i6) ratsubst (u, sqrt(x), x);
(%o6)                           x
@end group
(%i7) radsubstflag: true$
@group
(%i8) ratsubst (u, sqrt(x), x);
                                2
(%o8)                          u
@end group
@end example

@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{ratvars}
@c @deffn  {Function} ratvars (@var{x_1}, @dots{}, @var{x_n})
m4_deffn( {Function}, ratvars, <<<(@var{x_1}, @dots{}, @var{x_n})>>>)
@c @deffnx {Function} ratvars ()
m4_deffnx({Function}, ratvars, <<<()>>>)
@deffnx {System variable} ratvars

Declares main variables @var{x_1}, @dots{}, @var{x_n} for rational expressions.
@var{x_n}, if present in a rational expression, is considered the main variable.
Otherwise, @var{x_[n-1]} is considered the main variable if present, and so on
through the preceding variables to @var{x_1}, which is considered the main
variable only if none of the succeeding variables are present.

If a variable in a rational expression is not present in the @code{ratvars}
list, it is given a lower priority than @var{x_1}.

The arguments to @code{ratvars} can be either variables or non-rational
functions such as @code{sin(x)}.

The variable @code{ratvars} is a list of the arguments of 
the function @code{ratvars} when it was called most recently.
Each call to the function @code{ratvars} resets the list.
@code{ratvars ()} clears the list.

@c NEED EXAMPLES HERE
@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions, Global flags)
@c @defvr {Option variable} ratvarswitch
m4_defvr({Option variable}, ratvarswitch)
Default value: @code{true}

Maxima keeps an internal list in the Lisp variable @code{VARLIST} of the main
variables for rational expressions.  If @code{ratvarswitch} is @code{true}, 
every evaluation starts with a fresh list @code{VARLIST}.  This is the default
behavior.  Otherwise, the main variables from previous evaluations are not 
removed from the internal list @code{VARLIST}.

The main variables, which are declared with the function @code{ratvars} are
not affected by the option variable @code{ratvarswitch}.

Examples:

If @code{ratvarswitch} is @code{true}, every evaluation starts with a fresh
list @code{VARLIST}.

@c ===beg===
@c ratvarswitch:true$
@c rat(2*x+y^2);
@c :lisp varlist
@c rat(2*a+b^2);
@c :lisp varlist
@c ===end===
@example
(%i1) ratvarswitch:true$

(%i2) rat(2*x+y^2);
                             2
(%o2)/R/                    y  + 2 x
(%i3) :lisp varlist
($X $Y)

(%i3) rat(2*a+b^2);
                             2
(%o3)/R/                    b  + 2 a

(%i4) :lisp varlist
($A $B)
@end example

If @code{ratvarswitch} is @code{false}, the main variables from the last 
evaluation are still present.

@c ===beg===
@c ratvarswitch:false$
@c rat(2*x+y^2);
@c :lisp varlist
@c rat(2*a+b^2);
@c :lisp varlist
@c ===end===
@example
(%i4) ratvarswitch:false$

(%i5) rat(2*x+y^2);
                             2
(%o5)/R/                    y  + 2 x
(%i6) :lisp varlist
($X $Y)

(%i6) rat(2*a+b^2);
                             2
(%o6)/R/                    b  + 2 a

(%i7) :lisp varlist
($A $B $X $Y)
@end example

@c @opencatbox
@c @category{Rational expressions}
@c @category{Global flags}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions)
@c @deffn  {Function} ratweight @
m4_deffn( {Function}, ratweight, <<<>>>) @
@fname{ratweight} (@var{x_1}, @var{w_1}, @dots{}, @var{x_n}, @var{w_n}) @
@fname{ratweight} ()

Assigns a weight @var{w_i} to the variable @var{x_i}.
This causes a term to be replaced by 0 if its weight exceeds the
value of the variable @code{ratwtlvl} (default yields no truncation).
The weight of a term is the sum of the products of the
weight of a variable in the term times its power.
For example, the weight of @code{3 x_1^2 x_2} is @code{2 w_1 + w_2}.
Truncation according to @code{ratwtlvl} is carried out only when multiplying
or exponentiating canonical rational expressions (CRE).

@code{ratweight ()} returns the cumulative list of weight assignments.

Note: The @code{ratfac} and @code{ratweight} schemes are incompatible and may
not both be used at the same time.

Examples:

@c ===beg===
@c ratweight (a, 1, b, 1);
@c expr1: rat(a + b + 1)$
@c expr1^2;
@c ratwtlvl: 1$
@c expr1^2;
@c ===end===
@example
(%i1) ratweight (a, 1, b, 1);
(%o1)                     [a, 1, b, 1]
(%i2) expr1: rat(a + b + 1)$
(%i3) expr1^2;
                  2                  2
(%o3)/R/         b  + (2 a + 2) b + a  + 2 a + 1
(%i4) ratwtlvl: 1$
(%i5) expr1^2;
(%o5)/R/                  2 b + 2 a + 1
@end example

@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions)
@c @defvr {System variable} ratweights
m4_defvr({System variable}, ratweights)
Default value: @code{[]}

@code{ratweights} is the list of weights assigned by @code{ratweight}.
The list is cumulative:
each call to @code{ratweight} places additional items in the list.

@c DO WE REALLY NEED TO MENTION THIS ??
@code{kill (ratweights)} and @code{save (ratweights)} both work as expected.

@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
@need 1000
@c @defvr {Option variable} ratwtlvl
m4_defvr({Option variable}, ratwtlvl)
Default value: @code{false}

@code{ratwtlvl} is used in combination with the @code{ratweight}
function to control the truncation of canonical rational expressions (CRE).
For the default value of @code{false}, no truncation occurs.

@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials)
@c @deffn  {Function} remainder @
m4_deffn( {Function}, remainder, <<<@>>>)
@fname{remainder} (@var{p_1}, @var{p_2}) @
@fname{remainder} (@var{p_1}, @var{p_2}, @var{x_1}, @dots{}, @var{x_n})

Returns the remainder of the polynomial @var{p_1} divided by the polynomial
@var{p_2}.  The arguments @var{x_1}, @dots{}, @var{x_n} are interpreted as in
@code{ratvars}.

@code{remainder} returns the second element
of the two-element list returned by @code{divide}.

@c NEED SOME EXAMPLES HERE
@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials)
@anchor{resultant}
@c @deffn {Function} resultant (@var{p_1}, @var{p_2}, @var{x})
m4_deffn({Function}, resultant, <<<(@var{p_1}, @var{p_2}, @var{x})>>>)

The function @code{resultant} computes the resultant of the two polynomials
@var{p_1} and @var{p_2}, eliminating the variable @var{x}.  The resultant is a
determinant of the coefficients of @var{x} in @var{p_1} and @var{p_2}, which
equals zero if and only if @var{p_1} and @var{p_2} have a non-constant factor
in common.

If @var{p_1} or @var{p_2} can be factored, it may be desirable to call
@mref{factor} before calling @code{resultant}.

The option variable @code{resultant} controls which algorithm will be used to
compute the resultant.  See the option variable
@mxrefdot{option_resultant, resultant}

The function @mref{bezout} takes the same arguments as @code{resultant} and
returns a matrix.  The determinant of the return value is the desired resultant.

Examples:

@c ===beg===
@c resultant(2*x^2+3*x+1, 2*x^2+x+1, x);
@c resultant(x+1, x+1, x);
@c resultant((x+1)*x, (x+1), x);
@c resultant(a*x^2+b*x+1, c*x + 2, x);
@c bezout(a*x^2+b*x+1, c*x+2, x);
@c determinant(%);
@c ===end===
@example
(%i1) resultant(2*x^2+3*x+1, 2*x^2+x+1, x);
(%o1)                           8
(%i2) resultant(x+1, x+1, x);
(%o2)                           0
(%i3) resultant((x+1)*x, (x+1), x);
(%o3)                           0
(%i4) resultant(a*x^2+b*x+1, c*x + 2, x);
                         2
(%o4)                   c  - 2 b c + 4 a

(%i5) bezout(a*x^2+b*x+1, c*x+2, x);
@group
                        [ 2 a  2 b - c ]
(%o5)                   [              ]
                        [  c      2    ]
@end group
(%i6) determinant(%);
(%o6)                   4 a - (2 b - c) c
@end example
@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials)
@anchor{option_resultant}
@c @defvr {Option variable} resultant
m4_defvr({Option variable}, resultant)
Default value: @code{subres}

The option variable @code{resultant} controls which algorithm will be used to
compute the resultant with the function @mrefdot{resultant}  The possible
values are:

@table @code
@item subres
for the subresultant polynomial remainder sequence (PRS) algorithm,
@item mod
(not enabled) for the modular resultant algorithm, and 
@item red
for the reduced polynomial remainder sequence (PRS) algorithm.
@end table

On most problems the default value @code{subres} should be best.
@c On some large degree univariate or bivariate problems @code{mod}
@c may be better.

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@anchor{savefactors}
@c -----------------------------------------------------------------------------
@c @defvr {Option variable} savefactors
m4_defvr({Option variable}, savefactors)
Default value: @code{false}

@c "certain functions" -- WHICH ONES ??
When @code{savefactors} is @code{true}, causes the factors of an
expression which is a product of factors to be saved by certain
functions in order to speed up later factorizations of expressions
containing some of the same factors.

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions, Display functions)
@anchor{showratvars}
@c @deffn {Function} showratvars (@var{expr})
m4_deffn({Function}, showratvars, <<<(@var{expr})>>>)

Returns a list of the canonical rational expression (CRE) variables in
expression @code{expr}.

See also @mrefdot{ratvars}

@c @opencatbox
@c @category{Rational expressions}
@c @category{Display functions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c I CAN'T TELL WHAT THIS IS SUPPOSED TO BE ABOUT

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials)
@anchor{sqfr}
@c @deffn {Function} sqfr (@var{expr})
m4_deffn({Function}, sqfr, <<<(@var{expr})>>>)

is similar to @mref{factor} except that the polynomial factors are
"square-free."  That is, they have factors only of degree one.
This algorithm, which is also used by the first stage of @mrefcomma{factor} utilizes
the fact that a polynomial has in common with its n'th derivative all
its factors of degree greater than n.  Thus by taking greatest common divisors
with the polynomial of
the derivatives with respect to each variable in the polynomial, all
factors of degree greater than 1 can be found.

Example:

@c ===beg===
@c sqfr (4*x^4 + 4*x^3 - 3*x^2 - 4*x - 1);
@c ===end===
@example
(%i1) sqfr (4*x^4 + 4*x^3 - 3*x^2 - 4*x - 1);
                                2   2
(%o1)                  (2 x + 1)  (x  - 1)
@end example

@c @opencatbox
@c @category{Polynomials}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c THIS ITEM STILL NEEDS WORK

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials, Rational expressions)
@c @deffn  {Function} tellrat @
m4_deffn( {Function}, tellrat, <<<>>>) @
@fname{tellrat} (@var{p_1}, @dots{}, @var{p_n}) @
@fname{tellrat} ()

Adds to the ring of algebraic integers known to Maxima
the elements which are the solutions of the polynomials @var{p_1}, @dots{},
@var{p_n}.  Each argument @var{p_i} is a polynomial with integer coefficients.

@code{tellrat (@var{x})} effectively means substitute 0 for @var{x} in rational
functions.

@code{tellrat ()} returns a list of the current substitutions.

@code{algebraic} must be set to @code{true} in order for the simplification of
algebraic integers to take effect.

Maxima initially knows about the imaginary unit @code{%i}
and all roots of integers.

There is a command @code{untellrat} which takes kernels and
removes @code{tellrat} properties.

When @code{tellrat}'ing a multivariate
polynomial, e.g., @code{tellrat (x^2 - y^2)}, there would be an ambiguity as to
whether to substitute @code{@var{y}^2} for @code{@var{x}^2}
or vice versa.  
Maxima picks a particular ordering, but if the user wants to specify which, e.g.
@code{tellrat (y^2 = x^2)} provides a syntax which says replace
@code{@var{y}^2} by @code{@var{x}^2}.

@c CAN'T TELL WHAT THIS IS ABOUT -- tellrat(w^3-1)$ algebraic:true$ rat(1/(w^2-w));
@c DOES NOT YIELD AN ERROR, SO WHAT IS THE POINT ABOUT ratalgdenom ??
@c When you @code{tellrat} reducible polynomials, you want to be careful not to
@c attempt to rationalize a denominator with a zero divisor.  E.g.
@c tellrat(w^3-1)$ algebraic:true$ rat(1/(w^2-w)); will give "quotient by
@c zero".  This error can be avoided by setting @code{ratalgdenom} to @code{false}.

Examples:

@c ===beg===
@c 10*(%i + 1)/(%i + 3^(1/3));
@c ev (ratdisrep (rat(%)), algebraic);
@c tellrat (1 + a + a^2);
@c 1/(a*sqrt(2) - 1) + a/(sqrt(3) + sqrt(2));
@c ev (ratdisrep (rat(%)), algebraic);
@c tellrat (y^2 = x^2);
@c ===end===
@example
(%i1) 10*(%i + 1)/(%i + 3^(1/3));
                           10 (%i + 1)
(%o1)                      -----------
                                  1/3
                            %i + 3
(%i2) ev (ratdisrep (rat(%)), algebraic);
             2/3      1/3              2/3      1/3
(%o2)    (4 3    - 2 3    - 4) %i + 2 3    + 4 3    - 2
(%i3) tellrat (1 + a + a^2);
                            2
(%o3)                     [a  + a + 1]
(%i4) 1/(a*sqrt(2) - 1) + a/(sqrt(3) + sqrt(2));
                      1                 a
(%o4)           ------------- + -----------------
                sqrt(2) a - 1   sqrt(3) + sqrt(2)
(%i5) ev (ratdisrep (rat(%)), algebraic);
         (7 sqrt(3) - 10 sqrt(2) + 2) a - 2 sqrt(2) - 1
(%o5)    ----------------------------------------------
                               7
(%i6) tellrat (y^2 = x^2);
                        2    2   2
(%o6)                 [y  - x , a  + a + 1]
@end example

@c @opencatbox
@c @category{Polynomials}
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Rational expressions)
@anchor{totaldisrep}
@c @deffn {Function} totaldisrep (@var{expr})
m4_deffn({Function}, totaldisrep, <<<(@var{expr})>>>)

Converts every subexpression of @var{expr} from canonical rational expressions
(CRE) to general form and returns the result.
If @var{expr} is itself in CRE form then @code{totaldisrep} is identical to
@code{ratdisrep}.

@code{totaldisrep} may be useful for
ratdisrepping expressions such as equations, lists, matrices, etc., which
have some subexpressions in CRE form.

@c NEED EXAMPLES HERE
@c @opencatbox
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Polynomials, Rational expressions)
@anchor{untelltat}
@c @deffn {Function} untellrat (@var{x_1}, @dots{}, @var{x_n})
m4_deffn({Function}, untellrat, <<<(@var{x_1}, @dots{}, @var{x_n})>>>)

Removes @code{tellrat} properties from @var{x_1}, @dots{}, @var{x_n}.

@c NEED EXAMPLES HERE
@c @opencatbox
@c @category{Polynomials}
@c @category{Rational expressions}
@c @closecatbox
@c @end deffn
m4_end_deffn()
