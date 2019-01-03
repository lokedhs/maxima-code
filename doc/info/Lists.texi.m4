@c -*- Mode: texinfo -*-
@c -----------------------------------------------------------------------------
@page
@node Lists, Arrays, Constants, Data Types and Structures
@section Lists
@c -----------------------------------------------------------------------------

@menu
* Introduction to Lists::
* Functions and Variables for Lists::
* Performance considerations for Lists::
@end menu

@c -----------------------------------------------------------------------------
@node Introduction to Lists, Functions and Variables for Lists, Lists, Lists
@subsection Introduction to Lists
@c -----------------------------------------------------------------------------

Lists are the basic building block for Maxima and Lisp.  All data types
other than arrays, @mref{hashed arrays} and numbers are represented as Lisp lists,
These Lisp lists have the form

@example
((MPLUS) $A 2)
@end example

@noindent
to indicate an expression @code{a+2}.  At Maxima level one would see
the infix notation @code{a+2}.  Maxima also has lists which are printed
as

@example
[1, 2, 7, x+y]
@end example

@noindent
for a list with 4 elements.  Internally this corresponds to a Lisp list
of the form

@example
((MLIST) 1 2 7 ((MPLUS) $X $Y))
@end example

@noindent
The flag which denotes the type field of the Maxima expression is a list
itself, since after it has been through the simplifier the list would become

@example
((MLIST SIMP) 1 2 7 ((MPLUS SIMP) $X $Y))
@end example

@c -----------------------------------------------------------------------------
@node Functions and Variables for Lists, Performance considerations for Lists ,Introduction to Lists, Lists
@subsection Functions and Variables for Lists
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
@anchor{[}
@anchor{]}
@fnindex List delimiters
@fnindex Subscript operator

@defvr  {Operator} [
@defvrx {Operator} ]

@code{[} and @code{]} mark the beginning and end, respectively, of a list.

@code{[} and @code{]} also enclose the subscripts of
a list, array, @mrefcomma{hashed array} or @mrefdot{memoizing function} Note that
other than for arrays accessing the @code{n}th element of a list
may need an amount of time that is roughly proportional to  @code{n},
@xref{Performance considerations for Lists}.

Note that if an element of a subscripted variable is written to before
a list or an array of this name is declared a @mref{hashed array}
(@pxref{Arrays}) is created, not a list.

Examples:

@c ===beg===
@c x: [a, b, c];
@c x[3];
@c array (y, fixnum, 3);
@c y[2]: %pi;
@c y[2];
@c z['foo]: 'bar;
@c z['foo];
@c g[k] := 1/(k^2+1);
@c g[10];
@c ===end===
@example
@group
(%i1) x: [a, b, c];
(%o1)                       [a, b, c]
@end group
@group
(%i2) x[3];
(%o2)                           c
@end group
@group
(%i3) array (y, fixnum, 3);
(%o3)                           y
@end group
@group
(%i4) y[2]: %pi;
(%o4)                          %pi
@end group
@group
(%i5) y[2];
(%o5)                          %pi
@end group
@group
(%i6) z['foo]: 'bar;
(%o6)                          bar
@end group
@group
(%i7) z['foo];
(%o7)                          bar
@end group
@group
(%i8) g[k] := 1/(k^2+1);
                                  1
(%o8)                     g  := ------
                           k     2
                                k  + 1
@end group
@group
(%i9) g[10];
                                1
(%o9)                          ---
                               101
@end group
@end example

@opencatbox
@category{Lists} @category{Operators}
@closecatbox
@end defvr

@c NEED ANOTHER deffn FOR GENERAL EXPRESSIONS ARGUMENTS
@c NEEDS CLARIFICATION AND EXAMPLES

@c -----------------------------------------------------------------------------
@anchor{append}
@deffn {Function} append (@var{list_1}, @dots{}, @var{list_n})

Returns a single list of the elements of @var{list_1} followed
by the elements of @var{list_2}, @dots{}  @code{append} also works on
general expressions, e.g. @code{append (f(a,b), f(c,d,e));} yields
@code{f(a,b,c,d,e)}.

See also @mrefcomma{addrow} @mref{addcol} and @mrefdot{join}

Do @code{example(append);} for an example.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c NEEDS CLARIFICATION AND EXAMPLES

@c -----------------------------------------------------------------------------
@anchor{assoc}
@deffn {Function} assoc @
@fname{assoc} (@var{key}, @var{list}, @var{default}) @
@fname{assoc} (@var{key}, @var{list})

This function searches for @var{key} in the left hand side of the
input @var{list}. The @var{list} argument should be a list, each of
whose elements is an expression with exactly two parts. Most usually,
the elements of @var{list} are themselves lists, each with two
elements.

The @code{assoc} function iterates along @var{list}, checking the
first part of each element for equality with @var{key}. If an element
is found where the comparison is true, @code{assoc} returns the second
part of that element. If there is no such element in the list,
@code{assoc} returns either @code{false} or @var{default}, if given.

For example, in the expression @code{assoc (y, [[x,1], [y,2],
[z,3]])}, the @code{assoc} function searches for @code{x} in the left
hand side of the list @code{[[y,1],[x,2]]} and finds it at the second
term, returning @code{2}. In @code{assoc (z, [[x,1], [z,2], [z,3]])},
the search stops at the first term starting with @code{z} and returns
@code{2}. In @code{assoc(x, [[y,1]])}, there is no matching element,
so @code{assoc} returns @code{false}.

@c ===beg===
@c assoc (y, [[x,1], [y,2],[z,3]]);
@c assoc (z, [[x,1], [z,2], [z,3]]);
@c assoc (x, [[y,1]]);
@c ===end===
@example
@group
(%i1) assoc (y, [[x,1], [y,2],[z,3]]);
(%o1)                           2
@end group
@group
(%i2) assoc (z, [[x,1], [z,2], [z,3]]);
(%o2)                           2
@end group
@group
(%i3) assoc (x, [[y,1]]);
(%o3)                         false
@end group
@end example

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn


@c -----------------------------------------------------------------------------
@anchor{cons}
@deffn {Function} cons @
@fname{cons} (@var{expr}, @var{list}) @
@fname{cons} (@var{expr_1}, @var{expr_2})

@code{cons (@var{expr}, @var{list})} returns a new list constructed of the element 
@var{expr} as its first element, followed by the elements of @var{list}. This is 
analogous to the Lisp language construction operation "cons".

The Maxima function @code{cons} can also be used where the second argument is other
than a list and this might be useful. In this case, @code{cons (@var{expr_1}, @var{expr_2})}
returns an expression with same operator as @var{expr_2} but with argument @code{cons(expr_1, args(expr_2))}.
Examples:

@c ===beg===
@c cons(a,[b,c,d]);
@c cons(a,f(b,c,d));
@c ===end===
@example
@group
(%i1) cons(a,[b,c,d]);
(%o1)                     [a, b, c, d]
@end group
@group
(%i2) cons(a,f(b,c,d));
(%o2)                     f(a, b, c, d)
@end group
@end example

In general, @code{cons} applied to a nonlist doesn't make sense. For instance, @code{cons(a,b^c)}
results in an illegal expression, since '^' cannot take three arguments. 

When @code{inflag} is true, @code{cons} operates on the internal structure of an expression, otherwise
@code{cons} operates on the displayed form. Especially when @code{inflag} is true, @code{cons} applied 
to a nonlist sometimes gives a surprising result; for example

@c ===beg===
@c cons(a,-a), inflag : true;
@c cons(a,-a), inflag : false;
@c ===end===
@example
@group
(%i1) cons(a,-a), inflag : true;
                                 2
(%o1)                         - a
@end group
@group
(%i2) cons(a,-a), inflag : false;
(%o2)                           0
@end group
@end example

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{copylist}
@deffn {Function} copylist (@var{list})

Returns a copy of the list @var{list}.

@opencatbox
@category{Lists}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{create_list}
@deffn {Function} create_list (@var{form}, @var{x_1}, @var{list_1}, @dots{}, @var{x_n}, @var{list_n})

Create a list by evaluating @var{form} with @var{x_1} bound to
each element of @var{list_1}, and for each such binding bind @var{x_2}
to each element of @var{list_2}, @dots{}
The number of elements in the result will be
the product of the number of elements in each list.
Each variable @var{x_i} must actually be a symbol -- it will not be evaluated.
The list arguments will be evaluated once at the beginning of the
iteration.

@c ===beg===
@c create_list (x^i, i, [1, 3, 7]);
@c ===end===
@example
@group
(%i1) create_list (x^i, i, [1, 3, 7]);
                                3   7
(%o1)                      [x, x , x ]
@end group
@end example

@noindent
With a double iteration:

@c ===beg===
@c create_list ([i, j], i, [a, b], j, [e, f, h]);
@c ===end===
@example
@group
(%i1) create_list ([i, j], i, [a, b], j, [e, f, h]);
(%o1)   [[a, e], [a, f], [a, h], [b, e], [b, f], [b, h]]
@end group
@end example

Instead of @var{list_i} two args may be supplied each of which should
evaluate to a number.  These will be the inclusive lower and
upper bounds for the iteration.

@c ===beg===
@c create_list ([i, j], i, [1, 2, 3], j, 1, i);
@c ===end===
@example
@group
(%i1) create_list ([i, j], i, [1, 2, 3], j, 1, i);
(%o1)   [[1, 1], [2, 1], [2, 2], [3, 1], [3, 2], [3, 3]]
@end group
@end example

Note that the limits or list for the @code{j} variable can
depend on the current value of @code{i}.

@opencatbox
@category{Lists}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{delete}
@deffn  {Function} delete @
@fname{delete} (@var{expr_1}, @var{expr_2}) @
@fname{delete} (@var{expr_1}, @var{expr_2}, @var{n})

@code{delete(@var{expr_1}, @var{expr_2})}
removes from @var{expr_2} any arguments of its top-level operator
which are the same (as determined by "=") as @var{expr_1}.
Note that "=" tests for formal equality, not equivalence.
Note also that arguments of subexpressions are not affected.

@var{expr_1} may be an atom or a non-atomic expression.
@var{expr_2} may be any non-atomic expression.
@code{delete} returns a new expression;
it does not modify @var{expr_2}.

@code{delete(@var{expr_1}, @var{expr_2}, @var{n})}
removes from @var{expr_2} the first @var{n} arguments of the top-level operator
which are the same as @var{expr_1}.
If there are fewer than @var{n} such arguments,
then all such arguments are removed.

Examples:

Removing elements from a list.

@c ===beg===
@c delete (y, [w, x, y, z, z, y, x, w]);
@c ===end===
@example
@group
(%i1) delete (y, [w, x, y, z, z, y, x, w]);
(%o1)                  [w, x, z, z, x, w]
@end group
@end example

Removing terms from a sum.

@c ===beg===
@c delete (sin(x), x + sin(x) + y);
@c ===end===
@example
@group
(%i1) delete (sin(x), x + sin(x) + y);
(%o1)                         y + x
@end group
@end example

Removing factors from a product.

@c ===beg===
@c delete (u - x, (u - w)*(u - x)*(u - y)*(u - z));
@c ===end===
@example
@group
(%i1) delete (u - x, (u - w)*(u - x)*(u - y)*(u - z));
(%o1)                (u - w) (u - y) (u - z)
@end group
@end example

Removing arguments from an arbitrary expression.

@c ===beg===
@c delete (a, foo (a, b, c, d, a));
@c ===end===
@example
@group
(%i1) delete (a, foo (a, b, c, d, a));
(%o1)                     foo(b, c, d)
@end group
@end example

Limit the number of removed arguments.

@c ===beg===
@c delete (a, foo (a, b, a, c, d, a), 2);
@c ===end===
@example
@group
(%i1) delete (a, foo (a, b, a, c, d, a), 2);
(%o1)                    foo(b, c, d, a)
@end group
@end example

Whether arguments are the same as @var{expr_1} is determined by "=".
Arguments which are @code{equal} but not "=" are not removed.

@c ===beg===
@c [is (equal (0, 0)), is (equal (0, 0.0)), is (equal (0, 0b0))];
@c [is (0 = 0), is (0 = 0.0), is (0 = 0b0)];
@c delete (0, [0, 0.0, 0b0]);
@c is (equal ((x + y)*(x - y), x^2 - y^2));
@c is ((x + y)*(x - y) = x^2 - y^2);
@c delete ((x + y)*(x - y), [(x + y)*(x - y), x^2 - y^2]);
@c ===end===
@example
@group
(%i1) [is (equal (0, 0)), is (equal (0, 0.0)), is (equal (0, 0b0))];
(%o1)                  [true, true, true]
@end group
@group
(%i2) [is (0 = 0), is (0 = 0.0), is (0 = 0b0)];
(%o2)                 [true, false, false]
@end group
@group
(%i3) delete (0, [0, 0.0, 0b0]);
(%o3)                     [0.0, 0.0b0]
@end group
@group
(%i4) is (equal ((x + y)*(x - y), x^2 - y^2));
(%o4)                         true
@end group
@group
(%i5) is ((x + y)*(x - y) = x^2 - y^2);
(%o5)                         false
@end group
@group
(%i6) delete ((x + y)*(x - y), [(x + y)*(x - y), x^2 - y^2]);
                              2    2
(%o6)                       [x  - y ]
@end group
@end example

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{eighth}
@deffn {Function} eighth (@var{expr})

Returns the 8'th item of expression or list @var{expr}.
See @mref{first} for more details.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn


@c -----------------------------------------------------------------------------
@anchor{endcons}
@deffn  {Function} endcons @
@fname{endcons} (@var{expr}, @var{list}) @
@fname{endcons} (@var{expr_1}, @var{expr_2})

@code{endcons (@var{expr}, @var{list})} returns a new list constructed of the elements of 
@var{list} followed by @var{expr}. The Maxima function @code{endcons} can also be used where 
the second argument is other than a list and this might be useful. In this case,
@code{endcons (@var{expr_1}, @var{expr_2})} returns an expression with same operator as 
@var{expr_2} but with argument @code{endcons(expr_1, args(expr_2))}. Examples:

@c ===beg===
@c endcons(a,[b,c,d]);
@c endcons(a,f(b,c,d));
@c ===end===
@example
@group
(%i1) endcons(a,[b,c,d]);
(%o1)                     [b, c, d, a]
@end group
@group
(%i2) endcons(a,f(b,c,d));
(%o2)                     f(b, c, d, a)
@end group
@end example

In general, @code{endcons} applied to a nonlist doesn't make sense. For instance, @code{endcons(a,b^c)}
results in an illegal expression, since '^' cannot take three arguments. 

When @code{inflag} is true, @code{endcons} operates on the internal structure of an expression, otherwise
@code{endcons} operates on the displayed form. Especially when @code{inflag} is true, @code{endcons} applied 
to a nonlist sometimes gives a surprising result; for example

@c ===beg===
@c endcons(a,-a), inflag : true;
@c endcons(a,-a), inflag : false;
@c ===end===
@example
@group
(%i1) endcons(a,-a), inflag : true;
                                 2
(%o1)                         - a
@end group
@group
(%i2) endcons(a,-a), inflag : false;
(%o2)                           0
@end group
@end example

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn


@c -----------------------------------------------------------------------------
@anchor{fifth}
@deffn {Function} fifth (@var{expr})

Returns the 5'th item of expression or list @var{expr}.
See @mref{first} for more details.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{first}
@deffn {Function} first (@var{expr})

Returns the first part of @var{expr} which may result in the first element of a
list, the first row of a matrix, the first term of a sum, etc.:

@example
@group
(%i1) matrix([1,2],[3,4]);
                                   [ 1  2 ]
(%o1)                              [      ]
                                   [ 3  4 ]
(%i2) first(%);
(%o2)                              [1,2]
(%i3) first(%);
(%o3)                              1
(%i4) first(a*b/c+d+e/x);
                                   a b
(%o4)                              ---
                                    c
(%i5) first(a=b/c+d+e/x);
(%o5)                              a
@end group
@end example

Note that
@code{first} and its related functions, @code{rest} and @code{last}, work
on the form of @var{expr} which is displayed not the form which is typed on
input.  If the variable @mref{inflag} is set to @code{true} however, these
functions will look at the internal form of @var{expr}. One reason why this may
make a difference is that the simplifier re-orders expressions:

@example
@group
(%i1) x+y;
(%o1)                              y+1
(%i2) first(x+y),inflag : true;
(%o2)                              x
(%i3) first(x+y),inflag : false;
(%o3)                              y
@end group
@end example

The functions @code{second} @dots{}
@code{tenth} yield the second through the tenth part of their input argument.

See also @mref{firstn} and @mrefdot{part}

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{firstn}
@deffn {Function} firstn (@var{expr}, @var{count})

Returns the first @var{count} arguments of @var{expr}, if @var{expr} has at least @var{count} arguments.
Returns @var{expr} if @var{expr} has less than @var{count} arguments.

@var{expr} may be any nonatomic expression. 
When @var{expr} is something other than a list,
@code{firstn} returns an expression which has the same operator as @var{expr}.
@var{count} must be a nonnegative integer.

@code{firstn} honors the global flag @code{inflag},
which governs whether the internal form of an expression is processed (when @code{inflag} is true)
or the displayed form (when @code{inflag} is false).

Note that @code{firstn(@var{expr}, 1)},
which returns a nonatomic expression containing the first argument,
is not the same as @code{first(@var{expr})},
which returns the first argument by itself.

See also @mref{lastn} and @mrefdot{rest}

Examples:

@code{firstn} returns the first @var{count} elements of @var{expr}, if @var{expr} has at least @var{count} elements.

@c ===beg===
@c mylist : [1, a, 2, b, 3, x, 4 - y, 2*z + sin(u)];
@c firstn (mylist, 0);
@c firstn (mylist, 1);
@c firstn (mylist, 2);
@c firstn (mylist, 7);
@c ===end===
@example
@group
(%i1) mylist : [1, a, 2, b, 3, x, 4 - y, 2*z + sin(u)];
(%o1)        [1, a, 2, b, 3, x, 4 - y, 2 z + sin(u)]
@end group
@group
(%i2) firstn (mylist, 0);
(%o2)                          []
@end group
@group
(%i3) firstn (mylist, 1);
(%o3)                          [1]
@end group
@group
(%i4) firstn (mylist, 2);
(%o4)                        [1, a]
@end group
@group
(%i5) firstn (mylist, 7);
(%o5)               [1, a, 2, b, 3, x, 4 - y]
@end group
@end example

@code{firstn} returns @var{expr} if @var{expr} has less than @var{count} elements.

@c ===beg===
@c mylist : [1, a, 2, b, 3, x, 4 - y, 2*z + sin(u)];
@c firstn (mylist, 100);
@c ===end===
@example
@group
(%i1) mylist : [1, a, 2, b, 3, x, 4 - y, 2*z + sin(u)];
(%o1)        [1, a, 2, b, 3, x, 4 - y, 2 z + sin(u)]
@end group
@group
(%i2) firstn (mylist, 100);
(%o2)        [1, a, 2, b, 3, x, 4 - y, 2 z + sin(u)]
@end group
@end example

@var{expr} may be any nonatomic expression. 

@c ===beg===
@c myfoo : foo(1, a, 2, b, 3, x, 4 - y, 2*z + sin(u));
@c firstn (myfoo, 4);
@c mybar : bar[m, n](1, a, 2, b, 3, x, 4 - y, 2*z + sin(u));
@c firstn (mybar, 4);
@c mymatrix : genmatrix (lambda ([i, j], 10*i + j), 10, 4) $
@c firstn (mymatrix, 3);
@c ===end===
@example
@group
(%i1) myfoo : foo(1, a, 2, b, 3, x, 4 - y, 2*z + sin(u));
(%o1)      foo(1, a, 2, b, 3, x, 4 - y, 2 z + sin(u))
@end group
@group
(%i2) firstn (myfoo, 4);
(%o2)                    foo(1, a, 2, b)
@end group
@group
(%i3) mybar : bar[m, n](1, a, 2, b, 3, x, 4 - y, 2*z + sin(u));
(%o3)    bar    (1, a, 2, b, 3, x, 4 - y, 2 z + sin(u))
            m, n
@end group
@group
(%i4) firstn (mybar, 4);
(%o4)                  bar    (1, a, 2, b)
                          m, n
@end group
(%i5) mymatrix : genmatrix (lambda ([i, j], 10*i + j), 10, 4) $
@group
(%i6) firstn (mymatrix, 3);
                       [ 11  12  13  14 ]
                       [                ]
(%o6)                  [ 21  22  23  24 ]
                       [                ]
                       [ 31  32  33  34 ]
@end group
@end example

@code{firstn} honors the global flag @code{inflag}.

@c ===beg===
@c myexpr : a + b + c + d + e;
@c firstn (myexpr, 3), inflag=true;
@c firstn (myexpr, 3), inflag=false;
@c ===end===
@example
@group
(%i1) myexpr : a + b + c + d + e;
(%o1)                   e + d + c + b + a
@end group
@group
(%i2) firstn (myexpr, 3), inflag=true;
(%o2)                       c + b + a
@end group
@group
(%i3) firstn (myexpr, 3), inflag=false;
(%o3)                       e + d + c
@end group
@end example

Note that @code{firstn(@var{expr}, 1)} is not the same as @code{first(@var{expr})}.

@c ===beg===
@c firstn ([w, x, y, z], 1);
@c first ([w, x, y, z]);
@c ===end===
@example
@group
(%i1) firstn ([w, x, y, z], 1);
(%o1)                          [w]
@end group
@group
(%i2) first ([w, x, y, z]);
(%o2)                           w
@end group
@end example

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{fourth}
@deffn {Function} fourth (@var{expr})

Returns the 4'th item of expression or list @var{expr}.
See @mref{first} for more details.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{join}
@deffn {Function} join (@var{l}, @var{m})

Creates a new list containing the elements of lists @var{l} and @var{m},
interspersed.  The result has elements @code{[@var{l}[1], @var{m}[1],
@var{l}[2], @var{m}[2], ...]}.  The lists @var{l} and @var{m} may contain any
type of elements.

If the lists are different lengths, @code{join} ignores elements of the longer
list.

Maxima complains if @var{l} or @var{m} is not a list.

See also @mrefdot{append}

Examples:

@c ===beg===
@c L1: [a, sin(b), c!, d - 1];
@c join (L1, [1, 2, 3, 4]);
@c join (L1, [aa, bb, cc, dd, ee, ff]);
@c ===end===
@example
@group
(%i1) L1: [a, sin(b), c!, d - 1];
(%o1)                [a, sin(b), c!, d - 1]
@end group
@group
(%i2) join (L1, [1, 2, 3, 4]);
(%o2)          [a, 1, sin(b), 2, c!, 3, d - 1, 4]
@end group
@group
(%i3) join (L1, [aa, bb, cc, dd, ee, ff]);
(%o3)        [a, aa, sin(b), bb, c!, cc, d - 1, dd]
@end group
@end example

@opencatbox
@category{Lists}
@closecatbox
@end deffn

@c NEEDS EXAMPLES
@c HOW IS "LAST" PART DETERMINED ??

@c -----------------------------------------------------------------------------
@anchor{last}
@deffn {Function} last (@var{expr})

Returns the last part (term, row, element, etc.) of the @var{expr}.

See also @mrefdot{lastn}

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c NEEDS CLARIFICATION AND EXAMPLES

@c -----------------------------------------------------------------------------
@anchor{lastn}
@deffn {Function} lastn (@var{expr}, @var{count})

Returns the last @var{count} arguments of @var{expr}, if @var{expr} has at least @var{count} arguments.
Returns @var{expr} if @var{expr} has less than @var{count} arguments.

@var{expr} may be any nonatomic expression. 
When @var{expr} is something other than a list,
@code{lastn} returns an expression which has the same operator as @var{expr}.
@var{count} must be a nonnegative integer.

@code{lastn} honors the global flag @code{inflag},
which governs whether the internal form of an expression is processed (when @code{inflag} is true)
or the displayed form (when @code{inflag} is false).

Note that @code{lastn(@var{expr}, 1)},
which returns a nonatomic expression containing the last argument,
is not the same as @code{last(@var{expr})},
which returns the last argument by itself.

See also @mref{firstn} and @mrefdot{rest}

Examples:

@code{lastn} returns the last @var{count} elements of @var{expr}, if @var{expr} has at least @var{count} elements.

@c ===beg===
@c mylist : [1, a, 2, b, 3, x, 4 - y, 2*z + sin(u)];
@c lastn (mylist, 0);
@c lastn (mylist, 1);
@c lastn (mylist, 2);
@c lastn (mylist, 7);
@c ===end===
@example
@group
(%i1) mylist : [1, a, 2, b, 3, x, 4 - y, 2*z + sin(u)];
(%o1)        [1, a, 2, b, 3, x, 4 - y, 2 z + sin(u)]
@end group
@group
(%i2) lastn (mylist, 0);
(%o2)                          []
@end group
@group
(%i3) lastn (mylist, 1);
(%o3)                    [2 z + sin(u)]
@end group
@group
(%i4) lastn (mylist, 2);
(%o4)                 [4 - y, 2 z + sin(u)]
@end group
@group
(%i5) lastn (mylist, 7);
(%o5)         [a, 2, b, 3, x, 4 - y, 2 z + sin(u)]
@end group
@end example

@code{lastn} returns @var{expr} if @var{expr} has less than @var{count} elements.

@c ===beg===
@c mylist : [1, a, 2, b, 3, x, 4 - y, 2*z + sin(u)];
@c lastn (mylist, 100);
@c ===end===
@example
@group
(%i1) mylist : [1, a, 2, b, 3, x, 4 - y, 2*z + sin(u)];
(%o1)        [1, a, 2, b, 3, x, 4 - y, 2 z + sin(u)]
@end group
@group
(%i2) lastn (mylist, 100);
(%o2)        [1, a, 2, b, 3, x, 4 - y, 2 z + sin(u)]
@end group
@end example

@var{expr} may be any nonatomic expression. 

@c ===beg===
@c myfoo : foo(1, a, 2, b, 3, x, 4 - y, 2*z + sin(u));
@c lastn (myfoo, 4);
@c mybar : bar[m, n](1, a, 2, b, 3, x, 4 - y, 2*z + sin(u));
@c lastn (mybar, 4);
@c mymatrix : genmatrix (lambda ([i, j], 10*i + j), 10, 4) $
@c lastn (mymatrix, 3);
@c ===end===
@example
@group
(%i1) myfoo : foo(1, a, 2, b, 3, x, 4 - y, 2*z + sin(u));
(%o1)      foo(1, a, 2, b, 3, x, 4 - y, 2 z + sin(u))
@end group
@group
(%i2) lastn (myfoo, 4);
(%o2)            foo(3, x, 4 - y, 2 z + sin(u))
@end group
@group
(%i3) mybar : bar[m, n](1, a, 2, b, 3, x, 4 - y, 2*z + sin(u));
(%o3)    bar    (1, a, 2, b, 3, x, 4 - y, 2 z + sin(u))
            m, n
@end group
@group
(%i4) lastn (mybar, 4);
(%o4)          bar    (3, x, 4 - y, 2 z + sin(u))
                  m, n
@end group
(%i5) mymatrix : genmatrix (lambda ([i, j], 10*i + j), 10, 4) $
@group
(%i6) lastn (mymatrix, 3);
                     [ 81   82   83   84  ]
                     [                    ]
(%o6)                [ 91   92   93   94  ]
                     [                    ]
                     [ 101  102  103  104 ]
@end group
@end example

@code{lastn} honors the global flag @code{inflag}.

@c ===beg===
@c myexpr : a + b + c + d + e;
@c lastn (myexpr, 3), inflag=true;
@c lastn (myexpr, 3), inflag=false;
@c ===end===
@example
@group
(%i1) myexpr : a + b + c + d + e;
(%o1)                   e + d + c + b + a
@end group
@group
(%i2) lastn (myexpr, 3), inflag=true;
(%o2)                       e + d + c
@end group
@group
(%i3) lastn (myexpr, 3), inflag=false;
(%o3)                       c + b + a
@end group
@end example

Note that @code{lastn(@var{expr}, 1)} is not the same as @code{last(@var{expr})}.

@c ===beg===
@c lastn ([w, x, y, z], 1);
@c last ([w, x, y, z]);
@c ===end===
@example
@group
(%i1) lastn ([w, x, y, z], 1);
(%o1)                          [z]
@end group
@group
(%i2) last ([w, x, y, z]);
(%o2)                           z
@end group
@end example

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{length}
@deffn {Function} length (@var{expr})

Returns (by default) the number of parts in the external
(displayed) form of @var{expr}.  For lists this is the number of elements,
for matrices it is the number of rows, and for sums it is the number
of terms (see @mref{dispform}).

The @code{length} command is affected by the @mref{inflag} switch.  So, e.g.
@code{length(a/(b*c));} gives 2 if @code{inflag} is @code{false} (Assuming
@mref{exptdispflag} is @code{true}), but 3 if @code{inflag} is @code{true} (the
internal representation is essentially @code{a*b^-1*c^-1}).

Determining a list's length typically needs an amount of time proportional
to the number of elements in the list. If the length of a list is used inside
a loop it therefore might drastically increase the performance if the length
is calculated outside the loop instead.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{listarith}
@defvr {Option variable} listarith
Default value: @code{true} 

If @code{false} causes any arithmetic operations with lists to be suppressed;
when @code{true}, list-matrix operations are contagious causing lists to be
converted to matrices yielding a result which is always a matrix.  However,
list-list operations should return lists.

@opencatbox
@category{Lists} @category{Global flags}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@deffn {Function} listp (@var{expr})

Returns @code{true} if @var{expr} is a list else @code{false}.

@opencatbox
@category{Lists} @category{Predicate functions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{lreduce}
@deffn {Function} lreduce @
@fname{lreduce} (@var{F}, @var{s}) @
@fname{lreduce} (@var{F}, @var{s}, @var{s_0})

Extends the binary function @var{F} to an n-ary function by composition,
where @var{s} is a list.

@code{lreduce(@var{F}, @var{s})} returns @code{F(... F(F(s_1, s_2), s_3), ... s_n)}.
When the optional argument @var{s_0} is present,
the result is equivalent to @code{lreduce(@var{F}, cons(@var{s_0}, @var{s}))}.

The function @var{F} is first applied to the
@i{leftmost} list elements, thus the name "lreduce".

See also @mref{rreduce}, @mref{xreduce}, and @mref{tree_reduce}.

Examples:

@code{lreduce} without the optional argument.

@c ===beg===
@c lreduce (f, [1, 2, 3]);
@c lreduce (f, [1, 2, 3, 4]);
@c ===end===
@example
@group
(%i1) lreduce (f, [1, 2, 3]);
(%o1)                     f(f(1, 2), 3)
@end group
@group
(%i2) lreduce (f, [1, 2, 3, 4]);
(%o2)                  f(f(f(1, 2), 3), 4)
@end group
@end example

@code{lreduce} with the optional argument.

@c ===beg===
@c lreduce (f, [1, 2, 3], 4);
@c ===end===
@example
@group
(%i1) lreduce (f, [1, 2, 3], 4);
(%o1)                  f(f(f(4, 1), 2), 3)
@end group
@end example

@code{lreduce} applied to built-in binary operators.
@code{/} is the division operator.

@c ===beg===
@c lreduce ("^", args ({a, b, c, d}));
@c lreduce ("/", args ({a, b, c, d}));
@c ===end===
@example
@group
(%i1) lreduce ("^", args (@{a, b, c, d@}));
                               b c d
(%o1)                       ((a ) )
@end group
@group
(%i2) lreduce ("/", args (@{a, b, c, d@}));
                                a
(%o2)                         -----
                              b c d
@end group
@end example

@opencatbox
@category{Lists}
@closecatbox

@end deffn

@c -----------------------------------------------------------------------------
@anchor{makelist}
@deffn  {Function} makelist @
@fname{makelist} () @
@fname{makelist} (@var{expr}, @var{n}) @
@fname{makelist} (@var{expr}, @var{i}, @var{i_max}) @
@fname{makelist} (@var{expr}, @var{i}, @var{i_0}, @var{i_max}) @
@fname{makelist} (@var{expr}, @var{i}, @var{i_0}, @var{i_max}, @var{step}) @
@fname{makelist} (@var{expr}, @var{x}, @var{list})

The first form, @code{makelist ()}, creates an empty list. The second form,
@code{makelist (@var{expr})}, creates a list with @var{expr} as its single
element. @code{makelist (@var{expr}, @var{n})} creates a list of @var{n}
elements generated from @var{expr}.

The most general form, @code{makelist (@var{expr}, @var{i}, @var{i_0},
@var{i_max}, @var{step})}, returns the list of elements obtained when
@code{ev (@var{expr}, @var{i}=@var{j})} is applied to the elements
@var{j} of the sequence: @var{i_0}, @var{i_0} + @var{step}, @var{i_0} +
2*@var{step}, ..., with @var{|j|} less than or equal to @var{|i_max|}.

The increment @var{step} can be a number (positive or negative) or an
expression. If it is omitted, the default value 1 will be used. If both
@var{i_0} and @var{step} are omitted, they will both have a default
value of 1.

@code{makelist (@var{expr}, @var{x}, @var{list})} returns a list, the
@code{j}'th element of which is equal to
@code{ev (@var{expr}, @var{x}=@var{list}[j])} for @code{j} equal to 1 through
@code{length (@var{list})}.

Examples:

@c ===beg===
@c makelist (concat (x,i), i, 6);
@c makelist (x=y, y, [a, b, c]);
@c makelist (x^2, x, 3, 2*%pi, 2);
@c makelist (random(6), 4);
@c flatten (makelist (makelist (i^2, 3), i, 4));
@c flatten (makelist (makelist (i^2, i, 3), 4));
@c ===end===
@example
@group
(%i1) makelist (concat (x,i), i, 6);
(%o1)               [x1, x2, x3, x4, x5, x6]
@end group
@group
(%i2) makelist (x=y, y, [a, b, c]);
(%o2)                 [x = a, x = b, x = c]
@end group
@group
(%i3) makelist (x^2, x, 3, 2*%pi, 2);
(%o3)                        [9, 25]
@end group
@group
(%i4) makelist (random(6), 4);
(%o4)                     [2, 0, 2, 5]
@end group
@group
(%i5) flatten (makelist (makelist (i^2, 3), i, 4));
(%o5)        [1, 1, 1, 4, 4, 4, 9, 9, 9, 16, 16, 16]
@end group
@group
(%i6) flatten (makelist (makelist (i^2, i, 3), 4));
(%o6)         [1, 4, 9, 1, 4, 9, 1, 4, 9, 1, 4, 9]
@end group
@end example

@opencatbox
@category{Lists}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{member}
@deffn {Function} member (@var{expr_1}, @var{expr_2})

Returns @code{true} if @code{is(@var{expr_1} = @var{a})}
for some element @var{a} in @code{args(@var{expr_2})},
otherwise returns @code{false}.

@code{expr_2} is typically a list, in which case
@code{args(@var{expr_2}) = @var{expr_2}} and @code{is(@var{expr_1} = @var{a})}
for some element @var{a} in @code{expr_2} is the test.

@code{member} does not inspect parts of the arguments of @code{expr_2}, so it
may return @code{false} even if @code{expr_1} is a part of some argument of
@code{expr_2}.

See also @mrefdot{elementp}

Examples:

@c ===beg===
@c member (8, [8, 8.0, 8b0]);
@c member (8, [8.0, 8b0]);
@c member (b, [a, b, c]);
@c member (b, [[a, b], [b, c]]);
@c member ([b, c], [[a, b], [b, c]]);
@c F (1, 1/2, 1/4, 1/8);
@c member (1/8, %);
@c member ("ab", ["aa", "ab", sin(1), a + b]);
@c ===end===
@example
@group
(%i1) member (8, [8, 8.0, 8b0]);
(%o1)                         true
@end group
@group
(%i2) member (8, [8.0, 8b0]);
(%o2)                         false
@end group
@group
(%i3) member (b, [a, b, c]);
(%o3)                         true
@end group
@group
(%i4) member (b, [[a, b], [b, c]]);
(%o4)                         false
@end group
@group
(%i5) member ([b, c], [[a, b], [b, c]]);
(%o5)                         true
@end group
@group
(%i6) F (1, 1/2, 1/4, 1/8);
                               1  1  1
(%o6)                     F(1, -, -, -)
                               2  4  8
@end group
@group
(%i7) member (1/8, %);
(%o7)                         true
@end group
@group
(%i8) member ("ab", ["aa", "ab", sin(1), a + b]);
(%o8)                         true
@end group
@end example

@opencatbox
@category{Lists} @category{Expressions} @category{Predicate functions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{ninth}
@deffn {Function} ninth (@var{expr})

Returns the 9'th item of expression or list @var{expr}.
See @mref{first} for more details.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{pop}
@deffn {Function} pop (@var{list})

@code{pop} removes and returns the first element from the list @var{list}. The argument
@var{list} must be a mapatom that is bound to a nonempty list. If the argument @var{list} is 
not bound to a nonempty list, Maxima signals an error. For examples, see @mrefdot{push}

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{push}
@deffn {Function} push (@var{item}, @var{list})

@code{push} prepends the item @var{item} to the list @var{list} and returns a copy of the new list. 
The second argument @var{list} must be a mapatom that is bound to a list. The first argument @var{item} 
can be any Maxima symbol or expression. If the argument @var{list} is not bound to a list, Maxima 
signals an error.


To remove the first item from a list, see @mrefdot{pop}


Examples:

@c ===beg===
@c ll: [];
@c push (x, ll);
@c push (x^2+y, ll);
@c a: push ("string", ll);
@c pop (ll);
@c pop (ll);
@c pop (ll);
@c ll;
@c a;
@c ===end===
@example
@group
(%i1) ll: [];
(%o1)                          []
@end group
@group
(%i2) push (x, ll);
(%o2)                          [x]
@end group
@group
(%i3) push (x^2+y, ll);
                                 2
(%o3)                      [y + x , x]
@end group
@group
(%i4) a: push ("string", ll);
                                     2
(%o4)                  [string, y + x , x]
@end group
@group
(%i5) pop (ll);
(%o5)                        string
@end group
@group
(%i6) pop (ll);
                                  2
(%o6)                        y + x
@end group
@group
(%i7) pop (ll);
(%o7)                           x
@end group
@group
(%i8) ll;
(%o8)                          []
@end group
@group
(%i9) a;
                                     2
(%o9)                  [string, y + x , x]
@end group
@end example

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{rest}
@deffn  {Function} rest @
@fname{rest} (@var{expr}, @var{n}) @
@fname{rest} (@var{expr})

Returns @var{expr} with its first @var{n} elements removed if @var{n}
is positive and its last @code{- @var{n}} elements removed if @var{n}
is negative. If @var{n} is 1 it may be omitted. The first argument
@var{expr} may be a list, matrix, or other expression. When @var{expr}
is an atom, @code{rest} signals an error; when @var{expr} is an empty
list and @code{partswitch} is false, @code{rest} signals an error. When 
@var{expr} is an empty list and @code{partswitch} is true, @code{rest} 
returns @code{end}.

Applying @code{rest} to expression such as @code{f(a,b,c)} returns
@code{f(b,c)}. In general, applying @code{rest} to an nonlist doesn't
make sense. For example, because '^' requires two arguments,
@code{rest(a^b)} results in an error message. The functions
@code{args} and @code{op} may be useful as well, since @code{args(a^b)}
returns @code{[a,b]} and @code{op(a^b)} returns ^.

See also @mref{firstn} and @mrefdot{lastn}

@example
@group
(%i1) rest(a+b+c);
(%o1) b+a
(%i2) rest(a+b+c,2);
(%o2) a
(%i3) rest(a+b+c,-2);
(%o3) c
@end group
@end example

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c NEED ANOTHER deffn FOR GENERAL EXPRESSIONS ARGUMENTS
@c SPLIT OFF EXAMPLES INTO EXAMPLE SECTION

@c -----------------------------------------------------------------------------
@anchor{reverse}
@deffn {Function} reverse (@var{list})

Reverses the order of the members of the @var{list} (not
the members themselves).  @code{reverse} also works on general expressions,
e.g.  @code{reverse(a=b);} gives @code{b=a}.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{rreduce}
@deffn {Function} rreduce @
@fname{rreduce} (@var{F}, @var{s}) @
@fname{rreduce} (@var{F}, @var{s}, @var{s_@{n + 1@}})

Extends the binary function @var{F} to an n-ary function by composition,
where @var{s} is a list.

@code{rreduce(@var{F}, @var{s})} returns @code{F(s_1, ... F(s_@{n - 2@}, F(s_@{n - 1@}, s_n)))}.
When the optional argument @var{s_@{n + 1@}} is present,
the result is equivalent to @code{rreduce(@var{F}, endcons(@var{s_@{n + 1@}}, @var{s}))}.

The function @var{F} is first applied to the
@i{rightmost} list elements, thus the name "rreduce".

See also @mref{lreduce}, @mref{tree_reduce}, and @mref{xreduce}.

Examples:

@code{rreduce} without the optional argument.

@c ===beg===
@c rreduce (f, [1, 2, 3]);
@c rreduce (f, [1, 2, 3, 4]);
@c ===end===
@example
@group
(%i1) rreduce (f, [1, 2, 3]);
(%o1)                     f(1, f(2, 3))
@end group
@group
(%i2) rreduce (f, [1, 2, 3, 4]);
(%o2)                  f(1, f(2, f(3, 4)))
@end group
@end example

@code{rreduce} with the optional argument.

@c ===beg===
@c rreduce (f, [1, 2, 3], 4);
@c ===end===
@example
@group
(%i1) rreduce (f, [1, 2, 3], 4);
(%o1)                  f(1, f(2, f(3, 4)))
@end group
@end example

@code{rreduce} applied to built-in binary operators.
@code{/} is the division operator.

@c ===beg===
@c rreduce ("^", args ({a, b, c, d}));
@c rreduce ("/", args ({a, b, c, d}));
@c ===end===
@example
@group
(%i1) rreduce ("^", args (@{a, b, c, d@}));
                                 d
                                c
                               b
(%o1)                         a
@end group
@group
(%i2) rreduce ("/", args (@{a, b, c, d@}));
                               a c
(%o2)                          ---
                               b d
@end group
@end example

@opencatbox
@category{Lists}
@closecatbox

@end deffn

@c -----------------------------------------------------------------------------
@anchor{second}
@deffn {Function} second (@var{expr})

Returns the 2'nd item of expression or list @var{expr}.
See @mref{first} for more details.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{seventh}
@deffn {Function} seventh (@var{expr})

Returns the 7'th item of expression or list @var{expr}.
See @mref{first} for more details.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{sixth}
@deffn {Function} sixth (@var{expr})

Returns the 6'th item of expression or list @var{expr}.
See @mref{first} for more details.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{sort}
@deffn  {Function} sort @
@fname{sort} (@var{L}, @var{P}) @
@fname{sort} (@var{L})

@code{sort(@var{L}, @var{P})} sorts a list @var{L} according to a predicate @code{P} of two arguments
which defines a strict weak order on the elements of @var{L}.
If @code{@var{P}(a, b)} is @code{true}, then @code{a} appears before @code{b} in the result.
If neither @code{@var{P}(a, b)} nor @code{@var{P}(b, a)} are @code{true},
then @code{a} and @code{b} are equivalent, and appear in the result in the same order as in the input.
That is, @code{sort} is a stable sort.

If @code{@var{P}(a, b)} and @code{@var{P}(b, a)} are both @code{true} for some elements of @var{L},
then @var{P} is not a valid sort predicate, and the result is undefined.
If @code{@var{P}(a, b)} is something other than @code{true} or @code{false}, @code{sort} signals an error.

The predicate may be specified as the name of a function 
or binary infix operator, or as a @code{lambda} expression.  If specified as
the name of an operator, the name must be enclosed in double quotes.

The sorted list is returned as a new object; the argument @var{L} is not modified.

@code{sort(@var{L})} is equivalent to @code{sort(@var{L}, orderlessp)}.

The default sorting order is ascending, as determined by @mrefdot{orderlessp} The predicate @code{ordergreatp} sorts a list in descending order.

All Maxima atoms and expressions are comparable under @code{orderlessp} and @code{ordergreatp}.

Operators @code{<} and @code{>} order numbers, constants, and constant expressions by magnitude.
Note that @code{orderlessp} and @code{ordergreatp} do not order numbers, constants, and constant expressions by magnitude.

@code{ordermagnitudep} orders numbers, constants, and constant expressions the same as @code{<},
and all other elements the same as @code{orderlessp}.

Examples:

@code{sort} sorts a list according to a predicate of two arguments
which defines a strict weak order on the elements of the list.

@c ===beg===
@c sort ([1, a, b, 2, 3, c], 'orderlessp);
@c sort ([1, a, b, 2, 3, c], 'ordergreatp);
@c ===end===
@example
@group
(%i1) sort ([1, a, b, 2, 3, c], 'orderlessp);
(%o1)                  [1, 2, 3, a, b, c]
@end group
@group
(%i2) sort ([1, a, b, 2, 3, c], 'ordergreatp);
(%o2)                  [c, b, a, 3, 2, 1]
@end group
@end example

The predicate may be specified as the name of a function 
or binary infix operator, or as a @code{lambda} expression.  If specified as
the name of an operator, the name must be enclosed in double quotes.

@c ===beg===
@c L : [[1, x], [3, y], [4, w], [2, z]];
@c foo (a, b) := a[1] > b[1];
@c sort (L, 'foo);
@c infix (">>");
@c a >> b := a[1] > b[1];
@c sort (L, ">>");
@c sort (L, lambda ([a, b], a[1] > b[1]));
@c ===end===
@example
@group
(%i1) L : [[1, x], [3, y], [4, w], [2, z]];
(%o1)           [[1, x], [3, y], [4, w], [2, z]]
@end group
@group
(%i2) foo (a, b) := a[1] > b[1];
(%o2)                 foo(a, b) := a  > b
                                    1    1
@end group
@group
(%i3) sort (L, 'foo);
(%o3)           [[4, w], [3, y], [2, z], [1, x]]
@end group
@group
(%i4) infix (">>");
(%o4)                          >>
@end group
@group
(%i5) a >> b := a[1] > b[1];
(%o5)                  (a >> b) := a  > b
                                    1    1
@end group
@group
(%i6) sort (L, ">>");
(%o6)           [[4, w], [3, y], [2, z], [1, x]]
@end group
@group
(%i7) sort (L, lambda ([a, b], a[1] > b[1]));
(%o7)           [[4, w], [3, y], [2, z], [1, x]]
@end group
@end example

@code{sort(@var{L})} is equivalent to @code{sort(@var{L}, orderlessp)}.

@c ===beg===
@c L : [a, 2*b, -5, 7, 1 + %e, %pi];
@c sort (L);
@c sort (L, 'orderlessp);
@c ===end===
@example
@group
(%i1) L : [a, 2*b, -5, 7, 1 + %e, %pi];
(%o1)             [a, 2 b, - 5, 7, %e + 1, %pi]
@end group
@group
(%i2) sort (L);
(%o2)             [- 5, 7, %e + 1, %pi, a, 2 b]
@end group
@group
(%i3) sort (L, 'orderlessp);
(%o3)             [- 5, 7, %e + 1, %pi, a, 2 b]
@end group
@end example

The default sorting order is ascending, as determined by @mrefdot{orderlessp} The predicate @code{ordergreatp} sorts a list in descending order.

@c ===beg===
@c L : [a, 2*b, -5, 7, 1 + %e, %pi];
@c sort (L);
@c sort (L, 'ordergreatp);
@c ===end===
@example
@group
(%i1) L : [a, 2*b, -5, 7, 1 + %e, %pi];
(%o1)             [a, 2 b, - 5, 7, %e + 1, %pi]
@end group
@group
(%i2) sort (L);
(%o2)             [- 5, 7, %e + 1, %pi, a, 2 b]
@end group
@group
(%i3) sort (L, 'ordergreatp);
(%o3)             [2 b, a, %pi, %e + 1, 7, - 5]
@end group
@end example

All Maxima atoms and expressions are comparable under @code{orderlessp} and @code{ordergreatp}.

@c ===beg===
@c L : [11, -17, 29b0, 9*c, 7.55, foo(x, y), -5/2, b + a];
@c sort (L, orderlessp);
@c sort (L, ordergreatp);
@c ===end===
@example
@group
(%i1) L : [11, -17, 29b0, 9*c, 7.55, foo(x, y), -5/2, b + a];
                                                 5
(%o1)  [11, - 17, 2.9b1, 9 c, 7.55, foo(x, y), - -, b + a]
                                                 2
@end group
@group
(%i2) sort (L, orderlessp);
                5
(%o2)  [- 17, - -, 7.55, 11, 2.9b1, b + a, 9 c, foo(x, y)]
                2
@end group
@group
(%i3) sort (L, ordergreatp);
                                                  5
(%o3)  [foo(x, y), 9 c, b + a, 2.9b1, 11, 7.55, - -, - 17]
                                                  2
@end group
@end example

Operators @code{<} and @code{>} order numbers, constants, and constant expressions by magnitude.
Note that @code{orderlessp} and @code{ordergreatp} do not order numbers, constants, and constant expressions by magnitude.

@c ===beg===
@c L : [%pi, 3, 4, %e, %gamma];
@c sort (L, ">");
@c sort (L, ordergreatp);
@c ===end===
@example
@group
(%i1) L : [%pi, 3, 4, %e, %gamma];
(%o1)                [%pi, 3, 4, %e, %gamma]
@end group
@group
(%i2) sort (L, ">");
(%o2)                [4, %pi, 3, %e, %gamma]
@end group
@group
(%i3) sort (L, ordergreatp);
(%o3)                [%pi, %gamma, %e, 4, 3]
@end group
@end example

@code{ordermagnitudep} orders numbers, constants, and constant expressions the same as @code{<},
and all other elements the same as @code{orderlessp}.

@c ===beg===
@c L : [%i, 1+%i, 2*x, minf, inf, %e, sin(1), 0, 1, 2, 3, 1.0, 1.0b0];
@c sort (L, ordermagnitudep);
@c sort (L, orderlessp);
@c ===end===
@example
@group
(%i1) L : [%i, 1+%i, 2*x, minf, inf, %e, sin(1), 0, 1, 2, 3, 1.0, 1.0b0];
(%o1) [%i, %i + 1, 2 x, minf, inf, %e, sin(1), 0, 1, 2, 3, 1.0, 
                                                           1.0b0]
@end group
@group
(%i2) sort (L, ordermagnitudep);
(%o2) [minf, 0, sin(1), 1, 1.0, 1.0b0, 2, %e, 3, inf, %i, 
                                                     %i + 1, 2 x]
@end group
@group
(%i3) sort (L, orderlessp);
(%o3) [0, 1, 1.0, 2, 3, sin(1), 1.0b0, %e, %i, %i + 1, inf, 
                                                       minf, 2 x]
@end group
@end example

@opencatbox
@category{Lists}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{sublist}
@deffn {Function} sublist (@var{list}, @var{p})

Returns the list of elements of @var{list} for which the predicate @code{p}
returns @code{true}.

Example:

@c ===beg===
@c L: [1, 2, 3, 4, 5, 6];
@c sublist (L, evenp);
@c ===end===
@example
@group
(%i1) L: [1, 2, 3, 4, 5, 6];
(%o1)                  [1, 2, 3, 4, 5, 6]
@end group
@group
(%i2) sublist (L, evenp);
(%o2)                       [2, 4, 6]
@end group
@end example

@opencatbox
@category{Lists}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{sublist_indices}
@deffn {Function} sublist_indices (@var{L}, @var{P})

Returns the indices of the elements @code{x} of the list @var{L} for which
the predicate @code{maybe(@var{P}(x))} returns @code{true};
this excludes @code{unknown} as well as @code{false}.
@var{P} may be the name of a function or a lambda expression.
@var{L} must be a literal list.

Examples:

@c ===beg===
@c sublist_indices ('[a, b, b, c, 1, 2, b, 3, b], 
@c                        lambda ([x], x='b));
@c sublist_indices ('[a, b, b, c, 1, 2, b, 3, b], symbolp);
@c sublist_indices ([1 > 0, 1 < 0, 2 < 1, 2 > 1, 2 > 0], 
@c                        identity);
@c assume (x < -1);
@c map (maybe, [x > 0, x < 0, x < -2]);
@c sublist_indices ([x > 0, x < 0, x < -2], identity);
@c ===end===
@example
@group
(%i1) sublist_indices ('[a, b, b, c, 1, 2, b, 3, b],
                       lambda ([x], x='b));
(%o1)                     [2, 3, 7, 9]
@end group
@group
(%i2) sublist_indices ('[a, b, b, c, 1, 2, b, 3, b], symbolp);
(%o2)                  [1, 2, 3, 4, 7, 9]
@end group
@group
(%i3) sublist_indices ([1 > 0, 1 < 0, 2 < 1, 2 > 1, 2 > 0],
                       identity);
(%o3)                       [1, 4, 5]
@end group
@group
(%i4) assume (x < -1);
(%o4)                       [x < - 1]
@end group
@group
(%i5) map (maybe, [x > 0, x < 0, x < -2]);
(%o5)                [false, true, unknown]
@end group
@group
(%i6) sublist_indices ([x > 0, x < 0, x < -2], identity);
(%o6)                          [2]
@end group
@end example

@opencatbox
@category{Lists}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{tenth}
@deffn {Function} tenth (@var{expr})

Returns the 10'th item of expression or list @var{expr}.
See @mref{first} for more details.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{third}
@deffn {Function} third (@var{expr})

Returns the 3'rd item of expression or list @var{expr}.
See @mref{first} for more details.

@opencatbox
@category{Lists} @category{Expressions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@c TREE_REDUCE ACCEPTS A SET OR LIST AS AN ARGUMENT, BUT RREDUCE AND LREDUCE WANT ONLY LISTS; STRANGE
@anchor{tree_reduce}
@deffn {Function} tree_reduce @
@fname{tree_reduce} (@var{F}, @var{s}) @
@fname{tree_reduce} (@var{F}, @var{s}, @var{s_0})

Extends the binary function @var{F} to an n-ary function by composition,
where @var{s} is a set or list.

@code{tree_reduce} is equivalent to the following:
Apply @var{F} to successive pairs of elements
to form a new list @code{[@var{F}(@var{s_1}, @var{s_2}), @var{F}(@var{s_3}, @var{s_4}), ...]},
carrying the final element unchanged if there are an odd number of elements.
Then repeat until the list is reduced to a single element, which is the return value.

When the optional argument @var{s_0} is present,
the result is equivalent @code{tree_reduce(@var{F}, cons(@var{s_0}, @var{s}))}.

For addition of floating point numbers,
@code{tree_reduce} may return a sum that has a smaller rounding error
than either @code{rreduce} or @code{lreduce}.

The elements of @var{s} and the partial results may be arranged in a minimum-depth binary tree,
thus the name "tree_reduce".

Examples:

@code{tree_reduce} applied to a list with an even number of elements.

@c ===beg===
@c tree_reduce (f, [a, b, c, d]);
@c ===end===
@example
@group
(%i1) tree_reduce (f, [a, b, c, d]);
(%o1)                  f(f(a, b), f(c, d))
@end group
@end example

@code{tree_reduce} applied to a list with an odd number of elements.

@c ===beg===
@c tree_reduce (f, [a, b, c, d, e]);
@c ===end===
@example
@group
(%i1) tree_reduce (f, [a, b, c, d, e]);
(%o1)               f(f(f(a, b), f(c, d)), e)
@end group
@end example

@opencatbox
@category{Sets} @category{Lists}
@closecatbox

@end deffn

@c -----------------------------------------------------------------------------
@anchor{unique}
@deffn {Function} unique (@var{L})

Returns the unique elements of the list @var{L}.

When all the elements of @var{L} are unique,
@code{unique} returns a shallow copy of @var{L},
not @var{L} itself.

If @var{L} is not a list, @code{unique} returns @var{L}.

Example:

@c ===beg===
@c unique ([1, %pi, a + b, 2, 1, %e, %pi, a + b, [1]]);
@c ===end===
@example
@group
(%i1) unique ([1, %pi, a + b, 2, 1, %e, %pi, a + b, [1]]);
(%o1)              [1, 2, %e, %pi, [1], b + a]
@end group
@end example
@end deffn

@c -----------------------------------------------------------------------------
@c XREDUCE ACCEPTS A SET OR LIST AS AN ARGUMENT, BUT RREDUCE AND LREDUCE WANT ONLY LISTS; STRANGE
@anchor{xreduce}
@deffn {Function} xreduce @
@fname{xreduce} (@var{F}, @var{s}) @
@fname{xreduce} (@var{F}, @var{s}, @var{s_0})

Extends the function @var{F} to an n-ary function by composition,
or, if @var{F} is already n-ary, applies @var{F} to @var{s}.
When @var{F} is not n-ary, @code{xreduce} is the same as @code{lreduce}.
The argument @var{s} is a list.

Functions known to be n-ary include
addition @code{+}, multiplication @code{*}, @code{and}, @code{or}, @code{max},
@code{min}, and @code{append}.
Functions may also be declared n-ary by @code{declare(@var{F}, nary)}.
For these functions,
@code{xreduce} is expected to be faster than either @code{rreduce} or @code{lreduce}.

When the optional argument @var{s_0} is present,
the result is equivalent to @code{xreduce(@var{s}, cons(@var{s_0}, @var{s}))}.

@c NOT SURE WHAT IS THE RELEVANCE OF THE FOLLOWING COMMENT
@c MAXIMA IS NEVER SO CAREFUL ABOUT FLOATING POINT ASSOCIATIVITY SO FAR AS I KNOW
Floating point addition is not exactly associative; be that as it may,
@code{xreduce} applies Maxima's n-ary addition when @var{s} contains floating point numbers.

Examples:

@code{xreduce} applied to a function known to be n-ary.
@code{F} is called once, with all arguments.

@c ===beg===
@c declare (F, nary);
@c F ([L]) := L;
@c xreduce (F, [a, b, c, d, e]);
@c ===end===
@example
@group
(%i1) declare (F, nary);
(%o1)                         done
@end group
@group
(%i2) F ([L]) := L;
(%o2)                      F([L]) := L
@end group
@group
(%i3) xreduce (F, [a, b, c, d, e]);
(%o3)                    [a, b, c, d, e]
@end group
@end example

@code{xreduce} applied to a function not known to be n-ary.
@code{G} is called several times, with two arguments each time.

@c ===beg===
@c G ([L]) := L;
@c xreduce (G, [a, b, c, d, e]);
@c lreduce (G, [a, b, c, d, e]);
@c ===end===
@example
@group
(%i1) G ([L]) := L;
(%o1)                      G([L]) := L
@end group
@group
(%i2) xreduce (G, [a, b, c, d, e]);
(%o2)                 [[[[a, b], c], d], e]
@end group
@group
(%i3) lreduce (G, [a, b, c, d, e]);
(%o3)                 [[[[a, b], c], d], e]
@end group
@end example

@opencatbox
@category{Sets} @category{Lists}
@closecatbox

@end deffn

@c h-----------------------------------------------------------------------------
@node Performance considerations for Lists, ,Functions and Variables for Lists, Lists
@subsection Performance considerations for Lists
@c -----------------------------------------------------------------------------

Lists provide efficient ways of appending and removing elements.
They can be created without knowing their final dimensions.
Lisp provides efficient means of copying and handling lists.
Also nested lists do not need to be strictly rectangular.
These advantages over declared arrays come with the drawback that the amount of time
needed for accessing a random element within a list may be roughly
proportional to the element's distance from its beginning.
Efficient traversal of lists is still possible, though, by using the list as a
stack or a fifo:

@c ===beg===
@c l:[Test,1,2,3,4];
@c while l # [] do
@c    disp(pop(l));
@c ===end===
@example
@group
(%i1) l:[Test,1,2,3,4];
(%o1)                  [Test, 1, 2, 3, 4]
@end group
(%i2) while l # [] do
   disp(pop(l));
                              Test

                                1

                                2

                                3

                                4

(%o2)                         done
@end example
Another even faster example would be:
@c ===beg===
@c l:[Test,1,2,3,4];
@c for i in l do
@c    disp(pop(l));
@c ===end===
@example
@group
(%i1) l:[Test,1,2,3,4];
(%o1)                  [Test, 1, 2, 3, 4]
@end group
(%i2) for i in l do
   disp(pop(l));
                              Test

                                1

                                2

                                3

                                4

(%o2)                         done
@end example

Beginning traversal with the last element of a list is possible after
reversing the list using @code{reverse ()}.
If the elements of a long list need to be processed in a different
order performance might be increased by converting the list into a
declared array first.

It is also to note that the ending condition of @code{for} loops
is tested for every iteration which means that the result of a
@code{length} should be cached if it is used in the ending
condition:

@c ===beg===
@c l:makelist(i,i,1,100000)$
@c lngth:length(l);
@c x:1;
@c for i:1 thru lngth do
@c     x:x+1$
@c x;
@c ===end===
@example
(%i1) l:makelist(i,i,1,100000)$
@group
(%i2) lngth:length(l);
(%o2)                        100000
@end group
@group
(%i3) x:1;
(%o3)                           1
@end group
@group
(%i4) for i:1 thru lngth do
    x:x+1$
@end group
@group
(%i5) x;
(%o5)                        100001
@end group
@end example