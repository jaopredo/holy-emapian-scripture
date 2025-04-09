#set page(numbering: "1")

#align(right, text(12pt)[
  help
])

#align(center, text(17pt)[
  Vectorial Calculus A1 Recap

  #datetime.today().display("[day]/[month]/[year]")
])
socorro
= Riemann integral


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

