#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#set page(width: 21cm, height: 29.7cm, margin: 1.5cm)
#set heading(numbering: "1.1.")

#let theorem = thmbox("theorem", "Theorem")
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

#align(center + top)[
  FGV EMAp

  João Pedro Jerônimo
]

#align(horizon + center)[
  #text(17pt)[
    Numerical Linear Algebra
  ]
  
  #text(14pt)[
    A1 Recap
  ]
]

#align(bottom + center)[
  Rio de Janeiro

  2025
]

#pagebreak()

#outline(title: [Summary])

#pagebreak()


The lectures below refer to Trefethen's book on numerical linear algebra

= Lecture 3 - Norms
*Diclaimer*: The norm's chapter has pretty abstract concepts, some of them are not very *intutive*, so try to abstract and accept they exist for now, later we will show that they are very useful.

== Vector norms

#definition("Norm")[
  A #text(weight: "bold")[norm] is a function $|| dot ||: CC^m -> RR$ that satisfies 3 properties:

  1. $||x|| >= 0$, and $||x|| = 0 <=> x = 0$
  2. $||x + y|| <= ||x|| + ||y||$
  3. $||alpha x|| = |alpha|||x||$
]

We normally see the 2-norm, or the *Euclidian Norm*, that represents the *size* of a vector. Based on that, we can define a *p-norm*.

#definition("p-norm")[
  The *p-norm* of $x in CC^n$ (or $||x||_p$) is defined as:

  #align(center)[$||x||_p = (sum_(i=1)^n|x_i|^p)^(1/p)$]
]

So we can have multiple types of norms, from 1 to $infinity$, and we define it as well!

#definition("Inifinite-norm")[
  The *infinite norm* of $x in CC^n$ (or $||x||_(infinity)$) is defined as:

  #align(center)[$||x||_(infinity) = max|x_i|$]
]

You probably wondering "why would I need something like this"? But trust me, it will be useful in the future!
There is a pretty useful type of norm (According to the book), that is called the *weighted norm*.

#definition("Weighted norm")[
  The *weighted norm* of $x in CC^n$ is:
  
  #align(center)[$||x||_W = ||W x|| = (sum_(i=1)^n |w_(i i) x_i|^p)^(1/p)$]

  Where W is a *diagonal matrix* and $p$ is an arbitrary number
]

== Matrix Norms
WHAT?? MATRICES HAVE NORMS???? Yes, my young Padawan! The book tells that we could see a matrix as a vector in a $m times n$ space, and we could use any $m n$-norm to measure it, but some norms are more useful than the ones already discussed.

#definition("Induced norm")[
  Given $A in CC^(m times n)$, the induced norm $||A||_(m -> n)$ is the smallest integer for wich the inequality holds:

  #align(center)[$||A x||_m <= C||x||_n$]

  In other words:

  #align(center)[$||A||_(m -> n) = sup_(x != 0)(||A x||_m)/(||x||_n)$]
]

This definition may seem stupid and useless by now, but it will be very useful when we see about errors and conditioning.

A useful norm we may say is the $infinity$-norm of a Matrix

#definition("Infinite norm of a Matrix")[
  Given $A in CC^(m times n)$, if $a_j$ is the $j^(t h)$ row of $A$, $||A||_(infinity)$ is defined by:

  #align(center)[$||A||_(infinity) = max_(1 <= i <= m)||a_i||_1$]
]

== Cauchy-Schwarz & Hölder Inequalities
When we are using norms, usually it is difficult to compute $p$-norms with high values of $p$, so we manage them using inequalities! A very useful inequality is the Hölder inequality:

#definition("Hölder Inequality")[
  Given $1 <= p, q  <= infinity$, and $1/p + 1/q = 1$, then, for any vectors $x, y$:

  #align(center)[$|x^*y| <= ||x||_p||y||_q$]
]

and the Cauchy-Schwarz inequality is a special case where $p = q = 2$

== Bounding $||A B||$
We can bound $||A B||$ as we do with vector norms

#theorem[
  Given $A in CC^(l times m)$,$B in CC^(m times n)$ and $x in CC^n$, then the induced norm of $A B$ must satisfy:

  #align(center)[$||A B||_(l -> n) <= ||A||_(l->m)||B||_(m->n)$]
]
#proof[
  $||A B x||_l <= ||A||_(l->m) ||B x||_m <= ||A||_(l->m) ||B||_(m->n) ||x||_n$
]

== Generalization of Matrices Norms
We saw that a norm follows 3 properties, we define a general matrix norm the same way!!

#definition[
  Given matrices $A$ and $B$, a norm  $||dot||: CC^(m times n) -> RR^+$ is a function that follow these 3 properties:

  1. $||A|| >= 0$, and $||A|| = 0 <=> A = 0$
  2. $||A + A|| <= ||A|| + ||B||$
  3. $||alpha A|| = |alpha|||A||$
]

the most important one is the *Frobenius Norm*, defined as:

#definition[
  Given a matrix $A in CC^(m times n)$, its *Frobenius Norm* is defined as:

  #align(center)[$||A||_F = (sum_(i=1)^m sum_(j=1)^n |a_(i j)|^2)^(1/2)$ = $sqrt(\t\r(A^*A))$ = $sqrt(\t\r(A A^*))$]
]

#theorem[$||A B||_F <= ||A||_F ||B||_F$]
#proof[
  $||A B||_F = (sum_(i=1)^m sum_(j=1)^n |c_(i j)|^2)^(1/2) <= (sum_(i=1)^m sum_(j=1)^n (||a_i||_2||b_j||_2)^2)^(1/2) = (sum_(i=1)^m ||a_i||^2_2 sum_(j=1)^n ||b_j||^2_2)^(1/2) = ||A||_F||B||_F$
]

= Lecture 4 and 5 - The SVD
*Quick Disclaimer:* When we start talking about the factorization itself, we are going to talk about matrices in $CC^(m times n)$ with $m >= n$, because it's the most common when we talk about real problems, rarely is the situations with more variables then equations

Aaaaaah, the SVD, why it exists? What does it mean? Remember that, in Linear Algebra, when we have a base of a Vector Space and a Linear Transformation, we know how the Linear Transformation affects *every* vector on that Vector Space? No? Let me refresh your memmory:

#theorem[
  Given ${a_j}$ $(1 <= j <= n)$ being the base of a Vector Space and $T$ a Linear Transformation in that space, if we know how $T$ affects the vectors of the base, we know how $T$ affects *every* vector on that space
]
#proof[
  Being $v$ a vector on the described Vector Space, we know $v$ can be expressed as

  #align(center)[$v = alpha_1 a_1 + ... + alpha_n a_n$]

  Applying $T$ on $v$

  #align(center)[$T(v) = T(alpha_1 a_1 + ... + alpha_n a_n) => T(v) = alpha_1 T(a_1) + ... + alpha_n T(a_n)$]

  This implies that, if we know a base of the Vectorial Space and how $T$ affects it, we know how $T$ affects every vector on the space
]

RIGHT! Memory refreshed, why did I say that? Remember that matrices are linear transformations? So if we have a base ${s_j}$ of a Vectorial Space $S$, we can know what happens to every linear combination of ${s_j}$ if we apply A on it right? Right!

We can resume the operations we do in vectors in two: *stretch*, and *rotate*, so basically, when we apply a linear transformation on a vector, we are rotating it, then stretching it.

Okay, but why am I saying that? Where the hell is the S.V.D? Well, I basically already described the S.V.D to you! When we apply A as a linear transformation, if we do the operations described early, do you agree we can decompose A as a matrix product of Orthogonal Matrices and Diagonal Matrices? What? Why? When? Wait, young padawan! Remember I said a linear transformation can be resumed in stretching and rotating vectors? Do you remember what kind of matrices do EXACTLY what I said? Yes, orthogonal matrices do rotations and diagonal matrices do stretching.

Now we can introduce that classic visualization of how S.V.D works, imagine a orthonormal base in $RR^2$, looks what happens if we apply A on it:

#align(center)[
#image("images/Singular-Value-Decomposition.svg.png", width: auto, height: 6.8cm)
(Change the M in the image for A)
]

Based on that, we can define that, given $A in CC^(m times n)$:

#align(center)[$A v_j = sigma_j u_j$]

Where $v_j$ and $u_j$ are from two different orthonormal bases and $sigma_j in CC$.

== Reduced Form
We can rewrite this equation as a matrix product!

$A V = accent(U, \u{0302}) accent(Sigma, \u{0302})$

Where

#align(center)[$V = mat(
  |, ,|;
  v_1, ..., v_n;
  |, , |
), Sigma = mat(
  sigma_1, , ,;
  , sigma_2, , ;
  , , dots.down,;
  , , , sigma_n
), U = mat(
  |, ,|;
  u_1, ..., u_n;
  |, , |
)$]

This is known as the *reduced* SVD factorization. We can see that $V$ is a square orthogonal matrix (For $A v_j$ be a valid multiplication, $v_j in CC^n$), so we can rewrite A as:

#align(center)[$A = accent(U, \u{0302}) accent(Sigma, \u{0302}) V^*$]

== Full SVD
Okay, if $v_j in CC^n$ and $A v_j = sigma_j u_j$, then $u_j in CC^m$! That means, beside the $u$ vectors we added in $accent(U, \u{0302})$, we have $m - n$ more orthonormal vectors to the columns of $accent(U, \u{0302})$, finding those vectors, we can build another matrix $U$ that the columns are a orthonormal base of $CC^m$, that means the new matrix $U$ is orthogonal!

#align(center)[$V = mat(
  |, ,|;
  v_1, ..., v_n;
  |, , |
), U = mat(
  |, ,|;
  u_1, ..., u_m;
  |, , |
)$]

Nice! But what about the $accent(Sigma, \u{0302})$ matrix? How does it change? Well, we want to maintain $V$ and $U$ as we wanted right? Well, the thing we did was add columns to $accent(U, \u{0302})$, so, in the multiplication, we only need those columns to disappear, how we do that? Multiplying by 0! So, before, $accent(Sigma, \u{0302})$ was a square matrix with the single values on the diagonal, specifically, $n$ single values. If we added $m-n$ vectors on U, we can add $m-n$ zeros on $accent(Sigma, \u{0302})$, so our new matrix multiplication is

#align(center)[
  $A = U Sigma V^*$
]

#align(center)[
  $mat(
  |, ,|;
  a_1, ..., a_n;
  |, , |
) = mat(
  |, ,|;
  u_1, ..., u_m;
  |, , |
)
mat(
  sigma_1, ,;
  , dots.down,;
  , , sigma_n;
  -, 0, -;
  , dots.v,;
)
mat(
  - v_1 -;
  dots.h;
  - v_n -
)$
]

== Formal Definition
#definition[
  Given $A in CC^(m times n)$ with $m >= n$, the Singular Value Decomposition of $A$ is:

  #align(center)[$A = U Sigma V^*$]

  where $U in CC^(m times m)$ is unitary, $V in CC^(n times n)$ is unitary and $Sigma in CC^(m times n)$ is diagonal. For *convinience*, we denote:

  #align(center)[$sigma_1 >= sigma_2 >= sigma_3 >= ... >= sigma_n$]

  Where $sigma_j$ is the j-th entry of $Sigma$
]

Okay, we saw a intuitive method for seeing that every matrix has this decomposition, but how do we prove it mathematically?

