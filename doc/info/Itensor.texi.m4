@c -*- Mode: texinfo -*-
@c RECOMMEND REVISE TEXT THROUGHOUT TO LOSE NOTION OF TIME RELATIVE TO PRESENT
@c LOOK FOR "NOW", "OLD", "NEW", "RECENT", "EARLIER", DATES

@c RERUN EXAMPLES WITH ADDT'L WHITESPACE IN INPUT TO AID LEGIBILITY

@menu
* Introduction to itensor::
* Functions and Variables for itensor::
@end menu

@c -----------------------------------------------------------------------------
@node Introduction to itensor, Functions and Variables for itensor, itensor, itensor
@section Introduction to itensor
@c -----------------------------------------------------------------------------

Maxima implements symbolic tensor manipulation of two distinct types:
component tensor manipulation (@code{ctensor} package) and indicial tensor
manipulation (@code{itensor} package).

Nota bene: Please see the note on 'new tensor notation' below.

Component tensor manipulation means that geometrical tensor
objects are represented as arrays or matrices. Tensor operations such
as contraction or covariant differentiation are carried out by
actually summing over repeated (dummy) indices with @code{do} statements.
That is, one explicitly performs operations on the appropriate tensor
components stored in an array or matrix.

Indicial tensor manipulation is implemented by representing
tensors as functions of their covariant, contravariant and derivative
indices. Tensor operations such as contraction or covariant
differentiation are performed by manipulating the indices themselves
rather than the components to which they correspond.

These two approaches to the treatment of differential, algebraic and
analytic processes in the context of Riemannian geometry have various
advantages and disadvantages which reveal themselves only through the
particular nature and difficulty of the user's problem.  However, one
should keep in mind the following characteristics of the two
implementations:

The representation of tensors and tensor operations explicitly in
terms of their components makes @code{ctensor} easy to use. Specification of
the metric and the computation of the induced tensors and invariants
is straightforward. Although all of Maxima's powerful simplification
capacity is at hand, a complex metric with intricate functional and
coordinate dependencies can easily lead to expressions whose size is
excessive and whose structure is hidden. In addition, many calculations
involve intermediate expressions which swell causing programs to
terminate before completion. Through experience, a user can avoid
many of these difficulties.

Because of the special way in which tensors and tensor operations
are represented in terms of symbolic operations on their indices,
expressions which in the component representation would be
unmanageable can sometimes be greatly simplified by using the special
routines for symmetrical objects in @code{itensor}. In this way the structure
of a large expression may be more transparent. On the other hand, because
of the special indicial representation in @code{itensor}, in some cases the
user may find difficulty with the specification of the metric, function
definition, and the evaluation of differentiated "indexed" objects.

The @code{itensor} package can carry out differentiation with respect to an indexed
variable, which allows one to use the package when dealing with Lagrangian
and Hamiltonian formalisms. As it is possible to differentiate a field
Lagrangian with respect to an (indexed) field variable, one can use Maxima
to derive the corresponding Euler-Lagrange equations in indicial form. These
equations can be translated into component tensor (@code{ctensor}) programs using
the @code{ic_convert} function, allowing us to solve the field equations in a
particular coordinate representation, or to recast the equations of motion
in Hamiltonian form. See @code{einhil.dem} and @code{bradic.dem} for two comprehensive
examples. The first, @code{einhil.dem}, uses the Einstein-Hilbert action to derive
the Einstein field tensor in the homogeneous and isotropic case (Friedmann
equations) and the spherically symmetric, static case (Schwarzschild
solution.) The second, @code{bradic.dem}, demonstrates how to compute the Friedmann
equations from the action of Brans-Dicke gravity theory, and also derives
the Hamiltonian associated with the theory's scalar field.

@opencatbox
@category{Tensors}
@category{Share packages}
@category{Package itensor}
@closecatbox

@c -----------------------------------------------------------------------------
@subsection New tensor notation
@c -----------------------------------------------------------------------------

Earlier versions of the @code{itensor} package in Maxima used a notation that sometimes
led to incorrect index ordering. Consider the following, for instance:

@example
(%i2) imetric(g);
(%o2)                                done
(%i3) ishow(g([],[j,k])*g([],[i,l])*a([i,j],[]))$
                                 i l  j k
(%t3)                           g    g    a
                                           i j
(%i4) ishow(contract(%))$
                                      k l
(%t4)                                a
@end example

This result is incorrect unless @code{a} happens to be a symmetric tensor.
The reason why this happens is that although @code{itensor} correctly maintains
the order within the set of covariant and contravariant indices, once an
index is raised or lowered, its position relative to the other set of
indices is lost.

To avoid this problem, a new notation has been developed that remains fully
compatible with the existing notation and can be used interchangeably. In
this notation, contravariant indices are inserted in the appropriate
positions in the covariant index list, but with a minus sign prepended.
Functions like @mref{contract_Itensor} and @mref{ishow} are now aware of this
new index notation and can process tensors appropriately.

In this new notation, the previous example yields a correct result:

@example
(%i5) ishow(g([-j,-k],[])*g([-i,-l],[])*a([i,j],[]))$
                                 i l       j k
(%t5)                           g    a    g
                                      i j
(%i6) ishow(contract(%))$
                                      l k
(%t6)                                a
@end example

Presently, the only code that makes use of this notation is the @code{lc2kdt}
function. Through this notation, it achieves consistent results as it
applies the metric tensor to resolve Levi-Civita symbols without resorting
to numeric indices.

Since this code is brand new, it probably contains bugs. While it has been
tested to make sure that it doesn't break anything using the "old" tensor
notation, there is a considerable chance that "new" tensors will fail to
interoperate with certain functions or features. These bugs will be fixed
as they are encountered... until then, caveat emptor!

@c -----------------------------------------------------------------------------
@subsection Indicial tensor manipulation
@c -----------------------------------------------------------------------------

The indicial tensor manipulation package may be loaded by
@code{load("itensor")}. Demos are also available: try @code{demo("tensor")}.

In @code{itensor} a tensor is represented as an "indexed object" .  This is a
function of 3 groups of indices which represent the covariant,
contravariant and derivative indices.  The covariant indices are
specified by a list as the first argument to the indexed object, and
the contravariant indices by a list as the second argument. If the
indexed object lacks either of these groups of indices then the empty
list @code{[]} is given as the corresponding argument.  Thus, @code{g([a,b],[c])}
represents an indexed object called @code{g} which has two covariant indices
@code{(a,b)}, one contravariant index (@code{c}) and no derivative indices.

The derivative indices, if they are present, are appended as
additional arguments to the symbolic function representing the tensor.
They can be explicitly specified by the user or be created in the
process of differentiation with respect to some coordinate variable.
Since ordinary differentiation is commutative, the derivative indices
are sorted alphanumerically, unless @code{iframe_flag} is set to @code{true},
indicating that a frame metric is being used. This canonical ordering makes it
possible for Maxima to recognize that, for example, @code{t([a],[b],i,j)} is
the same as @code{t([a],[b],j,i)}.  Differentiation of an indexed object with
respect to some coordinate whose index does not appear as an argument
to the indexed object would normally yield zero. This is because
Maxima would not know that the tensor represented by the indexed
object might depend implicitly on the corresponding coordinate.  By
modifying the existing Maxima function @code{diff} in @code{itensor}, Maxima now
assumes that all indexed objects depend on any variable of
differentiation unless otherwise stated.  This makes it possible for
the summation convention to be extended to derivative indices. It
should be noted that @code{itensor} does not possess the capabilities of
raising derivative indices, and so they are always treated as
covariant.

The following functions are available in the tensor package for
manipulating indexed objects.  At present, with respect to the
simplification routines, it is assumed that indexed objects do not
by default possess symmetry properties. This can be overridden by
setting the variable @code{allsym[false]} to @code{true}, which will
result in treating all indexed objects completely symmetric in their
lists of covariant indices and symmetric in their lists of
contravariant indices.

The @code{itensor} package generally treats tensors as opaque objects. Tensorial
equations are manipulated based on algebraic rules, specifically symmetry
and contraction rules. In addition, the @code{itensor} package understands
covariant differentiation, curvature, and torsion. Calculations can be
performed relative to a metric of moving frame, depending on the setting
of the @code{iframe_flag} variable.

A sample session below demonstrates how to load the @code{itensor} package,
specify the name of the metric, and perform some simple calculations.

@example
(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) imetric(g);
(%o2)                                done
(%i3) components(g([i,j],[]),p([i,j],[])*e([],[]))$
(%i4) ishow(g([k,l],[]))$
(%t4)                               e p
                                       k l
(%i5) ishow(diff(v([i],[]),t))$
(%t5)                                  0
(%i6) depends(v,t);
(%o6)                               [v(t)]
(%i7) ishow(diff(v([i],[]),t))$
                                    d
(%t7)                               -- (v )
                                    dt   i
(%i8) ishow(idiff(v([i],[]),j))$
(%t8)                                v
                                      i,j
(%i9) ishow(extdiff(v([i],[]),j))$
(%t9)                             v    - v
                                   j,i    i,j
                                  -----------
                                       2
(%i10) ishow(liediff(v,w([i],[])))$
                               %3          %3
(%t10)                        v   w     + v   w
                                   i,%3    ,i  %3
(%i11) ishow(covdiff(v([i],[]),j))$
                                              %4
(%t11)                        v    - v   ichr2
                               i,j    %4      i j
