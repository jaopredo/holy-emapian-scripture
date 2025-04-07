// A bunch of lets here


#set page(numbering: "1")

#align(right, text(12pt)[
  help
])

#align(center, text(17pt)[
  Numerical Linear Algebra A1 recap

  #datetime.today().display("[day]/[month]/[year]")
])

The lectures below refer to Trefethen's book on numerical linear algebra
= Lecture 1,2

This is ordinary linear algebra. Shit starts to get wild from Lecture 3:

= Lecture 3 - Norms
== Vector norms

A #text(weight: "bold")[norm] is a function $|| dot ||: CC^m -> RR$ that satisfies, for $x,y,z in C^m$:

$
  ||x|| >= 0
$

= Lecture 4 and 5 - The SVD

= Lecture 6 - Projectors

$P in C^(m times n)$ is said to be a #text(weight: "bold")[Projector] if"

$
  P^2 = P
$ and the matrix $I-P$ is its complementary projector:

$
  (I - P)^2 - I - 2P + P^2 = I- P
$









= Lecture 7- QR Factorization

= Lecture 8 - Gram-Schmidt Orthogonalization

= Lecture 9 - MATLAB
fuck MATLAB

= Lecture 10 - Householder Triangularization

= Lecture 11 - Least Squares problems

= Lecture 12 - Conditioning and Condition Numbers

= Lecture 13 - Floating Point Arithmetic

= Lecture 14 and 15 - Stability

= Lecture 16 - Stability of Householder Triangularization



