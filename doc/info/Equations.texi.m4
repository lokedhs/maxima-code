@c -*- Mode: texinfo -*-
@menu
* Functions and Variables for Equations::   
@end menu

@c -----------------------------------------------------------------------------
@node Functions and Variables for Equations,  , Equations, Equations
@section Functions and Variables for Equations
@c -----------------------------------------------------------------------------

@anchor{%rnum}
@defvr {System variable} %rnum
Default value: @code{0}

@code{%rnum} is the counter for the @code{%r} variables introduced in solutions by
@mref{solve} and @mrefdot{algsys}.  The next @code{%r} variable is numbered
@code{%rnum+1}.

See also @mref{%rnum_list}.

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{%rnum_list}
@defvr {System variable} %rnum_list
Default value: @code{[]}

@code{%rnum_list} is the list of variables introduced in solutions by
@mref{solve} and @mrefdot{algsys}  @code{%r} variables are added to
@code{%rnum_list} in the order they are created.  This is convenient for doing
substitutions into the solution later on.

See also @mref{%rnum}.

@c WHAT DOES THIS STATEMENT MEAN ??
It's recommended to use this list rather than doing @code{concat ('%r, j)}.

@c ===beg===
@c solve ([x + y = 3], [x,y]);
@c %rnum_list;
@c sol : solve ([x + 2*y + 3*z = 4], [x,y,z]);
@c %rnum_list;
@c for i : 1 thru length (%rnum_list) do
@c   sol : subst (t[i], %rnum_list[i], sol)$
@c sol;
@c ===end===
@example
@group
(%i1) solve ([x + y = 3], [x,y]);
(%o1)              [[x = 3 - %r1, y = %r1]]
@end group
@group
(%i2) %rnum_list;
(%o2)                       [%r1]
@end group
@group
(%i3) sol : solve ([x + 2*y + 3*z = 4], [x,y,z]);
(%o3)   [[x = - 2 %r3 - 3 %r2 + 4, y = %r3, z = %r2]]
@end group
@group
(%i4) %rnum_list;
(%o4)                     [%r2, %r3]
@end group
@group
(%i5) for i : 1 thru length (%rnum_list) do
        sol : subst (t[i], %rnum_list[i], sol)$
@end group
@group
(%i6) sol;
(%o6)     [[x = - 2 t  - 3 t  + 4, y = t , z = t ]]
                     2      1           2       1
@end group
@end example

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{algepsilon}
@defvr {Option variable} algepsilon
Default value: 10^8

@c WHAT IS algepsilon, EXACTLY ??? describe ("algsys") IS NOT VERY INFORMATIVE !!!
@code{algepsilon} is used by @mrefdot{algsys}

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{algexact}
@defvr {Option variable} algexact
Default value: @code{false}

@code{algexact} affects the behavior of @mref{algsys} as follows:

If @code{algexact} is @code{true}, @code{algsys} always calls @mref{solve} and
then uses @mref{realroots} on @code{solve}'s failures.

If @code{algexact} is @code{false}, @code{solve} is called only if the
eliminant was not univariate, or if it was a quadratic or biquadratic.

Thus @code{algexact: true} does not guarantee only exact solutions, just that
@code{algsys} will first try as hard as it can to give exact solutions, and
only yield approximations when all else fails.

@c ABOVE DESCRIPTION NOT TOO CLEAR -- MAYBE EXAMPLES WILL HELP

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{algsys}
@deffn  {Function} algsys @
@fname{algsys} ([@var{expr_1}, @dots{}, @var{expr_m}], [@var{x_1}, @dots{}, @var{x_n}]) @
@fname{algsys} ([@var{eqn_1}, @dots{}, @var{eqn_m}], [@var{x_1}, @dots{}, @var{x_n}])

Solves the simultaneous polynomials @var{expr_1}, @dots{}, @var{expr_m} or
polynomial equations @var{eqn_1}, @dots{}, @var{eqn_m} for the variables
@var{x_1}, @dots{}, @var{x_n}.  An expression @var{expr} is equivalent to an
equation @code{@var{expr} = 0}.  There may be more equations than variables or
vice versa.

@code{algsys} returns a list of solutions, with each solution given as a list
of equations stating values of the variables @var{x_1}, @dots{}, @var{x_n}
which satisfy the system of equations.  If @code{algsys} cannot find a solution,
an empty list @code{[]} is returned.

The symbols @code{%r1}, @code{%r2}, @dots{}, are introduced as needed to
represent arbitrary parameters in the solution; these variables are also
appended to the list @mrefdot{%rnum_list}

The method is as follows:

@enumerate
@item
First the equations are factored and split into subsystems.