(%i12) ishow(ev(%,ichr2))$
                %4 %5
(%t12) v    - (g      v   (e p       + e   p     - e p       - e    p
        i,j            %4     j %5,i    ,i  j %5      i j,%5    ,%5  i j

                                         + e p       + e   p    ))/2
                                              i %5,j    ,j  i %5
(%i13) iframe_flag:true;
(%o13)                               true
(%i14) ishow(covdiff(v([i],[]),j))$
                                             %6
(%t14)                        v    - v   icc2
                               i,j    %6     i j
(%i15) ishow(ev(%,icc2))$
                                             %6
(%t15)                        v    - v   ifc2
                               i,j    %6     i j
(%i16) ishow(radcan(ev(%,ifc2,ifc1)))$
             %6 %7                    %6 %7
(%t16) - (ifg      v   ifb       + ifg      v   ifb       - 2 v
                    %6    j %7 i             %6    i j %7      i,j

                                             %6 %7
                                        - ifg      v   ifb      )/2
                                                    %6    %7 i j
(%i17) ishow(canform(s([i,j],[])-s([j,i])))$
(%t17)                            s    - s
                                   i j    j i
(%i18) decsym(s,2,0,[sym(all)],[]);
(%o18)                               done
(%i19) ishow(canform(s([i,j],[])-s([j,i])))$
(%t19)                                 0
(%i20) ishow(canform(a([i,j],[])+a([j,i])))$
(%t20)                            a    + a
                                   j i    i j
(%i21) decsym(a,2,0,[anti(all)],[]);
(%o21)                               done
(%i22) ishow(canform(a([i,j],[])+a([j,i])))$
(%t22)                                 0
@end example

@c end concepts itensor

@c -----------------------------------------------------------------------------
@node Functions and Variables for itensor,  , Introduction to itensor, itensor
@section Functions and Variables for itensor
@subsection Managing indexed objects
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
@anchor{dispcon}
@deffn {Function} dispcon @
@fname{dispcon} (@var{tensor_1}, @var{tensor_2}, @dots{}) @
@fname{dispcon} (all)

Displays the contraction properties of its arguments as were given to
@code{defcon}.  @code{dispcon (all)} displays all the contraction properties
which were defined.

@opencatbox
@category{Display functions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{entertensor}
@deffn {Function} entertensor (@var{name})

is a function which, by prompting, allows one to create an indexed
object called @var{name} with any number of tensorial and derivative
indices. Either a single index or a list of indices (which may be
null) is acceptable input (see the example under @code{covdiff}).

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{changename}
@deffn {Function} changename (@var{old}, @var{new}, @var{expr})

will change the name of all indexed objects called @var{old} to @var{new}
in @var{expr}. @var{old} may be either a symbol or a list of the form
@code{[@var{name}, @var{m}, @var{n}]} in which case only those indexed objects called
@var{name} with @var{m} covariant and @var{n} contravariant indices will be
renamed to @var{new}.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@deffn {Function} listoftens

@anchor{listoftens}

Lists all tensors in a tensorial expression, complete with their indices. E.g.,

@example

(%i6) ishow(a([i,j],[k])*b([u],[],v)+c([x,y],[])*d([],[])*e)$
                                         k
(%t6)                        d e c    + a    b
                                  x y    i j  u,v
(%i7) ishow(listoftens(%))$
                               k
(%t7)                        [a   , b   , c   , d]
                               i j   u,v   x y

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{ishow}
@deffn {Function} ishow (@var{expr})

displays @var{expr} with the indexed objects in it shown having their
covariant indices as subscripts and contravariant indices as
superscripts. The derivative indices are displayed as subscripts,
separated from the covariant indices by a comma (see the examples
throughout this document).

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{indices}
@deffn {Function} indices (@var{expr})

Returns a list of two elements.  The first is a list of the free
indices in @var{expr} (those that occur only once). The second is the
list of the dummy indices in @var{expr} (those that occur exactly twice)
as the following example demonstrates.

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) ishow(a([i,j],[k,l],m,n)*b([k,o],[j,m,p],q,r))$
                                k l      j m p
(%t2)                          a        b
                                i j,m n  k o,q r
(%i3) indices(%);
(%o3)                 [[l, p, i, n, o, q, r], [k, j, m]]

@end example

A tensor product containing the same index more than twice is syntactically
illegal. @code{indices} attempts to deal with these expressions in a
reasonable manner; however, when it is called to operate upon such an
illegal expression, its behavior should be considered undefined.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{rename}
@deffn {Function} rename @
@fname{rename} (@var{expr}) @
@fname{rename} (@var{expr}, @var{count})

Returns an expression equivalent to @var{expr} but with the dummy indices
in each term chosen from the set @code{[%1, %2,...]}, if the optional second
argument is omitted. Otherwise, the dummy indices are indexed
beginning at the value of @var{count}.  Each dummy index in a product
will be different. For a sum, @code{rename} will operate upon each term in
the sum resetting the counter with each term. In this way @code{rename} can
serve as a tensorial simplifier. In addition, the indices will be
sorted alphanumerically (if @code{allsym} is @code{true}) with respect to
covariant or contravariant indices depending upon the value of @code{flipflag}.
If @code{flipflag} is @code{false} then the indices will be renamed according
to the order of the contravariant indices. If @code{flipflag} is @code{true}
the renaming will occur according to the order of the covariant
indices. It often happens that the combined effect of the two renamings will
reduce an expression more than either one by itself.

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) allsym:true;
(%o2)                                true
(%i3) g([],[%4,%5])*g([],[%6,%7])*ichr2([%1,%4],[%3])*
ichr2([%2,%3],[u])*ichr2([%5,%6],[%1])*ichr2([%7,r],[%2])-
g([],[%4,%5])*g([],[%6,%7])*ichr2([%1,%2],[u])*
ichr2([%3,%5],[%1])*ichr2([%4,%6],[%3])*ichr2([%7,r],[%2]),noeval$
(%i4) expr:ishow(%)$
@group
       %4 %5  %6 %7      %3         u          %1         %2
(%t4) g      g      ichr2      ichr2      ichr2      ichr2
                         %1 %4      %2 %3      %5 %6      %7 r

        %4 %5  %6 %7      u          %1         %3         %2
     - g      g      ichr2      ichr2      ichr2      ichr2
                          %1 %2      %3 %5      %4 %6      %7 r
@end group
(%i5) flipflag:true;
(%o5)                                true
(%i6) ishow(rename(expr))$
       %2 %5  %6 %7      %4         u          %1         %3
(%t6) g      g      ichr2      ichr2      ichr2      ichr2
                         %1 %2      %3 %4      %5 %6      %7 r

        %4 %5  %6 %7      u          %1         %3         %2
     - g      g      ichr2      ichr2      ichr2      ichr2
                          %1 %2      %3 %4      %5 %6      %7 r
(%i7) flipflag:false;
(%o7)                                false
(%i8) rename(%th(2));
(%o8)                                  0
(%i9) ishow(rename(expr))$
       %1 %2  %3 %4      %5         %6         %7        u
(%t9) g      g      ichr2      ichr2      ichr2     ichr2
                         %1 %6      %2 %3      %4 r      %5 %7

        %1 %2  %3 %4      %6         %5         %7        u
     - g      g      ichr2      ichr2      ichr2     ichr2
                          %1 %3      %2 %6      %4 r      %5 %7
@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c THIS FUNCTION IS IN THE SHARE PACKAGE itensor.lisp
@c MOVE THIS DESCRIPTION TO Itensor.texi

@c -----------------------------------------------------------------------------
@anchor{show}
@deffn {Function} show (@var{expr})

Displays @code{expr} with the indexed objects in it shown
having covariant indices as subscripts, contravariant indices as
superscripts.  The derivative indices are displayed as subscripts,
separated from the covariant indices by a comma.