#theorem[
  Every $A in CC^(m times n)$ matrix has a S.V.D decomposition
]
#proof[
  Let ${v_j}$ be an orthonormal base of $CC^n$, ${u_j}$ an orthonormal base of $CC^m$, $A v_j = sigma_j u_j$, $U_1$ and $V_1$ be unitary matrices of columns ${u_j}$ and ${v_j}$ respectively and that, for every matrix with less than $m$ lines and $n$ columns the factorization is valid:

  #align(center)[$A = U_1 S V^*_1 <=> U_1^* A V_1 = S$]

  Então temos $S = mat(
    sigma_1, w^*;
    0, B;
  )$ onde $sigma_1$ é $1 times 1$, $w^*$ é $1 times (n-1)$ e $B$ é $(m-1) times (n-1)$. Beleza, mas o que é $w$? Bem, podemos chegar nesse resultado fazendo umas manipulações com $||mat(
    sigma_1, w^*;
    0, B;
  )mat(sigma_1;w)||_2$:

  #align(center)[$||mat(
    sigma_1, w^*;
    0, B;
  )mat(sigma_1;w)||_2^2 >= sigma_1^2 + w^*w$]

  What? Why this is valid? Because:

  #align(center)[$||M x||_2 <= ||M||_2 ||x||_2 => ||M||_2 >= (||M x||_2) / (||x||_2)$]

  If we set $x = mat(sigma_1;w)$ and $M = S$, then we have:

  #align(center)[
    $M x = mat(sigma_1^2 + ||w||^2; B w)=>||M||_2 >= (|sigma_1^2 + ||w||^2|^2 + ||B w||^2)/(sigma_1^2 + ||w||^2)$
  ]

  But notice that the numerator is always greater than the denominator, so that means

  #align(center)[
    $(|sigma_1^2 + ||w||^2|^2 + ||B w||^2)/(sigma_1^2 + ||w||^2) >= sigma_1^2 + ||w||^2 = (sigma_1^2 + w^*w)^(1/2)||mat(sigma_1;w)||$
  ]

  Now we can go back to see what $w$ is! Well, now is easy! We know that $||S||_2 = ||U_1^* A V_1||_2 = ||A||_2 = sigma_1$ because $U_1$ and $V_1$ are orthogonal. That means $||S||_2 >= (sigma_1^2 + ||w||^2)^(1/2) => sigma_1 >= (sigma_1^2 + ||w||^2)^(1/2) <=> sigma_1^2 >= sigma_1^2 + ||w||^2 => w=0$.

  By the inductive hypothesis described in the start of the proof, we know $B = U_2 Sigma_2 V_2^*$, so we can easily write $A$ as

  #align(center)[$A = U_1 mat(1, 0; 0, U_2) mat(sigma_1, 0; 0, Sigma_2) mat(1, 0; 0, V_2^*)^*V_1^*$]

  That is a S.V.D of A, using the base case of $m=1$ and $n=1$, we finish the existence's proof
]

== Change of Basis
Given $b in CC^m$, $x in CC^n$ and $A in CC^(m times n), A = U Sigma V^*$ we can get the coordinates of $b$ on the basis of the columns of $U$ and $x$ in the columns of $V$. Just to remember:

#definition[
  Given $w in V$ where $V$ is a Vector Space, $exists!x_1, ..., x_n in CC$ such that $w = v_1 x_1 + ... + v_n x_n$ where ${v_j}$ is a base of $V$. The vector $mat(x_1;dots.v;x_n)$, also denoted as $[w]_v$, is the $w$'s *coordinate vector* in the $v$ base
]

Getting back, we can express $[b]_u = U^*b$ and $[x]_v = V^*x$, but why?

#theorem[
  Given a orthonormal base ${v_k}$ of $V$ and $w in V$, then
  
  #align(center)[$([w]_v)_j = v_j^*w$]
]
#proof[
  #align(center)[
    $w = alpha_1 v_1 + ... + alpha_n v_n$

    $v_j^*w = alpha_1 v_j^*v_1 +... + alpha_n v_j^*v_n$
  ]

  Knowing that ${v_j}$ is a orthonormal base, the product $alpha_i v_j^*v_i$ is equal to 0 if $j != i$ and equal to $alpha_i$ if $j = i$, that is:

  #align(center)[
    $v_j^*w = alpha_j$
  ]
]

Ok, now that we remembered all these properties, we can express the relation $b = A x$ in terms of $[b]_u$ and $[x]_v$, let's see:

#align(center)[
  $b = A x <=> U^*b = U^*A x = U^*U Sigma V^* x <=> U^*b = Sigma V^* x$

  $<=> [b]_u = Sigma [x]_v$
]

So we can reduce $A$ to the $Sigma$ matrix and $b$ and $x$ to its coordinates on $u$ base and $v$ base

== S.V.D vs Eigenvalue Decomposition
We can do something similar with the eigenvalue decomposition. Given $A in CC^(m times m)$ with linear independent eigenvectors, i.e we can express $A = S Lambda S^(-1)$ with the columns of $S$ being the eigenvectors of $A$ and $Lambda$ is a diagonal matrix with the eigenvalues of $A$ as entries.

Defining $b, x in CC^(m)$ satisfying $b = A x$, we can write:

#align(center)[
  $[b]_(s^(-1)) = S^(-1)b$ and $[x]_(s^(-1)) = S^(-1)x$
]

Where I'm denoting $s^(-1)$ as the base expressed by the columns of $S^(-1)$, then the new expanded expression is:

#align(center)[
  $b = A x <=> S^(-1)b = S^(-1)A x = S^(-1)S Lambda S^(-1) x <=> S^(-1)b = Lambda S^(-1)x$

  $[b]_(s^(-1)) = Lambda [x]_(s^(-1))$
]

== Matrix Properties with SVD
For the next properties, let $A in CC^(m times n)$ and $r <= min(m, n)$ be the number of non-zero singular values

#theorem[
  rank$(A) = r$
]
#proof[
  The rank of a diagonal matrix is the number of non-zero entries, well, if $A = U Sigma V^*$, we know $U$ and $V$ are full-rank, then the rank of A must be the same as $Sigma$, that is, $r$
]

#theorem[
  $C(A) = "span"{u_1, ..., u_r}$, $C(A^*) = "span"{v_1, ... v_r}, N(A) = "span"{v_(r+1), ..., v_n}, N(A^*) = "span"{u_(r+1),...,u_m}$
]
#proof[
  Let's remember how each matrix is structured:

  #align(center)[
    $A = mat(|,,|;u_1,...,u_m;|,,|) mat(sigma_1;,dots.down;,,sigma_r;,,,0;,,,,dots.down) mat(- v_1^* -;dots.v; - v_n^* -)$
  ]

  It's easy to see why $C(A) = "span"{u_1, ..., u_r}$, because the entries of $Sigma$ makes only possible to span the first $r$ columns of $U$.
  
  About $N(A) = "span"{v_(r+1), ..., v_n}$, notice how, if we do $A v_j space r+1 <= j <= n$, the first $r$ lines will turn to 0 (All $v_k$ are orthonormal between them) and, because the diagonal entries after the $r$-th one are 0, then we have $U$ times the 0 matrix

  To see the $A^*$'s properties, let's transpose A

  #align(center)[
    $A^* = mat(|,,|;v_1,...,v_n;|,,|) mat(sigma_1;,dots.down;,,sigma_r;,,,0;,,,,dots.down) mat(- u_1^* -;dots.v; - u_m^* -)$
  ]

  So, again, is easy to see $C(A^*) = "span"{v_1, ... v_r}$ and, using the same argument shown before, $N(A^*) = "span"{u_(r+1),...,u_m}$ 
]

#theorem[
  $||A||_2 = sigma_1$ and $||A||_F = sqrt(sigma_1^2 + ... + sigma_r^2)$
]
#proof[
  1. $||A||_2 = ||U Sigma V||_2 = ||Sigma||_2$, as we denoted before, from all entries, $sigma_1$ is the greatest, that means $||A||_2 = ||Sigma||_2 = sigma_1$
  2. We know that $||A||_F = sqrt(tr(A^*A)) = sqrt(tr(V Sigma^*U^* U Sigma V^*)) = sqrt(tr(V Sigma^* Sigma V^*))$. We also know that $tr(A) = lambda_1 +...+ lambda_n$ with $lambda_j$ being the eigenvalues of $A$, and w can clearly see that the eigenvalues of $V Sigma^* Sigma V^*$ are $sigma_j^2$, therefore $||A||_F = sqrt(sigma_1^2 + ... + sigma_r^2)$
]

#theorem[
  $sigma_j = sqrt(lambda_j)$ with $sigma_j$ being the singular values of $A$ and $lambda_j$ the eigenvalues of $A^*A$
]
#proof[
  $A^*A = V Sigma^* U^* U Sigma V^* = V Sigma^* Sigma V^*$
]

#theorem[
  if $A = A^*$, then the singular values of $A$ are the absolute values of $A$'s eigenvalues
]
#proof[
  By the Spectral Theorem, we know $A$ has an eigenvalue decomposition

  #align(center)[
    $A = Q Lambda Q^*$
  ]

  We can rewrite it as

  #align(center)[
    $A = Q|Lambda|$sign$(Lambda)Q^*$
  ]

  Where the entries of $|Lambda|$ is $|lambda_j|$ and the entries of sign$(Lambda)$ are sign$(lambda_j)$. We can show that, if $Q$ is unitary, sign$(Lambda)Q$ is unitary, that means $Q|Lambda|$sign$(Lambda)Q^*$ is a SVD of A
]

#theorem[
  For $A in CC^(m times m)$, $|det(A)| = product^m_(i=1)sigma_i$
]
#proof[
  $|det(A)| = |det(U Sigma V^*)| = |det(U) det(Sigma) det(V)| = |det(Sigma)|$
]

= Lecture 6 - Projectors

$P in C^(m times n)$ is said to be a #text(weight: "bold")[Projector] if

$
  P^2 = P
$

also called _idempotent_. You might confuse thinking only on orthogonal projections, that ones we get the vector and project it in a way to make a 90 degree angle in the projected space! But we are talking about *EVERY* projection, including non-orthogonal ones

Imagine we put a light on that vector, it will give a shadow somewhere, but you agree with me we can get that shadow somehow right? Let's see a 2D example

#image("images/Projector.jpg")

As you can see, the dashed vector tells us the direction where the light is projecting the shadow of $v$ onto $P$. We can express this direction as $P v - v$. Is important to remember that, if you're laying on the ground, you won't have a shadow right? Or even better, shadows doesn't have shadows! Translating this on our contexts:

#theorem[
  If $v in C(P)$, then $P v = v$
]
#proof[
  Every $v in C(P)$ can be expressed as $v = P x$ for some $x$, that means $P v = P^2x = P x = v$
]

Notice that, if we apply the projection onto the direction we had early

$
  P(P v - v) = P^2v - P v = P v - P v = 0
$

That means $P v - v in $ null$(P)$. Also notice we can rewrite the direction as

$
  P v - v = (P - I)v = -(I - P)v
$

Look what's even stranger!

$
  (I - P)^2 = I - 2P + P^2 = I - P
$

That mens $I - P$ is also a projector! A projector that projects into the direction of projection of $P$

== Complementary Projectors
If $P$ is a projector, $I - P$ is its complementary projector