@item
For each subsystem @var{S_i}, an equation @var{E} and a variable @var{x} are
selected.  The variable is chosen to have lowest nonzero degree.  Then the
resultant of @var{E} and @var{E_j} with respect to @var{x} is computed for each
of the remaining equations @var{E_j} in the subsystem @var{S_i}.  This yields a
new subsystem @var{S_i'} in one fewer variables, as @var{x} has been eliminated.
The process now returns to (1).

@item
Eventually, a subsystem consisting of a single equation is obtained.  If the
equation is multivariate and no approximations in the form of floating point
numbers have been introduced, then @mref{solve} is called to find an exact
solution.

In some cases, @code{solve} is not be able to find a solution, or if it does
the solution may be a very large expression.

@c REMAINDER OF (3) IS PRETTY COMPLEX. HOW CAN IT BE CLARIFIED ??
If the equation is univariate and is either linear, quadratic, or biquadratic,
then again @code{solve} is called if no approximations have been introduced.
If approximations have been introduced or the equation is not univariate and
neither linear, quadratic, or biquadratic, then if the switch
@mref{realonly} is @code{true}, the function @mref{realroots} is called to find
the real-valued solutions.  If @code{realonly} is @code{false}, then
@mref{allroots} is called which looks for real and complex-valued solutions.

If @code{algsys} produces a solution which has fewer significant digits than
required, the user can change the value of @mref{algepsilon} to a higher value.

If @code{algexact} is set to @code{true}, @code{solve} will always be called.
@c algepsilon IS IN Floating.texi -- MAY WANT TO BRING IT INTO THIS FILE

@item
Finally, the solutions obtained in step (3) are substituted into
previous levels and the solution process returns to (1).
@c "PREVIOUS LEVELS" -- WHAT ARE THOSE ??
@end enumerate

When @code{algsys} encounters a multivariate equation which contains floating
point approximations (usually due to its failing to find exact solutions at an
earlier stage), then it does not attempt to apply exact methods to such
equations and instead prints the message:
"@code{algsys} cannot solve - system too complicated."

Interactions with @mref{radcan} can produce large or complicated expressions.
In that case, it may be possible to isolate parts of the result with
@mref{pickapart} or @mrefdot{reveal}

Occasionally, @code{radcan} may introduce an imaginary unit @code{%i} into a
solution which is actually real-valued.

Examples:

@c ===beg===
@c e1: 2*x*(1 - a1) - 2*(x - 1)*a2;
@c e2: a2 - a1;
@c e3: a1*(-y - x^2 + 1);
@c e4: a2*(y - (x - 1)^2);
@c algsys ([e1, e2, e3, e4], [x, y, a1, a2]);
@c e1: x^2 - y^2;
@c e2: -1 - y + 2*y^2 - x + x^2;
@c algsys ([e1, e2], [x, y]);
@c ===end===
@example
(%i1) e1: 2*x*(1 - a1) - 2*(x - 1)*a2;
(%o1)              2 (1 - a1) x - 2 a2 (x - 1)
(%i2) e2: a2 - a1; 
(%o2)                        a2 - a1
(%i3) e3: a1*(-y - x^2 + 1); 
                                   2
(%o3)                   a1 (- y - x  + 1)
(%i4) e4: a2*(y - (x - 1)^2);
                                       2
(%o4)                   a2 (y - (x - 1) )
(%i5) algsys ([e1, e2, e3, e4], [x, y, a1, a2]);
(%o5) [[x = 0, y = %r1, a1 = 0, a2 = 0], 

                                  [x = 1, y = 0, a1 = 1, a2 = 1]]
(%i6) e1: x^2 - y^2;
                              2    2
(%o6)                        x  - y
(%i7) e2: -1 - y + 2*y^2 - x + x^2;
                         2        2
(%o7)                 2 y  - y + x  - x - 1
(%i8) algsys ([e1, e2], [x, y]);
                 1            1
(%o8) [[x = - -------, y = -------], 
              sqrt(3)      sqrt(3)

        1              1             1        1
[x = -------, y = - -------], [x = - -, y = - -], [x = 1, y = 1]]
     sqrt(3)        sqrt(3)          3        3
@end example

@opencatbox
@category{Algebraic equations}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{allroots}
@deffn  {Function} allroots @
@fname{allroots} (@var{expr}) @
@fname{allroots} (@var{eqn})

Computes numerical approximations of the real and complex roots of the
polynomial @var{expr} or polynomial equation @var{eqn} of one variable.

The flag @mref{polyfactor} when @code{true} causes @code{allroots} to factor
the polynomial over the real numbers if the polynomial is real, or over the
complex numbers, if the polynomial is complex.

@code{allroots} may give inaccurate results in case of multiple roots.
If the polynomial is real, @code{allroots (%i*@var{p})} may yield
more accurate approximations than @code{allroots (@var{p})}, as @code{allroots}
invokes a different algorithm in that case.

@code{allroots} rejects non-polynomials.  It requires that the numerator
after @code{rat}'ing should be a polynomial, and it requires that the
denominator be at most a complex number.  As a result of this @code{allroots}
will always return an equivalent (but factored) expression, if
@code{polyfactor} is @code{true}.

For complex polynomials an algorithm by Jenkins and Traub is used
(Algorithm 419, @i{Comm. ACM}, vol. 15, (1972), p. 97).  For real polynomials
the algorithm used is due to Jenkins (Algorithm 493, @i{ACM TOMS}, vol. 1,
(1975), p.178).

Examples:

@c ===beg===
@c eqn: (1 + 2*x)^3 = 13.5*(1 + x^5);
@c soln: allroots (eqn);
@c for e in soln
@c         do (e2: subst (e, eqn), disp (expand (lhs(e2) - rhs(e2))));
@c polyfactor: true$
@c allroots (eqn);
@c ===end===
@example
(%i1) eqn: (1 + 2*x)^3 = 13.5*(1 + x^5);
                            3          5
(%o1)              (2 x + 1)  = 13.5 (x  + 1)
(%i2) soln: allroots (eqn);
(%o2) [x = .8296749902129361, x = - 1.015755543828121, 

x = .9659625152196369 %i - .4069597231924075, 

x = - .9659625152196369 %i - .4069597231924075, x = 1.0]
(%i3) for e in soln
        do (e2: subst (e, eqn), disp (expand (lhs(e2) - rhs(e2))));
                      - 3.5527136788005E-15

                     - 5.32907051820075E-15

         4.44089209850063E-15 %i - 4.88498130835069E-15

        - 4.44089209850063E-15 %i - 4.88498130835069E-15

                       3.5527136788005E-15

(%o3)                         done
(%i4) polyfactor: true$
(%i5) allroots (eqn);
(%o5) - 13.5 (x - 1.0) (x - .8296749902129361)

                           2
 (x + 1.015755543828121) (x  + .8139194463848151 x

 + 1.098699797110288)
@end example

@opencatbox
@category{Polynomials} @category{Numerical methods}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{bfallroots}
@deffn  {Function} bfallroots @
@fname{bfallroots} (@var{expr}) @
@fname{bfallroots} (@var{eqn})

Computes numerical approximations of the real and complex roots of the
polynomial @var{expr} or polynomial equation @var{eqn} of one variable.

In all respects, @code{bfallroots} is identical to @code{allroots} except
that @code{bfallroots} computes the roots using bigfloats.  See 
@mref{allroots} for more information.

@opencatbox
@category{Polynomials} @category{Numerical methods}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{backsubst}
@defvr {Option variable} backsubst
Default value: @code{true}

@c WHAT IS THE CONTEXT HERE ?? (TO WHICH OTHER FUNCTION DOES THIS APPLY ??)
@c --- According to the documentation, to linsolve
When @code{backsubst} is @code{false}, prevents back substitution in
@mref{linsolve} after the equations have been triangularized.  This may
be helpful in very big problems where back substitution would cause
the generation of extremely large expressions.

@c ===beg===
@c eq1 : x + y + z = 6$
@c eq2 : x - y + z = 2$
@c eq3 : x + y - z = 0$
@c backsubst : false$
@c linsolve ([eq1, eq2, eq3], [x,y,z]);
@c backsubst : true$
@c linsolve ([eq1, eq2, eq3], [x,y,z]);
@c ===end===
@example
(%i1) eq1 : x + y + z = 6$
(%i2) eq2 : x - y + z = 2$
(%i3) eq3 : x + y - z = 0$
(%i4) backsubst : false$
@group
(%i5) linsolve ([eq1, eq2, eq3], [x,y,z]);
(%o5)             [x = z - y, y = 2, z = 3]
@end group
(%i6) backsubst : true$
@group
(%i7) linsolve ([eq1, eq2, eq3], [x,y,z]);
(%o7)               [x = 1, y = 2, z = 3]
@end group
@end example

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{breakup}
@defvr {Option variable} breakup
Default value: @code{true}

When @code{breakup} is @code{true}, @mref{solve} expresses solutions of cubic
and quartic equations in terms of common subexpressions, which are assigned to
intermediate expression labels (@code{%t1}, @code{%t2}, etc.).
Otherwise, common subexpressions are not identified.

@code{breakup: true} has an effect only when @mref{programmode} is @code{false}.

Examples:

@example
(%i1) programmode: false$
(%i2) breakup: true$
(%i3) solve (x^3 + x^2 - 1);

                        sqrt(23)    25 1/3
(%t3)                  (--------- + --)
                        6 sqrt(3)   54
Solution:

                                      sqrt(3) %i   1
                                      ---------- - -
                sqrt(3) %i   1            2        2   1
(%t4)    x = (- ---------- - -) %t3 + -------------- - -
                    2        2            9 %t3        3

                                      sqrt(3) %i   1
                                    - ---------- - -
              sqrt(3) %i   1              2        2   1
(%t5)    x = (---------- - -) %t3 + ---------------- - -
                  2        2             9 %t3         3

                                   1     1
(%t6)                  x = %t3 + ----- - -
                                 9 %t3   3
(%o6)                    [%t4, %t5, %t6]
(%i6) breakup: false$
(%i7) solve (x^3 + x^2 - 1);
Solution:

             sqrt(3) %i   1
             ---------- - -
                 2        2        sqrt(23)    25 1/3
(%t7) x = --------------------- + (--------- + --)
             sqrt(23)    25 1/3    6 sqrt(3)   54
          9 (--------- + --)
             6 sqrt(3)   54

                                              sqrt(3) %i   1    1
                                           (- ---------- - -) - -
                                                  2        2    3
@group
           sqrt(23)    25 1/3  sqrt(3) %i   1
(%t8) x = (--------- + --)    (---------- - -)
           6 sqrt(3)   54          2        2

                                            sqrt(3) %i   1
                                          - ---------- - -
                                                2        2      1
                                      + --------------------- - -
                                           sqrt(23)    25 1/3   3
                                        9 (--------- + --)
                                           6 sqrt(3)   54
@end group
            sqrt(23)    25 1/3             1             1
(%t9)  x = (--------- + --)    + --------------------- - -
            6 sqrt(3)   54          sqrt(23)    25 1/3   3
                                 9 (--------- + --)
                                    6 sqrt(3)   54
(%o9)                    [%t7, %t8, %t9]
@end example

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{dimension}
@deffn  {Function} dimension @
@fname{dimension} (@var{eqn}) @
@fname{dimension} (@var{eqn_1}, @dots{}, @var{eqn_n})

@code{dimen} is a package for dimensional analysis.
@code{load ("dimen")} loads this package.
@code{demo ("dimen")} displays a short demonstration.
@c I GUESS THIS SHOULD BE EXPANDED TO COVER EACH FUNCTION IN THE PACKAGE

@opencatbox
@category{Share packages}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{dispflag}
@defvr {Option variable} dispflag
Default value: @code{true}

@c WHAT DOES THIS MEAN ??
If set to @code{false} within a @code{block} will inhibit the display of output
generated by the solve functions called from within the @code{block}.
Termination of the @code{block} with a dollar sign, @code{$}, sets @code{dispflag} to
@code{false}.

@opencatbox
@category{Algebraic equations} @category{Display flags and variables}
@closecatbox
@end defvr

@c THIS COULD BENEFIT FROM REPHRASING

@c -----------------------------------------------------------------------------
@anchor{funcsolve}
@deffn {Function} funcsolve (@var{eqn}, @var{g}(@var{t}))

Returns @code{[@var{g}(@var{t}) = ...]}  or @code{[]}, depending on whether
or not there exists a rational function @code{@var{g}(@var{t})} satisfying
@var{eqn}, which must be a first order, linear polynomial in (for this case)
@code{@var{g}(@var{t})} and @code{@var{g}(@var{t}+1)}

@c ===beg===
@c eqn: (n + 1)*f(n) - (n + 3)*f(n + 1)/(n + 1) =
@c      (n - 1)/(n + 2);
@c funcsolve (eqn, f(n));
@c ===end===
@example
(%i1) eqn: (n + 1)*f(n) - (n + 3)*f(n + 1)/(n + 1) =
      (n - 1)/(n + 2);
                            (n + 3) f(n + 1)   n - 1
(%o1)        (n + 1) f(n) - ---------------- = -----
                                 n + 1         n + 2
(%i2) funcsolve (eqn, f(n));

Dependent equations eliminated:  (4 3)
                                   n
(%o2)                f(n) = ---------------
                            (n + 1) (n + 2)
@end example

Warning: this is a very rudimentary implementation -- many safety checks
and obvious generalizations are missing.

@opencatbox
@category{Algebraic equations}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{globalsolve}
@defvr {Option variable} globalsolve
Default value: @code{false}

When @code{globalsolve} is @code{true}, solved-for variables are assigned the
solution values found by @code{linsolve}, and by @mref{solve} when solving two
or more linear equations.

When @code{globalsolve} is @code{false}, solutions found by @mref{linsolve} and
by @code{solve} when solving two or more linear equations are expressed as
equations, and the solved-for variables are not assigned.

When solving anything other than two or more linear equations, @code{solve}
ignores @code{globalsolve}.  Other functions which solve equations (e.g.,
@mref{algsys}) always ignore @code{globalsolve}.

Examples:

@c ===beg===
@c globalsolve: true$
@c solve ([x + 3*y = 2, 2*x - y = 5], [x, y]);
@c x;
@c y;
@c globalsolve: false$
@c kill (x, y)$
@c solve ([x + 3*y = 2, 2*x - y = 5], [x, y]);
@c x;
@c y;
@c ===end===
@example
(%i1) globalsolve: true$
(%i2) solve ([x + 3*y = 2, 2*x - y = 5], [x, y]);
Solution

                                 17
(%t2)                        x : --
                                 7

                                   1
(%t3)                        y : - -
                                   7
(%o3)                     [[%t2, %t3]]
(%i3) x;
                               17
(%o3)                          --
                               7
(%i4) y;
                                 1
(%o4)                          - -
                                 7
(%i5) globalsolve: false$
(%i6) kill (x, y)$
(%i7) solve ([x + 3*y = 2, 2*x - y = 5], [x, y]);
Solution

                                 17
(%t7)                        x = --
                                 7

                                   1
(%t8)                        y = - -
                                   7
(%o8)                     [[%t7, %t8]]
(%i8) x;
(%o8)                           x
(%i9) y;
(%o9)                           y
@end example

@opencatbox
@category{Linear equations}
@closecatbox
@end defvr

@c THIS DESCRIPTION NEEDS WORK AND EXAMPLES
@c MERGE IN TEXT FROM share/integequations/inteqn.usg
@c AND EXAMPLES FROM .../intexs.mac

@c --- I'm not sure that all examples from share/integequations/intexs.mac
@c are handled correctly by ieqn.

@c -----------------------------------------------------------------------------
@anchor{ieqn}
@deffn {Function} ieqn (@var{ie}, @var{unk}, @var{tech}, @var{n}, @var{guess})

@code{inteqn} is a package for solving integral equations.
@code{load ("inteqn")} loads this package.
 
@var{ie} is the integral equation; @var{unk} is the unknown function; @var{tech}
is the technique to be tried from those given above (@var{tech} = @code{first}
means: try the first technique which finds a solution; @var{tech} = @code{all}
means: try all applicable techniques); @var{n} is the maximum number of terms
to take for @code{taylor}, @code{neumann}, @code{firstkindseries}, or
@code{fredseries} (it is also the maximum depth of recursion for the
differentiation method); @var{guess} is the initial guess for @code{neumann} or
@code{firstkindseries}.

Default values for the 2nd thru 5th parameters are:

@var{unk}: @code{@var{p}(@var{x})}, where @var{p} is the first function
encountered in an integrand which is unknown to Maxima and @var{x} is the
variable which occurs as an argument to the first occurrence of @var{p} found
outside of an integral in the case of @code{secondkind} equations, or is the
only other variable besides the variable of integration in @code{firstkind}
equations.  If the attempt to search for @var{x} fails, the user will be asked
to supply the independent variable.

tech: @code{first}

n: 1

guess: @code{none} which will cause @code{neumann} and @code{firstkindseries}
to use @code{@var{f}(@var{x})} as an initial guess.

@opencatbox
@category{Integral equations}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{ieqnprint}
@defvr {Option variable} ieqnprint
Default value: @code{true}

@code{ieqnprint} governs the behavior of the result returned by the
@mref{ieqn} command.  When @code{ieqnprint} is @code{false}, the lists returned
by the @code{ieqn} function are of the form

   [@var{solution}, @var{technique used}, @var{nterms}, @var{flag}]

where @var{flag} is absent if the solution is exact.

Otherwise, it is the word @code{approximate} or @code{incomplete} corresponding
to an inexact or non-closed form solution, respectively.  If a series method was
used, @var{nterms} gives the number of terms taken (which could be less than
the n given to @code{ieqn} if an error prevented generation of further terms).

@opencatbox
@category{Integral equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{lhs}
@deffn {Function} lhs (@var{expr})

Returns the left-hand side (that is, the first argument) of the expression
@var{expr}, when the operator of @var{expr} is one of the relational operators
@code{< <= = # equal notequal >= >},
@c MENTION -> (MARROW) IN THIS LIST IF/WHEN THE PARSER RECOGNIZES IT
one of the assignment operators @code{:= ::= : ::}, or a user-defined binary
infix operator, as declared by @mrefdot{infix}

When @var{expr} is an atom or its operator is something other than the ones
listed above, @code{lhs} returns @var{expr}.

See also @mrefdot{rhs}

Examples:

@c ===beg===
@c e: aa + bb = cc;
@c lhs (e);
@c rhs (e);
@c [lhs (aa < bb), lhs (aa <= bb), lhs (aa >= bb), 
@c        lhs (aa > bb)];
@c [lhs (aa = bb), lhs (aa # bb), lhs (equal (aa, bb)), 
@c        lhs (notequal (aa, bb))];
@c e1: '(foo(x) := 2*x);
@c e2: '(bar(y) ::= 3*y);
@c e3: '(x : y);
@c e4: '(x :: y);
@c [lhs (e1), lhs (e2), lhs (e3), lhs (e4)];
@c infix ("][");
@c lhs (aa ][ bb);
@c ===end===
@example
(%i1) e: aa + bb = cc;
(%o1)                     bb + aa = cc
(%i2) lhs (e);
(%o2)                        bb + aa
(%i3) rhs (e);
(%o3)                          cc
(%i4) [lhs (aa < bb), lhs (aa <= bb), lhs (aa >= bb),
       lhs (aa > bb)];
(%o4)                   [aa, aa, aa, aa]
(%i5) [lhs (aa = bb), lhs (aa # bb), lhs (equal (aa, bb)),
       lhs (notequal (aa, bb))];
(%o5)                   [aa, aa, aa, aa]
(%i6) e1: '(foo(x) := 2*x);
(%o6)                     foo(x) := 2 x
(%i7) e2: '(bar(y) ::= 3*y);
(%o7)                    bar(y) ::= 3 y
(%i8) e3: '(x : y);
(%o8)                         x : y
(%i9) e4: '(x :: y);
(%o9)                        x :: y
(%i10) [lhs (e1), lhs (e2), lhs (e3), lhs (e4)];
(%o10)               [foo(x), bar(y), x, x]
(%i11) infix ("][");
(%o11)                         ][
(%i12) lhs (aa ][ bb);
(%o12)                         aa
@end example

@opencatbox
@category{Expressions}
@closecatbox
@end deffn

@c REVISIT -- THERE'S PROBABLY MORE TO SAY HERE

@c -----------------------------------------------------------------------------
@anchor{linsolve}
@deffn {Function} linsolve ([@var{expr_1}, @dots{}, @var{expr_m}], [@var{x_1}, @dots{}, @var{x_n}])

Solves the list of simultaneous linear equations for the list of variables.
The expressions must each be polynomials in the variables and may be equations.
If the length of the list of variables doesn't match the number of
linearly-independent equations to solve the result will be an empty list.

When @mref{globalsolve} is @code{true}, each solved-for variable is bound to
its value in the solution of the equations.

When @mref{backsubst} is @code{false}, @code{linsolve} does not carry out back
substitution after the equations have been triangularized.  This may be
necessary in very big problems where back substitution would cause the
generation of extremely large expressions.

When @mref{linsolve_params} is @code{true}, @code{linsolve} also generates the
@code{%r} symbols used to represent arbitrary parameters described in the manual
under @mrefdot{algsys}  Otherwise, @code{linsolve} solves an under-determined
system of equations with some variables expressed in terms of others.

When @mref{programmode} is @code{false}, @code{linsolve} displays the solution
with intermediate expression (@code{%t}) labels, and returns the list of labels.

See also @mrefcomma{algsys} @mrefdot{eliminate} and @mrefdot{solve}

Examples:
@c ===beg===
@c e1: x + z = y;
@c e2: 2*a*x - y = 2*a^2;
@c e3: y - 2*z = 2;
@c [globalsolve: false, programmode: true];
@c linsolve ([e1, e2, e3], [x, y, z]);
@c [globalsolve: false, programmode: false];
@c linsolve ([e1, e2, e3], [x, y, z]);
@c ''%;
@c [globalsolve: true, programmode: false];
@c linsolve ([e1, e2, e3], [x, y, z]);
@c ''%;
@c [x, y, z];
@c [globalsolve: true, programmode: true];
@c linsolve ([e1, e2, e3], '[x, y, z]);
@c [x, y, z];
@c ===end===
@example
(%i1) e1: x + z = y;
(%o1)                       z + x = y
(%i2) e2: 2*a*x - y = 2*a^2;
                                       2
(%o2)                   2 a x - y = 2 a
(%i3) e3: y - 2*z = 2;
(%o3)                      y - 2 z = 2
(%i4) [globalsolve: false, programmode: true];
(%o4)                     [false, true]
(%i5) linsolve ([e1, e2, e3], [x, y, z]);
(%o5)            [x = a + 1, y = 2 a, z = a - 1]
(%i6) [globalsolve: false, programmode: false];
(%o6)                    [false, false]
(%i7) linsolve ([e1, e2, e3], [x, y, z]);
Solution

(%t7)                       z = a - 1

(%t8)                        y = 2 a

(%t9)                       x = a + 1
(%o9)                    [%t7, %t8, %t9]
(%i9) ''%;
(%o9)            [z = a - 1, y = 2 a, x = a + 1]
(%i10) [globalsolve: true, programmode: false];
(%o10)                    [true, false]
(%i11) linsolve ([e1, e2, e3], [x, y, z]);
Solution

(%t11)                      z : a - 1

(%t12)                       y : 2 a

(%t13)                      x : a + 1
(%o13)                 [%t11, %t12, %t13]
(%i13) ''%;
(%o13)           [z : a - 1, y : 2 a, x : a + 1]
(%i14) [x, y, z];
(%o14)                 [a + 1, 2 a, a - 1]
(%i15) [globalsolve: true, programmode: true];
(%o15)                    [true, true]
(%i16) linsolve ([e1, e2, e3], '[x, y, z]);
(%o16)           [x : a + 1, y : 2 a, z : a - 1]
(%i17) [x, y, z];
(%o17)                 [a + 1, 2 a, a - 1]
@end example

@opencatbox
@category{Linear equations}
@closecatbox
@end deffn

@c DO ANY FUNCTIONS OTHER THAN linsolve RESPECT linsolvewarn ??

@c -----------------------------------------------------------------------------
@anchor{linsolvewarn}
@defvr {Option variable} linsolvewarn
Default value: @code{true}

When @code{linsolvewarn} is @code{true}, @mref{linsolve} prints a message
"Dependent equations eliminated".

@opencatbox
@category{Linear equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{linsolve_params}
@defvr {Option variable} linsolve_params
Default value: @code{true}

When @code{linsolve_params} is @code{true}, @mref{linsolve} also generates
the @code{%r} symbols used to represent arbitrary parameters described in
the manual under @mrefdot{algsys}  Otherwise, @code{linsolve} solves an
under-determined system of equations with some variables expressed in terms of
others.

@opencatbox
@category{Linear equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{multiplicities}
@defvr {System variable} multiplicities
Default value: @code{not_set_yet}

@code{multiplicities} is set to a list of the multiplicities of the individual
solutions returned by @mref{solve} or @mrefdot{realroots}
@c NEED AN EXAMPLE HERE

@opencatbox
@category{Algebraic equations} @category{Polynomials}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{nroots}
@deffn {Function} nroots (@var{p}, @var{low}, @var{high})

Returns the number of real roots of the real univariate polynomial @var{p} in
the half-open interval @code{(@var{low}, @var{high}]}.  The endpoints of the
interval may be @code{minf} or @code{inf}.

@code{nroots} uses the method of Sturm sequences.

@c ===beg===
@c p: x^10 - 2*x^4 + 1/2$
@c nroots (p, -6, 9.1);
@c ===end===
@example
(%i1) p: x^10 - 2*x^4 + 1/2$
(%i2) nroots (p, -6, 9.1);
(%o2)                           4
@end example

@opencatbox
@category{Polynomials} @category{Numerical methods}
@closecatbox
@end deffn

@c NEEDS WORK

@c -----------------------------------------------------------------------------
@anchor{nthroot}
@deffn {Function} nthroot (@var{p}, @var{n})

where @var{p} is a polynomial with integer coefficients and @var{n} is a
positive integer returns @code{q}, a polynomial over the integers, such that
@code{q^n = p} or prints an error message indicating that @var{p} is not a
perfect nth power.  This routine is much faster than @mref{factor} or even
@mrefdot{sqfr}

@opencatbox
@category{Polynomials}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{polyfactor}
@defvr {Option variable} polyfactor
Default value: @code{false}

The option variable @code{polyfactor} when @code{true} causes
@mref{allroots} and @mref{bfallroots} to factor the polynomial over the real
numbers if the polynomial is real, or over the complex numbers, if the
polynomial is complex.

See @code{allroots} for an example.

@opencatbox
@category{Polynomials} @category{Numerical methods}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{programmode}
@defvr {Option variable} programmode
Default value: @code{true}

When @code{programmode} is @code{true}, @mrefcomma{solve}@w{}
@mrefcomma{realroots} @mrefcomma{allroots} and @mref{linsolve} return solutions
as elements in a list.
@c WHAT DOES BACKSUBSTITUTION HAVE TO DO WITH RETURN VALUES ??
(Except when @mref{backsubst} is set to @code{false}, in which case
@code{programmode: false} is assumed.)

When @code{programmode} is @code{false}, @code{solve}, etc. create intermediate
expression labels @code{%t1}, @code{%t2}, etc., and assign the solutions to them.
@c NEED AN EXAMPLE HERE

@opencatbox
@category{Algebraic equations} @category{Polynomials}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{realonly}
@defvr {Option variable} realonly
Default value: @code{false}

When @code{realonly} is @code{true}, @mref{algsys} returns only those solutions
which are free of @code{%i}.

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{realroots}
@deffn  {Function} realroots @
@fname{realroots} (@var{expr}, @var{bound}) @
@fname{realroots} (@var{eqn}, @var{bound}) @
@fname{realroots} (@var{expr}) @
@fname{realroots} (@var{eqn})

Computes rational approximations of the real roots of the polynomial @var{expr}
or polynomial equation @var{eqn} of one variable, to within a tolerance of
@var{bound}.  Coefficients of @var{expr} or @var{eqn} must be literal numbers;
symbol constants such as @code{%pi} are rejected.

@code{realroots} assigns the multiplicities of the roots it finds
to the global variable @mrefdot{multiplicities}

@code{realroots} constructs a Sturm sequence to bracket each root, and then
applies bisection to refine the approximations.  All coefficients are converted
to rational equivalents before searching for roots, and computations are carried
out by exact rational arithmetic.  Even if some coefficients are floating-point
numbers, the results are rational (unless coerced to floats by the
@mref{float} or @mref{numer} flags).

When @var{bound} is less than 1, all integer roots are found exactly.
When @var{bound} is unspecified, it is assumed equal to the global variable
@mrefdot{rootsepsilon}

When the global variable @mref{programmode} is @code{true}, @code{realroots}
returns a list of the form @code{[x = @var{x_1}, x = @var{x_2}, ...]}.
When @code{programmode} is @code{false}, @code{realroots} creates intermediate
expression labels @code{%t1}, @code{%t2}, @dots{},
assigns the results to them, and returns the list of labels.

Examples:

@c ===beg===
@c realroots (-1 - x + x^5, 5e-6);
@c ev (%[1], float);
@c ev (-1 - x + x^5, %);
@c ===end===
@example
(%i1) realroots (-1 - x + x^5, 5e-6);
                               612003
(%o1)                     [x = ------]
                               524288
(%i2) ev (%[1], float);
(%o2)                 x = 1.167303085327148
(%i3) ev (-1 - x + x^5, %);
(%o3)                - 7.396496210176905E-6
@end example

@c ===beg===
@c realroots (expand ((1 - x)^5 * (2 - x)^3 * (3 - x)), 1e-20);
@c multiplicities;
@c ===end===
@example
(%i1) realroots (expand ((1 - x)^5 * (2 - x)^3 * (3 - x)), 1e-20);
(%o1)                 [x = 1, x = 2, x = 3]
(%i2) multiplicities;
(%o2)                       [5, 3, 1]
@end example

@opencatbox
@category{Polynomials} @category{Numerical methods}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{rhs}
@deffn {Function} rhs (@var{expr})

Returns the right-hand side (that is, the second argument) of the expression
@var{expr}, when the operator of @var{expr} is one of the relational operators
@code{< <= = # equal notequal >= >},
@c MENTION -> (MARROW) IN THIS LIST IF/WHEN THE PARSER RECOGNIZES IT
one of the assignment operators @code{:= ::= : ::}, or a user-defined binary
infix operator, as declared by @mrefdot{infix}

When @var{expr} is an atom or its operator is something other than the ones
listed above, @code{rhs} returns 0.

See also @mrefdot{lhs}

Examples:

@c ===beg===
@c e: aa + bb = cc;
@c lhs (e);
@c rhs (e);
@c [rhs (aa < bb), rhs (aa <= bb), rhs (aa >= bb), 
@c        rhs (aa > bb)];
@c [rhs (aa = bb), rhs (aa # bb), rhs (equal (aa, bb)), 
@c        rhs (notequal (aa, bb))];
@c e1: '(foo(x) := 2*x);
@c e2: '(bar(y) ::= 3*y);
@c e3: '(x : y);
@c e4: '(x :: y);
@c [rhs (e1), rhs (e2), rhs (e3), rhs (e4)];
@c infix ("][");
@c rhs (aa ][ bb);
@c ===end===
@example
(%i1) e: aa + bb = cc;
(%o1)                     bb + aa = cc
(%i2) lhs (e);
(%o2)                        bb + aa
(%i3) rhs (e);
(%o3)                          cc
(%i4) [rhs (aa < bb), rhs (aa <= bb), rhs (aa >= bb),
       rhs (aa > bb)];
(%o4)                   [bb, bb, bb, bb]
@group
(%i5) [rhs (aa = bb), rhs (aa # bb), rhs (equal (aa, bb)),
       rhs (notequal (aa, bb))];
@end group
(%o5)                   [bb, bb, bb, bb]
(%i6) e1: '(foo(x) := 2*x);
(%o6)                     foo(x) := 2 x
(%i7) e2: '(bar(y) ::= 3*y);
(%o7)                    bar(y) ::= 3 y
(%i8) e3: '(x : y);
(%o8)                         x : y
(%i9) e4: '(x :: y);
(%o9)                        x :: y
(%i10) [rhs (e1), rhs (e2), rhs (e3), rhs (e4)];
(%o10)                  [2 x, 3 y, y, y]
(%i11) infix ("][");
(%o11)                         ][
(%i12) rhs (aa ][ bb);
(%o12)                         bb
@end example

@opencatbox
@category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{rootsconmode}
@defvr {Option variable} rootsconmode
Default value: @code{true}

@code{rootsconmode} governs the behavior of the @code{rootscontract} command.
See @mref{rootscontract} for details.

@opencatbox
@category{Expressions} @category{Simplification flags and variables}
@closecatbox
@end defvr

@c NEEDS WORK

@c -----------------------------------------------------------------------------
@anchor{rootscontract}
@deffn {Function} rootscontract (@var{expr})

Converts products of roots into roots of products.  For example,
@code{rootscontract (sqrt(x)*y^(3/2))} yields @code{sqrt(x*y^3)}.

When @mref{radexpand} is @code{true} and @mref{domain} is @code{real},
@code{rootscontract} converts @mref{abs} into @mrefcomma{sqrt}  e.g.,
@code{rootscontract (abs(x)*sqrt(y))} yields @code{sqrt(x^2*y)}.

There is an option @mref{rootsconmode} affecting @code{rootscontract} as
follows:

@example
Problem            Value of        Result of applying
                  rootsconmode        rootscontract
      
x^(1/2)*y^(3/2)      false          (x*y^3)^(1/2)
x^(1/2)*y^(1/4)      false          x^(1/2)*y^(1/4)
x^(1/2)*y^(1/4)      true           (x*y^(1/2))^(1/2)
x^(1/2)*y^(1/3)      true           x^(1/2)*y^(1/3)
x^(1/2)*y^(1/4)      all            (x^2*y)^(1/4)
x^(1/2)*y^(1/3)      all            (x^3*y^2)^(1/6)
@end example

When @code{rootsconmode} is @code{false}, @code{rootscontract} contracts only
with respect to rational number exponents whose denominators are the same.  The
key to the @code{rootsconmode: true} examples is simply that 2 divides into 4
but not into 3.  @code{rootsconmode: all} involves taking the least common
multiple of the denominators of the exponents.

@code{rootscontract} uses @mref{ratsimp} in a manner similar to
@mrefdot{logcontract}

Examples:

@c ===beg===
@c rootsconmode: false$
@c rootscontract (x^(1/2)*y^(3/2));
@c rootscontract (x^(1/2)*y^(1/4));
@c rootsconmode: true$
@c rootscontract (x^(1/2)*y^(1/4));
@c rootscontract (x^(1/2)*y^(1/3));
@c rootsconmode: all$
@c rootscontract (x^(1/2)*y^(1/4));
@c rootscontract (x^(1/2)*y^(1/3));
@c rootsconmode: false$
@c rootscontract (sqrt(sqrt(x) + sqrt(1 + x))
@c                     *sqrt(sqrt(1 + x) - sqrt(x)));
@c rootsconmode: true$
@c rootscontract (sqrt(5 + sqrt(5)) - 5^(1/4)*sqrt(1 + sqrt(5)));
@c ===end===
@example
(%i1) rootsconmode: false$
(%i2) rootscontract (x^(1/2)*y^(3/2));
                                   3
(%o2)                      sqrt(x y )
(%i3) rootscontract (x^(1/2)*y^(1/4));
                                   1/4
(%o3)                     sqrt(x) y
(%i4) rootsconmode: true$
(%i5) rootscontract (x^(1/2)*y^(1/4));
(%o5)                    sqrt(x sqrt(y))
(%i6) rootscontract (x^(1/2)*y^(1/3));
                                   1/3
(%o6)                     sqrt(x) y
(%i7) rootsconmode: all$
(%i8) rootscontract (x^(1/2)*y^(1/4));
                              2   1/4
(%o8)                       (x  y)
(%i9) rootscontract (x^(1/2)*y^(1/3));
                             3  2 1/6
(%o9)                      (x  y )
(%i10) rootsconmode: false$
(%i11) rootscontract (sqrt(sqrt(x) + sqrt(1 + x))
                    *sqrt(sqrt(1 + x) - sqrt(x)));
(%o11)                          1
(%i12) rootsconmode: true$
(%i13) rootscontract (sqrt(5+sqrt(5)) - 5^(1/4)*sqrt(1+sqrt(5)));
(%o13)                          0
@end example

@opencatbox
@category{Simplification functions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{rootsepsilon}
@defvr {Option variable} rootsepsilon
Default value: 1.0e-7

@code{rootsepsilon} is the tolerance which establishes the confidence interval
for the roots found by the @mref{realroots} function.
@c IS IT GUARANTEED THAT |ACTUAL - ESTIMATE| < rootepsilon OR IS IT SOME OTHER
@c NOTION ?? NEED EXAMPLE HERE

@opencatbox
@category{Polynomials} @category{Numerical methods}
@closecatbox
@end defvr

@c NEEDS WORK

@c -----------------------------------------------------------------------------
@anchor{solve}
@deffn  {Function} solve @
@fname{solve} (@var{expr}, @var{x}) @
@fname{solve} (@var{expr}) @
@fname{solve} ([@var{eqn_1}, @dots{}, @var{eqn_n}], [@var{x_1}, @dots{}, @var{x_n}])

Solves the algebraic equation @var{expr} for the variable @var{x} and returns a
list of solution equations in @var{x}.  If @var{expr} is not an equation, the
equation @code{@var{expr} = 0} is assumed in its place.
@var{x} may be a function (e.g. @code{f(x)}), or other non-atomic expression
except a sum or product.  @var{x} may be omitted if @var{expr} contains only one
variable.  @var{expr} may be a rational expression, and may contain
trigonometric functions, exponentials, etc.

The following method is used:

Let @var{E} be the expression and @var{X} be the variable.  If @var{E} is linear
in @var{X} then it is trivially solved for @var{X}.  Otherwise if @var{E} is of
the form @code{A*X^N + B} then the result is @code{(-B/A)^1/N)} times the
@code{N}'th roots of unity.

If @var{E} is not linear in @var{X} then the gcd of the exponents of @var{X} in
@var{E} (say @var{N}) is divided into the exponents and the multiplicity of the
roots is multiplied by @var{N}.  Then @code{solve} is called again on the
result.  If @var{E} factors then @code{solve} is called on each of the factors.
Finally @code{solve} will use the quadratic, cubic, or quartic formulas where
necessary.

In the case where @var{E} is a polynomial in some function of the variable to be
solved for, say @code{F(X)}, then it is first solved for @code{F(X)} (call the
result @var{C}), then the equation @code{F(X)=C} can be solved for @var{X}
provided the inverse of the function @var{F} is known.

@mref{breakup} if @code{false} will cause @code{solve} to express the solutions
of cubic or quartic equations as single expressions rather than as made
up of several common subexpressions which is the default.

@mref{multiplicities} - will be set to a list of the multiplicities of the
individual solutions returned by @code{solve}, @mrefcomma{realroots} or
@mrefdot{allroots}  Try @code{apropos (solve)} for the switches which affect
@code{solve}.  @mref{describe} may then by used on the individual switch names
if their purpose is not clear.

@code{solve ([@var{eqn_1}, ..., @var{eqn_n}], [@var{x_1}, ..., @var{x_n}])}
solves a system of simultaneous (linear or non-linear) polynomial equations by
calling @mref{linsolve} or @mref{algsys} and returns a list of the solution
lists in the variables.  In the case of @mref{linsolve} this list would contain
a single list of solutions.  It takes two lists as arguments.  The first list
represents the equations to be solved; the second list is a
list of the unknowns to be determined.  If the total number of
variables in the equations is equal to the number of equations, the
second argument-list may be omitted.

@c I think this is not true --hgeyer
@c 
@c if no unique
@c solution exists, then @code{singular} will be displayed.

When @mref{programmode} is @code{false}, @code{solve} displays solutions with
intermediate expression (@code{%t}) labels, and returns the list of labels.

When @mref{globalsolve} is @code{true} and the problem is to solve two or more
linear equations, each solved-for variable is bound to its value in the solution
of the equations.

Examples:

@c FOLLOWING ADAPTED FROM example (solve)
@c ===beg===
@c solve (asin (cos (3*x))*(f(x) - 1), x);
@c ev (solve (5^f(x) = 125, f(x)), solveradcan);
@c [4*x^2 - y^2 = 12, x*y - x = 2];
@c solve (%, [x, y]);
@c solve (1 + a*x + x^3, x);
@c solve (x^3 - 1);
@c solve (x^6 - 1);
@c ev (x^6 - 1, %[1]);
@c expand (%);
@c x^2 - 1;
@c solve (%, x);
@c ev (%th(2), %[1]);
@c ===end===
@example
(%i1) solve (asin (cos (3*x))*(f(x) - 1), x);

solve: using arc-trig functions to get a solution.
Some solutions will be lost.
                            %pi
(%o1)                  [x = ---, f(x) = 1]
                             6
(%i2) ev (solve (5^f(x) = 125, f(x)), solveradcan);
                                log(125)
(%o2)                   [f(x) = --------]
                                 log(5)
(%i3) [4*x^2 - y^2 = 12, x*y - x = 2];
                      2    2
(%o3)             [4 x  - y  = 12, x y - x = 2]

(%i4) solve (%, [x, y]);
(%o4) [[x = 2, y = 2], [x = .5202594388652008 %i
 - .1331240357358706, y = .07678378523787788
 - 3.608003221870287 %i], [x = - .5202594388652008 %i
 - .1331240357358706, y = 3.608003221870287 %i
 + .07678378523787788], [x = - 1.733751846381093, 
y = - .1535675710019696]]

(%i5) solve (1 + a*x + x^3, x);

                                       3
              sqrt(3) %i   1   sqrt(4 a  + 27)   1 1/3
(%o5) [x = (- ---------- - -) (--------------- - -)
                  2        2      6 sqrt(3)      2

        sqrt(3) %i   1
       (---------- - -) a
            2        2
 - --------------------------, x = 
              3
      sqrt(4 a  + 27)   1 1/3
   3 (--------------- - -)
         6 sqrt(3)      2

                          3
 sqrt(3) %i   1   sqrt(4 a  + 27)   1 1/3
(---------- - -) (--------------- - -)
     2        2      6 sqrt(3)      2

         sqrt(3) %i   1
      (- ---------- - -) a
             2        2
 - --------------------------, x = 
              3
      sqrt(4 a  + 27)   1 1/3
   3 (--------------- - -)
         6 sqrt(3)      2

         3
 sqrt(4 a  + 27)   1 1/3               a
(--------------- - -)    - --------------------------]
    6 sqrt(3)      2                  3
                              sqrt(4 a  + 27)   1 1/3
                           3 (--------------- - -)
                                 6 sqrt(3)      2
(%i6) solve (x^3 - 1);
             sqrt(3) %i - 1        sqrt(3) %i + 1
(%o6)   [x = --------------, x = - --------------, x = 1]
                   2                     2
(%i7) solve (x^6 - 1);
           sqrt(3) %i + 1      sqrt(3) %i - 1
(%o7) [x = --------------, x = --------------, x = - 1, 
                 2                   2

                     sqrt(3) %i + 1        sqrt(3) %i - 1
               x = - --------------, x = - --------------, x = 1]
                           2                     2
(%i8) ev (x^6 - 1, %[1]);
@group
                                      6
                      (sqrt(3) %i + 1)
(%o8)                 ----------------- - 1
                             64
@end group
(%i9) expand (%);
(%o9)                           0
(%i10) x^2 - 1;
                              2
(%o10)                       x  - 1
(%i11) solve (%, x);
(%o11)                  [x = - 1, x = 1]
(%i12) ev (%th(2), %[1]);
(%o12)                          0
@end example

The symbols @code{%r} are used to denote arbitrary constants in a solution.

@c ===beg===
@c solve([x+y=1,2*x+2*y=2],[x,y]);
@c ===end===
@example
(%i1) solve([x+y=1,2*x+2*y=2],[x,y]);

solve: dependent equations eliminated: (2)
(%o1)                      [[x = 1 - %r1, y = %r1]]
@end example

See @mref{algsys} and @mref{%rnum_list} for more information.

@opencatbox
@category{Algebraic equations}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{solvedecomposes}
@defvr {Option variable} solvedecomposes
Default value: @code{true}

When @code{solvedecomposes} is @code{true}, @code{solve} calls
@mref{polydecomp} if asked to solve polynomials.
@c OTHERWISE WHAT HAPPENS -- CAN'T SOLVE POLYNOMIALS, OR SOME OTHER METHOD IS USED ??

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{solveexplicit}
@defvr {Option variable} solveexplicit
Default value: @code{false}

When @code{solveexplicit} is @code{true}, inhibits @mref{solve} from returning
implicit solutions, that is, solutions of the form @code{F(x) = 0} where
@code{F} is some function.
@c NEED AN EXAMPLE HERE

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{solvefactors}
@defvr {Option variable} solvefactors
Default value: @code{true}

@c WHAT IS THIS ABOUT EXACTLY ??
When @code{solvefactors} is @code{false}, @mref{solve} does not try to factor
the expression.  The @code{false} setting may be desired in some cases where
factoring is not necessary.
@c NEED AN EXAMPLE HERE

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{solvenullwarn}
@defvr {Option variable} solvenullwarn
Default value: @code{true}

When @code{solvenullwarn} is @code{true}, @mref{solve} prints a warning message
if called with either a null equation list or a null variable list.  For
example, @code{solve ([], [])} would print two warning messages and return
@code{[]}.

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{solveradcan}
@defvr {Option variable} solveradcan
Default value: @code{false}

When @code{solveradcan} is @code{true}, @mref{solve} calls @mref{radcan}@w{}
which makes @code{solve} slower but will allow certain problems containing
exponentials and logarithms to be solved.
@c NEED AN EXAMPLE HERE

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{solvetrigwarn}
@defvr {Option variable} solvetrigwarn
Default value: @code{true}

@c MAYBE THIS CAN BE CLARIFIED
When @code{solvetrigwarn} is @code{true}, @mref{solve} may print a message
saying that it is using inverse trigonometric functions to solve the equation,
and thereby losing solutions.
@c NEED AN EXAMPLE HERE

@opencatbox
@category{Algebraic equations}
@closecatbox
@end defvr