@opencatbox
@category{Package itensor}
@category{Display functions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{flipflag}
@defvr {Option variable} flipflag
Default value: @code{false}

If @code{false} then the indices will be
renamed according to the order of the contravariant indices,
otherwise according to the order of the covariant indices.

If @code{flipflag} is @code{false} then @code{rename} forms a list
of the contravariant indices as they are encountered from left to right
(if @code{true} then of the covariant indices). The first dummy
index in the list is renamed to @code{%1}, the next to @code{%2}, etc.
Then sorting occurs after the @code{rename}-ing (see the example
under @code{rename}).

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{defcon}
@deffn {Function} defcon @
@fname{defcon} (@var{tensor_1}) @
@fname{defcon} (@var{tensor_1}, @var{tensor_2}, @var{tensor_3})

gives @var{tensor_1} the property that the
contraction of a product of @var{tensor_1} and @var{tensor_2} results in @var{tensor_3}
with the appropriate indices.  If only one argument, @var{tensor_1}, is
given, then the contraction of the product of @var{tensor_1} with any indexed
object having the appropriate indices (say @code{my_tensor}) will yield an
indexed object with that name, i.e. @code{my_tensor}, and with a new set of
indices reflecting the contractions performed.
    For example, if @code{imetric:g}, then @code{defcon(g)} will implement the
raising and lowering of indices through contraction with the metric
tensor.
    More than one @code{defcon} can be given for the same indexed object; the
latest one given which applies in a particular contraction will be
used.
@code{contractions} is a list of those indexed objects which have been given
contraction properties with @code{defcon}.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{remcon}
@deffn {Function} remcon @
@fname{remcon} (@var{tensor_1}, ..., @var{tensor_n}) @
@fname{remcon} (all)

Removes all the contraction properties
from the (@var{tensor_1}, ..., @var{tensor_n}). @code{remcon(all)} removes all contraction
properties from all indexed objects.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{contract_Itensor}
@deffn {Function} contract (@var{expr})

Carries out the tensorial contractions in @var{expr} which may be any
combination of sums and products. This function uses the information
given to the @code{defcon} function. For best results, @code{expr}
should be fully expanded. @code{ratexpand} is the fastest way to expand
products and powers of sums if there are no variables in the denominators
of the terms. The @code{gcd} switch should be @code{false} if GCD
cancellations are unnecessary.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{indexed_tensor}
@deffn {Function} indexed_tensor (@var{tensor})

Must be executed before assigning components to a @var{tensor} for which
a built in value already exists as with @code{ichr1}, @code{ichr2},
@code{icurvature}. See the example under @mref{icurvature}.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{components}
@deffn {Function} components (@var{tensor}, @var{expr})

permits one to assign an indicial value to an expression
@var{expr} giving the values of the components of @var{tensor}. These
are automatically substituted for the tensor whenever it occurs with
all of its indices. The tensor must be of the form @code{t([...],[...])}
where either list may be empty. @var{expr} can be any indexed expression
involving other objects with the same free indices as @var{tensor}. When
used to assign values to the metric tensor wherein the components
contain dummy indices one must be careful to define these indices to
avoid the generation of multiple dummy indices. Removal of this
assignment is given to the function @code{remcomps}.

It is important to keep in mind that @code{components} cares only about
the valence of a tensor, not about any particular index ordering. Thus
assigning components to, say, @code{x([i,-j],[])}, @code{x([-j,i],[])}, or
@code{x([i],[j])} all produce the same result, namely components being
assigned to a tensor named @code{x} with valence @code{(1,1)}.

Components can be assigned to an indexed expression in four ways, two
of which involve the use of the @code{components} command:

1) As an indexed expression. For instance:

@example
(%i2) components(g([],[i,j]),e([],[i])*p([],[j]))$
(%i3) ishow(g([],[i,j]))$
                                      i  j
(%t3)                                e  p

@end example

2) As a matrix:

@example

(%i5) lg:-ident(4)$lg[1,1]:1$lg;
@group
                            [ 1   0    0    0  ]
                            [                  ]
                            [ 0  - 1   0    0  ]
(%o5)                       [                  ]
                            [ 0   0   - 1   0  ]
                            [                  ]
                            [ 0   0    0   - 1 ]
@end group
(%i6) components(g([i,j],[]),lg);
(%o6)                                done
(%i7) ishow(g([i,j],[]))$
(%t7)                                g
                                      i j
(%i8) g([1,1],[]);
(%o8)                                  1
(%i9) g([4,4],[]);
(%o9)                                 - 1
@end example

3) As a function. You can use a Maxima function to specify the
components of a tensor based on its indices. For instance, the following
code assigns @code{kdelta} to @code{h} if @code{h} has the same number
of covariant and contravariant indices and no derivative indices, and
@code{g} otherwise:

@example

(%i4) h(l1,l2,[l3]):=if length(l1)=length(l2) and length(l3)=0
  then kdelta(l1,l2) else apply(g,append([l1,l2], l3))$
(%i5) ishow(h([i],[j]))$
                                          j
(%t5)                               kdelta
                                          i
(%i6) ishow(h([i,j],[k],l))$
                                     k
(%t6)                               g
                                     i j,l
@end example

4) Using Maxima's pattern matching capabilities, specifically the
@code{defrule} and @code{applyb1} commands:

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) matchdeclare(l1,listp);
(%o2)                                done
(%i3) defrule(r1,m(l1,[]),(i1:idummy(),
      g([l1[1],l1[2]],[])*q([i1],[])*e([],[i1])))$

(%i4) defrule(r2,m([],l1),(i1:idummy(),
      w([],[l1[1],l1[2]])*e([i1],[])*q([],[i1])))$

(%i5) ishow(m([i,n],[])*m([],[i,m]))$
@group
                                    i m
(%t5)                              m    m
                                         i n
@end group
(%i6) ishow(rename(applyb1(%,r1,r2)))$
                           %1  %2  %3 m
(%t6)                     e   q   w     q   e   g
                                         %1  %2  %3 n
@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@anchor{remcomps}
@deffn {Function} remcomps (@var{tensor})

Unbinds all values from @var{tensor} which were assigned with the
@code{components} function.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c NEED LIST OF ARGUMENTS HERE

@c -----------------------------------------------------------------------------
@anchor{showcomps}
@deffn {Function} showcomps (@var{tensor})

Shows component assignments of a tensor, as made using the @code{components}
command. This function can be particularly useful when a matrix is assigned
to an indicial tensor using @code{components}, as demonstrated by the
following example:

@example

(%i1) load(ctensor);
(%o1)       /share/tensor/ctensor.mac
(%i2) load("itensor");
(%o2)      /share/tensor/itensor.lisp
(%i3) lg:matrix([sqrt(r/(r-2*m)),0,0,0],[0,r,0,0],
                [0,0,sin(theta)*r,0],[0,0,0,sqrt((r-2*m)/r)]);
               [         r                                     ]
               [ sqrt(-------)  0       0              0       ]
               [      r - 2 m                                  ]
               [                                               ]
               [       0        r       0              0       ]
(%o3)          [                                               ]
               [       0        0  r sin(theta)        0       ]
               [                                               ]
               [                                      r - 2 m  ]
               [       0        0       0        sqrt(-------) ]
               [                                         r     ]
(%i4) components(g([i,j],[]),lg);
(%o4)                                done
(%i5) showcomps(g([i,j],[]));
                  [         r                                     ]
                  [ sqrt(-------)  0       0              0       ]
                  [      r - 2 m                                  ]
                  [                                               ]
                  [       0        r       0              0       ]
(%t5)      g    = [                                               ]
            i j   [       0        0  r sin(theta)        0       ]
                  [                                               ]
                  [                                      r - 2 m  ]
                  [       0        0       0        sqrt(-------) ]
                  [                                         r     ]
(%o5)                                false

@end example

The @code{showcomps} command can also display components of a tensor of
rank higher than 2.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{idummy}
@deffn {Function} idummy ()

Increments @code{icounter} and returns as its value an index of the form
@code{%n} where n is a positive integer.  This guarantees that dummy indices
which are needed in forming expressions will not conflict with indices
already in use (see the example under @code{indices}).

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@anchor{idummyx}
@defvr {Option variable} idummyx
Default value: @code{%}

Is the prefix for dummy indices (see the example under @code{indices}).

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{icounter}
@defvr {Option variable} icounter
Default value: @code{1}

Determines the numerical suffix to be used in
generating the next dummy index in the tensor package.  The prefix is
determined by the option @code{idummy} (default: @code{%}).

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{kdelta}
@deffn {Function} kdelta (@var{L1}, @var{L2})
is the generalized Kronecker delta function defined in
the @code{itensor} package with @var{L1} the list of covariant indices and @var{L2}
the list of contravariant indices.  @code{kdelta([i],[j])} returns the ordinary
Kronecker delta.  The command @code{ev(@var{expr},kdelta)} causes the evaluation of
an expression containing @code{kdelta([],[])} to the dimension of the
manifold.

In what amounts to an abuse of this notation, @code{itensor} also allows
@code{kdelta} to have 2 covariant and no contravariant, or 2 contravariant
and no covariant indices, in effect providing a co(ntra)variant "unit matrix"
capability. This is strictly considered a programming aid and not meant to
imply that @code{kdelta([i,j],[])} is a valid tensorial object.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{kdels}
@deffn {Function} kdels (@var{L1}, @var{L2})

Symmetrized Kronecker delta, used in some calculations. For instance:

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) kdelta([1,2],[2,1]);
(%o2)                                 - 1
(%i3) kdels([1,2],[2,1]);
(%o3)                                  1
(%i4) ishow(kdelta([a,b],[c,d]))$
                             c       d         d       c
(%t4)                  kdelta  kdelta  - kdelta  kdelta
                             a       b         a       b
(%i4) ishow(kdels([a,b],[c,d]))$
                             c       d         d       c