#theorem[
  $I - P$ projects onto null$(P)$ and $P$ projects onto null$(I - P)$
]
#proof[
  1. $C(I - P) subset.eq N(P)$ because $v - P v in N(P)$ and $C(I - P) supset.eq N(P)$ because, if $P v = 0$, we can rewrite it as $(I - P)v = v$, that means $N(P) = C(I - P)$
  2. If we rewrite the expression as $P = I - (I - P)$, then, using the same argument as before, we have $C(P) = N(I - P)$
]

#theorem[
  $N(I-P) inter N(P) = {0}$
]
#proof[
  $N(A) inter C(A) = {0} => N(P) inter C(P) = {0} <=> N(P) inter N(I-P) = {0}$
]

That means, if we have a projector $P$ in $CC^(m times m)$, this projector separates $CC^m$ in to spaces $S_1 and S_2$, in a way that $S_1 inter S_2 = {0}$ and $S_1 + S_2 = CC^m$

== Orthogonal Projectors
Finally! The projectors we hear all the time! They project a vector in a space making the direction form a 90 degree with the projection

#image("images/Orthogonal_Projector.jpg")

That means $(P v)^*(v - P v) = 0$

#theorem[
  $P$ is a orthogonal projector $<=>$ $P = P^*$
]<orthogonal-projectors>
#proof[
  1. $arrow.l.double)$ Given $x, y in CC^m$, then $x^*P^*(I - P)y = x^*(P^* - P^*P)y = x^*(P - P^2)y = x^*(P - P)y = 0$
  2. $=>)$ Let ${q_1, ..., q_m}$ be a orthonormal base of $CC^m$ where ${q_1,...,q_n}$ is base of $S_1$ and ${q_(n+1),...,q_m}$ is base of $S_2$. For $j <= n$ we have $P q_j = q_j$ and for $j > n$ we have $P q_j = 0$, let $Q$ be the matrix with columns ${q_1,...,q_m}$ we have: $ Q = mat(|,,|;q_1,...,q_m;|,,|) <=> P Q = mat(|,,|,|;q_1,...,q_n,0,...;|,,|,|;) <=> Q^*P Q = mat(1;,1;,,dots.down;,,,1;,,,,0;,,,,,dots.down)$, wich means we found a SVD decomposition for $P$:

  $
    P = Q Sigma Q^* <=> P^* = Q Sigma^* Q^* = Q Sigma Q^* = P
  $
]

== Orthogonal projection onto a vector
Let's use the same example used previously

#image("images/Orthogonal_Projector.jpg")

Let $q$ be the vector that spans $P$, we know that $P v = alpha q$
$
(v - P v)^*q = 0 = (v - alpha q)^* q = 0
$
Now we look for the $alpha$ that makes this equation valid
$
v^*q-alpha q^*q=0 <=> v^*q = alpha q^*q <=> alpha = (v^*q)/(q^*q)
$
$
P v = alpha q <=> P v = (v^*q)/(q^*q)q <=> P v = (q^*v)/(q^*q)q <=> P v = q (q^*v)/(q^*q) <=> P v = (q q^*)/(q^*q)v => P = (q q^*)/(q^*q)
$

== Projection with orthonormal basis
We saw in @orthogonal-projectors's proof that some singular values of $P$ are $0$, so we could remove those lines of $Sigma$ and reduce it to $I$, also removing the columns and lines of $Q$, getting:
$
  P = accent(Q, \u{0302})accent(Q, \u{0302})^*
$
Let ${q_1,...,q_n}$ be any set of orthonormal vectors in $CC^m$ and let them be the columns of $accent(Q, \u{0302})$, we know that, for any vector $v in CC^m$:
$
  v = r + sum^n_(i=1)q_i q_i^*v
$
What? when we saw that? Calm down, let me recap for you:

#theorem[
  Let ${q_1,...,q_n}$ be any set of orthonormal vectors in $CC^m$, then any $v in CC^m$ can be expressed as
  $
    v = r + sum^n_(i=1)q_i q_i^*v
  $
  With $r$ being another vector in $C^m$ orthogonal to ${q_1, ..., q_n}$ and, $-> n = m => r = 0$ and the set of vectors chosen is a base for $CC^m$
]
#proof[
  You know that, given a base of $CC^m$, any vector can be expressed as a linear combination of those vectors. Imagine the cannon base (With some rotations, this logic can be expanded for other orthonormal bases), you can imagine that, if you project the vector you have onto any vector of the cannon base, you'll obtain a vector that, if you sum with another vector $r$, you'll obtain your original vector again! And we can continue this process until we do it with $n$ vectors of the canon base, obtaining the original $r$ that, if we sum all our projections, we get the original vector again, that is:
  $
    v = r + sum^n_(i=1)q_i q_i^*v
  $
]

Ok, knowing a vector can be expressed like this, we can see that the sum part is the same as doing:
$
accent(Q, \u{0302})accent(Q, \u{0302})^*v
$
That is, $sum^n_(i=1)q_i q_i^*v$ is a projector onto $C(accent(Q, \u{0302}))$

#theorem[
  The complement of an orthogonal projector is also an orthogonal projector
]
#proof[
  1. $(I-accent(Q, \u{0302})accent(Q, \u{0302})^*)^2 = I - 2accent(Q, \u{0302})accent(Q, \u{0302})^* + (accent(Q, \u{0302})accent(Q, \u{0302})^*)^2 = I - 2accent(Q, \u{0302})accent(Q, \u{0302})^* + accent(Q, \u{0302})accent(Q, \u{0302})^* = I - accent(Q, \u{0302})accent(Q, \u{0302})^*$
  2. $(I - accent(Q, \u{0302})accent(Q, \u{0302})^*)^* = I - (accent(Q, \u{0302})accent(Q, \u{0302})^*)^* = I - accent(Q, \u{0302})accent(Q, \u{0302})^*$
]

A special case is the rank-one orthogonal projector, this gets the vector and get the component of a single direction $q$, wich can be written:
$
  P_q = q q^*
$
And its complement is the ($m-1$) rank matrix
$
  P_(tack.t q) = I - q q^*
$
This concept is valid for non-unitary vectors too:
$
  P_a = (a a^*)/(a^* a)
$
$
  P_(tack.t a) = I - (a a^*) / (a^* a)
$
Just to clear the things. If we project a vector $v$ onto a vector $a$, we're restraining $v$ in the direction of the projection, so, if we project onto the complement of $a$, is like, we can express $v$ as a linear combination of $a$ and some other vectors, and then remove the part of $a$ in this linear combination, having only the other vectors expressing a new vector

== Projection on arbitrary basis
Given an arbitrary base ${a_j}$, we let the vectors of this base be the columns of $A$. Given $v$ with $P v = y in$ $C(A)$, that means $y - v tack.t$ $C(A)$, that means $a_j^*(y-v) = 0 space forall j$. We know $y in$ $C(A)$, so let's write it as $A x = y$, then we can rewrite $a_j^*(y-v) = 0 space forall j$ as:
$
A^*(A x - v) = 0 <=> A^*A x - A^*v = 0 <=> A^*A x = A^*v <=> x = (A^*A)^(-1)A^*v
$
$
A x = A(A^*A)^(-1)A^*v <=> y = A(A^*A)^(-1)A^*v
$
$
=> P = A(A^*A)^(-1)A^*
$

= Lecture 7- QR Factorization
The scary one, the part where anyone knows anything! Let's calm down and see everything with patiently.

How does this factorization works? We want to express $A$ as:
$
A = Q R
$

With $Q$ being an orthogonal matrix and $R$ an upper triangular matrix. But why would I want to do such a thing? The main reason is resolving linear systems! Let's get the system $b = A x$, we rewrite it as
$
b = Q R x <=> Q^* b = R x <=> c = R x
$
We have a equivalent system, and this one is a *triangular* system, i.e, a trivial system for us and for a computer to solve!

== The idea of the reduced factorization
Let ${a_j}$ denote the columns of $A in CC^(m times n), space m >= n$. In some applications, we are interested in the columns _spaces_ of $A$, i.e, the sequential spaces spanned by the columns of $A$:

#align(center)[
  span${a_1} subset.eq$ span${a_1, a_2} subset.eq$ span${a_1, a_2, a_3} subset.eq ...$
]

For now, we'll assume $A$ has full-rank $n$. First of all, we want to obtain a set of orthonormal vectors with the following property:

#align(center)[
  span${a_1, ..., a_j} =$ span${q_1, ..., q_j}$ with $j = 1,...,n$
]

Well, I think a good idea for doing this, is vectors such that we could express $a_j$ as a linear combination of ${q_1, ..., q_j}$. So that means:
$
a_1 = r_(11)q_1
$
$
a_2 = r_(12)q_1 + r_(22)q_2
$
$
dots.v
$
$
a_n = r_(1n)q_1 + r_(2n)q_2 + ... + r_(n n)q_n
$

We could express this equations as a matrix product!

$
mat(|,|,,|;a_1,a_2,...,a_n;|,|,,|) = mat(|,|,,|;q_1,q_2,...,q_n;|,|,,|) mat(r_(11), r_(12), ..., r_(1n);,r_(22),,dots.v;,,dots.down,dots.v;,,,r_(n n))
$

So we have $A = accent(Q, \u{0302})accent(R, \u{0302})$, where $Q in CC^(m times n)$ and $R in CC^(n times n)$

== Full QR Factorization
Goes a bit further. We know ${q_1, ..., q_n}$ is a set of orthonormal vectors of $CC^m$, this means that we have $m-n$ more vectors orthonormal to the ones we had before, so we can create a base for $CC^m$, adding these vectors as columns of $accent(Q, \u{0302})$, we have a orthogonal matrix $Q$. But what do we do for $A$ stay the same? We can simply add lines of 0 bellow $accent(R, \u{0302})$, creating $R in CC^(m times n) space (m >= n)$, obtaining

$
A = Q R
$

== Gram-Schidt Orthogonalization
Oh no... the scary one... Let's go very calmly. We saw previously a way to calculate all $q_j$, let's remember it:
$
a_1 = r_(11)q_1
$
$
a_2 = r_(12)q_1 + r_(22)q_2
$
$
dots.v
$
$
a_n = r_(1n)q_1 + r_(2n)q_2 + ... + r_(n n)q_n
$
Well, this suggests an algorithm for calculating the next $q_j$, let's think, we have all $a_j$, and each $q_j$ needs the vectors ${q_1,...,q_(j-1)}$. Well, we can have some freedom here! Let's see what happens when we try to calculate $q_j$:
$
a_j = r_(1j)q_1 + ... + r_(j j)q_j
$
Let's isolate $q_j$:
$
q_j = (a_j - r_(1j)q_1 - r_(2j)q_2 - ... - r_(2(j-1))q_(j-1))/r_(j j)
$
Well, that suggest us that $r_(j j)$ is the norm of the vector $a_j - sum^(j-1)_(k=1)r_(i j)q_i$, but what is $r_(i j)$? Remember the decomposition on orthogonal factors? Yes, that one, $v = r + sum^n_(i=1)q_i q_i^*v$. If we change $v$ for $a_j$, we have almost the same thing we defined previously!
$
a_j - sum^(j-1)_(k=1)r_(i j)q_i, space v - sum^k_(i=1)q_i q_i^*v
$
And you remember that $r$ is orthogonal to span${q_1,...,q_k}$? That's exactly what $q_j$ is! All this things I just said, suggest I can define $r_(i j)$ as $q_i^*a_j space (i != j)$. And our algorithm is done! Let's recap it all here:

$
q_1 = (a_1)/(||a_1||_2)
$
$
q_2 = (a_2 - q_1q_1^*a_2)/(||a_2 - q_1q_1^*a_2||_2)
$
$
q_3 = (a_3 - q_1q_1^*a_3 - q_2q_2^*a_3)/(||a_3 - q_1q_1^*a_3 - q_2q_2^*a_3||_2)
$
$
dots.v
$
$
q_n = (a_n - sum^(n-1)_(i=1)q_i q_i^*a_n)/(||a_n - sum^(n-1)_(i=1)q_i q_i^*a_n||_2)
$

Writing in an algorithm form:

#pseudocode-list[
  + *for* $j = 1$ *to* $n$
    + $v_j = a_j$
    + *for* $i = 1$ *to* $j-1$
      + $r_(i j) = q_i^*a_j$
      + $v_j = v_j - r_(i j)q_i$
    + $r_(j j) = ||v_j||_2$
    + $q_j = v_j/r_(j j)$
]

== Existence and Uniqueness
#theorem[
  Every $A in CC^(m times n), space (m >= n)$ has a full $Q R$ factorization, hence also a reduced QR factorization
]
#proof[
  If rank$(A) = n$, we can build the reduced factorization using Gram-Schmidt as we did before. The only problem here is if, at some point, $v_j = a_j - sum^(j-1)_(k=1)q_k q_k^*a_j = 0$ thus cannot be normalized. If this happens, that means $A$ hasn't full-rank, that means I can choose whatever orthogonal vector I want to continue the process.
]

#theorem[
  Each $A in CC^(m times n) space (m >= n))$ of full rank has a unique reduced $Q R$ factorization $A = accent(Q, \u{0302})accent(R, \u{0302})$ with $r_(j j) > 0$
]
#proof[
  We know that, if $A$ is full rank $=> r_(j j) != 0$ and thus at each successive step $j$ the formulas shown previously determine $r_(i j)$ and $q_j$ fully, the only problem is the signal of $r_(j j)$, once we say $r_(j j) > 0$, this problem is solved
]

= Lecture 8 - Gram-Schmidt Orthogonalization
We can describe the Gram-Schmidt algorithm using projectors, but why would we want this? Actually this is an introduction for another algorithm we'll see later. When we talk about algorithms, we want them to be stable, in a sense that if we put an input into the computer, it will return me an answer next to the right one (Computers won't solve continuous problems exactly), and the Gram-Schmidt process isn't stable (We'll talk about it on next lectures)

Remember I told you that, if you have a vector $v$ and decompose it as
$
v = r + sum^(n)_(k=1)q_k q_k^* v
$
The part $sum^(n)_(k=1)q_k q_k^*$ is a projector that project onto the matrix $accent(Q, \u{0302})accent(Q, \u{0302})^*$ ($accent(Q, \u{0302})$ has columns ${q_1, ..., q_n}$)? Well, it turns out that we can express the Gram-Schmidt algorithm steps the same way! Let's remember. At the $j$-th step, we have:
$
q_j = (a_j - sum^(j-1)_(i=1)q_i q_i^* a_j)/(||a_j - sum^(j-1)_(i=1)q_i q_i^* a_j||_2)
$
That means we can rewrite this as
$
q_j = ((I - accent(Q, \u{0302})_(j-1) accent(Q, \u{0302})_(j-1)^*)a_j)/(||(I - accent(Q, \u{0302})_(j-1) accent(Q, \u{0302})_(j-1)^*)a_j||_2)
$
Where $accent(Q, \u{0302})_(j-1) = mat(|,,|;q_1,,q_(j-1);|,,|)$. Let's define, for simplification, the projector $P_j$ as:
$
  P_j = I - accent(Q, \u{0302})_(j-1) accent(Q, \u{0302})_(j-1)^*
$

== Modified Gram-Schmidt Algorithm
Using the definitions before, let's rewrite the Gram-Schmidt Algorithm.

For each value of $j$, the original Gram-Schmidt algorithm computes a single orthogonal projection of rank $m - (j - 1)$. I'm just translating to language using projectors, it does this:
$
v_j = P_j a_j = (I - accent(Q, \u{0302})_(j-1) accent(Q, \u{0302})_(j-1)^*)a_j
$
If you go back to what I said early, you get the original formula, I'm just changing that bunch of sums and vectors for a matrix product. The original algorithm makes this computation using a single projector, but the one we'll see does this by a sequence of $j-1$ projectors of rank $m - 1$. By the definition of $P_j$ we can state that:

#theorem[
$
P_j = P_(perp q_(j-1))...P_(perp q_2)P_(perp q_1)
$
]
#proof[
  Remember that $P_(perp q_k) = I - q_k q_k^*$, and what does it do? It projects a vector $v$ onto the subspace orthogonal to ${q_1,...,q_(k-1)}$, that is, removing the components ${q_1, ..., q_(k-1)}$ of $v$. The projector $P_j$ does the exact same thing right? So, you can think that, if I project onto the complement of $q_1$, then onto the complement of $q_2$ and so on, at the $j$-th step, I'll have a vector that is orthogonal to the previous ones, that means, I remove all the previous components, leaving the projected vector as a linear combination of ${q_k, ...}$
]

Okay! If we define $P_1 = I$ we can rewrite $v_j = P_j a_j$ as:

$
  v_j = P_(perp q_(j-1))...P_(perp q_2)P_(perp q_1)a_j
$

The new modified algorithm is based on this new equation. We can get the same result stated on the previous version of the algorithm as:

$
  v_j^((1)) = a_j
$
$
  v_j^((2)) = P_(perp q_1)v_j^((1))
$
$
  v_j^((3)) = P_(perp q_2)v_j^((2))
$
$
  v_j = v_j^((j)) = P_(perp q_(j-1))v_j^((j-1))
$

We can rewrite it in form of pseudo-code:

#pseudocode-list[
  + *for* $i = 1$ *to* $n$
    + $v_i = a_i$
  + *for* $i = 1$ *to* $n$
    + $r_(i i) = ||v_i||$
    + $q_i = v_i / r_(i i)$
    + *for* $j = i + 1$ *to* $n$
      + $r_(i j) = q_i^* v_j$
      + $v_j = v_j - r_(i j)q_i$
]

== Gram-Schmidt as Triangular Orthogonalization
We can interpret each step of the Gram-Schmidt algorithm as a right-multiplication by a square upper-triangular matrix. Wait, what? Why? Get the $R$ matrix:
$
mat(
  r_11, r_12, ..., r_(1n);
  , r_22, , dots.v;
  ,,dots.down,dots.v;
  ,,,r_(n n)
)
$

You can separate it as:
$
mat(
  r_11, r_12, ..., r_(1n);
  , 1, , dots.v;
  , , dots.down, dots.v;
  , , , 1
)
mat(
  1, 0, ..., 0;
  , r_22, , dots.v;
  , , dots.down, dots.v;
  , , , 1
)...
$

So, we can easily see that, for the $j$-th matrix, the inverse of it is:

$
mat(
  dots.down,;
  , 1;
  , ,r_(j j), r_(j (j+1)),...;
  ,,,dots.down;
)^(-1)
=
mat(
  dots.down,;
  , 1;
  , ,1/r_(j j), -r_(j (j+1))/r_(j j),...;
  ,,,dots.down;
)
$

That means we can understand the Gram-Schmidt algorithm as a orthogonalization by triangular matrices

$
A R_1R_2...R_n = accent(Q, \u{0302})
$
$
R_1R_2...R_n = R^(-1)
$

= Lecture 10 - Householder Triangularization
NOOOOO, HOUSEHOLDER NOOOOOO! Wait wait wait, let's get into it step-by-step! We saw on the last chapter, that the Gram-Schmidt algorithm can be written as a series of upper triangular matrices multiplication, right? Well, the householder triangularization's algorithm is really similar, but as the name suggests, instead of getting an orthogonal matrix at the end, we end up having an upper triangular matrix
$
Q_1Q_2...Q_n A = R
$
Is easy to see that $Q_n^*...Q_2^*Q_1^*$ is a unitary matrix, that means $A = Q_n^*...Q_2^*Q_1^*R$ is a full $Q R$ factorization of $A$

== Triangularizing by Introducing Zeros
At the heart of the Householder algorithm, we have an idea of applying an orthogonal matrix that introduces zeros bellow the main diagonal! Like this (In this example, $x$ means a non-zero entry, *$x$* means a entry that has changed since the last orthogonal application and nothing means 0)

$
mat(
  x, x, x;
  x, x, x;
  x, x, x;
  x, x, x;
  x, x, x;
)_A
-> Q_1 A ->
mat(
  bold(x), bold(x), bold(x);
  , bold(x), bold(x);
  , bold(x), bold(x);
  , bold(x), bold(x);
  , bold(x), bold(x);
)_(Q_1 A)
-> Q_2 Q_1 A ->
mat(
  x, x, x;
  , bold(x), bold(x);
  , , bold(x);
  , , bold(x);
  , , bold(x);
)_(Q_2 Q_1 A)
-> Q_3Q_2Q_1 A ->
mat(
  x, x, x;
  , x, x;
  , , bold(x);
  , , ;
  , , ;
)_(Q_3 Q_2 Q_1 A)
$

== Householder Reflectors
Ok, we understood how the algorithm will work, but what kind of matrices can do such a thing? This is when the *Householder reflectors* enters the scene! Each $Q_k$ will have this structure:
$
Q_k = mat(I,0;0,F)
$
Where $I$ is the identity matrix of size $k-1 times k-1$ and $F$ is an $m-k+1 times m-k+1$ unitary matrix. But why this structure, where did we see that? Well, remember that, as we saw earlier, when we multiply $Q_(k-1)...Q_1 A$ by $Q_k$, we want to maintain the lines $1$ to $k-1$ untouched, so, for doing that, we make a $k-1 times k-1$ block matrix of the identity to make this lines be untouched.

And why $F$ is a unitary matrix? Well, we know that, because of the zeros bellow $I$ and above $F$, the columns of $F$ will be orthogonal to the columns of $I$ independently of what I put there, but we want $Q_k$ to be orthogonal, so, if the columns of $I$ are already orthonormal, we just need the columns of $F$ to be orthonormal too, that is, $F$ to be orthogonal.

Ok, but now the most difficult part, we need that, when we multiply by $F$, it will introduce zeros bellow the $k$-th diagonal's entry and still be orthogonal. Let's make $F$ be in $CC^(m - k + 1 times m - k +1)$ and affect vectors of $CC^(m - k + 1)$ (We can see the lines bellow the $k$-th entries of vectors of this space), so we want the vectors' first entry to different then 0 and the rest be 0, knowing that orthogonal matrices are rotations in a space, we can make $F$ do this:

$
x = mat(x;x;x;dots.v;x) -> F x = mat(||x||;0;0;dots.v;0) = ||x||e_1
$

As shown in this figure:
#image("images/Householder_Reflector.jpg")

Notice that, projecting $v$ to get $||v||e_1$ won't give me a orthogonal projection, but I can project it on the blue line, that is the bisector of the angle between $v$ and $||v||e_1$. This bisector forms a 90 degree angle with $||v||e_1 - v$. This is a 2D plane, so it is the bisector of the angle, but in a greater dimension space, it will be a hyperplane that is orthogonal to $||v||e_1 - v$. Let's define $w = ||v||e_1 - v$, so , if $H$ is the hyperplane orthogonal to $w$, we can project $v$ onto $H$ doing:

$
  P v = I - (w w^*)/(w^* w)v
$

But, as we can see, if we project $v$ onto $H$, to get to $||v||e_1$, we need to go twite the distance we just went, so, the final equation for the Householder reflector is:

$
  F = I - 2(w w^*)/(w^* w)
$

== The Better of Two Reflectors
Actually, we can have lots of Householder reflectors, for example in the complex case, we can project $v$ onto any vector $z||v||e_1$ with $|z|=1$. In the real case, we have two alternatives:

#image("images/Householder_Reflector_2.jpg")

So what should I pick? What vector is better for my algorithm? Everyone will be the same thing? Actually there is a best option you can pick! Mathematically, all of them is the same thing, but for numerical stability (Insensitivity for rounding errors), we'll pick the $z||v||e_1$ that is not too close to $v$, to achieve this, we'll project it onto $-"sign"(v_1)||v||e_1$ where $v_1$ is the first entry of $v$, that means:

$
w = -"sign"(v_1)||v||e_1 - v or w = "sign"(v_1)||v||e_1 + v
$

And we can define that:

$
"sign"(0) = 1
$

Just to clarify why we made this choice, imagine the angle between $v$ and $||v||e_1$ is REALLY SMALL, this means that, when we do $||v||e_1 - v$, we are subtracting nearby quantities, depending on what quantities, this could lend us to imprecise calculations, lending to big errors

== The Algorithm
Now we can rewrite it as an algorithm, but before that:

#definition[
  Given the matrix $A$, $A_(i:i', j:j')$ is the $(i' - i + 1) times (j' - j + 1)$ submatrix of $A$ with the upper left corner element equal to $(A)_(i j)$ and the lower right corner element equal to $(A)_(i' j')$. If the submatrix is a line or column vector we can write it as $A_(i,j:j')$ or $A_(i:i',j)$
]

Given this definition, let's rewrite the algorithm

#pseudocode-list[
  + *for* $k = 1$ *to* $n$
    + $x = A_(k:m,k)$
    + $v_k = "sign"(x_1)||x||e_1 + x$
    + $v_k = v_k / (||v_k||)$
    + $A_(k:m,k:n) = A_(k:m,k:n) - 2v_k (v_k^*A_(k:m,k:n))$
]

== Applying on forming Q
Notice that we didn't build the whole matrix $Q$ on the algorithm, we just applied:
$
Q^* = Q_n...Q_1 <=> Q = Q_1...Q_n
$
(There's no missing asterisks, because each $Q_j$ is hermitian!)

We do this because build $Q$ requires extra work, so we work directly with $Q_j$. For example, remember we can rewrite $b = A x$ as $Q^*b = R x$? Well, we can do this as in the previous algorithm:

#pseudocode-list[
  + *for* $k=1$ *to* $n$
    + $b_(k:m) = b_(k:m) - 2 v_k (v^*_k b_(k:m))$
]

Notice we did the same process as we did with $A$, I just didn't explicit the parts where I defined $v_k$ and normalized it.

= Lecture 11 - Least Squares problems
What is the problem we are trying to look here? Well, we have a set of $m$ equations with $n$ variables, and we have more equations then variables $(m >= n)$, and we want to find a solution to this system! But you agree with me, if we make the $Q R$ factorization of $A$, most of this equations will have no solution right? Because the entries bellow the $n$-th line of $R$ will be equal to $0$, so for the vector $Q^*b$ to have all entries equal to zero bellow the $n$-th line, just some specific choices of $b$ will satisfy this!
$
A = Q R => A x = b <=> R x = Q^* b
$
So what can we do to this system? Ignore it? Well, not at all! We know $b$ will have a solution only if it lies in $C(A)$, that means, if $b in.not C(A)$, we have:
$
  b - A x = r space (r != 0)
$
So we could find a way that $r$ is the lowest as possible, so our new goal is to *minimize* $b - A x$. To measure how small $r$ is, we can choose any norm, but the 2-norm is a good choice, and have some good properties to work with.

#align(center)[
  Given $A in CC^(m times n)$, $m >= n$ and $b in CC^m$

  find $x in CC^n$ such that $||b - A x||_2$ is minimized
]

So how do we solve it? Is there a fixed way to solve this problem? What do we do? Actually, there is a fixed way for resolving it, and it circles around *orthogonal projection*

== Orthogonal Projections and the Normal Equations
It makes sense that the solution is obtained by a projection of $b$ in $C(A)$, but what kind of projection? You can imagine a $3$D plane, if you visualize $A$ as a plane, it makes sense that the $A x$ that makes $||b - A x||_2$, look to the picture at the next page:

#image("images/Projection_Min_Squared.jpg", width: 14cm)

Ok, it looks right, and we can think that intuitively, but is it mathematical right?

#theorem[
  Let $A in CC^(m times n) space (m >= n)$, $b in CC^m$.
  #align(center)[
    $x$ minimizes $||b - A x||_2 <=> b - A x perp C(A)$
  ]
]
#proof[
  First, define as $P$ an orthogonal projector that projects onto $C(A)$ and $c = P b$

  Well, we know that $c perp b - A x$ (See the previous picture), then, because $c$ is in $C(A)$, we can express $c = A y$ for some $y in CC^n != 0$. Let's write all down:
  $
    c^*(b - A x) = 0 <=> y^*A^*(b - A x) = 0
  $
  We know that $y != 0$, that means $A^*(b - A x) = 0$
  $
    A^*(b - A x) = 0 <=> A^*b - A^*A x = 0 <=> A^*b = A^*A x
  $
  We want $x$ that satisfies this equation, if $A^*A$ is invertible, then
  $
    x = (A^*A)^(-1)A^* b
  $
  And notice that if we apply $A$ on $x$, it gives me the exact formula of the orthogonal projection of $b$ onto $A$:
  $
    A x = A(A^*A)^(-1)A^*b
  $
]

The equation $A^*b = A^*A x$ is known as "normal equation", and using it, we can get some different algorithms to compute the least square solution!

=== Standart
If $A$ has full rank, this means $A^*A$ is a square, hermitian and positive definite system of equations with dimension $n$. So we can make the Cholesky's Factorization of $A^*A$, obtaining $R^*R$ where $R$ is upper triangular, then we can make the reduction:
$
  A^*b = A^*A x <=> A^* b = R^*R x
$
Then we can make the algorithm:
1. Form the matrix $A^*A$ and $A^*b$
2. Compute the Cholesky Factorization of $A^*A$, $R^*R$
3. Solve the lower triangular system $R^* w = A^* b$ for $w$
4. Solve the upper triangular system $R x = w$ for $x$

=== $Q R$ Factorization
A "modern" method uses the reduced $Q R$ factorization. Using the Householder's algorithm, we compute $A = accent(Q, \u{0302}) accent(R, \u{0302})$ (Remember that $accent(R, \u{0302})$ is squared and $accent(Q, \u{0302})$ is $m times n$). We can then rewrite the orthogonal projector $P = (A^*A)^(-1)A$ as $P = accent(Q, \u{0302})accent(Q, \u{0302})^*$, because $C(A) = C(Q)$.
$
  accent(Q, \u{0302}) accent(R, \u{0302}) x = accent(Q, \u{0302}) accent(Q, \u{0302})^* b <=> accent(R, \u{0302}) x = accent(Q, \u{0302})^* b
$
And if $R$ has inverse, we can multiply it by $R^(-1)$ and have $A^+ = accent(R, \u{0302}) accent(Q, \u{0302})^*$
1. Compute the reduced $Q R$ factorization $A = accent(Q, \u{0302}) accent(R, \u{0302})$
2. Compute the vector $accent(Q, \u{0302})^*b$
3. Solve the upper-triangular system $accent(R, \u{0302}) x = accent(Q, \u{0302})^* b$ for $x$

=== S.V.D
If we get $A = accent(U, \u{0302}) accent(Sigma, \u{0302}) V^*$ (Reduced S.V.D factorization), we can rewrite $P$ as $P = accent(U, \u{0302})accent(U, \u{0302})^*$, because $accent(U, \u{0302})$ is rectangular with orthonormal columns and $C(A) = C(accent(U, \u{0302}))$, so project orthogonally onto $C(A)$ is the same as project orthogonally onto $C(accent(U, \u{0302}))$, analogues of the $Q R$ method, we have:
$
  accent(U, \u{0302}) accent(Sigma, \u{0302}) V^* x = accent(U, \u{0302})accent(U, \u{0302})^* b <=> accent(Sigma, \u{0302}) V^* x = accent(U, \u{0302})^* b
$
Look that we can get a new formula for $A^+$, that is $A^+ = V accent(Sigma, \u{0302})^(-1) accent(U, \u{0302})^*$
1. Compute the reduced S.V.D $A = accent(U, \u{0302}) accent(Sigma, \u{0302}) V^*$
2. Compute the vector $accent(U, \u{0302})^* b$
3. Solve the diagonal system $accent(Sigma, \u{0302})w = accent(U, \u{0302})^* b$ for $w$
4. Set $x = V w$

= Lecture 12 - Conditioning and Condition Numbers
This is the part where the things start get confusing, so we'll need to get through it very calmly!

== Condition of a Problem
First of all, what is a problem?

#definition[
  A _problem_ $f: X -> Y$ is a function from a normed vector space $X$ of *data* to a normed vector $Y$ of *solutions*
]

Why did I define a problem like that? Because throughout the next lectures, we want to identify and measure what happens when I give a slightly different data to this problem, given that I have a certain data and pass it to the problem and it gives me a solution, the solution differs a lot? Just a bit? Is the same solution?

#definition[
  A *well-conditioned* problem is one that all small perturbations of $x in X$ gives small differences on $f(x) in Y$, that means if we make perturbations in $x$, the solutions of the problem won't change so much
]

#definition[
  A *ill-conditioned* problem is one that a small perturbation of $x in X$ give me a large difference in the solutions $f(x) in Y$, that is, changing the data, even if just slightly, will give me completely different answers to the problem
]

The meaning of *small* and *large* depends on what context I'm looking. And how can I measure this type of changes? How do I quantify those "*small*" and "*large*" changes? I'll define it here and show to you how we could visualize it

#definition("Absolute Condition Number")[
  Let $Delta x$ denote a small perturbation of $x$ and write $Delta f = f(x + Delta x) - f(x)$. The *absolute condition number* of the problem $f$ is defined as
  $
    accent(kappa, \u{0302}) = lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||Delta f||)/(||Delta x||))
  $

  For better understanding, we can rewrite it as $accent(kappa, \u{0302}) = sup_(Delta x)(||Delta f||)/(||Delta x||)$, that is, the supreme over all infinitesimal perturbations on $x$ (Understanding that $Delta x$ and $Delta f$ are infinitesimal)
]

Dude, I didn't understand ANYTHING! Hold on, let's try to draw it here:

#align(center)[
  #image("images/Problem.jpg", width: 14cm)
]

First, I have the normed spaces $X$ and $Y$ and how the problem $f$ applies a transformation on $x$. Then, let's make just a tiny little adjustment on $x$, having $Delta x$, this new vector is a infinitesimal perturbation on $x$, almost the same thing, now let's have a look on how $f$ affects $Delta x$:

#align(center)[
  #image("images/Condition-Problem.jpg", width: 14cm)
]

