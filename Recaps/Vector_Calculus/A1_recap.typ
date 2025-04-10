#set page(numbering: "1")

#align(right, text(12pt)[
  help
])

#align(center, text(17pt)[
  Vectorial Calculus A1 Recap

  #datetime.today().display("[day]/[month]/[year]")
])
= Riemann integral(s)
something cool
== Spherical and Cylindrical coordinates

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

== Jacobian Determinant For Multiple Integrals

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
  integral.triple_A f(x, y, z) d x d y d z = integral.triple_T(A) f(x(u, v, w), y(u, v, w), z(u, v, w)) (diff(x , y , z)) / diff(u , v , w) d u d v d w
$

= Physics

== Center of Mass and Centroid

Given a plane region $S^2 subset RR^2$, its #text(weight: "bold")[centroid] is the point $(x_c , y_c)$, where:

$
  x_c = 1 / ("area"(S)) integral.double x d x d y\

  y_c = 1 / ("area"(S)) integral.double_S y d x d y
$

If the region/body/whatever has #text(weight: "bold")[constant] density $mu(x,y), forall x, y in RR$, then its centroid is the same as the center of mass, which is the point $(hat(x_c), hat(y_c))$ where:

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

== Scalar Line Integrals

== Centroid and Mass Center of a Curve

== Vectorial Line Integrals

== Conservative Vector Fields

== Angle Variation