(%t4)                  kdelta  kdelta  + kdelta  kdelta
                             a       b         a       b

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{levi_civita}
@deffn {Function} levi_civita (@var{L})
is the permutation (or Levi-Civita) tensor which yields 1 if
the list @var{L} consists of an even permutation of integers, -1 if it
consists of an odd permutation, and 0 if some indices in @var{L} are
repeated.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{lc2kdt}
@deffn {Function} lc2kdt (@var{expr})
Simplifies expressions containing the Levi-Civita symbol, converting these
to Kronecker-delta expressions when possible. The main difference between
this function and simply evaluating the Levi-Civita symbol is that direct
evaluation often results in Kronecker expressions containing numerical
indices. This is often undesirable as it prevents further simplification.
The @code{lc2kdt} function avoids this problem, yielding expressions that
are more easily simplified with @code{rename} or @code{contract}.

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) expr:ishow('levi_civita([],[i,j])
                 *'levi_civita([k,l],[])*a([j],[k]))$
                                  i j  k
(%t2)                  levi_civita    a  levi_civita
                                       j            k l
(%i3) ishow(ev(expr,levi_civita))$
                                  i j  k       1 2
(%t3)                       kdelta    a  kdelta
                                  1 2  j       k l
(%i4) ishow(ev(%,kdelta))$
             i       j         j       i   k
(%t4) (kdelta  kdelta  - kdelta  kdelta ) a
             1       2         1       2   j

                               1       2         2       1
                        (kdelta  kdelta  - kdelta  kdelta )
                               k       l         k       l
(%i5) ishow(lc2kdt(expr))$
                     k       i       j    k       j       i
(%t5)               a  kdelta  kdelta  - a  kdelta  kdelta
                     j       k       l    j       k       l
(%i6) ishow(contract(expand(%)))$
                                 i           i
(%t6)                           a  - a kdelta
                                 l           l
@end example

The @code{lc2kdt} function sometimes makes use of the metric tensor.
If the metric tensor was not defined previously with @code{imetric},
this results in an error.

@example

(%i7) expr:ishow('levi_civita([],[i,j])
                 *'levi_civita([],[k,l])*a([j,k],[]))$
@group
                                 i j            k l
(%t7)                 levi_civita    levi_civita    a
                                                     j k
@end group
(%i8) ishow(lc2kdt(expr))$
Maxima encountered a Lisp error:

 Error in $IMETRIC [or a callee]:
 $IMETRIC [or a callee] requires less than two arguments.

Automatically continuing.
To reenable the Lisp debugger set *debugger-hook* to nil.
(%i9) imetric(g);
(%o9)                                done
(%i10) ishow(lc2kdt(expr))$
         %3 i       k   %4 j       l     %3 i       l   %4 j
(%t10) (g     kdelta   g     kdelta   - g     kdelta   g    
                    %3             %4               %3
              k
        kdelta  ) a
              %4   j k
(%i11) ishow(contract(expand(%)))$
                                  l i    l i  j
(%t11)                           a    - g    a
                                              j
@end example


@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c HMM, WHICH CATEGORY DOES THIS FALL INTO -- FUNCTION, VARIABLE, OTHER ??

@c -----------------------------------------------------------------------------
@anchor{lc_l}
@deffn {Function} lc_l
Simplification rule used for expressions containing the unevaluated Levi-Civita
symbol (@code{levi_civita}). Along with @code{lc_u}, it can be used to simplify
many expressions more efficiently than the evaluation of @code{levi_civita}.
For example:

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) el1:ishow('levi_civita([i,j,k],[])*a([],[i])*a([],[j]))$
                             i  j
(%t2)                       a  a  levi_civita
                                             i j k
(%i3) el2:ishow('levi_civita([],[i,j,k])*a([i])*a([j]))$
                                       i j k
(%t3)                       levi_civita      a  a
                                              i  j
(%i4) canform(contract(expand(applyb1(el1,lc_l,lc_u))));
(%t4)                                  0
(%i5) canform(contract(expand(applyb1(el2,lc_l,lc_u))));
(%t5)                                  0

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c HMM, WHICH CATEGORY DOES THIS FALL INTO -- FUNCTION, VARIABLE, OTHER ??

@c -----------------------------------------------------------------------------
@deffn {Function} lc_u

Simplification rule used for expressions containing the unevaluated Levi-Civita
symbol (@code{levi_civita}). Along with @code{lc_u}, it can be used to simplify
many expressions more efficiently than the evaluation of @code{levi_civita}.
For details, see @code{lc_l}.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{canten}
@deffn {Function} canten (@var{expr})
Simplifies @var{expr} by renaming (see @code{rename})
and permuting dummy indices. @code{rename} is restricted to sums of tensor
products in which no derivatives are present. As such it is limited
and should only be used if @code{canform} is not capable of carrying out the
required simplification.

The @code{canten} function returns a mathematically correct result only
if its argument is an expression that is fully symmetric in its indices.
For this reason, @code{canten} returns an error if @code{allsym} is not
set to @code{true}.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{concan}
@deffn {Function} concan (@var{expr})
Similar to @code{canten} but also performs index contraction.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@subsection Tensor symmetries
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
@anchor{allsym}
@defvr {Option variable} allsym
Default value: @code{false}

If @code{true} then all indexed objects
are assumed symmetric in all of their covariant and contravariant
indices. If @code{false} then no symmetries of any kind are assumed
in these indices. Derivative indices are always taken to be symmetric
unless @code{iframe_flag} is set to @code{true}.

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{decsym}
@deffn {Function} decsym (@var{tensor}, @var{m}, @var{n}, [@var{cov_1}, @var{cov_2}, ...], [@var{contr_1}, @var{contr_2}, ...])

Declares symmetry properties for @var{tensor} of @var{m} covariant and
@var{n} contravariant indices. The @var{cov_i} and @var{contr_i} are
pseudofunctions expressing symmetry relations among the covariant and
contravariant indices respectively.  These are of the form
@code{symoper(@var{index_1}, @var{index_2},...)} where @code{symoper} is one of
@code{sym}, @code{anti} or @code{cyc} and the @var{index_i} are integers
indicating the position of the index in the @var{tensor}.  This will
declare @var{tensor} to be symmetric, antisymmetric or cyclic respectively
in the @var{index_i}. @code{symoper(all)} is also an allowable form which
indicates all indices obey the symmetry condition. For example, given an
object @code{b} with 5 covariant indices,
@code{decsym(b,5,3,[sym(1,2),anti(3,4)],[cyc(all)])} declares @code{b}
symmetric in its first and second and antisymmetric in its third and
fourth covariant indices, and cyclic in all of its contravariant indices.
Either list of symmetry declarations may be null.  The function which
performs the simplifications is @code{canform} as the example below
illustrates.

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) expr:contract( expand( a([i1, j1, k1], [])
           *kdels([i, j, k], [i1, j1, k1])))$
(%i3) ishow(expr)$
@group
(%t3)         a      + a      + a      + a      + a      + a
               k j i    k i j    j k i    j i k    i k j    i j k
@end group
(%i4) decsym(a,3,0,[sym(all)],[]);
(%o4)                                done
(%i5) ishow(canform(expr))$
(%t5)                              6 a
                                      i j k
(%i6) remsym(a,3,0);
(%o6)                                done
(%i7) decsym(a,3,0,[anti(all)],[]);
(%o7)                                done
(%i8) ishow(canform(expr))$
(%t8)                                  0
(%i9) remsym(a,3,0);
(%o9)                                done
(%i10) decsym(a,3,0,[cyc(all)],[]);
(%o10)                               done
(%i11) ishow(canform(expr))$
(%t11)                        3 a      + 3 a
                                 i k j      i j k
(%i12) dispsym(a,3,0);
(%o12)                     [[cyc, [[1, 2, 3]], []]]

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{remsym}
@deffn {Function} remsym (@var{tensor}, @var{m}, @var{n})
Removes all symmetry properties from @var{tensor} which has @var{m}
covariant indices and @var{n} contravariant indices.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{canform}
@deffn {Function} canform @
@fname{canform} (@var{expr}) @
@fname{canform} (@var{expr}, @var{rename})

Simplifies @var{expr} by renaming dummy
indices and reordering all indices as dictated by symmetry conditions
imposed on them. If @code{allsym} is @code{true} then all indices are assumed
symmetric, otherwise symmetry information provided by @code{decsym}
declarations will be used. The dummy indices are renamed in the same
manner as in the @code{rename} function. When @code{canform} is applied to a large
expression the calculation may take a considerable amount of time.
This time can be shortened by calling @code{rename} on the expression first.
Also see the example under @code{decsym}. Note: @code{canform} may not be able to
reduce an expression completely to its simplest form although it will
always return a mathematically correct result.

The optional second parameter @var{rename}, if set to @code{false}, suppresses renaming.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@subsection Indicial tensor calculus
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
@anchor{itensor_diff}
@deffn {Function} diff (@var{expr}, @var{v_1}, [@var{n_1}, [@var{v_2}, @var{n_2}] ...])

is the usual Maxima differentiation function which has been expanded
in its abilities for @code{itensor}. It takes the derivative of @var{expr} with
respect to @var{v_1} @var{n_1} times, with respect to @var{v_2} @var{n_2}
times, etc. For the tensor package, the function has been modified so
that the @var{v_i} may be integers from 1 up to the value of the variable
@code{dim}.  This will cause the differentiation to be carried out with
respect to the @var{v_i}th member of the list @code{vect_coords}.  If
@code{vect_coords} is bound to an atomic variable, then that variable
subscripted by @var{v_i} will be used for the variable of
differentiation.  This permits an array of coordinate names or
subscripted names like @code{x[1]}, @code{x[2]}, ...  to be used.

A further extension adds the ability to @code{diff} to compute derivatives
with respect to an indexed variable. In particular, the tensor package knows
how to differentiate expressions containing combinations of the metric tensor
and its derivatives with respect to the metric tensor and its first and
second derivatives. This capability is particularly useful when considering
Lagrangian formulations of a gravitational theory, allowing one to derive
the Einstein tensor and field equations from the action principle.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{idiff}
@deffn {Function} idiff (@var{expr}, @var{v_1}, [@var{n_1}, [@var{v_2}, @var{n_2}] ...])
Indicial differentiation. Unlike @code{diff}, which differentiates
with respect to an independent variable, @code{idiff)} can be used
to differentiate with respect to a coordinate. For an indexed object,
this amounts to appending the @var{v_i} as derivative indices.
Subsequently, derivative indices will be sorted, unless @code{iframe_flag}
is set to @code{true}.

@code{idiff} can also differentiate the determinant of the metric
tensor. Thus, if @code{imetric} has been bound to @code{G} then
@code{idiff(determinant(g),k)} will return
@code{2 * determinant(g) * ichr2([%i,k],[%i])} where the dummy index @code{%i}
is chosen appropriately.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{liediff}
@deffn {Function} liediff (@var{v}, @var{ten})

Computes the Lie-derivative of the tensorial expression @var{ten} with
respect to the vector field @var{v}. @var{ten} should be any indexed
tensor expression; @var{v} should be the name (without indices) of a vector
field. For example:

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) ishow(liediff(v,a([i,j],[])*b([],[k],l)))$
       k    %2            %2          %2
