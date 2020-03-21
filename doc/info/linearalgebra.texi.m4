@c -*- Mode: texinfo -*-
@menu
* Introduction to linearalgebra::
* Functions and Variables for linearalgebra::
@end menu

@c -----------------------------------------------------------------------------
@node Introduction to linearalgebra, Functions and Variables for linearalgebra, linearalgebra-pkg, linearalgebra-pkg
@section Introduction to linearalgebra
@c -----------------------------------------------------------------------------

@code{linearalgebra} is a collection of functions for linear algebra.

Example:

@c ===beg===
@c M : matrix ([1, 2], [1, 2]);
@c nullspace (M);
@c columnspace (M);
@c ptriangularize (M - z*ident(2), z);
@c M : matrix ([1, 2, 3], [4, 5, 6], [7, 8, 9]) - z*ident(3);
@c MM : ptriangularize (M, z);
@c algebraic : true;
@c tellrat (MM [3, 3]);
@c MM : ratsimp (MM);
@c nullspace (MM);
@c M : matrix ([1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], 
@c                    [13, 14, 15, 16]);
@c columnspace (M);
@c apply ('orthogonal_complement, args (nullspace (transpose (M))));
@c ===end===
@example
(%i1) M : matrix ([1, 2], [1, 2]);
                            [ 1  2 ]
(%o1)                       [      ]
                            [ 1  2 ]
(%i2) nullspace (M);
                               [  1  ]
                               [     ]
(%o2)                     span([   1 ])
                               [ - - ]
                               [   2 ]
(%i3) columnspace (M);
                                [ 1 ]
(%o3)                      span([   ])
                                [ 1 ]
(%i4) ptriangularize (M - z*ident(2), z);
                         [ 1   2 - z   ]
(%o4)                    [             ]
                         [           2 ]
                         [ 0  3 z - z  ]
(%i5) M : matrix ([1, 2, 3], [4, 5, 6], [7, 8, 9]) - z*ident(3);
                     [ 1 - z    2      3   ]
                     [                     ]
(%o5)                [   4    5 - z    6   ]
                     [                     ]
                     [   7      8    9 - z ]
(%i6) MM : ptriangularize (M, z);
              [ 4  5 - z            6            ]
              [                                  ]
              [                2                 ]
              [     66        z    102 z   132   ]
              [ 0   --      - -- + ----- + ---   ]
(%o6)         [     49        7     49     49    ]
              [                                  ]
              [               3        2         ]
              [           49 z    245 z    147 z ]
              [ 0    0    ----- - ------ - ----- ]
              [            264      88      44   ]
(%i7) algebraic : true;
(%o7)                         true
(%i8) tellrat (MM [3, 3]);
                         3       2
(%o8)                  [z  - 15 z  - 18 z]
(%i9) MM : ratsimp (MM);
               [ 4  5 - z           6           ]
               [                                ]
               [                2               ]
(%o9)          [     66      7 z  - 102 z - 132 ]
               [ 0   --    - ------------------ ]
               [     49              49         ]
               [                                ]
               [ 0    0             0           ]
(%i10) nullspace (MM);
                        [        1         ]
                        [                  ]
                        [   2              ]
                        [  z  - 14 z - 16  ]
                        [  --------------  ]
(%o10)             span([        8         ])
                        [                  ]
                        [    2             ]
                        [   z  - 18 z - 12 ]
                        [ - -------------- ]
                        [         12       ]
(%i11) M : matrix ([1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12],
                   [13, 14, 15, 16]);
                       [ 1   2   3   4  ]
                       [                ]
                       [ 5   6   7   8  ]
(%o11)                 [                ]
                       [ 9   10  11  12 ]
                       [                ]
                       [ 13  14  15  16 ]
(%i12) columnspace (M);
                           [ 1  ]  [ 2  ]
                           [    ]  [    ]
                           [ 5  ]  [ 6  ]
(%o12)                span([    ], [    ])
                           [ 9  ]  [ 10 ]
                           [    ]  [    ]
                           [ 13 ]  [ 14 ]
(%i13) apply ('orthogonal_complement, args (nullspace (transpose (M))));
                           [ 0 ]  [  1  ]
                           [   ]  [     ]
                           [ 1 ]  [  0  ]
(%o13)                span([   ], [     ])
                           [ 2 ]  [ - 1 ]
                           [   ]  [     ]
                           [ 3 ]  [ - 2 ]
@end example

@opencatbox
@category{Linear algebra}
@category{Share packages}
@category{Package linearalgebra}
@closecatbox

@c -----------------------------------------------------------------------------
@need 800
@node Functions and Variables for linearalgebra,  , Introduction to linearalgebra, linearalgebra-pkg
@section Functions and Variables for linearalgebra
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
@anchor{addmatrices}
@deffn {Function} addmatrices (@var{f}, @var{M_1}, @dots{}, @var{M_n})

@c REWORD -- THE RESULT IS NOT GENERALLY THE SUM OF M_1, ..., M_N
Using the function @var{f} as the addition function, return the sum of the
matrices @var{M_1}, @dots{}, @var{M_n}.  The function @var{f} must accept any
number of arguments (a Maxima nary function).

Examples:

@c ===beg===
@c m1 : matrix([1,2],[3,4])$
@c m2 : matrix([7,8],[9,10])$
@c addmatrices('max,m1,m2);
@c addmatrices('max,m1,m2,5*m1);
@c ===end===
@example
(%i1) m1 : matrix([1,2],[3,4])$
(%i2) m2 : matrix([7,8],[9,10])$
(%i3) addmatrices('max,m1,m2);
(%o3) matrix([7,8],[9,10])
(%i4) addmatrices('max,m1,m2,5*m1);
(%o4) matrix([7,10],[15,20])
@end example

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{blockmatrixp}
@deffn {Function} blockmatrixp (@var{M})

Return true if and only if @var{M} is a matrix and every entry of 
@var{M} is a matrix.

@opencatbox
@category{Package linearalgebra}
@category{Predicate functions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{columnop}
@deffn {Function} columnop (@var{M}, @var{i}, @var{j}, @var{theta})

If @var{M} is a matrix, return the matrix that results from doing the column
operation @code{C_i <- C_i - @var{theta} * C_j}. If @var{M} doesn't have a row
@var{i} or @var{j}, signal an error.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{columnswap}
@deffn {Function} columnswap (@var{M}, @var{i}, @var{j})

If @var{M} is a matrix, swap columns @var{i} and @var{j}.  If @var{M} doesn't
have a column @var{i} or @var{j}, signal an error.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{columnspace}
@deffn {Function} columnspace (@var{M})

If @var{M} is a matrix, return @code{span (v_1, ..., v_n)}, where the set
@code{@{v_1, ..., v_n@}} is a basis for the column space of @var{M}.  The span 
of the empty set is @code{@{0@}}.  Thus, when the column space has only
one member, return @code{span ()}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{cholesky}
@deffn  {Function} cholesky @
@fname{cholesky} (@var{M}) @
@fname{cholesky} (@var{M}, @var{field})

Return the Cholesky factorization of the matrix selfadjoint (or hermitian)
matrix @var{M}.  The second argument defaults to 'generalring.' For a
description of the possible values for @var{field}, see @code{lu_factor}.

@opencatbox
@category{Matrix decompositions}
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{ctranspose}
@deffn {Function} ctranspose (@var{M})

Return the complex conjugate transpose of the matrix @var{M}.  The function
@code{ctranspose} uses @code{matrix_element_transpose} to transpose each matrix
element.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{diag_matrix}
@deffn {Function} diag_matrix (@var{d_1}, @var{d_2}, @dots{}, @var{d_n})

Return a diagonal matrix with diagonal entries @var{d_1}, @var{d_2}, @dots{},
@var{d_n}.  When the diagonal entries are matrices, the zero entries of the
returned matrix are zero matrices of the appropriate size; for example:

@c ===beg===
@c diag_matrix(diag_matrix(1,2),diag_matrix(3,4));
@c diag_matrix(p,q);
@c ===end===
@example
(%i1) diag_matrix(diag_matrix(1,2),diag_matrix(3,4));

                            [ [ 1  0 ]  [ 0  0 ] ]
                            [ [      ]  [      ] ]
                            [ [ 0  2 ]  [ 0  0 ] ]
(%o1)                       [                    ]
                            [ [ 0  0 ]  [ 3  0 ] ]
                            [ [      ]  [      ] ]
                            [ [ 0  0 ]  [ 0  4 ] ]
(%i2) diag_matrix(p,q);

                                   [ p  0 ]
(%o2)                              [      ]
                                   [ 0  q ]
@end example

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{dotproduct}
@deffn {Function} dotproduct (@var{u}, @var{v})

Return the dotproduct of vectors @var{u} and @var{v}.  This is the same as
@code{conjugate (transpose (@var{u})) .  @var{v}}.  The arguments @var{u} and
@var{v} must be column vectors.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{eigens_by_jacobi}
@deffn  {Function} eigens_by_jacobi @
@fname{eigens_by_jacobi} (@var{A}) @
@fname{eigens_by_jacobi} (@var{A}, @var{field_type})

Computes the eigenvalues and eigenvectors of @var{A} by the method of Jacobi
rotations.  @var{A} must be a symmetric matrix (but it need not be positive
definite nor positive semidefinite).  @var{field_type} indicates the
computational field, either @code{floatfield} or @code{bigfloatfield}.
If @var{field_type} is not specified, it defaults to @code{floatfield}.

The elements of @var{A} must be numbers or expressions which evaluate to numbers
via @code{float} or @code{bfloat} (depending on @var{field_type}).

Examples:

@c ===beg===
@c S : matrix ([1/sqrt(2), 1/sqrt(2)], [- 1/sqrt(2), 1/sqrt(2)]);
@c L : matrix ([sqrt(3), 0], [0, sqrt(5)]);
@c M : S . L . transpose (S);
@c eigens_by_jacobi (M);
@c float ([[sqrt(3), sqrt(5)], S]);
@c eigens_by_jacobi (M, bigfloatfield);
@c ===end===
@example
(%i1) S: matrix([1/sqrt(2), 1/sqrt(2)],[-1/sqrt(2), 1/sqrt(2)]);
                     [     1         1    ]
                     [  -------   ------- ]
                     [  sqrt(2)   sqrt(2) ]
(%o1)                [                    ]
                     [      1        1    ]
                     [ - -------  ------- ]
                     [   sqrt(2)  sqrt(2) ]
(%i2) L : matrix ([sqrt(3), 0], [0, sqrt(5)]);
                      [ sqrt(3)     0    ]
(%o2)                 [                  ]
                      [    0     sqrt(5) ]
(%i3) M : S . L . transpose (S);
            [ sqrt(5)   sqrt(3)  sqrt(5)   sqrt(3) ]
            [ ------- + -------  ------- - ------- ]
            [    2         2        2         2    ]
(%o3)       [                                      ]
            [ sqrt(5)   sqrt(3)  sqrt(5)   sqrt(3) ]
            [ ------- - -------  ------- + ------- ]
            [    2         2        2         2    ]
(%i4) eigens_by_jacobi (M);
The largest percent change was 0.1454972243679
The largest percent change was 0.0
number of sweeps: 2
number of rotations: 1
(%o4) [[1.732050807568877, 2.23606797749979], 
                        [  0.70710678118655   0.70710678118655 ]
                        [                                      ]]
                        [ - 0.70710678118655  0.70710678118655 ]
(%i5) float ([[sqrt(3), sqrt(5)], S]);
(%o5) [[1.732050807568877, 2.23606797749979], 
                        [  0.70710678118655   0.70710678118655 ]
                        [                                      ]]
                        [ - 0.70710678118655  0.70710678118655 ]
(%i6) eigens_by_jacobi (M, bigfloatfield);
The largest percent change was 1.454972243679028b-1
The largest percent change was 0.0b0
number of sweeps: 2
number of rotations: 1
(%o6) [[1.732050807568877b0, 2.23606797749979b0], 
                [  7.071067811865475b-1   7.071067811865475b-1 ]
                [                                              ]]
                [ - 7.071067811865475b-1  7.071067811865475b-1 ]
@end example

@opencatbox
@category{Matrix decompositions}
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{get_lu_factors}
@deffn {Function} get_lu_factors (@var{x}) 

When @code{@var{x} = lu_factor (@var{A})}, then @code{get_lu_factors} returns a
list of the form @code{[P, L, U]}, where @var{P} is a permutation matrix,
@var{L} is lower triangular with ones on the diagonal, and @var{U} is upper
triangular, and @code{@var{A} = @var{P} @var{L} @var{U}}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{hankel}
@deffn  {Function} hankel @
@fname{hankel} (@var{col}) @
@fname{hankel} (@var{col}, @var{row})

Return a Hankel matrix @var{H}.  The first column of @var{H} is @var{col};
except for the first entry, the last row of @var{H} is @var{row}.  The
default for @var{row} is the zero vector with the same length as @var{col}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{hessian}
@deffn {Function} hessian (@var{f}, @var{x})

Returns the Hessian matrix of @var{f} with respect to the list of variables
@var{x}.  The @code{(i, j)}-th element of the Hessian matrix is
@code{diff(@var{f}, @var{x}[i], 1, @var{x}[j], 1)}.

Examples:

@c ===beg===
@c hessian (x * sin (y), [x, y]);
@c depends (F, [a, b]);
@c hessian (F, [a, b]);
@c ===end===
@example
(%i1) hessian (x * sin (y), [x, y]);
                     [   0       cos(y)   ]
(%o1)                [                    ]
                     [ cos(y)  - x sin(y) ]
(%i2) depends (F, [a, b]);
(%o2)                       [F(a, b)]
(%i3) hessian (F, [a, b]);
                        [   2      2   ]
                        [  d F    d F  ]
                        [  ---   ----- ]
                        [    2   da db ]
                        [  da          ]
(%o3)                   [              ]
                        [   2      2   ]
                        [  d F    d F  ]
                        [ -----   ---  ]
                        [ da db     2  ]
                        [         db   ]
@end example

@opencatbox
@category{Differential calculus}
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{hilbert_matrix}
@deffn {Function} hilbert_matrix (@var{n})

Return the @var{n} by @var{n} Hilbert matrix.  When @var{n} isn't a positive
integer, signal an error.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{identfor}
@deffn  {Function} identfor @
@fname{identfor} (@var{M}) @
@fname{identfor} (@var{M}, @var{fld})

Return an identity matrix that has the same shape as the matrix
@var{M}.  The diagonal entries of the identity matrix are the 
multiplicative identity of the field @var{fld}; the default for
@var{fld} is @var{generalring}.

The first argument @var{M} should be a square matrix or a non-matrix.  When
@var{M} is a matrix, each entry of @var{M} can be a square matrix -- thus
@var{M} can be a blocked Maxima matrix.  The matrix can be blocked to any
(finite) depth.

See also @mref{zerofor}

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{invert_by_lu}
@deffn {Function} invert_by_lu (@var{M}, @var{(rng generalring)})

Invert a matrix @var{M} by using the LU factorization.  The LU factorization
is done using the ring @var{rng}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{jacobian}
@deffn {Function} jacobian (@var{f}, @var{x})

Returns the Jacobian matrix of the list of functions @var{f} with respect to
the list of variables @var{x}.  The @code{(i, j)}-th element of the Jacobian
matrix is @code{diff(@var{f}[i], @var{x}[j])}.

Examples:

@c ===beg===
@c jacobian ([sin (u - v), sin (u * v)], [u, v]);
@c depends ([F, G], [y, z]);
@c jacobian ([F, G], [y, z]);
@c ===end===
@example
(%i1) jacobian ([sin (u - v), sin (u * v)], [u, v]);
                  [ cos(v - u)  - cos(v - u) ]
(%o1)             [                          ]
                  [ v cos(u v)   u cos(u v)  ]
(%i2) depends ([F, G], [y, z]);
(%o2)                  [F(y, z), G(y, z)]
(%i3) jacobian ([F, G], [y, z]);
                           [ dF  dF ]
                           [ --  -- ]
                           [ dy  dz ]
(%o3)                      [        ]
                           [ dG  dG ]
                           [ --  -- ]
                           [ dy  dz ]
@end example

@opencatbox
@category{Differential calculus}
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{kronecker_product}
@deffn {Function} kronecker_product (@var{A}, @var{B})

Return the Kronecker product of the matrices @var{A} and @var{B}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{listp}
@deffn  {Function} listp @
@fname{listp} (@var{e}, @var{p}) @
@fname{listp} (@var{e})

Given an optional argument @var{p}, return @code{true} if @var{e} is a Maxima
list and @var{p} evaluates to @code{true} for every list element.  When
@code{listp} is not given the optional argument, return @code{true} if @var{e}
is a Maxima list.  In all other cases, return @code{false}.

@opencatbox
@category{Package linearalgebra}
@category{Predicate functions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{locate_matrix_entry}
@deffn {Function} locate_matrix_entry (@var{M}, @var{r_1}, @var{c_1}, @var{r_2}, @var{c_2}, @var{f}, @var{rel})

The first argument must be a matrix; the arguments
@var{r_1} through @var{c_2} determine a sub-matrix of @var{M} that consists of
rows @var{r_1} through @var{r_2} and columns @var{c_1} through @var{c_2}.

Find a entry in the sub-matrix @var{M} that satisfies some property.
Three cases:

(1) @code{@var{rel} = 'bool} and @var{f} a predicate: 

Scan the sub-matrix from left to right then top to bottom,
and return the index of the first entry that satisfies the 
predicate @var{f}.  If no matrix entry satisfies @var{f}, return @code{false}.

(2) @code{@var{rel} = 'max} and @var{f} real-valued:

Scan the sub-matrix looking for an entry that maximizes @var{f}.
Return the index of a maximizing entry.

(3) @code{@var{rel} = 'min} and @var{f} real-valued:

Scan the sub-matrix looking for an entry that minimizes @var{f}.
Return the index of a minimizing entry.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{lu_backsub}
@deffn {Function} lu_backsub (@var{M}, @var{b})

When @code{@var{M} = lu_factor (@var{A}, @var{field})},
then @code{lu_backsub (@var{M}, @var{b})} solves the linear
system @code{@var{A} @var{x} = @var{b}}.

The @var{n} by @var{m} matrix @code{@var{b}}, with @var{n} the number of 
rows of the matrix @code{@var{A}}, contains one right hand side per column. If 
there is only one right hand side then @code{@var{b}} must be a @var{n} by 1
matrix.

Each column of the matrix @code{@var{x}=lu_backsub (@var{M}, @var{b})} is the 
solution corresponding to the respective column of @code{@var{b}}.

Examples:

@c ===beg===
@c A : matrix ([1 - z, 3], [3, 8 - z]);
@c M : lu_factor (A,generalring);
@c b : matrix([a],[c]);
@c x : lu_backsub(M,b);
@c ratsimp(A . x - b);
@c B : matrix([a,d],[c,f]);
@c x : lu_backsub(M,B);
@c ratsimp(A . x - B);
@c ===end===
@example
(%i1) A : matrix ([1 - z, 3], [3, 8 - z]);
                               [ 1 - z    3   ]
(%o1)                          [              ]
                               [   3    8 - z ]
(%i2) M : lu_factor (A,generalring);
               [ 1 - z          3         ]
               [                          ]
(%o2)         [[   3              9       ], [1, 2], generalring]
               [ -----  (- z) - ----- + 8 ]
               [ 1 - z          1 - z     ]
(%i3) b : matrix([a],[c]);
                                     [ a ]
(%o3)                                [   ]
                                     [ c ]
(%i4) x : lu_backsub(M,b);
                           [               3 a     ]
                           [       3 (c - -----)   ]
                           [              1 - z    ]
                           [ a - ----------------- ]
                           [               9       ]
                           [     (- z) - ----- + 8 ]
                           [             1 - z     ]
                           [ --------------------- ]
(%o4)                      [         1 - z         ]
                           [                       ]
                           [            3 a        ]
                           [       c - -----       ]
                           [           1 - z       ]
                           [   -----------------   ]
                           [             9         ]
                           [   (- z) - ----- + 8   ]
                           [           1 - z       ]
(%i5) ratsimp(A . x - b);
                                     [ 0 ]
(%o5)                                [   ]
                                     [ 0 ]
(%i6) B : matrix([a,d],[c,f]);
                                   [ a  d ]
(%o6)                              [      ]
                                   [ c  f ]
(%i7) x : lu_backsub(M,B);
               [               3 a                    3 d     ]
               [       3 (c - -----)          3 (f - -----)   ]
               [              1 - z                  1 - z    ]
               [ a - -----------------  d - ----------------- ]
               [               9                      9       ]
               [     (- z) - ----- + 8      (- z) - ----- + 8 ]
               [             1 - z                  1 - z     ]
               [ ---------------------  --------------------- ]
(%o7)          [         1 - z                  1 - z         ]
               [                                              ]
               [            3 a                    3 d        ]
               [       c - -----              f - -----       ]
               [           1 - z                  1 - z       ]
               [   -----------------      -----------------   ]
               [             9                      9         ]
               [   (- z) - ----- + 8      (- z) - ----- + 8   ]
               [           1 - z                  1 - z       ]
(%i8) ratsimp(A . x - B);
                                   [ 0  0 ]
(%o8)                              [      ]
                                   [ 0  0 ]
@end example

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{lu_factor}
@deffn {Function} lu_factor (@var{M}, @var{field})

Return a list of the form @code{[@var{LU}, @var{perm}, @var{fld}]}, or
@code{[@var{LU}, @var{perm}, @var{fld}, @var{lower-cnd} @var{upper-cnd}]}, where

(1) The matrix @var{LU} contains the factorization of @var{M} in a packed form.
    Packed form means three things: First, the rows of @var{LU} are permuted
    according to the list @var{perm}.  If, for example, @var{perm} is the list
    @code{[3,2,1]}, the actual first row of the @var{LU} factorization is the
    third row of the matrix @var{LU}.  Second, the lower triangular factor of
    m is the lower triangular part of @var{LU} with the diagonal entries
    replaced by all ones.  Third, the upper triangular factor of @var{M} is the
    upper triangular part of @var{LU}.

(2) When the field is either @code{floatfield} or @code{complexfield}, the
    numbers @var{lower-cnd} and @var{upper-cnd} are lower and upper bounds for
    the infinity norm condition number of @var{M}.  For all fields, the
    condition number might not be estimated; for such fields, @code{lu_factor}
    returns a two item list.  Both the lower and upper bounds can differ from
    their true values by arbitrarily large factors.  (See also @mref{mat_cond}.)
   
  The argument @var{M} must be a square matrix.

  The optional argument @var{fld} must be a symbol that determines a ring or
  field.  The pre-defined fields and rings are:

  (a) @code{generalring}      -- the ring of Maxima expressions,

  (b) @code{floatfield}       -- the field of floating point numbers of the
                                 type double,

  (c) @code{complexfield}     -- the field of complex floating point numbers of
                                 the type double,

  (d) @code{crering}          -- the ring of Maxima CRE expressions,

  (e) @code{rationalfield}    -- the field of rational numbers,

  (f) @code{runningerror}     -- track the all floating point rounding errors,

  (g) @code{noncommutingring} -- the ring of Maxima expressions where
                                 multiplication is the non-commutative dot
                                 operator.

When the field is @code{floatfield}, @code{complexfield}, or
@code{runningerror}, the algorithm uses partial pivoting; for all
other fields, rows are switched only when needed to avoid a zero
pivot.

Floating point addition arithmetic isn't associative, so the meaning
of 'field' differs from the mathematical definition.

A member of the field @code{runningerror} is a two member Maxima list
of the form @code{[x,n]},where @var{x} is a floating point number and
@code{n} is an integer.  The relative difference between the 'true'
value of @code{x} and @code{x} is approximately bounded by the machine
epsilon times @code{n}.  The running error bound drops some terms that
of the order the square of the machine epsilon.

There is no user-interface for defining a new field.  A user that is
familiar with Common Lisp should be able to define a new field.  To do
this, a user must define functions for the arithmetic operations and
functions for converting from the field representation to Maxima and
back.  Additionally, for ordered fields (where partial pivoting will be
used), a user must define functions for the magnitude and for
comparing field members.  After that all that remains is to define a
Common Lisp structure @code{mring}.  The file @code{mring} has many
examples.
 
To compute the factorization, the first task is to convert each matrix
entry to a member of the indicated field.  When conversion isn't
possible, the factorization halts with an error message.  Members of
the field needn't be Maxima expressions.  Members of the
@code{complexfield}, for example, are Common Lisp complex numbers.  Thus
after computing the factorization, the matrix entries must be
converted to Maxima expressions.

See also  @mref{get_lu_factors}.

Examples:

@c ===beg===
@c w[i,j] := random (1.0) + %i * random (1.0);
@c showtime : true$
@c M : genmatrix (w, 100, 100)$
@c lu_factor (M, complexfield)$
@c lu_factor (M, generalring)$
@c showtime : false$
@c M : matrix ([1 - z, 3], [3, 8 - z]);
@c lu_factor (M, generalring);
@c get_lu_factors (%);
@c %[1] . %[2] . %[3];
@c ===end===
@example
(%i1) w[i,j] := random (1.0) + %i * random (1.0);
(%o1)          w     := random(1.) + %i random(1.)
                i, j
(%i2) showtime : true$
Evaluation took 0.00 seconds (0.00 elapsed)
(%i3) M : genmatrix (w, 100, 100)$
Evaluation took 7.40 seconds (8.23 elapsed)
(%i4) lu_factor (M, complexfield)$
Evaluation took 28.71 seconds (35.00 elapsed)
(%i5) lu_factor (M, generalring)$
Evaluation took 109.24 seconds (152.10 elapsed)
(%i6) showtime : false$

(%i7) M : matrix ([1 - z, 3], [3, 8 - z]); 
                        [ 1 - z    3   ]
(%o7)                   [              ]
                        [   3    8 - z ]
(%i8) lu_factor (M, generalring);
          [ 1 - z         3        ]
          [                        ]
(%o8)    [[   3            9       ], [1, 2], generalring]
          [ -----  - z - ----- + 8 ]
          [ 1 - z        1 - z     ]
(%i9) get_lu_factors (%);
                  [   1    0 ]  [ 1 - z         3        ]
        [ 1  0 ]  [          ]  [                        ]
(%o9)  [[      ], [   3      ], [                9       ]]
        [ 0  1 ]  [ -----  1 ]  [   0    - z - ----- + 8 ]
                  [ 1 - z    ]  [              1 - z     ]
(%i10) %[1] . %[2] . %[3];
                        [ 1 - z    3   ]
(%o10)                  [              ]
                        [   3    8 - z ]
@end example

@opencatbox
@category{Matrix decompositions}
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{mat_cond}
@deffn  {Function} mat_cond @
@fname{mat_cond} (@var{M}, 1) @
@fname{mat_cond} (@var{M}, inf)

Return the @var{p}-norm matrix condition number of the matrix
@var{m}.  The allowed values for @var{p} are 1 and @var{inf}.  This
function uses the LU factorization to invert the matrix @var{m}.  Thus
the running time for @code{mat_cond} is proportional to the cube of
the matrix size; @code{lu_factor} determines lower and upper bounds
for the infinity norm condition number in time proportional to the
square of the matrix size.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{mat_norm}
@deffn  {Function} mat_norm @
@fname{mat_norm} (@var{M}, 1) @
@fname{mat_norm} (@var{M}, inf) @
@fname{mat_norm} (@var{M}, frobenius)

Return the matrix @var{p}-norm of the matrix @var{M}.  The allowed values for
@var{p} are 1, @code{inf}, and @code{frobenius} (the Frobenius matrix norm).
The matrix @var{M} should be an unblocked matrix.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{linearalgebra_matrixp}
@deffn  {Function} matrixp @
@fname{matrixp} (@var{e}, @var{p}) @
@fname{matrixp} (@var{e})

Given an optional argument @var{p}, return @code{true} if @var{e} is 
a matrix and @var{p} evaluates to @code{true} for every matrix element.
When @code{matrixp} is not given an optional argument, return @code{true} 
if @code{e} is a matrix.  In all other cases, return @code{false}.

See also @mref{blockmatrixp}

@opencatbox
@category{Package linearalgebra}
@category{Predicate functions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{matrix_size}
@deffn {Function} matrix_size (@var{M})

Return a two member list that gives the number of rows and columns, respectively
of the matrix @var{M}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{mat_fullunblocker}
@deffn {Function} mat_fullunblocker (@var{M})

If @var{M} is a block matrix, unblock the matrix to all levels.  If @var{M} is
a matrix, return @var{M}; otherwise, signal an error.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{mat_trace}
@deffn {Function} mat_trace (@var{M})

Return the trace of the matrix @var{M}.  If @var{M} isn't a matrix, return a
noun form.  When @var{M} is a block matrix, @code{mat_trace(M)} returns
the same value as does @code{mat_trace(mat_unblocker(m))}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{mat_unblocker}
@deffn {Function} mat_unblocker (@var{M})

If @var{M} is a block matrix, unblock @var{M} one level.  If @var{M} is a
matrix, @code{mat_unblocker (M)} returns @var{M}; otherwise, signal an error.

Thus if each entry of @var{M} is matrix, @code{mat_unblocker (M)} returns an 
unblocked matrix, but if each entry of @var{M} is a block matrix,
@code{mat_unblocker (M)} returns a block matrix with one less level of blocking.

If you use block matrices, most likely you'll want to set
@code{matrix_element_mult} to @code{"."} and @code{matrix_element_transpose} to
@code{'transpose}.  See also @mref{mat_fullunblocker}.

Example:

@c ===beg===
@c A : matrix ([1, 2], [3, 4]);
@c B : matrix ([7, 8], [9, 10]);
@c matrix ([A, B]);
@c mat_unblocker (%);
@c ===end===
@example
(%i1) A : matrix ([1, 2], [3, 4]);
                            [ 1  2 ]
(%o1)                       [      ]
                            [ 3  4 ]
(%i2) B : matrix ([7, 8], [9, 10]);
                            [ 7  8  ]
(%o2)                       [       ]
                            [ 9  10 ]
(%i3) matrix ([A, B]);
@group
                     [ [ 1  2 ]  [ 7  8  ] ]
(%o3)                [ [      ]  [       ] ]
                     [ [ 3  4 ]  [ 9  10 ] ]
@end group
(%i4) mat_unblocker (%);
                         [ 1  2  7  8  ]
(%o4)                    [             ]
                         [ 3  4  9  10 ]
@end example

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{nullspace}
@deffn {Function} nullspace (@var{M})

If @var{M} is a matrix, return @code{span (v_1, ..., v_n)}, where the set
@code{@{v_1, ..., v_n@}} is a basis for the nullspace of @var{M}.  The span of
the empty set is @code{@{0@}}.  Thus, when the nullspace has only one member,
return @code{span ()}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{nullity}
@deffn {Function} nullity (@var{M})

If @var{M} is a matrix, return the dimension of the nullspace of @var{M}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{orthogonal_complement}
@deffn {Function} orthogonal_complement (@var{v_1}, @dots{}, @var{v_n})

Return @code{span (u_1, ..., u_m)}, where the set @code{@{u_1, ..., u_m@}} is a 
basis for the orthogonal complement of the set @code{(v_1, ..., v_n)}.

Each vector @var{v_1} through @var{v_n} must be a column vector.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{polynomialp}
@deffn  {Function} polynomialp @
@fname{polynomialp} (@var{p}, @var{L}, @var{coeffp}, @var{exponp}) @
@fname{polynomialp} (@var{p}, @var{L}, @var{coeffp}) @
@fname{polynomialp} (@var{p}, @var{L})

Return @code{true} if @var{p} is a polynomial in the variables in the list
@var{L}.  The predicate @var{coeffp} must evaluate to @code{true} for each
coefficient, and the predicate @var{exponp} must evaluate to @code{true} for all
exponents of the variables in @var{L}.  If you want to use a non-default value
for @var{exponp}, you must supply @var{coeffp} with a value even if you want
to use the default for @var{coeffp}.

@c WORK THE FOLLOWING INTO THE PRECEDING
The command @code{polynomialp (@var{p}, @var{L}, @var{coeffp})} is equivalent to
@code{polynomialp (@var{p}, @var{L}, @var{coeffp}, 'nonnegintegerp)} and the
command @code{polynomialp (@var{p}, @var{L})} is equivalent to
@code{polynomialp (@var{p}, L@var{,} 'constantp, 'nonnegintegerp)}.

The polynomial needn't be expanded:

@c ===beg===
@c polynomialp ((x + 1)*(x + 2), [x]);
@c polynomialp ((x + 1)*(x + 2)^a, [x]);
@c ===end===
@example
(%i1) polynomialp ((x + 1)*(x + 2), [x]);
(%o1)                         true
(%i2) polynomialp ((x + 1)*(x + 2)^a, [x]);
(%o2)                         false
@end example

An example using non-default values for coeffp and exponp:

@c ===beg===
@c polynomialp ((x + 1)*(x + 2)^(3/2), [x], numberp, numberp);
@c polynomialp ((x^(1/2) + 1)*(x + 2)^(3/2), [x], numberp, 
@c                                                        numberp);
@c ===end===
@example
(%i1) polynomialp ((x + 1)*(x + 2)^(3/2), [x], numberp, numberp);
(%o1)                         true
(%i2) polynomialp ((x^(1/2) + 1)*(x + 2)^(3/2), [x], numberp,
                                                        numberp);
(%o2)                         true
@end example

Polynomials with two variables:

@c ===beg===
@c polynomialp (x^2 + 5*x*y + y^2, [x]);
@c polynomialp (x^2 + 5*x*y + y^2, [x, y]);
@c ===end===
@example
(%i1) polynomialp (x^2 + 5*x*y + y^2, [x]);
(%o1)                         false
(%i2) polynomialp (x^2 + 5*x*y + y^2, [x, y]);
(%o2)                         true
@end example

@opencatbox
@category{Package linearalgebra}
@category{Predicate functions}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{polytocompanion}
@deffn {Function} polytocompanion (@var{p}, @var{x})

If @var{p} is a polynomial in @var{x}, return the companion matrix of @var{p}.
For a monic polynomial @var{p} of degree @var{n}, we have
@code{@var{p} = (-1)^@var{n} charpoly (polytocompanion (@var{p}, @var{x}))}.

When @var{p} isn't a polynomial in @var{x}, signal an error.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{ptringularize}
@deffn {Function} ptriangularize (@var{M}, @var{v})

If @var{M} is a matrix with each entry a polynomial in @var{v}, return 
a matrix @var{M2} such that

(1) @var{M2} is upper triangular,

(2) @code{@var{M2} = @var{E_n} ... @var{E_1} @var{M}},
where @var{E_1} through @var{E_n} are elementary matrices 
whose entries are polynomials in @var{v},

(3) @code{|det (@var{M})| = |det (@var{M2})|},

Note: This function doesn't check that every entry is a polynomial in @var{v}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{rowp}
@deffn {Function} rowop (@var{M}, @var{i}, @var{j}, @var{theta})

If @var{M} is a matrix, return the matrix that results from doing the
row operation @code{R_i <- R_i - theta * R_j}.  If @var{M} doesn't have a row
@var{i} or @var{j}, signal an error.

@opencatbox
@category{Package linearalgebra}
@closecatbox

@end deffn

@anchor{linalg_rank}
@deffn {Function} linalg_rank (@var{M})

Return the rank of the matrix @var{M}. This function is equivalent to
function @mref{rank}, but it uses a different algorithm: it finds the
@mref{columnspace} of the matrix and counts its elements, since the rank
of a matrix is the dimension of its column space. 

@c ===beg===
@c linalg_rank(matrix([1,2],[2,4]));
@c linalg_rank(matrix([1,b],[c,d]));
@c ===end===
@example
@group
(%i1) linalg_rank(matrix([1,2],[2,4]));
(%o1)                           1
@end group
@group
(%i2) linalg_rank(matrix([1,b],[c,d]));
(%o2)                           2
@end group
@end example

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{rowswap}
@deffn {Function} rowswap (@var{M}, @var{i}, @var{j})

If @var{M} is a matrix, swap rows @var{i} and @var{j}.  If @var{M} doesn't
have a row @var{i} or @var{j}, signal an error.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{toeplitz}
@deffn  {Function} toeplitz @
@fname{toeplitz} (@var{col}) @
@fname{toeplitz} (@var{col}, @var{row})

Return a Toeplitz matrix @var{T}.  The first first column of @var{T} is
@var{col}; except for the first entry, the first row of @var{T} is @var{row}.
The default for @var{row} is complex conjugate of @var{col}.  Example:

@c ===beg===
@c toeplitz([1,2,3],[x,y,z]);
@c toeplitz([1,1+%i]);
@c ===end===
@example
(%i1)  toeplitz([1,2,3],[x,y,z]);
@group
                                  [ 1  y  z ]
                                  [         ]
(%o1)                             [ 2  1  y ]
                                  [         ]
                                  [ 3  2  1 ]
@end group
(%i2)  toeplitz([1,1+%i]);

                              [   1     1 - %I ]
(%o2)                         [                ]
                              [ %I + 1    1    ]
@end example

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{vandermonde_matrix}
@deffn {Function} vandermonde_matrix ([@var{x_1}, ..., @var{x_n}])

Return a @var{n} by @var{n} matrix whose @var{i}-th row is 
@code{[1, @var{x_i}, @var{x_i}^2, ... @var{x_i}^(@var{n}-1)]}.

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{zerofor}
@deffn {Function} zerofor @
@fname{zerofor} (@var{M}) @
@fname{zerofor} (@var{M}, @var{fld})

Return a zero  matrix that has the same shape as the matrix
@var{M}.  Every entry of the zero matrix is the
additive identity of the field @var{fld}; the default for
@var{fld} is @var{generalring}.

The first argument @var{M} should be a square matrix or a
non-matrix.  When @var{M} is a matrix, each entry of @var{M} can be a
square matrix -- thus @var{M} can be a blocked Maxima matrix.  The
matrix can be blocked to any (finite) depth.

See also @mref{identfor}

@opencatbox
@category{Package linearalgebra}
@closecatbox
@end deffn

@c -----------------------------------------------------------------------------
@anchor{zeromatrixp}
@deffn {Function} zeromatrixp (@var{M})

If @var{M} is not a block matrix, return @code{true} if
@code{is (equal (@var{e}, 0))} is true for each element @var{e} of the matrix
@var{M}.  If @var{M} is a block matrix, return @code{true} if @code{zeromatrixp}
evaluates to @code{true} for each element of @var{e}.

@opencatbox
@category{Package linearalgebra}
@category{Predicate functions}
@closecatbox
@end deffn

