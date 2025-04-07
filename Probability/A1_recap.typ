#let Support = "supp"
#let Bernoulli = "Bern"
#let Binomial = "Bin"
#let Poisson = "Pois"
#let Hypergeometric = "Hypergeom"
#let Geometric = "Geom"
#let Image = "Im"
#let StandardDeviation = "SD"
#let Covariance = "Cov"
#set page(numbering: "1")

#align(right, text(12pt)[
  help
])

#align(center, text(17pt)[
  Probability theory A1 recap

  #datetime.today().display("[day]/[month]/[year]")
])

For the statements below, consider $E = (Omega, P)$ a given probability space.
= Fundamentals
== Baye's Theorem and LOTP

Baye's theorem states that $forall A,B subset Omega$:

$
  P(A|B) = (P(B|A)  P(A)) / P(B)
$

This follows directly from the #text(weight: "bold")[Law of Total Probability(LOTP)]:

$
  P(A) = sum_(i = 1)^n P(A|B_i) P(B_i) = sum_(i = 1)^n P(A inter B_i).
$

Given $B_i$ a partition of $Omega$.

Notice that the function $P_C: Omega -> [0,1]$, $P_C (A) = P(A|C)$, given $C subset Omega$ is also a probability in the same space $E$, so both Baye's theorem and LOTP assume conditional versions written in terms of $P_C$.

== Discrete Random Variables, Indicator Random Variables
A #text(weight: "bold")[Discrete Random Variable] is a function $X: Omega -> RR$, with $Image(X)$ a countable set. A good example is the amount of heads in 4 tosses of a fair coin:

$
  X(H H H H) = 4\
  X( H T H H) = 3\
  dots
$

The values $X$ for which a random variable assumes positive values have a special name: the #text(weight: "bold")[support of X]

$
  Support(X) := {phi in RR | P(X = phi) > 0}
$


Random variables are very useful in probability, and there is a category of them so useful and ubiquituous that it has its own name:

An #text(weight: "bold")[Indicator Random Variable] of $A subset Omega$ is $I_A: Omega -> RR$ defined below:

$
  I_A = cases(1 "if A occurs", 0 "otherwise,")
$

This will be of particular use after we define Expected Values:

== Expected Value and Variance

The expected value of a discrete random variable can be seen as a weighted sum of all possible values of $X$:

$
  E(X) := sum_(phi in RR) phi P(X = phi)
$

The most useful fact about indicator random variables is that the expected value of a i.r.v is the #text(weight: "bold")[probability] of the event at stake:

$
  E(I_A) = P(A).
$

This is #text(weight: "bold")[very] useful to determine hard to calculate probabilities.

Functions of real variables are useful as well and derive a famous result, known as the #text(weight: "bold")[Law of the Unconscious Statistician (LOTUS)]:

Let $X, Y: Omega -> RR$ be random variables and $Y = f(X), f: RR -> RR$, then:

$
  E(Y) = sum_(phi in RR) f(phi) P(X = phi)
$

The Expected Value is a linear function and has the following properties:

$
  E(a X + b) = a E(X) + b\
  E(X + Y) = E(X) + E(Y)\
$ and if $X$ and $Y$ are independent,

$
  E(X Y) = E(X) E(Y).
$

A good method to quantify the behaviour of a r.v is using its #text(weight: "bold")[standard deviation]:

$
  StandardDeviation(X) = E(|X - E(X)|)
$ and the  #text(weight: "bold")[variance] and #text(weight: "bold")[mean deviation]:

$
  V(X) = E([X - E(X)]^2)\
  sigma(X) = sqrt(V(X)).
$

The variance of a r.v has some properties too:

$
  V(a X + b) = a^2 V(X)\
  sigma(a X + b) = |a| sigma(X)\
  StandardDeviation(a X + b) = |a| StandardDeviation(X)
$ and if $X$ and $Y$ are independent:

$
  V(X + Y) = V(X) + V(Y)
$

== Covariance, Correlation
We will go straight to the definition:

The #text(weight: "bold")[Covariance] of $X,Y: Omega -> RR$ is:

$
  Covariance(X, Y) = E([X - E(X) ( Y - E(Y))])
$

This is the same as $Covariance(X) = E(X Y) - E(X) E(Y)$, so the idea behind this concept is to measure how both random variables change, when analyzed together. Notice that $Covariance(X, Y) = 0$ if $X$ and $Y$ are independent, this is intuitive 

Another useful concept is the #text(weight: "bold")[correlation coefficient:]

$
  rho(X, Y) = (Covariance(X, Y)) / (sigma(X) sigma(Y))
$ You can verify that $rho(a X , b Y) = rho(X, Y), forall a,b in RR$, so the units used to measure $X,Y$ are irrelevant to their correlation coefficient.

= Discrete Distributions

"The key to anihilating distributions problems in exams or wherever the fuck you find them is just to remember the stories behind them, so you can morph those stories into the conditions you currently have. So take your time and get those fucking stories in your memory." 

-A guy with a P.h.D that asked not to have his name written here.

== Bernoulli

=== Story

