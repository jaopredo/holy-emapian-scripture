#set page(numbering: "1")

#align(right, text(12pt)[
  help
])

#align(center, text(17pt)[
  Vectorial Calculus A1 Recap

  #datetime.today().display("[day]/[month]/[year]")
])

= Spherical and Cylindrical coordinates

Everything described in this section has an easier version in $RR^2$

=== Cylindrical coordinates

The transformation from the ordinary space $RR^3$ to $C(RR^3)$ is nearly analogous to polar coordinates in $RR^2$ described below:

$
  T(x, y, z) = (r cos theta, r sin theta, z)
$, and if we were integrating some function $f: RR^3 -> RR$ under the region $A subset RR^3$ in the space $(x , y , z)$, the equivalent integral in the new system $C(RR^3)$ is:

$
  integral.triple_C(A) f(r cos theta, r sin theta, z) r d z d r d theta
$

=== Spherical coordinates

From the reasoning used in cylindrical coordinates, we have:

$
  integral.triple_A f(x , y, z) d x d y d z = integral.triple_S(A) f( rho sin phi cos theta, rho sin phi sin theta, rho cos theta) rho^2 sin phi d rho d theta d phi
$

= Jacobian Determinant For Multiple Integrals

More general change of variables require some technicalities:

If $T:RR^3 -> RR^3$ is a bijective function that morphes a region in the space $x y z$ into the space $u v w$ throught the equations that follow:

$
  x = g(u, v, w)\
  y = h(u, , w)\
  z = k(u, v, w)
$ 

Then the #text(weight: "bold")[jacobian determinant of T] is:

$
  (diff(x , y , z)) / diff(u , v , w) = det mat(
    (diff x) / (diff u), (diff x) / (diff v) , (diff x) / ( diff w);
    (diff y) / (diff u) , (diff y) / (diff v) , (diff y) / (diff w);
    (diff z) / (diff u) , (diff z) / (diff v) , (diff z) / (diff w);
  )
$

And the equivalent integral onto the new system is:

$
  integral.triple_A f(x, y, z) d x d y d z = integral.triple_T(A) f(x(u, v, w), y(u, v, w), z(u, v, w)) |(diff(x , y , z)) / diff(u , v , w)| d u d v d w
$

= Physics

== Mass Center and Centroid

Given a plane region $S^2 subset RR^2$, its #text(weight: "bold")[centroid] is the point $(x_c , y_c)$, where:

$
  x_c = 1 / ("area"(S)) integral.double_S x d x d y\

  y_c = 1 / ("area"(S)) integral.double_S y d x d y
$

If the region/body/whatever has #text(weight: "bold")[constant] density $mu(x,y), forall x, y in RR$, then its centroid is the same as the mass center, which is the point $(hat(x_c), hat(y_c))$ where:

$
  hat(x_c) = (integral.double_S mu(x,y) x d x d y) / (integral.double_S mu(x,y) d x d y)\

  hat(y_c) = (integral.double_S mu(x,y) y d x d y) / (integral.double_S mu(x,y) d x d y)\
$

Notice that the #text(weight: "bold")[mass] of $S$ is given by:

$
  integral.double_S mu(x,y) d x d y
$

== Moment of Inertia

Let $X subset RR^3$ be a body, rotating over
a given axis, let $mu(x)$ be the mass density
in $x, forall x in X$, if $r(X)$ is the distance to axis it is rotating over, and $v(x)$ is the speed, $forall x in X$, then $|v(x)| = omega r(x)$, where $omega$ is the angular speed


It follows that the #text(weight: "bold")[kinetic energy] of the body is $(m v^2) / 2$:

$
  1/2 dot integral_X mu(x) |v(x)|^2 d X  = 1/2 omega^2 dot integral_X mu(x) r(x)^2 d X
$

We define now the #text(weight: "bold")[Moment of Inertia] as:

$
  I = integral_X mu(x) r(x)^2 d X.
$

$L = omega I$ is called the #text(weight: "bold")[angular momentum], it is conserved if there are no external rotational forces.

= Vector Calculus

== Curves

A Curve is a continuous function $gamma: [a,b] -> RR^n$, it is of class $C^1$ if $gamma '$ exists and is continuous in [a,b], if $gamma(a) = gamma(b)$, the curve is #text(weight: "bold")[closed].