(%t2) b   (v   a       + v   a     + v   a    )
       ,l       i j,%2    ,j  i %2    ,i  %2 j

                          %1  k        %1  k      %1  k
                      + (v   b      - b   v    + v   b   ) a
                              ,%1 l    ,l  ,%1    ,l  ,%1   i j

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{rediff}
@deffn {Function} rediff (@var{ten})

Evaluates all occurrences of the @code{idiff} command in the tensorial
expression @var{ten}.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{undiff}
@deffn {Function} undiff (@var{expr})

Returns an expression equivalent to @var{expr} but with all derivatives
of indexed objects replaced by the noun form of the @code{idiff} function. Its
arguments would yield that indexed object if the differentiation were
carried out.  This is useful when it is desired to replace a
differentiated indexed object with some function definition resulting
in @var{expr} and then carry out the differentiation by saying
@code{ev(@var{expr}, idiff)}.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{evundiff}
@deffn {Function} evundiff (@var{expr})

Equivalent to the execution of @code{undiff}, followed by @code{ev} and
@code{rediff}.

The point of this operation is to easily evalute expressions that cannot
be directly evaluated in derivative form. For instance, the following
causes an error:

@example
(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) icurvature([i,j,k],[l],m);
Maxima encountered a Lisp error:

 Error in $ICURVATURE [or a callee]:
 $ICURVATURE [or a callee] requires less than three arguments.

Automatically continuing.
To reenable the Lisp debugger set *debugger-hook* to nil.
@end example

However, if @code{icurvature} is entered in noun form, it can be evaluated
using @code{evundiff}:

@example
(%i3) ishow('icurvature([i,j,k],[l],m))$
                                         l
(%t3)                          icurvature
                                         i j k,m
(%i4) ishow(evundiff(%))$
             l              l         %1           l           %1
(%t4) - ichr2        - ichr2     ichr2      - ichr2       ichr2
             i k,j m        %1 j      i k,m        %1 j,m      i k

             l              l         %1           l           %1
      + ichr2        + ichr2     ichr2      + ichr2       ichr2
             i j,k m        %1 k      i j,m        %1 k,m      i j
@end example

Note: In earlier versions of Maxima, derivative forms of the
Christoffel-symbols also could not be evaluated. This has been fixed now,
so @code{evundiff} is no longer necessary for expressions like this:

@example
(%i5) imetric(g);
(%o5)                                done
(%i6) ishow(ichr2([i,j],[k],l))$
       k %3
      g     (g         - g         + g        )
              j %3,i l    i j,%3 l    i %3,j l
(%t6) -----------------------------------------
                          2

                         k %3
                        g     (g       - g       + g      )
                         ,l     j %3,i    i j,%3    i %3,j
                      + -----------------------------------
                                         2
@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{flush}
@deffn {Function} flush (@var{expr}, @var{tensor_1}, @var{tensor_2}, ...)
Set to zero, in
@var{expr}, all occurrences of the @var{tensor_i} that have no derivative indices.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{flushd}
@deffn {Function} flushd (@var{expr}, @var{tensor_1}, @var{tensor_2}, ...)
Set to zero, in
@var{expr}, all occurrences of the @var{tensor_i} that have derivative indices.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{flushnd}
@deffn {Function} flushnd (@var{expr}, @var{tensor}, @var{n})
Set to zero, in @var{expr}, all
occurrences of the differentiated object @var{tensor} that have @var{n} or more
derivative indices as the following example demonstrates.
@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) ishow(a([i],[J,r],k,r)+a([i],[j,r,s],k,r,s))$
                                J r      j r s
(%t2)                          a      + a
                                i,k r    i,k r s
(%i3) ishow(flushnd(%,a,3))$
                                     J r
(%t3)                               a
                                     i,k r
@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{coord}
@deffn {Function} coord (@var{tensor_1}, @var{tensor_2}, ...)

Gives @var{tensor_i} the coordinate differentiation property that the
derivative of contravariant vector whose name is one of the
@var{tensor_i} yields a Kronecker delta. For example, if @code{coord(x)} has
been done then @code{idiff(x([],[i]),j)} gives @code{kdelta([i],[j])}.
@code{coord} is a list of all indexed objects having this property.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{remcoord}
@deffn {Function} remcoord @
@fname{remcoord} (@var{tensor_1}, @var{tensor_2}, ...) @
@fname{remcoord} (all)

Removes the coordinate differentiation property from the @code{tensor_i}
that was established by the function @code{coord}.  @code{remcoord(all)}
removes this property from all indexed objects.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{makebox}
@deffn {Function} makebox (@var{expr})
Display @var{expr} in the same manner as @code{show}; however,
any tensor d'Alembertian occurring in @var{expr} will be indicated using the
symbol @code{[]}.  For example, @code{[]p([m],[n])} represents
@code{g([],[i,j])*p([m],[n],i,j)}.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{conmetderiv}
@deffn {Function} conmetderiv (@var{expr}, @var{tensor})

Simplifies expressions containing ordinary derivatives of
both covariant and con@-tra@-va@-ri@-ant forms of the metric tensor (the
current restriction).  For example, @code{conmetderiv} can relate the
derivative of the contravariant metric tensor with the Christoffel
symbols as seen from the following:

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) ishow(g([],[a,b],c))$
                                      a b
(%t2)                                g
                                      ,c
(%i3) ishow(conmetderiv(%,g))$
                         %1 b      a       %1 a      b
(%t3)                 - g     ichr2     - g     ichr2
                                   %1 c              %1 c
@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{simpmetderiv}
@deffn {Function} simpmetderiv @
@fname{simpmetderiv} (@var{expr}) @
@fname{simpmetderiv} (@var{expr}[, @var{stop}])

Simplifies expressions containing products of the derivatives of the
metric tensor. Specifically, @code{simpmetderiv} recognizes two identities:

@example

   ab        ab           ab                 a
  g   g   + g   g     = (g   g  )   = (kdelta )   = 0
   ,d  bc        bc,d         bc ,d          c ,d

@end example

hence

@example

   ab          ab
  g   g   = - g   g
   ,d  bc          bc,d
@end example

and

@example

  ab          ab
 g   g     = g   g
  ,j  ab,i    ,i  ab,j

@end example

which follows from the symmetries of the Christoffel symbols.

The @code{simpmetderiv} function takes one optional parameter which, when
present, causes the function to stop after the first successful
substitution in a product expression. The @code{simpmetderiv} function
also makes use of the global variable @var{flipflag} which determines
how to apply a ``canonical'' ordering to the product indices.

Put together, these capabilities can be used to achieve powerful
simplifications that are difficult or impossible to accomplish otherwise.
This is demonstrated through the following example that explicitly uses the
partial simplification features of @code{simpmetderiv} to obtain a
contractible expression:

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) imetric(g);
(%o2)                                done
(%i3) ishow(g([],[a,b])*g([],[b,c])*g([a,b],[],d)*g([b,c],[],e))$
                             a b  b c
(%t3)                       g    g    g      g
                                       a b,d  b c,e
(%i4) ishow(canform(%))$

errexp1 has improper indices
 -- an error.  Quitting.  To debug this try debugmode(true);
(%i5) ishow(simpmetderiv(%))$
                             a b  b c
(%t5)                       g    g    g      g
                                       a b,d  b c,e
(%i6) flipflag:not flipflag;
(%o6)                                true
(%i7) ishow(simpmetderiv(%th(2)))$
                               a b  b c
(%t7)                         g    g    g    g
                               ,d   ,e   a b  b c
(%i8) flipflag:not flipflag;
(%o8)                                false
(%i9) ishow(simpmetderiv(%th(2),stop))$
                               a b  b c
(%t9)                       - g    g    g      g
                                    ,e   a b,d  b c
(%i10) ishow(contract(%))$
                                    b c
(%t10)                           - g    g
                                    ,e   c b,d

@end example

See also @code{weyl.dem} for an example that uses @mref{simpmetderiv}
and @mref{conmetderiv} together to simplify contractions of the Weyl tensor.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------}
@anchor{flush1deriv}
@deffn {Function} flush1deriv (@var{expr}, @var{tensor})

Set to zero, in @code{expr}, all occurrences of @code{tensor} that have
exactly one derivative index.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@subsection Tensors in curved spaces
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
@anchor{imetric}
@deffn {Function} imetric (@var{g})
@deffnx {System variable} imetric

Specifies the metric by assigning the variable @code{imetric:@var{g}} in
addition, the con@-trac@-tion properties of the metric @var{g} are set up by
executing the commands @code{defcon(@var{g}), defcon(@var{g}, @var{g}, kdelta)}.
The variable @code{imetric} (unbound by default), is bound to the metric, assigned by
the @code{imetric(@var{g})} command.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{idim}
@deffn {Function} idim (@var{n})
Sets the dimensions of the metric. Also initializes the antisymmetry
properties of the Levi-Civita symbols for the given dimension.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{ichr1}
@deffn {Function} ichr1 ([@var{i}, @var{j}, @var{k}])
Yields the Christoffel symbol of the first kind via the
definition
@example
       (g      + g      - g     )/2 .
         ik,j     jk,i     ij,k