JESUS, notice how a slightly perturbation on $x$ changed the solution A LOT? That means this is a _ill-conditioned_ problem, and the *larger* of this perturbations is the *absolute condition number* of $f$

We are talking about problems in *normed* spaces, therefore, in its heart, we could say problems are functions of subspaces of $CC^m$ to $CC^n$, that means if a problem $f$ is _differentiable_ (It is a function, so it could or couldn't be differentiable), it has a _Jacobian_. There is a statement that says, _"If $f: X -> Y$ is differentiable, then $f(x + Delta x) approx f(x) + J(x)Delta x$ when $Delta x -> 0$"_, well, we are working with $Delta x -> 0$, so what happens if we substitute $f(x + Delta x)$ for $f(x) + J(x)Delta x$:

$
  accent(kappa, \u{0302}) = lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||Delta f||)/(||Delta x||)) = lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||f(x + Delta x) - f(x)||)/(||Delta x||)) = lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||f(x) + J(x) Delta x - f(x)||)/(||Delta x||))
$
$
lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||J(x) Delta x||)/(||Delta x||)) <= lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||J(x)|| ||Delta x||)/(||Delta x||)) = ||J(x)||
$

That means the supreme value over all infinitesimal variations of $x$ will be $||J(x)||$, that means

$
  accent(kappa, \u{0302}) = ||J(x)||
$

#definition("Relative Condition Number")[
  Let $Delta x$ denote a small perturbation of $x$ and write $Delta f = f(x + Delta x) - f(x)$. The *relative condition number* of the problem $f$ is defined as

  $
    kappa = lim_(Delta -> 0) sup_(||Delta x|| <= Delta) ((||Delta f(x)||)/(||f(x)||)) / ((||Delta x||)/(||x||))
  $
]<relative_condition_number>

Why we defined a "relative" condition number? Because I'm trying to measure it relatively.

Wow! You just repeated yourself... Hold on. Imagine that an engineer is making a 1000m rocket, and he measures an error of 1m, it is a little mistake right? But what if the rocket measures 2m? Is a COLOSSAL error right? That's the point, we are trying to measure the error caused by $Delta x$ based on the size of $x$ and its solution $f(x)$

Well, remember we could represent the absolute condition number as
$
accent(kappa, \u{0302}) = ||J(x)||
$

we can do something similar with $kappa$, let's see:

$
kappa = lim_(Delta -> 0) sup_(||Delta x|| <= Delta) ((||Delta f(x)||)/(||f(x)||)) / ((||Delta x||)/(||x||)) = lim_(Delta -> 0) sup_(||Delta x|| <= Delta) (||Delta f(x)||)/(||f(x)||) (||x||)/(||Delta x||) = lim_(Delta -> 0) sup_(||Delta x|| <= Delta) (||Delta f(x)||)/(||Delta x||) (||x||)/(||f(x)||) = ||J(x)||(||x||)/(||f(x)||)
$

== Conditioning Matrices and Vectors
Now, an important concept for stability and conditioning is how vector multiplication and matrices are conditioned, vector multiplications are _well-conditioned_? _ill-conditioned_? How matrices are conditioned? Let's see

=== Condition of Matrix-Vector Multiplication

#theorem[
  Given $A in CC^(m times n)$ fixed, the problem of calculating $A x$ with $x$ in the normed space of data, the condition problem of the matrix is

  $
    kappa = ||A|| (||x||)/(||A x||)
  $

  If $A$ is squared and invertible:

  $
    kappa <= ||A|| ||A^(-1)||
  $
]<condition_number_matrix_vector_multiplication>
#proof[
  Fix $A in CC^(m times n)$ and the problem of calculating $A x$, with $x$ being the data, that is, we'll calculate the condition of this problem based on perturbations of $x$, not $A$, $A$ will be fixed the entire time.
  $
    kappa = sup_(Delta x)((||f(x + Delta x) - f(x)||)/(||f(x)||) (||x||)/(||Delta x||)) = sup_(Delta x)((||A(x + Delta x) - A x||)/(||A x||) (||x||)/(||Delta x||)) = sup_(Delta x)((||A Delta x||)/(||A x||) (||x||)/(||Delta x||))
  $
  $
    kappa <= sup_(Delta x)((||A|| ||Delta x||)/(||A x||) (||x||)/(||Delta x||)) = ||A||(||x||)/(||A x||)
  $

  If $A$ is squared and invertible, we can use the fact that $(||x||)/(||A x||) <= ||A^(-1)||$ (We'll prove it later), to express $kappa$ as:

  $
    kappa <= ||A|| ||A^(-1)|| or kappa = alpha ||A|| ||A^(-1)||
  $
]

#corollary[
  Let $A in CC^(m times n)$ be non-singular and consider the equation $A x = b$. The problem of computing $b$ given $x$ has condition number
  $
    kappa = ||A||(||x||)/(||b||)
  $
]

#theorem[
  $
    (||x||)/(||A x||) <= ||A^(-1)||
  $
]
#proof[
  Write $x$ as $x = A^(-1)(A x)$, that means
  $
    ||x|| = ||A^(-1) A x|| <= ||A^(-1)|| ||A x|| <=> (||x||)/(||A x||) <= ||A^(-1)||
  $
]

=== Condition Number of a Matrix
What? Why can we give a condition number to a matrix? Because they are *functions*! Why? Remember we can represent every *linear transformation* as a *matrix multiplication*? This implies, if a matrix $A$ is in $CC^(m times n)$, then it could be represented as $A: CC^n -> CC^m$! Now we understood why they can have a condition number, let's define it

#definition[
  Given $A in CC^(m times m)$ non-singular, the condition number of $A$, denoted as $kappa(A)$ is:
  $
    kappa(A) = ||A|| ||A^(-1)||
  $
  If $A$ is singular
  $
    kappa(A) = infinity
  $
  If $A$ is rectangular
  $
    kappa(A) = ||A|| ||A^(+)||, space (A^(+) = (A^*A)^(-1)A)
  $
]

=== System of Equations' Condition
#theorem[
  Given a system $A x = b$, let us hold $b$ fixed and consider the problem $A  |-> x = A^(-1)b$, the condition number of this problem is:
  $
    kappa(A)
  $
]
#proof[
  If we perturb $A$ and $x$, we do:
  $
    (A + Delta A)(x + Delta x) = b
  $
  $
    <=> A x + A (Delta x) + (Delta A) x + (Delta A)(Delta x) = b
  $
  $
    <=> b + A (Delta x) + (Delta A) x + (Delta A)(Delta x) = b
  $
  $
    <=> A (Delta x) + (Delta A) x + (Delta A)(Delta x) = 0
  $

  We know that $(Delta A)(Delta x)$ is doubly infinitesimal and both are going to 0, so we can discard it, and we obtain

  $
    A (Delta x) + (Delta A)x = 0 <=> Delta x = -A^(-1)(Delta A)x
  $
  This equation implies that
  $
    ||Delta x|| <= ||A^(-1)|| ||Delta A|| ||x|| <=> ||Delta x|| ||A|| <= ||A^(-1)|| ||A|| ||Delta A|| ||x||
  $
  $
    (||Delta x||)/(||x||) (||A||)/(||Delta A||) <= ||A^(-1)|| ||A||
  $

  If we make $Delta x -> 0$ and $Delta A -> 0$, we have
  $
    kappa = ||A|| ||A^(-1)|| = kappa(A)
  $
]

= Lecture 13 - Floating Point Arithmetic
When we are looking into algorithms and computers, we have a *really* big problem. Computers are discrete machines, that means, when we are talking about real numbers, they can't represent *all* of them, there is a finite amount of numbers they can represent depending on how these computers are built. Most of computers use a binary system to represent real numbers, but they could use other systems. There are two big problems on the representation of real numbers:
1. *Underflow & Overflow*: As I said, a computer can represent a finite number of real numbers, that means there is a maximum and a minimum in this set. If I try to represent a number bigger than this maximum, I'll have an *overflow* error, therefore, trying to represent a smaller number, I'll have an *underflow* error. Now days this isn't a really big problem, most of computers are capable of storing really large and tiny numbers, sufficient for the problems we're going to work with
2. *Gap*: When we try to represent real numbers, there is a problem, because between two real numbers, there are infinite other real numbers, that lead us to the *gap* problem, because, if the set of numbers the computer can represent finite, we can count them, if we can count them, we can get an infinity of other real numbers between them. The *gap* problem isn't a really a *PROBLEM*, but when we are making algorithms, we want them to pre as precise as possible, because a unstable algorithm can lead us to large rounding errors

== Floating Point Set
The set of numbers a computer can understand and represent is called a *Floating Point set*. The book gives us a really hard definition, so I'll give you a simpler one and, later, understand the definition of the book:

#definition("Simple definition")[
  A *Floating Point Set* is defined as:
  $
    F = {plus.minus 0,d_1d_2...d_t*beta^e \/ e in ZZ}
  $
  Where $0,d_1...d_t$ is the *mantissa*, $t in NN^*$ is the mantissa's *precision*, $beta in NN (beta >= 2)$ is the base, $d_j (0 <= d_j < beta)$ are the mantissa's digits and $e in ZZ$ is the *exponent*. In computers, *we* define a range for $t$, $e$ and a specific base $beta$
]

Let's go through everything. First of all, we defined everything, but what and why I defined those things?

=== Mantissa
Is the core of a number, a number in this set has only one mantissa, but a mantissa can be attached at various numbers, for example, we could represent $1$ in the decimal system, as $0,1*10$ and we can represent 10 as $0,1*10^2$, that means the same mantissa can represent a lot of numbers. It's important to say that the mantissa is always wrote in base $beta$, we'll see what this means now

=== Base and Precision
#definition[
  If we have $x in RR$, write $x$ in base $beta$ means choose coefficients $..., alpha_(-1), alpha_0, alpha_1, ...$ with $0 <= alpha_j < beta$ and $alpha_j$ are integers such that:
  $
    x = ... + alpha_2 beta^(2) + alpha_2 beta^1 + alpha_0 beta^0 + alpha_(-1) beta^(-1) + alpha_(-2) beta^(-2) + ...
  $
  Then we write $x$ in base $beta$ as $...alpha_(2)alpha_1alpha_0,alpha_(-1)alpha_(-2)..._beta$, where each $alpha_j$ is a digit
]

This is a way of representing every single real number, but the computer is limited to a certain amount of $alpha_j$, he can't store like 1 billion $alpha_j$, there's where the precision enters, it tells the computer how many digits the mantissa is able to represent!

Wait... but we saw the mantissa only stores numbers after the _","_, so how do the set represents numbers grater then 1? That's where the *exponent* enters

=== Exponent
The exponent tells the order of our number, for example, with a mantissa $0,d_1d_2d_3$, we can represent 4 different numbers: $0,d_1d_2d_3$, $d_1,d_2d_3$, $d_1d_2,d_3$, $d_1d_2d_3$, they have exponent $0, 1, 2$ and $3$ respectively. But, if I have a mantissa $0,d_1...d_t$, why multiplying it by $beta^e$ moves the comma by $e$ digits? (Just to do a parallel, that is exactly how our decimal system works, if you have $0,1$, multiply it by 10 gives you $1$)

