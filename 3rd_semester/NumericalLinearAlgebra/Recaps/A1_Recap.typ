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

// A bunch of lets here
#set page(numbering: "1")

#align(center, text(17pt)[
  Numerical Linear Algebra A1 Recap

  #datetime.today().display("[day]/[month]/[year]")
])

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
  Given ${a_j}$ $(1 <= j <= n)$ being the base of a Vector Space and $T$ a Linear Transformation in that space, we know how $T$ affects *every* vector on that space
]
#proof[
  Being $v$ a vector on the described Vector Space, we know $v$ can be expressed as

  #align(center)[$v = alpha_1 a_1 + ... + alpha_n a_n$]

  Applying $T$ on $v$

  #align(center)[$T(v) = T(alpha_1 a_1 + ... + alpha_n a_n) => T(v) = alpha_1 T(a_1) + ... + alpha_n T(a_n)$]

  #align(center)[This implies that, if we know a base of the Vectorial Space, we know how $T$ affects every vector on the space]
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
  sigma_1, ,   , ,;
  , dots.down, , ,;
  , , sigma_n,   ,;
  , ,        , 0 ,;
  , ,        , , dots.down;
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
  range$(A) =$ span${u_1, ..., u_r}$, range$(A^*) =$ span${v_1, ... v_r}$, null$(A) =$ span${v_(r+1), ..., v_n}$, null$(A^*) =$ span${u_(r+1),...,u_m}$
]
#proof[
  Let's remember how each matrix is structured:

  #align(center)[
    $A = mat(|,,|;u_1,...,u_m;|,,|) mat(sigma_1;,dots.down;,,sigma_r;,,,0;,,,,dots.down) mat(- v_1^* -;dots.v; - v_n^* -)$
  ]

  It's easy to see why range$(A) =$ span${u_1, ..., u_r}$, because the entries of $Sigma$ makes only possible to span the first $r$ columns of $U$.
  
  About null$(A) =$ span${v_(r+1), ..., v_n}$, notice how, if we do $A v_j space r+1 <= j <= n$, the first $r$ lines will turn to 0 (All $v_k$ are orthonormal between them) and, because the diagonal entries after the $r$-th one are 0, then we have $U$ times the 0 matrix

  To see the $A^*$'s properties, let's transpose A

  #align(center)[
    $A^* = mat(|,,|;v_1,...,v_n;|,,|) mat(sigma_1;,dots.down;,,sigma_r;,,,0;,,,,dots.down) mat(- u_1^* -;dots.v; - u_m^* -)$
  ]

  So, again, is easy to see range$(A^*) =$ span${v_1, ... v_r}$ and, using the same argument shown before, null$(A^*) =$ span${u_(r+1),...,u_m}$ 
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
  If $v in$ range$(P)$, then $P v = v$
]
#proof[
  Every $v in $ range$(P)$ can be expressed as $v = P x$ for some $x$, that means $P v = P^2x = P x = v$
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
  1. range$(I - P) subset.eq$ null$(P)$ because $v - P v in$ null$(P)$ and range$(I - P) supset.eq$ null$(P)$ because, if $P v = 0$, we can rewrite it as $(I - P)v = v$, that means null$(P) =$ range$(I - P)$
  2. If we rewrite the expression as $P = I - (I - P)$, then, using the same argument as before, we have range$(P) =$ null$(I - P)$
]

#theorem[
  null$(I-P) inter$ null$(P) = {0}$
]
#proof[
  null$(A) inter$ range$(A) = {0} =>$ null$(P) inter$ range$(P) = {0} <=>$ null$(P) inter$ null$(I-P) = {0}$
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
That is, $sum^n_(i=1)q_i q_i^*v$ is a projector onto range$(accent(Q, \u{0302}))$

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
Given an arbitrary base ${a_j}$, we let the vectors of this base be the columns of $A$. Given $v$ with $P v = y in$ range$(A)$, that means $y - v tack.t$ range$(A)$, that means $a_j^*(y-v) = 0 space forall j$. We know $y in$ range$(A)$, so let's write it as $A x = y$, then we can rewrite $a_j^*(y-v) = 0 space forall j$ as:
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
  Remember that $P_(perp q_k) = I - q_k q_k^*$, and what does it do? It projects a vector $v$ onto the subspace ${q_1,...,q_(k-1)}$, removing the components ${q_k, ...}$ of $v$. The projector $P_j$ does the exact same thing right? So, you can think that, if I project onto the complement of $q_1$, then onto the complement of $q_2$ and so on, at the $j$-th step, I'll have a vector that is orthogonal to the previous ones, that means, I remove all the previous components, leaving the projected vector as a linear combination of ${q_k, ...}$
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

= Lecture 11 - Least Squares problems

= Lecture 12 - Conditioning and Condition Numbers

= Lecture 13 - Floating Point Arithmetic

= Lecture 14 and 15 - Stability

= Lecture 16 - Stability of Householder Triangularization