@end example
@noindent
To evaluate the Christoffel symbols for a particular metric, the
variable @code{imetric} must be assigned a name as in the example under @code{chr2}.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{ichr2}
@deffn {Function} ichr2 ([@var{i}, @var{j}], [@var{k}])
Yields the Christoffel symbol of the second kind
defined by the relation
@example
                       ks
   ichr2([i,j],[k]) = g    (g      + g      - g     )/2
                             is,j     js,i     ij,s
@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{icurvature}
@deffn {Function} icurvature ([@var{i}, @var{j}, @var{k}], [@var{h}])
Yields the Riemann
curvature tensor in terms of the Christoffel symbols of the second
kind (@code{ichr2}).  The following notation is used:
@example
            h             h            h         %1         h
  icurvature     = - ichr2      - ichr2     ichr2    + ichr2
            i j k         i k,j        %1 j      i k        i j,k
                            h          %1
                     + ichr2      ichr2
                            %1 k       i j
@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{covdiff}
@deffn {Function} covdiff (@var{expr}, @var{v_1}, @var{v_2}, ...)
Yields the covariant derivative of @var{expr} with
respect to the variables @var{v_i} in terms of the Christoffel symbols of the
second kind (@code{ichr2}).  In order to evaluate these, one should use
@code{ev(@var{expr},ichr2)}.

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) entertensor()$
Enter tensor name: a;
Enter a list of the covariant indices: [i,j];
Enter a list of the contravariant indices: [k];
Enter a list of the derivative indices: [];
                                      k
(%t2)                                a
                                      i j
(%i3) ishow(covdiff(%,s))$
             k         %1     k         %1     k
(%t3)     - a     ichr2    - a     ichr2    + a
             i %1      j s    %1 j      i s    i j,s

             k     %1
      + ichr2     a
             %1 s  i j
(%i4) imetric:g;
(%o4)                                  g
(%i5) ishow(ev(%th(2),ichr2))$
         %1 %4  k
        g      a     (g       - g       + g      )
                i %1   s %4,j    j s,%4    j %4,s
(%t5) - ------------------------------------------
                            2
@group
    %1 %3  k
   g      a     (g       - g       + g      )
           %1 j   s %3,i    i s,%3    i %3,s
 - ------------------------------------------
                       2
    k %2  %1
   g     a    (g        - g        + g       )
          i j   s %2,%1    %1 s,%2    %1 %2,s     k
 + ------------------------------------------- + a
                        2                         i j,s
@end group
(%i6)
@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{lorentz}
@deffn {Function} lorentz_gauge (@var{expr})
Imposes the Lorentz condition by substituting 0 for all
indexed objects in @var{expr} that have a derivative index identical to a
contravariant index.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{igeodesic}
@deffn {Function} igeodesic_coords (@var{expr}, @var{name})

Causes undifferentiated Christoffel symbols and
first derivatives of the metric tensor vanish in @var{expr}. The @var{name}
in the @code{igeodesic_coords} function refers to the metric @var{name}
(if it appears in @var{expr}) while the connection coefficients must be
called with the names @code{ichr1} and/or @code{ichr2}. The following example
demonstrates the verification of the cyclic identity satisfied by the Riemann
curvature tensor using the @code{igeodesic_coords} function.

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) ishow(icurvature([r,s,t],[u]))$
             u            u         %1         u     
(%t2) - ichr2      - ichr2     ichr2    + ichr2      
             r t,s        %1 s      r t        r s,t 

                                              u         %1
                                       + ichr2     ichr2
                                              %1 t      r s
(%i3) ishow(igeodesic_coords(%,ichr2))$
                                 u            u
(%t3)                       ichr2      - ichr2
                                 r s,t        r t,s
(%i4) ishow(igeodesic_coords(icurvature([r,s,t],[u]),ichr2)+
            igeodesic_coords(icurvature([s,t,r],[u]),ichr2)+
            igeodesic_coords(icurvature([t,r,s],[u]),ichr2))$
             u            u            u            u
(%t4) - ichr2      + ichr2      + ichr2      - ichr2
             t s,r        t r,s        s t,r        s r,t

                                             u            u
                                      - ichr2      + ichr2
                                             r t,s        r s,t
(%i5) canform(%);
(%o5)                                  0

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@subsection Moving frames
@c -----------------------------------------------------------------------------

Maxima now has the ability to perform calculations using moving frames.
These can be orthonormal frames (tetrads, vielbeins) or an arbitrary frame.

To use frames, you must first set @code{iframe_flag} to @code{true}. This
causes the Christoffel-symbols, @code{ichr1} and @code{ichr2}, to be replaced
by the more general frame connection coefficients @code{icc1} and @code{icc2}
in calculations. Speficially, the behavior of @code{covdiff} and
@code{icurvature} is changed.

The frame is defined by two tensors: the inverse frame field (@code{ifri},
the dual basis tetrad),
and the frame metric @code{ifg}. The frame metric is the identity matrix for
orthonormal frames, or the Lorentz metric for orthonormal frames in Minkowski
spacetime. The inverse frame field defines the frame base (unit vectors).
Contraction properties are defined for the frame field and the frame metric.

When @code{iframe_flag} is true, many @code{itensor} expressions use the frame
metric @code{ifg} instead of the metric defined by @code{imetric} for
raising and lowerind indices.

IMPORTANT: Setting the variable @code{iframe_flag} to @code{true} does NOT
undefine the contraction properties of a metric defined by a call to
@code{defcon} or @code{imetric}. If a frame field is used, it is best to
define the metric by assigning its name to the variable @code{imetric}
and NOT invoke the @code{imetric} function.

Maxima uses these two tensors to define the frame coefficients (@code{ifc1}
and @code{ifc2}) which form part of the connection coefficients (@code{icc1}
and @code{icc2}), as the following example demonstrates:

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) iframe_flag:true;
(%o2)                                true
(%i3) ishow(covdiff(v([],[i]),j))$
                               i        i     %1
(%t3)                         v   + icc2     v
                               ,j       %1 j
(%i4) ishow(ev(%,icc2))$
                               %1     i       i
(%t4)                         v   ifc2     + v
                                      %1 j    ,j
(%i5) ishow(ev(%,ifc2))$
                          %1    i %2                i
(%t5)                    v   ifg     ifc1        + v
                                         %1 j %2    ,j
(%i6) ishow(ev(%,ifc1))$
@group
            %1    i %2
           v   ifg     (ifb        - ifb        + ifb       )
                           j %2 %1      %2 %1 j      %1 j %2     i
(%t6)      -------------------------------------------------- + v
                                   2                             ,j
@end group
(%i7) ishow(ifb([a,b,c]))$
                                                   %3    %4
(%t7)               (ifri        - ifri       ) ifr   ifr
                         a %3,%4       a %4,%3     b     c

@end example

An alternate method is used to compute the frame bracket (@code{ifb}) if
the @code{iframe_bracket_form} flag is set to @code{false}:

@example

(%i8) block([iframe_bracket_form:false],ishow(ifb([a,b,c])))$
                                %6    %5        %5      %6
(%t8)              ifri     (ifr   ifr     - ifr     ifr  )
                       a %5     b     c,%6      b,%6    c

@end example

@c -----------------------------------------------------------------------------}
@anchor{iframes}
@deffn {Function} iframes ()

Since in this version of Maxima, contraction identities for @code{ifr} and
@code{ifri} are always defined, as is the frame bracket (@code{ifb}), this
function does nothing.

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{ifb}
@defvr {Variable} ifb

The frame bracket. The contribution of the frame metric to the connection
coefficients is expressed using the frame bracket:

@example

          - ifb      + ifb      + ifb
               c a b      b c a      a b c
ifc1    = --------------------------------
    abc                  2

@end example

The frame bracket itself is defined in terms of the frame field and frame
metric. Two alternate methods of computation are used depending on the
value of @code{frame_bracket_form}. If true (the default) or if the
@code{itorsion_flag} is @code{true}:

@example

          d      e                                      f
ifb =  ifr    ifr   (ifri      - ifri      - ifri    itr   )
   abc    b      c       a d,e       a e,d       a f    d e


@end example

Otherwise:

@example

             e      d        d      e
ifb    = (ifr    ifr    - ifr    ifr   ) ifri
   abc       b      c,e      b,e    c        a d

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{icc1}
@defvr {Variable} icc1

Connection coefficients of the first kind. In @code{itensor}, defined as

@example

icc1    = ichr1    - ikt1    - inmc1
    abc        abc       abc        abc

@end example

In this expression, if @code{iframe_flag} is true, the Christoffel-symbol
@code{ichr1} is replaced with the frame connection coefficient @code{ifc1}.
If @code{itorsion_flag} is @code{false}, @code{ikt1}
will be omitted. It is also omitted if a frame base is used, as the
torsion is already calculated as part of the frame bracket.
Lastly, of @code{inonmet_flag} is @code{false},
@code{inmc1} will not be present.

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{icc2}
@defvr {Variable} icc2

Connection coefficients of the second kind. In @code{itensor}, defined as