A random variable $X: Omega -> RR$ has a #text(weight: "bold")[Bernoulli] distribution if we can think about it as an event with two and only two possible outcomes: succes or failure. Ex: Tossing a coin, throwing a 2-sided dice (a fucking coin).

=== PMF, CDF, Expected Value and Variance

A random variable $X: Omega -> RR$ is said to have a Bernoulli distribution if $Support(X) := {v_1 , v_2}, v_i in RR$ and X's PMF is:

$
  P(X = phi_1) = p\
  P(X = phi_2) = 1-p
$

We write $X ~ Bernoulli(p)$ with parameter $p$ and say that X describes a Bernoulli Trial, a random experiment with 2 possible outcomes: success or failure.

The Expected value and Variance of X are:

$
 E(X) = sum_(phi in RR) phi P(X = phi) = v_1 p + v_2 (1-p)\
 V(X) = E(X^2) - [E(X)]^2 = sum_(phi in RR) phi^2 P(X = phi) - [v_1 p + v_2 (1-p)]^2\
 = v_1^2 p + v_2^2 (1-p) - [v_1 p + v_2 (1-p)]^2.
  
$
#text(weight: "bold")[P.S]: In the very common situation where $Support(X) = {1,0}$, we have $E(X) = p$ and $V(X)$ = np.


== Binomial
=== Story

A random variable $X: Omega -> RR$ has a binomial distribution if we can see it as a #text(weight: "bold")[series] of independent Bernoulli trials of same parameter $p$, such as tossing multiple coins, trying a binary experiment multiple times, etc.

=== PMF, CDF, Expected Value and Variance

A random variable $X:Omega -> RR$ is said to have the Binomial distribution if it can be decomposed as n independent and consecutive Bernouli Trials $X_i ~ Bernoulli(p)$, das ist:

$
  X = X_1 + X_2 + ... + X_n
$

So we can see that its PMF and PDF are:

$
  P(X = k) = p^k (1-p)^(n-k) binom(n, k)\
  P(X <= k) = sum_(i=1)^k P(X = k)
$

The Expected value and Variance of $X$ are:

$
  E(X) = sum_(phi in RR) phi P(X = phi) = sum_(phi in RR) phi p^phi (1-p)^(n-phi) binom(n, phi) = n p\
  
  V(X) = E(X^2) - [E(X)]^2 = sum_(phi in RR) phi^2 P(X = phi) = sum_(phi in RR) phi^2 p^phi (1-p)^(n-phi) binom(n, phi) - (n p)^2\
  = n p q
$

== Geometric
=== Story

Still on the Bernoulli universe, suppose we perform a bernoulli trial with parameter $p$ (probability of sucess), and let $X$ be the quantity of experiments performed until the first sucess (inclusive), then we say that $X: Omega -> RR$ has a #text(weight: "bold")[geometric] distribution with parameter $p$.

=== PMF, CDF, Expected value and Variance

The PMF and CDF of $X ~ Geometric(p)$ are:
$
  P(X = k) = Geometric(p) = p (1-p)^(k-1)\
  P(X <= k) = 1 - P(X > k) = 1 - (1 - p)^k.
$

Its Expected Value and Variance:

$
  E(X) = sum_(phi in RR) phi P(X = phi) = sum_(phi in RR) phi p (1-p)^(phi -1) = 1/p\

  V(X) = E(X^2) - [E(X)]^2 = (1-p)/p^2
$

== Hypergeometric

=== Story

If we have an urn filled with $w$ white and $b$ black balls, then drawing n balls out of the urn with replacement yields a $Binomial(n, w/(w+b))$ distribution for the number of white balls obtained in $n$ trials, because the draws are independent Bernoulli trials, each with probability $w/(w+b)$ of success. If we instead sample without replacement, then the number of white balls follows a #text(weight: "bold")[Hypergeometric] distribution. A good example is written below:

#text(weight: "bold")[(Communists capture-recapture)]. A forest has $N$ communists. Today, $m$ of the communists are
captured, tagged, and released into the wild. At a later date, $n$ communists are recaptured at random. Assume that the recaptured communists are equally likely to be any set of $n$ of the communists, e.g., a communist that has been captured does not learn how to avoid being
captured again (how surprising).

By the story of the Hypergeometric, the number of tagged communists in the recaptured sample has the $Hypergeometric(m, N- m, n)$ distribution. The $m$ tagged communists in this story correspond to the white balls and the $N - m$ untagged communists correspond to the black balls. Instead of sampling $n$ balls from the urn, we recapture $n$ communists from the forest.

=== PMF, Expected value and Variance

$X: Omega -> RR$, $X ~ Hypergeometric(w,b,n)$ has the following:

$
  P(X = k) = (binom(w, k) binom(b, n-k)) / binom(w+b, n)\
  E(X) = n p\
  V(X) = n p q 
$


== Poisson 
=== Story

The Poisson distribution is often used in situations where we are counting the number of successes in a particular region or interval of time, and there are a large number of trials, each with a small probability of success. For example, the following random variables could follow a distribution that is approximately Poisson.

- The number of emails you receive in an hour, There are a lot of people who could potentially email you in that hour, but it is unlikely that any specifc person will actually email you in that hour.