#theorem[
  If you have $x$ written in base $beta$, multiply it by $beta^e$ will move the comma, in base $beta$ notation, $e$ digits to the right
]
#proof[
  $
    x = ... + alpha_2 beta^(2) + alpha_1 beta^1 + alpha_0 beta^0 + alpha_(-1) beta^(-1) + alpha_(-2) beta^(-2) + ...
  $
  $
    <=> beta^e x = (... + alpha_2 beta^(2) + alpha_1 beta^1 + alpha_0 beta^0 + alpha_(-1) beta^(-1) + alpha_(-2) beta^(-2) + ...) beta^e
  $
  $
    <=> beta^e x = ... + alpha_2 beta^(2) beta^e + alpha_1 beta^1 beta^e + alpha_0 beta^0 beta^e + alpha_(-1) beta^(-1) beta^e + alpha_(-2) beta^(-2) beta^e + ...
  $
  $
    <=> beta^e x = ... + alpha_2 beta^(e+2) + alpha_1 beta^(e+1) + alpha_0 beta^e + alpha_(-1) beta^(e-1) + alpha_(-2) beta^(e-2) + ...
  $
  Notice how all $alpha_j$ moved $e$ digits to the left, that means the comma moves $e$ digits to the right
]

Lets go through an example to understand it better:

#example[
  I created a machine that represents my numbers by a floating point set $F$ with decimal base ($beta = 10$), precision $3$ and $e in [-5, 5]$, answer this questions:
  1. What is the smallest positive number $F$ can represent?

    Well, if $F$ has precision 3, my mantissa is like this:
    $
      0,d_1d_2d_3_beta
    $
    So if we want the minimum, we need to make $d_j$ as tiny as possible but still different from $0$, that means we make the last digit ($d_3$) equal to 1 and the rest equal to $0$, that means the smallest mantissa we can have is:
    $
      0,001
    $
    But we can still represent a larger number using the exponent, the smaller exponent we have is $-5$, that means the smallest positive number this set can represent is
    $
      0,001*10^(-5) = 0,00000001
    $
  
  2. What is the largest positive number $F$ can represent?

    Following the same logic, the largest mantissa we can have is:
    $
      0,999
    $
    Using the largest exponent possible, the largest number our set can represent is:
    $
      0,999 * 10^5 = 99900
    $

  3. Is -3921 in the set?

    Let's test it out, if we decompose it:
    $
      -3921 = -0,3921 * 10^4
    $
    The exponent is in the range $[-5, 5]$, but the mantissa is of precision $4$, that means $-3921$ *IS NOT ON THE SET $F$*

  4. Is 738000000 in the set?

    Decomposing, we have: $738000000 = 0,738 * 10^9$, as we can see, the mantissa has the desired precision, but the exponent is greater than the given range, that means 738000000 *IS NOT ON THE SET $F$*
]

Now that we understood this floating point set definition, let's see the book's definition:

#definition("Book's definition")[
  Being $F subset RR$, we define it as:
  $
    F = {plus.minus (m/(beta^t))beta^e}
  $
  Where $t$, $e$ and $beta$ means the same thing with the same restrictions as the previous definition
]

What is the difference and why the book defines it as this? There is just 1 big difference here: Why is he defining the *mantissa* as $m/(beta^t)$? Remember when we had proven that, if we write $x$ in base $beta$ and multiply $x$ by $beta^e$, the comma moves $e$ digits to the right? The same applies if $e < 0$, but the comma goes to the left, and why am I saying that? Because, what the book doesn't tell us, is that we write $m$ *IN BASE $beta$*, and this division by $beta^t$ makes that we only get the first $t$ digits of the number, meaning we only get the digits we desire to, JUST THIS (Yes, the book explains it poorly)

== Numbers not in $F$
When we try to represent a number that is not in $F$, the computer can do 2 things:
1. *Round*: We get $t+1$ digits of the number, and we check if the $(t+1)$-th digit is greater or equal then $ceil(beta/2)$, if it is, we exclude the $(t+1)$-th digit and sum 1 to the $t$-th digit. If the $(t+1)$-th digit is less then $ceil(beta/2)$, then we just exclude the $(t+1)$-th digit
  #example[
    Round 10324 knowing $F$ has precision $4$ and $e in [-infinity, +infinity]$ and $beta = 10$.

    Converting into the mantissa and exponent notation: $10324 = 0,10324 * 10^5$, we have 5 digits, so lets see the $5$-th one. $4 >= ceil(10/2) <=> 4 >= 5$? No, so the rounded number will be $0,1032*10^5$
  ]
2. *Truncate*: If the number's mantissa pass $t$ digits, we remove all of the digits after the $t$-th one

Knowing that, we can finally understand what is $epsilon_("machine")$ is

== Epsilon Machine
Let's see the first definition of the book, that is:
$
  epsilon_("machine") = 1/2 beta^(1 - t)
$
But what does this mean? Why he defined like that? First of all, $epsilon_("machine")$ is the number that, if we make this operation in $F$, it will be valid
$
  1 + epsilon_("machine") > 1
$
That means, if we sum 1 with a number less then $epsilon_("machine")$, even if by an infinitesimal difference, the number returned will be rounded or truncated to $1$ in $F$. The book says this definition is the distance between 2 representable numbers in $F$, but why is that?

#theorem[
  The distance between 2 representable numbers in $F$ is $beta^(1-t)$
]
#proof[
  If we have $x$ wrote in base $beta$ notation with precision $t$, we write it as:
  $
    x = 0,d_1d_2...d_t_beta
  $
  If we want to increment something in this number, but without making it go out of the possible precision and making the smallest increment possible, we can add $1$ to $d_t$. So let's do it and see what happens, writing $x$:
  $
    x = d_1beta^(-1) + d_2beta^(-2) + ... + d_t beta^(1-t)
  $
  If we sum $1$ to $d_t$:
  $
    alpha = d_1beta^(-1) + d_2beta^(-2) + ... + (d_t+1) beta^(1-t)
  $
  $
    <=> alpha = d_1beta^(-1) + d_2beta^(-2) + ... + d_t beta^(1-t) + beta^(1-t)
  $
  But notice how we can rewrite this as
  $
    alpha = x + beta^(1-t)
  $
  That means $alpha$ (The next representable number), is $x + bold(beta^(1-t))$, that is, the distance between them
]

Now we can visualize it as a line, where we have the representable numbers and, if we try to represent a number that is in the gap of them, the computer will round it based on $epsilon_("machine")$

#align(center)[
  #image("images/Epsilon_Machine.jpg", width: 13.5cm)
]

The cyan blue dots represent real numbers that can't be represented entirely by $F$, and the arrows shows where the computer rounds it. We'll change this definition later, and you'll understand why later.

The book shows us an inequality that every $epsilon_("machine")$ must hold, but that inequality can be rewritten:

#definition[
  Let $F$ be a floating point set. $"fl": RR -> F$ is a function that returns the rounded approximation of the input $x$ in the set $F$
]

#theorem("Floating Point Conversion")[
  $forall x in RR$, there exists $epsilon$ with $|epsilon| <= epsilon_("machine")$ such that:
  $
    "fl"(x) = x(1+epsilon)
  $
]<floating_point_conversion>

What does this mean? It means, whenever I round a real number to fit it in $F$, the rounded number is equivalent to multiply $x$ to $1+$ a very tiny number, you can visualize it looking at the line representation of $F$ I showed before

== Floating Point Arithmetic
We need to make operations with numbers right? But we have the same problem, computers need to round because they can't understand all numbers in an interval, so how can we make the operations as precise as possible? We construct a computer based on this principle (Some computers can have more principles on its core, so some operations can be even preciser, but let's focus only on this one):

#definition("Fundamental Axiom of Floating Point Arithmetic")[
  Given that $+$, $-$, $times$ and $div$ represents operations in $RR$, consider $plus.circle$, $minus.circle$, $times.circle$ and $div.circle$ being operations in $F$. Let $ast.circle$ define any of the previous operations in $F$, then we define a computer that makes the operation $x ast.circle y$ as
  $
    x ast.circle y = "fl"(x ast y) = (x ast y)
  $
  That means we make a computer following that $forall x, y in F$, there exists $epsilon$ with $|epsilon| <= epsilon_("machine")$ such that
  $
    x ast.circle y = (x ast y)(1 + epsilon)
  $
]<fundamental_axiom_of_floating_point_arithmetic>

In other words, every operation on $F$ have an error with size *at most* $epsilon_("machine")$

== More on Epsilon Machine
Now we can redefine $epsilon_("machine")$! But why? Well, we want to make it as low as possible, and sometimes increase the precision is not an option:

#definition[
  $epsilon_"machine"$ is the lowest value such that @floating_point_conversion and @fundamental_axiom_of_floating_point_arithmetic are valid
]

This implies that, for some computers, $epsilon_"machine"$ can be even lower then $1/2 beta^(1-t)$, wich is a *really* good thing!

= Lecture 14 and 15 - Stability
When we're talking about *stability*, we are trying to see if an algorithm has fidelity on the computer! That means, if the roundings the computer make on the inputs and outputs won't change the result to something a lot different from the original. But first, we need to define mathematically what is an algorithm!

#definition[
  Let a problem $f: X -> Y$ and a computer with floating point system that satisfies @fundamental_axiom_of_floating_point_arithmetic be fixed. The algorithm of $f$, $accent(f, ~): X->F^n subset Y$ is a function that represent a series of steps and its implementations on the given computer with the objective of solving the problem $f$

  *Note:* $F^n subset Y$ just represents that I have a vector of numbers that can be represented by $F$ and this vector is in $Y$
]

Well, we know that, if we pass $x in X$ for this algorithm, the result $accent(f, ~)(x)$ can be affected by rounding errors! In most cases, $accent(f, ~)$ is not a continuous function, but the algorithm needs to approximate $f(x)$ as good as possible.

Let's make a definition for a *stable* algorithm too! First, let's define the *precision* of an algorithm

#definition("Algorithm's Precision")[
  An algorithm $accent(f, ~)$ is precise if:
  $
    (||accent(f, ~)(x) - f(x)||)/(||f(x)||) = O(epsilon_"machine")
  $
]

WHAT? WTF DOES $O(epsilon_"machine")$ EVEN MEEEEEANS??? Wait wait, I'll make a formal definition later, for now, you can understand that an algorithm is precise if the error between the algorithm's output and the original output doesn't pass $epsilon_"machine"$

In a bad-conditioned algorithms, the equality shown on the definition is too ambitious, because rounding errors are inevitable, in this kind of algorithms this rounding could cause big errors, overpassing the desired errors we wanted

Now we can define a *stable* algorithm

#definition("Stable Algorithm")[
  An algorithm $accent(f, ~)$ for a problem $f$ is stable if
  $
    forall x "is valid that" (||accent(f, ~)(x) - f(accent(x, ~))||)/(||f(accent(x, ~))||) = O(epsilon_"machine")
  $
  $
    "for a" accent(x, ~) "with" (||accent(x, ~) - x||)/(||x||) = O(epsilon_"machine")
  $
]<stable_algorithm>

Wait what? What does this definition means?

It means that, all similar data to my original data passed for my algorithm will return outputs very similar to the right solutions (This is shown with $epsilon_"machine"$, that is, the difference between the solutions given by the algorithm and the real solutions won't surpass $epsilon_"machine"$)

There is another type of *stability*, very powerful:

#definition("Backwards Stability")[
  An algorithm $accent(f, ~)$ for $f$ is *backwards stable* if:
  $
    forall x in X "is valid that" exists accent(x, ~) "with" (||accent(x, ~) - x||)/(||x||) = O(epsilon_"machine") "such that" accent(f, ~)(x) = f(accent(x, ~))
  $
]