@example

    c         c        c         c
icc2   = ichr2   - ikt2   - inmc2
    ab        ab       ab        ab

@end example

In this expression, if @code{iframe_flag} is true, the Christoffel-symbol
@code{ichr2} is replaced with the frame connection coefficient @code{ifc2}.
If @code{itorsion_flag} is @code{false}, @code{ikt2}
will be omitted. It is also omitted if a frame base is used, as the
torsion is already calculated as part of the frame bracket.
Lastly, of @code{inonmet_flag} is @code{false},
@code{inmc2} will not be present.

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{ifc1}
@defvr {Variable} ifc1

Frame coefficient of the first kind (also known as Ricci-rotation
coefficients.) This tensor represents the contribution
of the frame metric to the connection coefficient of the first kind. Defined
as:

@example

          - ifb      + ifb      + ifb
               c a b      b c a      a b c
ifc1    = --------------------------------
    abc                   2


@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{ifc2}
@defvr {Variable} ifc2

Frame coefficient of the second kind. This tensor represents the contribution
of the frame metric to the connection coefficient of the second kind. Defined
as a permutation of the frame bracket (@code{ifb}) with the appropriate
indices raised and lowered as necessary:

@example

    c       cd
ifc2   = ifg   ifc1
    ab             abd

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{ifr}
@defvr {Variable} ifr

The frame field. Contracts with the inverse frame field (@code{ifri}) to
form the frame metric (@code{ifg}).

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{ifri}
@defvr {Variable} ifri

The inverse frame field. Specifies the frame base (dual basis vectors). Along
with the frame metric, it forms the basis of all calculations based on
frames.

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{ifg}
@defvr {Variable} ifg

The frame metric. Defaults to @code{kdelta}, but can be changed using
@code{components}.

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{ifgi}
@defvr {Variable} ifgi

The inverse frame metric. Contracts with the frame metric (@code{ifg})
to @code{kdelta}.

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{iframe_bracket_form}
@defvr {Option variable} iframe_bracket_form
Default value: @code{true}

Specifies how the frame bracket (@code{ifb}) is computed.

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@subsection Torsion and nonmetricity
@c -----------------------------------------------------------------------------

Maxima can now take into account torsion and nonmetricity. When the flag
@code{itorsion_flag} is set to @code{true}, the contribution of torsion
is added to the connection coefficients. Similarly, when the flag
@code{inonmet_flag} is true, nonmetricity components are included.

@c -----------------------------------------------------------------------------
@anchor{inm}
@defvr {Variable} inm

The nonmetricity vector. Conformal nonmetricity is defined through the
covariant derivative of the metric tensor. Normally zero, the metric
tensor's covariant derivative will evaluate to the following when
@code{inonmet_flag} is set to @code{true}:

@example

g     =- g  inm
 ij;k     ij   k

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{inmc1}
@defvr {Variable} inmc1

Covariant permutation of the nonmetricity vector components. Defined as

@example

           g   inm  - inm  g   - g   inm
            ab    c      a  bc    ac    b
inmc1    = ------------------------------
     abc                 2

@end example

(Substitute @code{ifg} in place of @code{g} if a frame metric is used.)

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{inmc2}
@defvr {Variable} inmc2

Contravariant permutation of the nonmetricity vector components. Used
in the connection coefficients if @code{inonmet_flag} is @code{true}. Defined
as:

@example

                      c         c         cd
          -inm  kdelta  - kdelta  inm  + g   inm  g
     c        a       b         a    b          d  ab
inmc2   = -------------------------------------------
     ab                        2

@end example

(Substitute @code{ifg} in place of @code{g} if a frame metric is used.)

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{ikt1}
@defvr {Variable} ikt1

Covariant permutation of the torsion tensor (also known as contorsion).
Defined as:

@example

                  d           d       d
          -g   itr  - g    itr   - itr   g
            ad    cb    bd    ca      ab  cd
ikt1    = ----------------------------------
    abc                   2

@end example

(Substitute @code{ifg} in place of @code{g} if a frame metric is used.)

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{ikt2}
@defvr {Variable} ikt2

Contravariant permutation of the torsion tensor (also known as contorsion).
Defined as:

@example

    c     cd
ikt2   = g   ikt1
    ab           abd

@end example

(Substitute @code{ifg} in place of @code{g} if a frame metric is used.)

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{itr}
@defvr {Variable} itr

The torsion tensor. For a metric with torsion, repeated covariant
differentiation on a scalar function will not commute, as demonstrated
by the following example:

@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) imetric:g;
(%o2)                                  g
(%i3) covdiff( covdiff( f( [], []), i), j)
                      - covdiff( covdiff( f( [], []), j), i)$
(%i4) ishow(%)$
                                   %4              %2
(%t4)                    f    ichr2    - f    ichr2
                          ,%4      j i    ,%2      i j
(%i5) canform(%);
(%o5)                                  0
(%i6) itorsion_flag:true;
(%o6)                                true
(%i7) covdiff( covdiff( f( [], []), i), j)
                      - covdiff( covdiff( f( [], []), j), i)$
(%i8) ishow(%)$
                           %8             %6
(%t8)             f    icc2    - f    icc2    - f     + f
                   ,%8     j i    ,%6     i j    ,j i    ,i j
(%i9) ishow(canform(%))$
                                   %1             %1
(%t9)                     f    icc2    - f    icc2
                           ,%1     j i    ,%1     i j
(%i10) ishow(canform(ev(%,icc2)))$
                                   %1             %1
(%t10)                    f    ikt2    - f    ikt2
                           ,%1     i j    ,%1     j i
(%i11) ishow(canform(ev(%,ikt2)))$
                      %2 %1                    %2 %1
(%t11)          f    g      ikt1       - f    g      ikt1
                 ,%2            i j %1    ,%2            j i %1
(%i12) ishow(factor(canform(rename(expand(ev(%,ikt1))))))$
                           %3 %2            %1       %1
                     f    g      g      (itr    - itr   )
                      ,%3         %2 %1     j i      i j
(%t12)               ------------------------------------
                                      2
(%i13) decsym(itr,2,1,[anti(all)],[]);
(%o13)                               done
(%i14) defcon(g,g,kdelta);
(%o14)                               done
(%i15) subst(g,nounify(g),%th(3))$
(%i16) ishow(canform(contract(%)))$
                                           %1
(%t16)                           - f    itr
                                    ,%1    i j

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@subsection Exterior algebra
@c -----------------------------------------------------------------------------

The @code{itensor} package can perform operations on totally antisymmetric
covariant tensor fields. A totally antisymmetric tensor field of rank
(0,L) corresponds with a differential L-form. On these objects, a
multiplication operation known as the exterior product, or wedge product,
is defined.

Unfortunately, not all authors agree on the definition of the wedge
product. Some authors prefer a definition that corresponds with the
notion of antisymmetrization: in these works, the wedge product of
two vector fields, for instance, would be defined as

@example
            a a  - a a
             i j    j i
 a  /\ a  = -----------
  i     j        2
@end example

More generally, the product of a p-form and a q-form would be defined as

@example
                       1     k1..kp l1..lq
A       /\ B       = ------ D              A       B
 i1..ip     j1..jq   (p+q)!  i1..ip j1..jq  k1..kp  l1..lq
@end example

where @code{D} stands for the Kronecker-delta.

Other authors, however, prefer a ``geometric'' definition that corresponds
with the notion of the volume element:

@example
a  /\ a  = a a  - a a
 i     j    i j    j i
@end example

and, in the general case

@example
                       1    k1..kp l1..lq
A       /\ B       = ----- D              A       B
 i1..ip     j1..jq   p! q!  i1..ip j1..jq  k1..kp  l1..lq
@end example

Since @code{itensor} is a tensor algebra package, the first of these two
definitions appears to be the more natural one. Many applications, however,
utilize the second definition. To resolve this dilemma, a flag has been
implemented that controls the behavior of the wedge product: if
@code{igeowedge_flag} is @code{false} (the default), the first, "tensorial"
definition is used, otherwise the second, "geometric" definition will
be applied.

@anchor{~}
@defvr {Operator} ~
@ifinfo
@fnindex Wedge product
@end ifinfo

The wedge product operator is denoted by the tilde @code{~}. This is
a binary operator. Its arguments should be expressions involving scalars,
covariant tensors of rank one, or covariant tensors of rank @code{l} that
have been declared antisymmetric in all covariant indices.

The behavior of the wedge product operator is controlled by the
@code{igeowedge_flag} flag, as in the following example:

@example
(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) ishow(a([i])~b([j]))$
                                 a  b  - b  a
                                  i  j    i  j
(%t2)                            -------------
                                       2
(%i3) decsym(a,2,0,[anti(all)],[]);
(%o3)                                done
(%i4) ishow(a([i,j])~b([k]))$
                          a    b  + b  a    - a    b
                           i j  k    i  j k    i k  j
(%t4)                     ---------------------------
                                       3
(%i5) igeowedge_flag:true;
(%o5)                                true
(%i6) ishow(a([i])~b([j]))$
(%t6)                            a  b  - b  a
                                  i  j    i  j
(%i7) ishow(a([i,j])~b([k]))$
(%t7)                     a    b  + b  a    - a    b
                           i j  k    i  j k    i k  j
@end example

@opencatbox
@category{Package itensor}
@category{Operators}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{|}
@defvr {Operator} |
@ifinfo
@fnindex Contraction with a vector
@end ifinfo