- The number of chips in a chocolate chip cookie. Imagine subdividing the cookie into small cubes; the probability of getting a chocolate chip in a single cube is small, but the number of cubes is large.

- The number of earthquakes in a year in some region of the world. At any given time and location, the probability of an earthquake is small, but there are a large number of possible times and locations for earthquakes to occur over the course of the year.

Now we move to:

=== PMF, Expected Value and Variance

IF $X: Omega -> RR$ is $X ~ Poisson(lambda)$ with parameter $lambda$, then the following hold:

$
  P(X = k) = (e^(-lambda) lambda^k) / k!\
  
  E(X) = sum_(phi in RR) phi P(X = phi) = sum_(phi in RR) phi (e^(-lambda) lambda^phi) / phi!\
  = e^(-lambda) sum_(phi in RR) (phi lambda^phi) / phi! = lambda e^(-lambda) sum_(phi in RR) (lambda^(phi-1)) / (phi - 1)! = lambda e^(-lambda) e^lambda = lambda.\

  V(X) = E(X^2) - [E(X)]^2 = lambda (1+lambda) - lambda^2 = lambda. 
$

The conclusion $E(X^2) = lambda (1 + lambda)$ is not trivial, but it is true.

We now proceed to continuous random variables,

= Continuous Random variables
== Fundamentals

A random variable $X: Omega -> RR$ is said to be #text(weight: "bold")[continuous] if $Omega$ is uncountable,

This is equivalent to the possible outcomes to the random experiment performed being infinite, such as choosing a #text(weight: "bold")[real] number in (0,1).

A continious random variable has some interesting properties, such as the PMF being constant = 0,

To see why this is true, let $X$ be a c.r.v. We know by the naive definition of probability that $P(X = k)$ is "the occurences of k in the support of X divided by the size of the sample space". But $|Omega| in.not RR$! ($= infinity$), therefore $P(X = k) = 0, forall k in RR$!

We now proceed with new concepts and a definition:

=== Definition

A random variable $X: Omega -> RR$ is said to be #text(weight: "bold")[continuous] if its CDF is differentiable.

=== PDF, CDF of a c.r.v

Let $X: Omega -> RR$ be a c.r.v with a differentiable $F: RR -> [0,1]$ CDF, analyzing $P(X = k)$ is a waste of time, instead we use the #text(weight: "bold")[PDF - Probability Density Function]: The density $f: RR -> RR$ in $a$ is, for $epsilon in RR^+$:

$
  f(a) = lim_(epsilon -> 0)  (P(a <= X <= a + epsilon)) / epsilon = lim_(epsilon -> 0) (P(X <= a + epsilon) - P(X <= a)) / epsilon = F^' (a)
$

This is rather useful because it yields an impressive result from calculus' fundamental theorem:

$
  P(a <= X <= b) = F(b) - F(a) = integral_a^b f(x) d x
$

Now calculating probabilities continously has been reduced to integrating a $RR -> RR$ function, which is not so hard.

=== Cauchy distribution

A c.r.v $X: Omega -> RR$ has the #text(weight: "bold")[Cauchy Distribution] if its PDF has the form:

$
  f(x) = c / (1+x^2), c in RR
$

=== Functions of Continuous Random variables

Given $X:Omega -> RR$ a c.r.v $f(x) "and" F(X)$ its PDF and CDF, in that order, finding the PDF and CDF of $Y: Omega -> RR, Y = h(X), h: RR -> RR$ is not so hard.

See that $Y <= y <=>  h(X) <= y$, and the right part can be solved for $X in I$, for some interval $I subset RR$, so Y's CMF is:

$
  G(Y) = P(Y <= y) = P(X in I)
$

With $G$ in hands, it is easy to calculate $g(y) = G^' (y)$.

#text(weight: "bold")[Example:]

Let $X: Omega -> RR$ have a uniform distribution in $[0,1]$ ($F(X) = x, forall x in [0,1]$), calculate the PMF and CMF of $Y = sqrt(X)$.

Solution:

We know that for $y in (0,1)$, $Y <= y <=> sqrt(X) <= y <=> X < y^2$, and since $P(X <= x) = x$;

$
  G(y) = P(Y <= y) = P(X <= y^2) = y^2, "and"\
  g(y) = G^' (y) = 2y "is the PDF",
$

Now we can move to the Expected Value and Variance of a c.r.v.

=== Expected value and variance of a c.r.V

As in the discrete case we had $mu = E(X) = sum_(phi = -infinity)^infinity phi P(X = phi)$, in the continous case, the $sum$ becomes and $integral$, and we use the fact that $P(X = k) ~ f(k)$, so:

$
  mu = E(X) = integral_(-infinity)^infinity phi f(phi)d phi.
$
Everything you know about $E(X)$ for a discrete r.v $X$ is valid for the discrete case, just switch the $sum$ for $integral$.


For the variance, we had $V(X) = E([X- mu^2])$ in the discrete case, and the continuous case is:

$
  V(X) = E([X - mu]^2) = integral_(-infinity)^infinity (phi - mu)^2 f(phi) d phi.
$