A curve is said to be  $C^1$ _by parts_ if there is a partition of $[a,b]$ in a finite number of subintervals such that the curve is $C^1$ in each of tese subintervals.

== Scalar Line Integrals

Given $f: RR^n -> RR$ a function and $gamma:[a,b] -> RR^n$ a $C^1$ class curve in $RR^n$, the #text(weight: "bold")[scalar line integral] of f along $gamma$ is:

$
  integral_gamma f d s = integral_a^b f(gamma(t)) ||gamma^' (y)|| d t
$

If $gamma$ is $C^1$ _by parts_, we integrate on the $C^1$ partition-subintervals and sum each odf the smaller integrals.



== Centroid and Mass Center of a Curve

=== Mass Cernter

Given $gamma subset RR^3$ a curve, and let $f(x,y,z)$ be the mass density per unit of lenght of $gamma$, we know that the $gamma$'s mass is given by:

$
  M = integral_gamma f(x, y, z) d s.
$

So the mass center of $gamma$ is the point $c_m = (x_c, y_c, z_c)$ s.t:

$
  x_c = (integral_gamma x f (x, y , z) d s ) / M\

  y_c = (integral_gamma y f (x, y , z) d s ) / M\

  z_c = (integral_gamma z f (x, y , z) d s ) / M\
$

If $f$ is constant (homogeneous curve), then the mass center is the centroid as well

=== Centroid

Let $gamma subset RR^3$ be a smooth or piecewise smooth curve, parameterized by $gamma(t): [a, b] -> RR^3$. If the curve is #text(weight: "bold")[homogeneous], meaning the mass density per unit length is constant, then its #text(weight: "bold")[centroid] is the point $(x_c, y_c, z_c)$ given by:

$ x_c = 1 / L integral_gamma x d s\

y_c = 1 / L integral_gamma y d s\

z_c = 1 / L integral_gamma z d s
$

Where $L$ is the total arc length of the curve:

$ L = integral_gamma d s = integral_a^b ||gamma^' (t)|| d t $
== Vectorial Line Integrals

Consider now $F: RR^n -> RR^n$, usually called a _vector field_, and a class $C^1$ curve $gamma: [a,b] -> RR^n$ in this field.

The integral of F _along_ $gamma$ is:

$
  integral_gamma F = integral_a^b F(gamma(t)) gamma^' (t) d t
$

This line integral is linear: $integral_gamma ( a F+ b G) = a integral_gamma F + b integral_gamma G$ 

== Conservative Vector Fields and Angle Variation

=== Foreword

We have been trained in the mysterious and dark arts of newtonian and lagrangian mechanics by Master Paulo Verdasca Amorim himself, this is nothing to us.

=== Conservative Vector Fields

A field $F: Omega subset RR^n -> RR^n$, $Omega$ an open and connected set, is said to be conservative if $exists U: Omega -> RR$ s.t $F  = Delta U$, $U$ is called $F$'s #text(weight: "bold")[potential]

#text(weight: "bold")[Theorem]: Let $F:Omega -> RR^n$ be a vector field and $f:Omega -> RR$ be its potential, i.e $F = Delta f$. Let $A, B in Omega$ and $c:[a, b] -> RR^n$ be a $C^1$ by parts curve s.t c(a) = A and c(b) = B, then:

$
  integral_c F = f(B) - f(A)
$ This looks like Calculus' Fundamental Theorem

=== Angle Variation

We conclude this section on line integrals with a counterexample: a vector field that satisfies $partial F_1 / partial y = partial F_2 / partial x$ but is not conservative.

Let $F(x, y) = 1 / (x^2 + y^2) (-y, x)$, defined over $RR^2 without 0$. Note that:

$ partial F_1 / partial y = partial F_2 / partial x = (y^2 - x^2) / (x^2 + y^2)^2 $

So the field meets the symmetry of mixed partials, but $F$ is still not conservative — the domain is not simply connected.

Take the closed curve $c: [0, 2pi] -> RR^2$ given by:

$ c(t) = (cos t, sin t) $

Then:

$ integral_c F = integral_0^{2pi} (-sin t, cos t) dot (-sin t, cos t) d t = integral_0^{2pi} 1 d t = 2pi != 0 $

Since the line integral over a closed curve is nonzero, $F$ is not conservative.