That means if I pass the data into the algorithm, I can find a really small perturbation $accent(x, ~)$ such that the solution of the problem if I pass this perturbation is the *same* as if I pass the original data into the algorithm!

#example[
  Given the data $x in CC$, check if the algorithm $x plus.circle x$ to compute the problem of summing two equal numbers (Solution is $2 x$) is backwards stable:

  We have that
  $
    f(x) = x + x and accent(f, ~)(x) = x plus.circle x
  $
  That means
  $
    accent(f, ~)(x) = (2 x)(1+epsilon)
  $
  Let's check if this algorithm is *stable*. First, define $accent(x, ~) = x(1+epsilon)$, we know that $epsilon = O(epsilon_"machine")$, let's check if the relative error between $x$ and $accent(x, ~)$ is $O(epsilon_"machine")$:
  $
    (||accent(x, ~) - x||)/(||x||) = (||x(1+epsilon) - x||)/(||x||) = (||x(1+epsilon - 1)||)/(||x||) = |epsilon| = O(epsilon_"machine")
  $
  So $x(1+epsilon)$ is a *valid* definition for $accent(x, ~)$, making this clear, let's check if $accent(f, ~)$ is stable
  $
    (||accent(f, ~)(x) - f(accent(x, ~))||)/(||f(accent(x, ~))||) = (||2 x (1+epsilon) - 2 x (1+epsilon)||)/(||f(accent(x, ~))||) = 0 = O(epsilon_"machine")
  $
  That means $accent(f, ~)$ is stable, but it is *backwards stable*? We need a definition of $accent(x, ~)$ that stills hold the condition of $x$ set in @stable_algorithm. Let's check if our definition holds it, we already checked that the condition is valid, but it holds $f(accent(x, ~)) = accent(f, ~)(x)$?
  $
    accent(f, ~)(x) = 2 x (1 + epsilon)
  $
  $
    f(accent(x, ~)) = 2 x (1 + epsilon)
  $
  That means this algorithm *IS* indeed *backwards stable*
]

== Formal Definition of $O(epsilon_"machine")$
I'll write the definition here and explain what it means right after it

#definition[
  Given the functions $phi(t)$ and $psi(t)$ the sentence
  $
    phi(t) = O(psi(t))
  $
  means that $exists C > 0$ such that $forall t$ close enough to a known limit (e.g $t -> 0$, $t -> infinity$), is valid that:
  $
    phi(t) <= C psi(t)
  $
]

What does this mean? It means that, if we write $phi(t) = O(psi(t))$, and we know where $t$ is going, there exists $C > 0$ such that the values of $phi(t)$ will never be greater then $C psi(t)$. Most of the times I don't even care what is $C$, I only care about its existence!

Talking about how we are talking about $epsilon_"machine"$, the implicit limit here is $epsilon_"machine" -> 0$, and write that $phi(t) = O(epsilon_"machine")$ means that we have a constant that limits the error over an amount of $epsilon_"machine"$, that means, the error will never be greater then, for example, $3$ times $epsilon_"machine"$, $2$ and a half times $epsilon_"machine"$.

We can make a stronger (But more confusing) formal definition for $O$ notation

#definition[
  Given $phi(s, t)$, we have that:
  $
    phi(s, t) = O(psi(t)) "uniformly in" s
  $
  makes sure that $exists ! C > 0$ such that:
  $
    phi(s, t) <= C psi(t)
  $
  and that is valid for any $s$ I choose
]

Is a similar definition, I'm only adding a variable that I can choose and it will change nothing on it.

In real computers, $epsilon_"machine"$ is a fixed number, so when we're working with the implicit limit $epsilon_"machine" -> 0$, we're selecting an *ideal* family of computers!

== Dependency on $m$ and $n$
In practice, when we are talking about rounding errors, the stability of algorithms involving a matrix $A$ depends not on $A$ itself, but on $m$ and $n$ (Its dimensions). We can see that looking at the following problem:

Suppose I have an algorithm for resolving a non-singular system $m times m$ $A x = b$ for $x$ and we make sure that the solution $accent(x, ~)$ given by the algorithm satisfies
$
  (||accent(x, ~) - x||)/(||x||) = O(kappa(A)epsilon_"machine")
$
That means a constant $C$ exists and satisfies
$
  ||accent(x, ~) - x|| <= C kappa(A) epsilon_"machine" ||x||
$
This shows that, even $C$ depending neither on $A$ or $b$, it ends up depending on the dimensions of $A$ because, if we change $m$ or $n$, the data passed to the problem changes, that means we'll have a *new* problem because we're changing its domain and $k(A)$ will change too if we change its dimensions!

== Independence of the Norm
You might have noticed that, when we are defining things in stability with norms, we denote $||dot||$ as _any_ type of norm, but, if we choose a certain norm, the definition might not hold right? Like, it might hold for $||dot||_2$ but not for $||dot||_3$ right? Actually wrong! We can show that *precision*, *stability* and *backwards stability* hold its properties for *any* kind of norm! That means, when we're choosing a norm, we can choose one that makes the calculations easier!

#theorem[
  For problems $f$ and its algorithms $accent(f, ~)$ in finite dimensional normed spaces $X$ and $Y$, the properties of *precision*, *stability* and *backwards stability* all hold or fail to hold independently on what norm I choose to make the analysis
]
#proof[
  If we prove that, if $||dot||$ and $||dot||'$ are two norms on $X$ and $Y$, then $exists c_1, c_2$ such that:
  $
    c_1||x|| <= ||x||' <= c_2||x||
  $
  then the theorem shown before is valid, because that shows:
  1. If a sequence converges or is really small in a norm, it will be in all other norms too
  2. Small errors in a norm will be small in all other norms too

  But we need to prove the previous statement right? Let's do it! (The book only says that it is easy, lol)

  First of all, lets reduce the problem to a unitary sphere of the norms, lets define:
  $
    S = { x in CC^(n) \/ ||x|| = 1 }
  $
  this set is *closed* because the norm is *continuous* and it's *limited* (A sphere, lol). Now let's define the function $f(x) = ||x||'$, because $f(x)$ is continuous in $CC^n$ and $S$ is closed and limited, we can find the *maximum* and *minimum* value of $f$ in $S$, lets define:
  1. $m = min_(x in S)||x||'$
  2. $M = max_(x in S)||x||'$
  $m > 0$ because $0 in.not S$. Now, let's try to generalize it in $CC^n$. If we want to generalize for all $x != 0 in CC^n$, let's write:
  $
    x = ||x||(x/(||x||))
  $
  You can clearly see that $x/(||x||) in S$ because $||x/(||x||)|| = 1$. So, lets see what happens if we take $||x||'$:
  $
    ||x||' = || ||x||(x/(||x||)) ||' = ||x|| ||x/(||x||)||'
  $
  If you look it closely, $x/(||x||)$ is a vector in $S$, that means $||x/(||x||)||' in [m, M]$ and, because of $||x||$ (Positive scalar number), we can see that
  $
    ||x|| ||x/(||x||)||' in [ ||x||m, ||x||M ]
  $
  We can rewrite this as
  $
    m||x|| <= ||x||' <= M||x||
  $
  That means this two constants exists and proves the theorem set before
]

== Floating Point Arithmetic Stability
#theorem[
  The operations $plus.circle$, $minus.circle$, $times.circle$ and $div.circle$ are *backwards stable*
]
#proof[
  Define $ast.circle$ as any of the 4 operations shown before. Given a problem $f: X -> Y$ that is calculating $x_1 ast x_2$, the algorithm $accent(f, ~)$ for solving this problem is $accent(f, ~)(x) = "fl"(x_1) ast.circle "fl"(x_2)$ where $x = mat(x_1;x_2)$.

  We have that:
  $
    accent(f, ~)(x) = "fl"(x_1) ast.circle "fl"(x_2)
  $
  $
    = ("fl"(x_1) ast "fl"(x_2))(1 + epsilon_3)
  $
  $
    = (x_1(1 + epsilon_1) ast x_2(1 + epsilon_2))(1 + epsilon_3)
  $
  $
    = x_1(1+epsilon_1)(1+epsilon_3) ast x_2(1+epsilon_2)(1+epsilon_3)
  $
  $
    = x_1(1+epsilon_4) ast x_2(1+epsilon_5)
  $

  Where $epsilon_4 = O(epsilon_"machine") and epsilon_5 = O(epsilon_"machine")$. We calculated $accent(f, ~)(x)$, now let's see $f(accent(x, ~))$. First, let's define:
  $
    accent(x, ~) = mat(x_1(1+epsilon_4);x_2(1+epsilon_5))
  $

  If we define $accent(x, ~)$ like this, we can clearly see that
  $
    f(accent(x, ~)) = x_1(1+epsilon_4) + x_2(1+epsilon_5) = accent(f, ~)(x)
  $

  But the condition $(||accent(x, ~) - x||)/(||x||) = O(epsilon_"machine")$ is satisfied?
  $
    (||accent(x, ~) - x||)/(||x||) = (||mat(x_1(1+epsilon_4);x_2(1+epsilon_5)) - mat(x_1;x_2)||)/(||mat(x_1;x_2)||) = (||mat(x_1 epsilon_4;x_2 epsilon_5)||)/(||mat(x_1;x_2)||)
  $
  Using the 1-norm
  $
    (x_1 epsilon_4 + x_2 epsilon_5)/(x_1 + x_2) = (x_1 O(epsilon_"machine") + x_2 O(epsilon_"machine"))/(x_1 + x_2) = ((x_1 + x_2)O(epsilon_"mahcine"))/(x_1 + x_2) = O(epsilon_"machine")
  $

  This shows that $plus.circle$, $minus.circle$, $times.circle$ and $div.circle$ are *backwards stable*
]

== Precision of a Backwards Stable Algorithm
We say condition numbers before stability, let's try to associate both of them!

#theorem[
  Suppose a backwards stable algorithm $accent(f, ~)$ is applied for a problem $f: X -> Y$ with condition number $kappa$ in a computer that satisfies @floating_point_conversion and @fundamental_axiom_of_floating_point_arithmetic, so, the relative error satisfies:
  $
    (||accent(f, ~)(x) - f(accent(x, ~))||)/(||f(accent(x, ~))||) = O(kappa(x)epsilon_"machine")
  $
]
#proof[
  By definition, we have $accent(f, ~)(x) = f(x + delta x)$ with $(||delta x||)/(||x||) = O(epsilon_"machine")$. Using @relative_condition_number (Relative Condition Number), we have that:
  $
    kappa(x) = lim_(delta x -> 0) ((||f(x + delta x) - f(x)||)/(||f(x)||)) ((||x||)/(||delta x||))
  $
  $
    kappa(x) = lim_(delta x -> 0)((||accent(f, ~)(x) - f(x)||)/(||f(x)||)(||x||)/(||delta x||))
  $

  Using some formal definitions (Even I don't understand, so if I try to explain it here, I'll just lose time, lol), we can rewrite this as:
  $
    (||accent(f, ~)(x) - f(x)||)/(||f(x)||) <= (kappa(x) + o(1))(||delta x||)/(||x||)
  $

  Where $o(1) -> 0$ when $epsilon_"machine" -> 0v$
]