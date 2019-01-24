@c -*- Mode: texinfo -*-
@menu
* Functions and Variables for to_poly_solve::
@end menu

@node Functions and Variables for to_poly_solve,  , to_poly_solve-pkg, to_poly_solve-pkg
@section Functions and Variables for to_poly_solve

The packages @code{to_poly} and @code{to_poly_solve} are experimental;
the specifications of the functions in these packages might change or
the some of the functions in these packages might be merged into other
Maxima functions.

Barton Willis (Professor of Mathematics, University of Nebraska at
Kearney) wrote the @code{to_poly} and @code{to_poly_solve} packages and the
English language user documentation for these packages.

@deffn {Operator} %and
@ifinfo
@fnindex Logical conjunction
@end ifinfo

The operator @code{%and} is a simplifying nonshort-circuited logical
conjunction.  Maxima simplifies an @code{%and} expression to either true,
false, or a logically equivalent, but simplified, expression.  The
operator @code{%and} is associative, commutative, and idempotent.  Thus
when @code{%and} returns a noun form, the arguments of @code{%and} form
a non-redundant sorted list; for example

@example
(%i1) a %and (a %and b);
(%o1)                       a %and b
@end example

If one argument to a conjunction is the @i{explicit} the negation of another
argument, @code{%and} returns false:

@example
(%i2) a %and (not a);
(%o2)                         false
@end example

If any member of the conjunction is false, the conjunction simplifies
to false even if other members are manifestly non-boolean; for example

@example
(%i3) 42 %and false;
(%o3)                         false
@end example

Any argument of an @code{%and} expression that is an inequation (that
is, an inequality or equation), is simplified using the Fourier
elimination package.  The Fourier elimination simplifier has a
pre-processor that converts some, but not all, nonlinear inequations
into linear inequations; for example the Fourier elimination code
simplifies @code{abs(x) + 1 > 0} to true, so

@example
(%i4) (x < 1) %and (abs(x) + 1 > 0);
(%o4)                         x < 1
@end example

@b{Notes}  
@itemize @bullet
@item The option variable @code{prederror} does @i{not} alter the
simplification @code{%and} expressions.

@item To avoid operator precedence errors, compound expressions
involving the operators @code{%and, %or}, and @code{not} should be
fully parenthesized.

@item The Maxima operators @code{and} and @code{or} are both
short-circuited.  Thus @code{and} isn't associative or commutative.

@end itemize

@b{Limitations} The conjunction @code{%and} simplifies inequations
@i{locally, not globally}.  This means that conjunctions such as

@example
(%i5) (x < 1) %and (x > 1);
(%o5)                 (x > 1) %and (x < 1)
@end example

do @i{not} simplify to false.  Also, the Fourier elimination code @i{ignores}
the fact database;

@example
(%i6) assume(x > 5);
(%o6)                        [x > 5]
(%i7) (x > 1) %and (x > 2);
(%o7)                 (x > 1) %and (x > 2)
@end example

Finally, nonlinear inequations that aren't easily converted into an
equivalent linear inequation aren't simplified.

There is no support for distributing @code{%and} over @code{%or};
neither is there support for distributing a logical negation over
@code{%and}.

@b{To use} @file{load(to_poly_solve)}

@b{Related functions} @code{%or, %if, and, or, not}

@b{Status} The operator @code{%and} is experimental; the
specifications of this function might change and its functionality
might be merged into other Maxima functions.

@end deffn

@deffn {Operator} %if (@var{bool}, @var{a}, @var{b})
@ifinfo
@fnindex conditional evaluation
@end ifinfo

The operator @code{%if} is a simplifying conditional.  The
@i{conditional} @var{bool} should be boolean-valued.  When the
conditional is true, return the second argument; when the conditional is
false, return the third; in all other cases, return a noun form.

Maxima inequations (either an inequality or an equality) are @i{not}
boolean-valued; for example, Maxima does @i{not} simplify @math{5 < 6}
to true, and it does not simplify @math{5 = 6} to false; however, in
the context of a conditional to an @code{%if} statement, Maxima
@i{automatically} attempts to determine the truth value of an
inequation.  Examples:

@example
(%i1) f : %if(x # 1, 2, 8);
(%o1)                 %if(x - 1 # 0, 2, 8)
(%i2) [subst(x = -1,f), subst(x=1,f)];
(%o2)                        [2, 8]
@end example

If the conditional involves an inequation, Maxima simplifies it using
the Fourier elimination package.

@b{Notes} 

@itemize @bullet
@item If the conditional is manifestly non-boolean, Maxima returns a noun form:
@end itemize

@example
(%i3) %if(42,1,2);
(%o3)                     %if(42, 1, 2)
@end example

@itemize @bullet
@item The Maxima operator @code{if} is nary, the operator @code{%if} @i{isn't}
nary.
@end itemize

@b{Limitations} The Fourier elimination code only simplifies nonlinear
inequations that are readily convertible to an equivalent linear
inequation.

@b{To use:} @file{load(to_poly_solve)}

@b{Status:} The operator @code{%if} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn
  
@deffn {Operator} %or
@ifinfo
@fnindex Logical disjunction
@end ifinfo

The operator @code{%or} is a simplifying nonshort-circuited logical
disjunction.  Maxima simplifies an @code{%or} expression to either
true, false, or a logically equivalent, but simplified,
expression.  The operator @code{%or} is associative, commutative, and
idempotent.  Thus when @code{%or} returns a noun form, the arguments
of @code{%or} form a non-redundant sorted list; for example

@example
(%i1) a %or (a %or b);
(%o1)                        a %or b
@end example

If one member of the disjunction is the @i{explicit} the negation of another
member, @code{%or} returns true:

@example
(%i2) a %or (not a);
(%o2)                         true
@end example

If any member of the disjunction is true, the disjunction simplifies
to true even if other members of the disjunction are manifestly non-boolean;
for example

@example
(%i3) 42 %or true;
(%o3)                         true
@end example

Any argument of an @code{%or} expression that is an inequation (that
is, an inequality or equation), is simplified using the Fourier
elimination package.  The Fourier elimination code simplifies
@code{abs(x) + 1 > 0} to true, so we have

@example
(%i4) (x < 1) %or (abs(x) + 1 > 0);
(%o4)                         true
@end example

@b{Notes}  
@itemize @bullet
@item The option variable @code{prederror} does @i{not} alter the 
simplification of @code{%or} expressions.

@item You should parenthesize compound expressions involving the
operators @code{%and, %or}, and @code{not}; the binding powers of these
operators might not match your expectations.

@item The Maxima operators @code{and} and @code{or} are both short-circuited.
Thus @code{or} isn't associative or commutative.

@end itemize

@b{Limitations} The conjunction @code{%or} simplifies inequations
@i{locally, not globally}.  This means that conjunctions such as

@c TODO: IN MAXIMA 5.24POST THIS SIMPLIFIES TO TRUE.

@example
(%i1) (x < 1) %or (x >= 1);
(%o1) (x > 1) %or (x >= 1)
@end example

do @i{not} simplify to true.  Further, the Fourier elimination code ignores
the fact database;

@example
(%i2) assume(x > 5);
(%o2)                        [x > 5]
(%i3) (x > 1) %and (x > 2);
(%o3)                 (x > 1) %and (x > 2)
@end example

Finally, nonlinear inequations that aren't easily converted into an
equivalent linear inequation aren't simplified.

The algorithm that looks for terms that cannot both be false is weak;
also there is no support for distributing @code{%or} over @code{%and};
neither is there support for distributing a logical negation over
@code{%or}.

@b{To use} @file{load(to_poly_solve)}

@b{Related functions} @code{%or, %if, and, or, not}

@b{Status} The operator @code{%or} is experimental; the
specifications of this function might change and its functionality
might be merged into other Maxima functions.

@end deffn

@anchor{complex_number_p}
@deffn {Function} complex_number_p (@var{x})

The predicate @code{complex_number_p} returns true if its argument is
either @code{a + %i * b}, @code{a}, @code{%i b}, or @code{%i},
where @code{a} and @code{b} are either rational or floating point
numbers (including big floating point); for all other inputs,
@code{complex_number_p} returns false; for example

@example
(%i1) map('complex_number_p,[2/3, 2 + 1.5 * %i, %i]);
(%o1)                  [true, true, true]
(%i2) complex_number_p((2+%i)/(5-%i));
(%o2)                         false
(%i3) complex_number_p(cos(5 - 2 * %i));
(%o3)                         false
@end example

@b{Related functions} @code{isreal_p}

@b{To use} @file{load(to_poly_solve)}

@b{Status} The operator @code{complex_number_p} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn

@anchor{compose_functions}
@deffn {Function} compose_functions (@var{l})

The function call @code{compose_functions(l)} returns a lambda form that is
the @i{composition} of the functions in the list @var{l}.  The functions are
applied from @i{right} to @i{left}; for example

@example
(%i1) compose_functions([cos, exp]);
                                        %g151
(%o1)             lambda([%g151], cos(%e     ))
(%i2) %(x);
                                  x
(%o2)                       cos(%e )
@end example

When the function list is empty, return the identity function:

@example
(%i3) compose_functions([]);
(%o3)                lambda([%g152], %g152)
(%i4)  %(x);
(%o4)                           x
@end example

@b{Notes} 
@itemize @bullet
@item When Maxima determines that a list member isn't a symbol or
a lambda form, @code{funmake} (@i{not} @code{compose_functions})
signals an error:
@end itemize

@example
(%i5) compose_functions([a < b]);

funmake: first argument must be a symbol, subscripted symbol,
string, or lambda expression; found: a < b
#0: compose_functions(l=[a < b])(to_poly_solve.mac line 40)
 -- an error. To debug this try: debugmode(true);
@end example

@itemize @bullet
@item To avoid name conflicts, the independent variable is determined by the
function @code{new_variable}.

@example
(%i6) compose_functions([%g0]);
(%o6)              lambda([%g154], %g0(%g154))
(%i7) compose_functions([%g0]);
(%o7)              lambda([%g155], %g0(%g155))
@end example

Although the independent variables are different, Maxima is able to to
deduce that these lambda forms are semantically equal:

@example
(%i8) is(equal(%o6,%o7));
(%o8)                         true
@end example
@end itemize

@b{To use} @file{load(to_poly_solve)}

@b{Status}  The function @code{compose_functions} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.
@end deffn

@anchor{dfloat}
@deffn {Function} dfloat (@var{x})

The function @code{dfloat} is a similar to @code{float}, but the function
@code{dfloat} applies @code{rectform} when @code{float} fails to evaluate
to an IEEE double floating point number; thus

@example
(%i1) float(4.5^(1 + %i));
                               %i + 1
(%o1)                       4.5
(%i2) dfloat(4.5^(1 + %i));
(%o2)        4.48998802962884 %i + .3000124893895671
@end example

@b{Notes} 

@itemize @bullet
@item The rectangular form of an expression might be poorly suited for
numerical evaluation--for example, the rectangular form might
needlessly involve the difference of floating point numbers
(subtractive cancellation).


@item The identifier @code{float} is both an option variable (default
value false) and a function name.


@end itemize

@b{Related functions} @code{float, bfloat}

@b{To use} @file{load(to_poly_solve)}

@b{Status} The function @code{dfloat} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn

@anchor{elim}
@deffn {Function} elim (@var{l}, @var{x})

The function @code{elim} eliminates the variables in the set or list
@code{x} from the equations in the set or list @code{l}.  Each member
of @code{x} must be a symbol; the members of @code{l} can either be
equations, or expressions that are assumed to equal zero.

The function @code{elim} returns a list of two lists; the first is
the list of expressions with the variables eliminated; the second
is the list of pivots; thus, the second list is a list of
expressions that @code{elim} used to eliminate the variables.

Here is a example of eliminating between linear equations:

@example
(%i1) elim(set(x + y + z = 1, x - y  - z = 8, x - z = 1), 
           set(x,y));
(%o1)            [[2 z - 7], [y + 7, z - x + 1]]
@end example

Eliminating @code{x} and @code{y} yields the single equation @code{2 z - 7 = 0};
the equations @code{y + 7 = 0} and @code{z - z + 1 = 1} were used as pivots.
Eliminating all three variables from these equations, triangularizes the linear
system:

@example
(%i2) elim(set(x + y + z = 1, x - y  - z = 8, x - z = 1),
           set(x,y,z));
(%o2)           [[], [2 z - 7, y + 7, z - x + 1]]
@end example

Of course, the equations needn't be linear:

@example
(%i3) elim(set(x^2 - 2 * y^3 = 1,  x - y = 5), [x,y]);
                     3    2
(%o3)       [[], [2 y  - y  - 10 y - 24, y - x + 5]]
@end example

The user doesn't control the order the variables are
eliminated.  Instead, the algorithm uses a heuristic to @i{attempt} to
choose the best pivot and the best elimination order.

@b{Notes} 

@itemize @bullet
@item Unlike the related function @code{eliminate}, the function
@code{elim} does @i{not} invoke @code{solve} when the number of equations
equals the number of variables.

@item The function @code{elim} works by applying resultants; the option
variable @code{resultant} determines which algorithm Maxima
uses.  Using @code{sqfr}, Maxima factors each resultant and suppresses
multiple zeros.

@item The @code{elim} will triangularize a nonlinear set of polynomial
equations; the solution set of the triangularized set @i{can} be larger
than that solution set of the untriangularized set.  Thus, the triangularized
equations can have @i{spurious} solutions.
@end itemize

@b{Related functions} @i{elim_allbut, eliminate_using, eliminate}

@b{Option variables} @i{resultant}

@b{To use} @file{load(to_poly)}

@b{Status} The function @code{elim} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn
 
@anchor{elim_allbut}
@deffn {Function} elim_allbut (@var{l}, @var{x})

This function is similar to @code{elim}, except that it eliminates all the
variables in the list of equations @code{l} @i{except} for those variables that
in in the list @code{x}

@example
(%i1) elim_allbut([x+y = 1, x - 5*y = 1],[]);
(%o1)                 [[], [y, y + x - 1]]
(%i2) elim_allbut([x+y = 1, x - 5*y = 1],[x]);
(%o2)                [[x - 1], [y + x - 1]]
@end example

@b{To use} @file{load(to_poly)}

@b{Option variables} @i{resultant}

@b{Related functions} @i{elim, eliminate_using, eliminate}

@b{Status} The function @code{elim_allbut} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn

@anchor{eliminate_using}
@deffn {Function} eliminate_using (@var{l}, @var{e}, @var{x})

Using @code{e} as the pivot, eliminate the symbol @code{x} from the
list or set of equations in @code{l}.  The function @code{eliminate_using}
returns a set.

@example
(%i1) eq : [x^2 - y^2 - z^3 , x*y - z^2 - 5, x - y + z];
               3    2    2     2
(%o1)      [- z  - y  + x , - z  + x y - 5, z - y + x]
(%i2) eliminate_using(eq,first(eq),z);
        3              2      2      3    2
(%o2) @{y  + (1 - 3 x) y  + 3 x  y - x  - x , 
                        4    3  3       2  2             4
                       y  - x  y  + 13 x  y  - 75 x y + x  + 125@}
(%i3) eliminate_using(eq,second(eq),z);
        2            2       4    3  3       2  2             4
(%o3) @{y  - 3 x y + x  + 5, y  - x  y  + 13 x  y  - 75 x y + x
                                                           + 125@}
(%i4) eliminate_using(eq, third(eq),z);
        2            2       3              2      2      3    2
(%o4) @{y  - 3 x y + x  + 5, y  + (1 - 3 x) y  + 3 x  y - x  - x @}
@end example

@b{Option variables} @i{resultant}

@b{Related functions} @i{elim, eliminate, elim_allbut}

@b{To use} @file{load(to_poly)}

@b{Status} The function @code{eliminate_using} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn

@anchor{fourier_elim}
@deffn {Function} fourier_elim ([@var{eq1}, @var{eq2}, @dots{}], [@var{var1}, @var{var}, @dots{}])

Fourier elimination is the analog of Gauss elimination for linear inequations
(equations or inequalities).  The function call @code{fourier_elim([eq1, eq2,
...], [var1, var2, ...])} does Fourier elimination on a list of linear
inequations @code{[eq1, eq2, ...]} with respect to the variables
@code{[var1, var2, ...]}; for example

@example
(%i1) fourier_elim([y-x < 5, x - y < 7, 10 < y],[x,y]);
(%o1)            [y - 5 < x, x < y + 7, 10 < y]
(%i2) fourier_elim([y-x < 5, x - y < 7, 10 < y],[y,x]);
(%o2)        [max(10, x - 7) < y, y < x + 5, 5 < x]
@end example

Eliminating first with respect to @math{x} and second with respect to
@math{y} yields lower and upper bounds for @math{x} that depend on
@math{y}, and lower and upper bounds for @math{y} that are numbers.
Eliminating in the other order gives @math{x} dependent lower and
upper bounds for @math{y}, and numerical lower and upper bounds for
@math{x}.

When necessary, @code{fourier_elim} returns a @emph{disjunction} of lists of
inequations:

@example
(%i3) fourier_elim([x # 6],[x]);
(%o3)                  [x < 6] or [6 < x]
@end example

When the solution set is empty,  @code{fourier_elim} returns @code{emptyset},
and when the solution set is all reals, @code{fourier_elim} returns @code{universalset};
for example

@example
(%i4) fourier_elim([x < 1, x > 1],[x]);
(%o4)                       emptyset
(%i5) fourier_elim([minf < x, x < inf],[x]);
(%o5)                     universalset
@end example

For nonlinear inequations, @code{fourier_elim} returns a (somewhat) 
simplified list of inequations:

@example
(%i6) fourier_elim([x^3 - 1 > 0],[x]);
@group
               2                             2
(%o6) [1 < x, x  + x + 1 > 0] or [x < 1, - (x  + x + 1) > 0]
@end group
(%i7) fourier_elim([cos(x) < 1/2],[x]);
(%o7)                  [1 - 2 cos(x) > 0]
@end example

Instead of a list of inequations, the first argument to @code{fourier_elim}
may be a logical disjunction or conjunction:

@example
(%i8) fourier_elim((x + y < 5) and (x - y >8),[x,y]);
                                              3
(%o8)            [y + 8 < x, x < 5 - y, y < - -]
                                              2
(%i9) fourier_elim(((x + y < 5) and x < 1) or  (x - y >8),[x,y]);
(%o9)          [y + 8 < x] or [x < min(1, 5 - y)]
@end example

The function @code{fourier_elim} supports the inequation operators 
@code{<, <=, >, >=, #}, and @code{=}.

The Fourier elimination code has a preprocessor that converts some
nonlinear inequations that involve the absolute value, minimum, and
maximum functions into linear in equations.  Additionally, the preprocessor
handles some expressions that are the product or quotient of linear terms:

@example
(%i10) fourier_elim([max(x,y) > 6, x # 8, abs(y-1) > 12],[x,y]);
(%o10) [6 < x, x < 8, y < - 11] or [8 < x, y < - 11]
 or [x < 8, 13 < y] or [x = y, 13 < y] or [8 < x, x < y, 13 < y]
 or [y < x, 13 < y]
(%i11) fourier_elim([(x+6)/(x-9) <= 6],[x]);
(%o11)           [x = 12] or [12 < x] or [x < 9]
(%i12) fourier_elim([x^2 - 1 # 0],[x]);
(%o12)      [- 1 < x, x < 1] or [1 < x] or [x < - 1]
@end example

@b{To use} @file{load(fourier_elim)}

@end deffn

@anchor{isreal_p}
@deffn {Function} isreal_p (@var{e})

The predicate @code{isreal_p} returns true when Maxima is able to
determine that @code{e} is real-valued on the @i{entire} real line; it
returns false when Maxima is able to determine that @code{e} @i{isn't}
real-valued on some nonempty subset of the real line; and it returns a
noun form for all other cases.

@example
(%i1) map('isreal_p, [-1, 0, %i, %pi]);
(%o1)               [true, true, false, true]
@end example

Maxima variables are assumed to be real; thus

@example
(%i2) isreal_p(x);
(%o2)                         true
@end example

The function @code{isreal_p} examines the fact database:

@example
(%i3) declare(z,complex)$

(%i4) isreal_p(z);
(%o4)                      isreal_p(z)
@end example

@b{Limitations}
Too often, @code{isreal_p} returns a noun form when it should be able
to return false; a simple example: the logarithm function isn't
real-valued on the entire real line, so @code{isreal_p(log(x))} should
return false; however

@example
(%i5) isreal_p(log(x));
(%o5)                   isreal_p(log(x))
@end example

@b{To use} @file{load(to_poly_solve)}

@b{Related functions} @i{complex_number_p}

@b{Status} The function @code{isreal_p} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.
@end deffn


@anchor{new_variable}
@deffn {Function} new_variable (type)

Return a unique symbol of the form @code{%[z,n,r,c,g]k}, where
@code{k} is an integer.  The allowed values for @math{type} are
@i{integer, natural_number, real, natural_number,} and @i{general}.
(By natural number, we mean the @i{nonnegative integers}; thus zero is
a natural number.  Some, but not all,definitions of natural number
@i{exclude} zero.)

When @math{type} isn't one of the allowed values, @math{type} defaults
to @math{general}.  For integers, natural numbers, and complex numbers,
Maxima automatically appends this information to the fact database.

@example
(%i1) map('new_variable,
          ['integer, 'natural_number, 'real, 'complex, 'general]);
(%o1)          [%z144, %n145, %r146, %c147, %g148]
(%i2) nicedummies(%);
(%o2)               [%z0, %n0, %r0, %c0, %g0]
(%i3) featurep(%z0, 'integer);
(%o3)                         true
(%i4) featurep(%n0, 'integer);
(%o4)                         true
(%i5) is(%n0 >= 0);
(%o5)                         true
(%i6) featurep(%c0, 'complex);
(%o6)                         true
@end example

@b{Note} Generally, the argument to @code{new_variable} should be quoted.  The quote
will protect against errors similar to

@example
(%i7) integer : 12$

(%i8) new_variable(integer);
(%o8)                         %g149
(%i9) new_variable('integer);
(%o9)                         %z150
@end example

@b{Related functions} @i{nicedummies}

@b{To use} @file{load(to_poly_solve)}

@b{Status} The function @code{new_variable} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn

@anchor{nicedummies}
@deffn {Function} nicedummies

Starting with zero, the function @code{nicedummies} re-indexes the variables 
in an expression that were introduced by @code{new_variable};

@example
(%i1) new_variable('integer) + 52 * new_variable('integer);
(%o1)                   52 %z136 + %z135
(%i2) new_variable('integer) - new_variable('integer);
(%o2)                     %z137 - %z138
(%i3) nicedummies(%);
(%o3)                       %z0 - %z1
@end example

@b{Related functions} @i{new_variable}

@b{To use} @file{load(to_poly_solve)}

@b{Status} The function @code{nicedummies} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn

@deffn {Function} parg (@var{x})

The function @code{parg} is a simplifying version of the complex argument function 
@code{carg}; thus

@example
(%i1) map('parg,[1,1+%i,%i, -1 + %i, -1]);
                        %pi  %pi  3 %pi
(%o1)               [0, ---, ---, -----, %pi]
                         4    2     4
@end example

Generally, for a non-constant input, @code{parg} returns a noun form; thus

@example
(%i2) parg(x + %i * sqrt(x));
(%o2)                 parg(x + %i sqrt(x))
@end example

When @code{sign} can determine that the input is a positive or negative real
number, @code{parg} will return a non-noun form for a non-constant input.
Here are two examples:

@c TODO: THE FIRST RESULT IS A NOUNFORM IN MAXIMA 5.24POST

@example
(%i3) parg(abs(x));
(%o3) 0
(%i4) parg(-x^2-1);
(%o4)                          %pi
@end example

@b{Note} The @code{sign} function mostly ignores the variables that are declared
to be complex (@code{declare(x,complex)}); for variables that are declared
to be complex, the @code{parg} can return incorrect values; for example

@c TODO: IN MAXIMA 5.24POST THE RESULT IS A NOUNFORM.

@example
(%i1) declare(x,complex)$

(%i2) parg(x^2 + 1);
(%o2) 0
@end example

@b{Related function} @i{carg, isreal_p}

@b{To use} @file{load(to_poly_solve)}

@b{Status} The function @code{parg} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn

@anchor{real_imagpart_to_conjugate}
@deffn {Function} real_imagpart_to_conjugate (@var{e})

The function @code{real_imagpart_to_conjugate} replaces all occurrences
of @code{realpart} and @code{imagpart} to algebraically equivalent expressions
involving the @code{conjugate}.

@example
(%i1) declare(x, complex)$

(%i2) real_imagpart_to_conjugate(realpart(x) +  imagpart(x) = 3);
          conjugate(x) + x   %i (x - conjugate(x))
(%o2)     ---------------- - --------------------- = 3
                 2                     2
@end example

@b{To use} @file{load(to_poly_solve)}

@b{Status} The function @code{real_imagpart_to_conjugate} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn

@anchor{rectform_log_if_constant}
@deffn {Function} rectform_log_if_constant (@var{e})

The function @code{rectform_log_if_constant} converts all terms of the form
@code{ log(c)} to  @code{rectform(log(c))}, where @code{c} is
either a declared constant expression or explicitly declared constant

@example
(%i1) rectform_log_if_constant(log(1-%i) - log(x - %i));
                                 log(2)   %i %pi
(%o1)            - log(x - %i) + ------ - ------
                                   2        4
(%i2) declare(a,constant, b,constant)$

(%i3) rectform_log_if_constant(log(a + %i*b));
                       2    2
                  log(b  + a )
(%o3)             ------------ + %i atan2(b, a)
                       2
@end example

@b{To use} @file{load(to_poly_solve)}

@b{Status} The function @code{rectform_log_if_constant} is
experimental; the specifications of this function might change might change and its functionality
might be merged into other Maxima functions.

@end deffn

@anchor{simp_inequality}
@deffn {Function} simp_inequality (@var{e})

The function @code{simp_inequality} applies some simplifications to
conjunctions and disjunctions of inequations.

@b{Limitations} The function @code{simp_inequality} is limited in at least two ways;
first, the simplifications are local; thus

@c TODO: IN MAXIMA 5.24POST THE RESULT IS SIMPLIFIED.

@example
(%i1) simp_inequality((x > minf) %and (x < 0));
(%o1) (x>1) %and (x<1)
@end example

And second, @code{simp_inequality} doesn't consult the fact database:

@example
(%i2) assume(x > 0)$

(%i3) simp_inequality(x > 0);
(%o3)                         x > 0
@end example

@b{To use} @file{load(fourier_elim)}

@b{Status} The function @code{simp_inequality} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn

@anchor{standardize_inverse_trig}
@deffn {Function} standardize_inverse_trig (@var{e})

This function applies the identities @code{cot(x) = atan(1/x),
acsc(x) = asin(1/x),} and similarly for @code{asec, acoth, acsch}
and @code{asech} to an expression.  See Abramowitz and Stegun, 
Eqs. 4.4.6 through 4.4.8 and 4.6.4 through 4.6.6.

@b{To use} @file{load(to_poly_solve)}

@b{Status} The function @code{standardize_inverse_trig} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.
@end deffn

@anchor{subst_parallel}
@deffn {Function} subst_parallel (@var{l}, @var{e})

When @code{l} is a single equation or a list of equations, substitute
the right hand side of each equation for the left hand side.  The
substitutions are made in parallel; for example

@example
(%i1) load(to_poly_solve)$

(%i2) subst_parallel([x=y,y=x], [x,y]);
(%o2)                        [y, x]
@end example

Compare this to substitutions made serially:

@example
(%i3) subst([x=y,y=x],[x,y]);
(%o3)                        [x, x]
@end example

The function @code{subst_parallel} is similar to @code{sublis} except that
@code{subst_parallel} allows for substitution of nonatoms; for example

@example
(%i4) subst_parallel([x^2 = a, y = b], x^2 * y);
(%o4)                          a b
(%i5) sublis([x^2 = a, y = b], x^2 * y);

                                                             2
sublis: left-hand side of equation must be a symbol; found: x
 -- an error. To debug this try: debugmode(true);
@end example

The substitutions made by @code{subst_parallel} are literal, not semantic; thus 
@code{subst_parallel} @i{does not} recognize that @math{x * y} is a subexpression 
of @math{x^2 * y}

@example
(%i6) subst_parallel([x * y = a], x^2 * y);
                               2
(%o6)                         x  y
@end example

The function @code{subst_parallel} completes all substitutions
@i{before} simplifications.  This allows for substitutions into
conditional expressions where errors might occur if the
simplifications were made earlier:

@example
(%i7) subst_parallel([x = 0], %if(x < 1, 5, log(x)));
(%o7)                           5
(%i8) subst([x = 0], %if(x < 1, 5, log(x)));

log: encountered log(0).
 -- an error. To debug this try: debugmode(true);
@end example

@b{Related functions} @i{subst, sublis, ratsubst}

@b{To use} @file{load(to_poly_solve_extra.lisp)}

@b{Status} The function @code{subst_parallel} is experimental; the
specifications of this function might change might change and its
functionality might be merged into other Maxima functions.

@end deffn

@anchor{to_poly}
@deffn {Function} to_poly (@var{e}, @var{l})

The function @code{to_poly} attempts to convert the equation @code{e}
into a polynomial system along with inequality constraints; the
solutions to the polynomial system that satisfy the constraints are
solutions to the equation @code{e}.  Informally, @code{to_poly}
attempts to polynomialize the equation @var{e}; an example might
clarify:

@example
(%i1) load(to_poly_solve)$

(%i2) to_poly(sqrt(x) = 3, [x]);
                            2
(%o2) [[%g130 - 3, x = %g130 ], 
                      %pi                               %pi
                   [- --- < parg(%g130), parg(%g130) <= ---], []]
                       2                                 2
@end example

The conditions @code{-%pi/2<parg(%g130),parg(%g130)<=%pi/2} tell us that
@code{%g130} is in the range of the square root function.  When this is
true, the solution set to @code{sqrt(x) = 3} is the same as the
solution set to @code{%g130-3,x=%g130^2}.

To polynomialize trigonometric expressions, it is necessary to
introduce a non algebraic substitution; these non algebraic substitutions
are returned in the third list returned by @code{to_poly}; for example

@example
(%i3) to_poly(cos(x),[x]);
                2                                 %i x
(%o3)    [[%g131  + 1], [2 %g131 # 0], [%g131 = %e    ]]
@end example

Constant terms aren't polynomializied unless the number one is a member of
the variable list; for example

@example
(%i4) to_poly(x = sqrt(5),[x]);
(%o4)                [[x - sqrt(5)], [], []]
(%i5) to_poly(x = sqrt(5),[1,x]);
                            2
(%o5) [[x - %g132, 5 = %g132 ], 
                      %pi                               %pi
                   [- --- < parg(%g132), parg(%g132) <= ---], []]
                       2                                 2
@end example

To generate a polynomial with @math{sqrt(5) + sqrt(7)} as
one of its roots, use the commands

@example
(%i6) first(elim_allbut(first(to_poly(x = sqrt(5) + sqrt(7),
                                      [1,x])), [x]));
                          4       2
(%o6)                   [x  - 24 x  + 4]
@end example

@b{Related functions} @i{to_poly_solve}

@b{To use} @file{load(to_poly)}

@b{Status:} The function @code{to_poly} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.

@end deffn

@deffn {Function} to_poly_solve (@var{e}, @var{l}, [options])

The function @code{to_poly_solve} tries to solve the equations @math{e}
for the variables @math{l}.  The equation(s) @math{e} can either be a
single expression or a set or list of expressions; similarly, @math{l}
can either be a single symbol or a list of set of symbols.  When
a member of @math{e} isn't explicitly an equation, for example @math{x^2 -1},
the solver asummes that the expression vanishes.

The basic strategy of @code{to_poly_solve} is to convert the input into a polynomial form and to 
call @code{algsys} on the polynomial system. Internally  @code{to_poly_solve} defaults @code{algexact} 
to true. To change the default for @code{algexact}, append 'algexact=false to the @code{to_poly_solve} 
argument list.

When @code{to_poly_solve} is able to determine the solution set, each
member of the solution set is a list in a @code{%union} object:

@example
(%i1) load(to_poly_solve)$

(%i2) to_poly_solve(x*(x-1) = 0, x);
(%o2)               %union([x = 0], [x = 1])
@end example

When  @code{to_poly_solve} is @i{unable} to determine the solution set, a
@code{%solve} nounform is returned (in this case, a warning is printed)

@example
(%i3) to_poly_solve(x^k + 2* x + 1 = 0, x);

Nonalgebraic argument given to 'to_poly'
unable to solve
                          k
(%o3)            %solve([x  + 2 x + 1 = 0], [x])
@end example

Subsitution into a @code{%solve} nounform can sometimes result in the solution

@example
(%i4) subst(k = 2, %);
(%o4)                   %union([x = - 1])
@end example

Especially for trigonometric equations, the solver sometimes needs
to introduce an arbitrary integer.  These arbitrary integers have the 
form @code{%zXXX}, where @code{XXX} is an integer; for example

@example
(%i5) to_poly_solve(sin(x) = 0, x);
(%o5)   %union([x = 2 %pi %z33 + %pi], [x = 2 %pi %z35])
@end example

To re-index these variables to zero, use @code{nicedummies}:

@example
(%i6) nicedummies(%);
(%o6)    %union([x = 2 %pi %z0 + %pi], [x = 2 %pi %z1])
@end example

Occasionally, the solver introduces an arbitrary complex number of the
form @code{%cXXX} or an  arbitrary real number of the form @code{%rXXX}.
The function @code{nicedummies} will re-index these identifiers to zero.

The solution set sometimes involves simplifing versions of various
of logical operators including @code{%and}, @code{%or}, or @code{%if}
for conjunction, disjuntion, and implication, respectively; for example

@example
(%i7) sol : to_poly_solve(abs(x) = a, x);
(%o7) %union(%if(isnonnegative_p(a), [x = - a], %union()), 
                      %if(isnonnegative_p(a), [x = a], %union()))
(%i8) subst(a = 42, sol);
(%o8)             %union([x = - 42], [x = 42])
(%i9) subst(a = -42, sol);
(%o9)                       %union()
@end example

The empty set is represented by @code{%union()}.

The function @code{to_poly_solve} is able to solve some, but not all,
equations involving rational powers, some nonrational powers, absolute
values, trigonometric functions, and minimum and maximum.  Also, some it
can solve some equations that are solvable in in terms of the Lambert W
function; some examples:

@example
(%i1) load(to_poly_solve)$

(%i2) to_poly_solve(set(max(x,y) = 5, x+y = 2), set(x,y));
(%o2)      %union([x = - 3, y = 5], [x = 5, y = - 3])
(%i3) to_poly_solve(abs(1-abs(1-x)) = 10,x);
(%o3)             %union([x = - 10], [x = 12])
(%i4) to_poly_solve(set(sqrt(x) + sqrt(y) = 5, x + y = 10),
                    set(x,y));
                     3/2               3/2
                    5    %i - 10      5    %i + 10
(%o4) %union([x = - ------------, y = ------------], 
                         2                 2
                                3/2                 3/2
                               5    %i + 10        5    %i - 10
                          [x = ------------, y = - ------------])
                                    2                   2
(%i5) to_poly_solve(cos(x) * sin(x) = 1/2,x,
                    'simpfuncs = ['expand, 'nicedummies]);
                                         %pi
(%o5)              %union([x = %pi %z0 + ---])
                                          4
(%i6) to_poly_solve(x^(2*a) + x^a + 1,x);
                                        2 %i %pi %z81
                                        -------------
                                  1/a         a
                  (sqrt(3) %i - 1)    %e
(%o6) %union([x = -----------------------------------], 
                                  1/a
                                 2
@group
                                                  2 %i %pi %z83
                                                  -------------
                                            1/a         a
                          (- sqrt(3) %i - 1)    %e
                     [x = -------------------------------------])
                                           1/a
                                          2
@end group
(%i7) to_poly_solve(x * exp(x) = a, x);
(%o7)              %union([x = lambert_w(a)])
@end example

For @i{linear} inequalities, @code{to_poly_solve} automatically does Fourier
elimination:

@example
(%i8) to_poly_solve([x + y < 1, x - y >= 8], [x,y]);
                               7
(%o8) %union([x = y + 8, y < - -], 
                               2
                                                              7
                                 [y + 8 < x, x < 1 - y, y < - -])
                                                              2
@end example

Each optional argument to @code{to_poly_solve} must be an equation;
generally, the order of these options does not matter.

@itemize @bullet
@item @code{simpfuncs = l}, where @code{l} is a list of functions.
Apply the composition of the members of l to each solution.

@example
(%i1) to_poly_solve(x^2=%i,x);
                               1/4             1/4
(%o1)       %union([x = - (- 1)   ], [x = (- 1)   ])
(%i2) to_poly_solve(x^2= %i,x, 'simpfuncs = ['rectform]);
                      %i         1             %i         1
(%o2) %union([x = - ------- - -------], [x = ------- + -------])
                    sqrt(2)   sqrt(2)        sqrt(2)   sqrt(2)
@end example

Sometimes additional simplification can revert a simplification; for example

@example
(%i3) to_poly_solve(x^2=1,x);
(%o3)              %union([x = - 1], [x = 1])
(%i4) to_poly_solve(x^2= 1,x, 'simpfuncs = [polarform]);
                                        %i %pi
(%o4)            %union([x = 1], [x = %e      ]
@end example

Maxima doesn't try to check that each member of the function list @code{l} is
purely a simplification; thus

@example
(%i5) to_poly_solve(x^2 = %i,x, 'simpfuncs = [lambda([s],s^2)]);
(%o5)                   %union([x = %i])
@end example

To convert each solution to a double float, use @code{simpfunc = ['dfloat]}:

@example
(%i6) to_poly_solve(x^3 +x + 1 = 0,x, 
                    'simpfuncs = ['dfloat]), algexact : true;
(%o6) %union([x = - .6823278038280178], 
[x = .3411639019140089 - 1.161541399997251 %i], 
[x = 1.161541399997251 %i + .3411639019140089])
@end example

@item @code{use_grobner = true} With this option, the function
@code{poly_reduced_grobner} is applied to the equations before
attempting their solution.  Primarily, this option provides a workaround
for weakness in the function @code{algsys}.  Here is an example of
such a workaround:

@example
(%i7) to_poly_solve([x^2+y^2=2^2,(x-1)^2+(y-1)^2=2^2],[x,y],
                    'use_grobner = true);
@group
                    sqrt(7) - 1      sqrt(7) + 1
(%o7) %union([x = - -----------, y = -----------], 
                         2                2
@end group
                                 sqrt(7) + 1        sqrt(7) - 1
                            [x = -----------, y = - -----------])
                                      2                  2
(%i8) to_poly_solve([x^2+y^2=2^2,(x-1)^2+(y-1)^2=2^2],[x,y]);
(%o8)                       %union()
@end example

@item @code{maxdepth = k}, where @code{k} is a positive integer.  This
function controls the maximum recursion depth for the solver.  The
default value for @code{maxdepth} is five.  When the recursions depth is
exceeded, the solver signals an error:

@example
(%i9) to_poly_solve(cos(x) = x,x, 'maxdepth = 2);

Unable to solve
Unable to solve
(%o9)        %solve([cos(x) = x], [x], maxdepth = 2)
@end example

@item @code{parameters = l}, where @code{l} is a list of symbols.  The solver
attempts to return a solution that is valid for all members of the list
@code{l}; for example:

@example
(%i10) to_poly_solve(a * x = x, x);
(%o10)                   %union([x = 0])
(%i11) to_poly_solve(a * x = x, x, 'parameters = [a]);
(%o11) %union(%if(a - 1 = 0, [x = %c111], %union()), 
                               %if(a - 1 # 0, [x = 0], %union()))
@end example

In @code{(%o2)}, the solver introduced a dummy variable; to re-index the
these dummy variables, use the function @code{nicedummies}:

@example
(%i12) nicedummies(%);
(%o12) %union(%if(a - 1 = 0, [x = %c0], %union()), 
                               %if(a - 1 # 0, [x = 0], %union()))
@end example
@end itemize

The @code{to_poly_solve} uses data stored in the hashed array
@code{one_to_one_reduce} to solve equations of the form @math{f(a) =
f(b)}.  The assignment @code{one_to_one_reduce['f,'f] : lambda([a,b],
a=b)} tells @code{to_poly_solve} that the solution set of @math{f(a)
= f(b)} equals the solution set of @math{a=b}; for example

@example
(%i13) one_to_one_reduce['f,'f] : lambda([a,b], a=b)$

(%i14) to_poly_solve(f(x^2-1) = f(0),x);
(%o14)             %union([x = - 1], [x = 1])
@end example

More generally, the assignment @code{one_to_one_reduce['f,'g] : lambda([a,b],
w(a, b) = 0} tells @code{to_poly_solve} that the solution set of @math{f(a)
= f(b)} equals the solution set of @math{w(a,b) = 0}; for example

@example
(%i15) one_to_one_reduce['f,'g] : lambda([a,b], a = 1 + b/2)$

(%i16) to_poly_solve(f(x) - g(x),x);
(%o16)                   %union([x = 2])
@end example

Additionally, the function @code{to_poly_solve} uses data stored in the hashed array 
@code{function_inverse} to solve equations of the form @math{f(a) = b}.
The assignment @code{function_inverse['f] : lambda([s], g(s))} 
informs  @code{to_poly_solve} that the solution set to @code{f(x) = b} equals
the solution set to @code{x = g(b)}; two examples:

@example
(%i17) function_inverse['Q] : lambda([s], P(s))$

(%i18) to_poly_solve(Q(x-1) = 2009,x);
(%o18)              %union([x = P(2009) + 1])
(%i19) function_inverse['G] : lambda([s], s+new_variable(integer));
(%o19)       lambda([s], s + new_variable(integer))
(%i20) to_poly_solve(G(x - a) = b,x);
(%o20)             %union([x = b + a + %z125])
@end example


@b{Notes}

@itemize
@item The solve variables needn't be symbols; when @code{fullratsubst} is 
able to appropriately make substitutions, the solve variables can be nonsymbols:
@end itemize

@example
(%i1) to_poly_solve([x^2 + y^2 + x * y = 5, x * y = 8],
                    [x^2 + y^2, x * y]);
                                  2    2
(%o1)           %union([x y = 8, y  + x  = - 3])
@end example

@itemize
@item For equations that involve complex conjugates, the solver automatically
appends the conjugate equations; for example
@end itemize

@example
(%i1) declare(x,complex)$

(%i2) to_poly_solve(x + (5 + %i) * conjugate(x) = 1, x);
                                   %i + 21
(%o2)              %union([x = - -----------])
                                 25 %i - 125
(%i3) declare(y,complex)$

(%i4) to_poly_solve(set(conjugate(x) - y = 42 + %i,
                        x + conjugate(y) = 0), set(x,y));
                           %i - 42        %i + 42
(%o4)        %union([x = - -------, y = - -------])
                              2              2
@end example

@itemize
@item For an equation that involves the absolute value function, the
@code{to_poly_solve} consults the fact database to decide if the
argument to the absolute value is complex valued.  When

@example
(%i1) to_poly_solve(abs(x) = 6, x);
(%o1)              %union([x = - 6], [x = 6])
(%i2) declare(z,complex)$

(%i3) to_poly_solve(abs(z) = 6, z);
(%o3) %union(%if((%c11 # 0) %and (%c11 conjugate(%c11) - 36 = 
                                       0), [z = %c11], %union()))
@end example

@i{This is the only situation that the solver consults the fact database.  If
a solve variable is declared to be an integer, for example, @code{to_poly_solve}
ignores this declaration}.
@end itemize

@b{Relevant option variables} @i{algexact, resultant, algebraic}

@b{Related functions} @i{to_poly}

@b{To use} @file{load(to_poly_solve)}

@b{Status:} The function @code{to_poly_solve} is experimental; its
specifications might change and its functionality might be merged into
other Maxima functions.
@end deffn

@anchor{%union}
@deffn {Operator} %union (@var{soln_1}, @var{soln_2}, @var{soln_3}, ...)
@deffnx {Operator} %union ()

@code{%union(@var{soln_1}, @var{soln_2}, @var{soln_3}, ...)} represents the union of its arguments,
each of which represents a solution set,
as determined by @code{to_poly_solve}.
@code{%union()} represents the empty set.

In many cases, a solution is a list of equations @code{[@var{x} = ..., @var{y} = ..., @var{z} = ...]}
where @var{x}, @var{y}, and @var{z} are one or more unknowns.
In such cases, @code{to_poly_solve} returns a @code{%union} expression
containing one or more such lists.

The solution set sometimes involves simplifing versions of various
of logical operators including @code{%and}, @code{%or}, or @code{%if}
for conjunction, disjuntion, and implication, respectively.

Examples:

@code{%union(...)} represents the union of its arguments,
each of which represents a solution set,
as determined by @code{to_poly_solve}.
In many cases, a solution is a list of equations.

@c ===beg===
@c load ("to_poly_solve") $
@c to_poly_solve ([sqrt(x^2 - y^2), x + y], [x, y]);
@c ===end===
@example
(%i1) load ("to_poly_solve") $
(%i2) to_poly_solve ([sqrt(x^2 - y^2), x + y], [x, y]);
(%o2)    %union([x = 0, y = 0], [x = %c13, y = - %c13])
@end example

@code{%union()} represents the empty set.

@c ===beg===
@c load ("to_poly_solve") $
@c to_poly_solve (abs(x) = -1, x);
@c ===end===
@example
(%i1) load ("to_poly_solve") $
(%i2) to_poly_solve (abs(x) = -1, x);
(%o2)                       %union()
@end example

The solution set sometimes involves simplifing versions of various
of logical operators.

@c ===beg===
@c load ("to_poly_solve") $
@c sol : to_poly_solve (abs(x) = a, x);
@c subst (a = 42, sol);
@c subst (a = -42, sol);
@c ===end===
@example
(%i1) load ("to_poly_solve") $
(%i2) sol : to_poly_solve (abs(x) = a, x);
(%o2) %union(%if(isnonnegative_p(a), [x = - a], %union()), 
                      %if(isnonnegative_p(a), [x = a], %union()))
(%i3) subst (a = 42, sol);
(%o3)             %union([x = - 42], [x = 42])
(%i4) subst (a = -42, sol);
(%o4)                       %union()
@end example

@end deffn