The vertical bar @code{|} denotes the "contraction with a vector" binary
operation. When a totally antisymmetric covariant tensor is contracted
with a contravariant vector, the result is the same regardless which index
was used for the contraction. Thus, it is possible to define the
contraction operation in an index-free manner.

In the @code{itensor} package, contraction with a vector is always carried out
with respect to the first index in the literal sorting order. This ensures
better simplification of expressions involving the @code{|} operator. For instance:

@example
(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) decsym(a,2,0,[anti(all)],[]);
(%o2)                                done
(%i3) ishow(a([i,j],[])|v)$
                                    %1
(%t3)                              v   a
                                        %1 j
(%i4) ishow(a([j,i],[])|v)$
                                     %1
(%t4)                             - v   a
                                         %1 j
@end example

Note that it is essential that the tensors used with the @code{|} operator be
declared totally antisymmetric in their covariant indices. Otherwise,
the results will be incorrect.

@opencatbox
@category{Package itensor}
@category{Operators}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@anchor{extdiff}
@deffn {Function} extdiff (@var{expr}, @var{i})

Computes the exterior derivative of @var{expr} with respect to the index
@var{i}. The exterior derivative is formally defined as the wedge
product of the partial derivative operator and a differential form. As
such, this operation is also controlled by the setting of @code{igeowedge_flag}.
For instance:

@example
(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) ishow(extdiff(v([i]),j))$
                                  v    - v
                                   j,i    i,j
(%t2)                             -----------
                                       2
(%i3) decsym(a,2,0,[anti(all)],[]);
(%o3)                                done
(%i4) ishow(extdiff(a([i,j]),k))$
                           a      - a      + a
                            j k,i    i k,j    i j,k
(%t4)                      ------------------------
                                      3
(%i5) igeowedge_flag:true;
(%o5)                                true
(%i6) ishow(extdiff(v([i]),j))$
(%t6)                             v    - v
                                   j,i    i,j
(%i7) ishow(extdiff(a([i,j]),k))$
(%t7)                    - (a      - a      + a     )
                             k j,i    k i,j    j i,k

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{hodge}
@deffn {Function} hodge (@var{expr})

Compute the Hodge-dual of @var{expr}. For instance:

@c ===beg===
@c load("itensor");
@c imetric(g);
@c idim(4);
@c icounter:100;
@c decsym(A,3,0,[anti(all)],[])$
@c ishow(A([i,j,k],[]))$
@c ishow(canform(hodge(%)))$
@c ishow(canform(hodge(%)))$
@c lc2kdt(%)$
@c %,kdelta$
@c ishow(canform(contract(expand(%))))$
@c ===end===
@example

(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) imetric(g);
(%o2)                            done
(%i3) idim(4);
(%o3)                            done
(%i4) icounter:100;
(%o4)                             100
(%i5) decsym(A,3,0,[anti(all)],[])$

(%i6) ishow(A([i,j,k],[]))$
(%t6)                           A
                                 i j k
(%i7) ishow(canform(hodge(%)))$
                          %1 %2 %3 %4
               levi_civita            g        A
                                       %1 %102  %2 %3 %4
(%t7)          -----------------------------------------
                                   6
(%i8) ishow(canform(hodge(%)))$
                 %1 %2 %3 %8            %4 %5 %6 %7
(%t8) levi_civita            levi_civita            g       
                                                     %1 %106
                             g        g        g      A         /6
                              %2 %107  %3 %108  %4 %8  %5 %6 %7
(%i9) lc2kdt(%)$

(%i10) %,kdelta$

(%i11) ishow(canform(contract(expand(%))))$
(%t11)                     - A
                              %106 %107 %108

@end example

@opencatbox
@category{Package itensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{igeowedge_flag}
@defvr {Option variable} igeowedge_flag
Default value: @code{false}

Controls the behavior of the wedge product and exterior derivative. When
set to @code{false} (the default), the notion of differential forms will
correspond with that of a totally antisymmetric covariant tensor field.
When set to @code{true}, differential forms will agree with the notion
of the volume element.

@opencatbox
@category{Package itensor}
@closecatbox
@end defvr

@c -----------------------------------------------------------------------------
@subsection Exporting TeX expressions
@c -----------------------------------------------------------------------------

The @code{itensor} package provides limited support for exporting tensor
expressions to TeX. Since @code{itensor} expressions appear as function calls,
the regular Maxima @code{tex} command will not produce the expected
output. You can try instead the @code{tentex} command, which attempts
to translate tensor expressions into appropriately indexed TeX objects.

@c -----------------------------------------------------------------------------
@anchor{tentex}
@deffn {Function} tentex (@var{expr})

To use the @code{tentex} function, you must first load @code{tentex},
as in the following example:

@c ===beg===
@c load("itensor");
@c load(tentex);
@c idummyx:m;
@c ishow(icurvature([j,k,l],[i]))$
@c tentex(%)$
@c ===end===
@example
(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) load(tentex);
(%o2)       /share/tensor/tentex.lisp
(%i3) idummyx:m;
(%o3)                                  m
(%i4) ishow(icurvature([j,k,l],[i]))$
            m1       i           m1       i           i
(%t4)  ichr2    ichr2     - ichr2    ichr2     - ichr2
            j k      m1 l        j l      m1 k        j l,k

                                                      i
                                               + ichr2
                                                      j k,l
(%i5) tentex(%)$
$$\Gamma_@{j\,k@}^@{m_1@}\,\Gamma_@{l\,m_1@}^@{i@}-\Gamma_@{j\,l@}^@{m_1@}\,
 \Gamma_@{k\,m_1@}^@{i@}-\Gamma_@{j\,l,k@}^@{i@}+\Gamma_@{j\,k,l@}^@{i@}$$
@end example

Note the use of the @code{idummyx} assignment, to avoid the appearance
of the percent sign in the TeX expression, which may lead to compile errors.

NB: This version of the @code{tentex} function is somewhat experimental.

@opencatbox
@category{Package itensor}
@category{TeX output}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@subsection Interfacing with ctensor
@c -----------------------------------------------------------------------------

The @code{itensor} package has the ability to generate Maxima code that can
then be executed in the context of the @code{ctensor} package. The function that performs
this task is @code{ic_convert}.

@c -----------------------------------------------------------------------------
@anchor{ic_convert}
@deffn {Function} ic_convert (@var{eqn})

Converts the @code{itensor} equation @var{eqn} to a @code{ctensor} assignment statement.
Implied sums over dummy indices are made explicit while indexed
objects are transformed into arrays (the array subscripts are in the
order of covariant followed by contravariant indices of the indexed
objects). The derivative of an indexed object will be replaced by the
noun form of @code{diff} taken with respect to @code{ct_coords} subscripted
by the derivative index. The Christoffel symbols @code{ichr1} and @code{ichr2}
will be translated to @code{lcs} and @code{mcs}, respectively and if
@code{metricconvert} is @code{true} then all occurrences of the metric
with two covariant (contravariant) indices will be renamed to @code{lg}
(@code{ug}). In addition, @code{do} loops will be introduced summing over
all free indices so that the
transformed assignment statement can be evaluated by just doing
@code{ev}. The following examples demonstrate the features of this
function.

@c Added some ===beg=== and ==end== pairs around some source code
@c
@c The tags used here are different. This prevents the Perl parser from
@c interpreting this section, since the text-based rendering of the output
@c is pretty much unreadable. The origin example is likely been hand-edited
@c for readability.
@c ===begx===
@c load("itensor");
@c eqn:ishow(t([i,j],[k])=f([],[])*g([l,m],[])*a([],[m],j)
@c      *b([i],[l,k]))$
@c ic_convert(eqn);
@c imetric(g);
@c metricconvert:true;
@c ic_convert(eqn);
@c ===endx===
@example
(%i1) load("itensor");
(%o1)      /share/tensor/itensor.lisp
(%i2) eqn:ishow(t([i,j],[k])=f([],[])*g([l,m],[])*a([],[m],j)
      *b([i],[l,k]))$
                             k        m   l k
(%t2)                       t    = f a   b    g
                             i j      ,j  i    l m
(%i3) ic_convert(eqn);
(%o3) for i thru dim do (for j thru dim do (
       for k thru dim do
        t        : f sum(sum(diff(a , ct_coords ) b
         i, j, k                   m           j   i, l, k

 g    , l, 1, dim), m, 1, dim)))
  l, m
(%i4) imetric(g);
(%o4)                                done
(%i5) metricconvert:true;
(%o5)                                true
(%i6) ic_convert(eqn);
(%o6) for i thru dim do (for j thru dim do (
       for k thru dim do
        t        : f sum(sum(diff(a , ct_coords ) b
         i, j, k                   m           j   i, l, k

 lg    , l, 1, dim), m, 1, dim)))
   l, m
@end example

@opencatbox
@category{Package itensor}
@category{Package ctensor}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@subsection Reserved words
@c -----------------------------------------------------------------------------

The following Maxima words are used by the @code{itensor} package internally and
should not be redefined:

@c REFORMAT THIS TABLE USING TEXINFO MARKUP
@example
  Keyword    Comments
  ------------------------------------------
  indices2() Internal version of indices()
  conti      Lists contravariant indices
  covi       Lists covariant indices of a indexed object
  deri       Lists derivative indices of an indexed object
  name       Returns the name of an indexed object
  concan
  irpmon
  lc0
  _lc2kdt0
  _lcprod
  _extlc
@end example