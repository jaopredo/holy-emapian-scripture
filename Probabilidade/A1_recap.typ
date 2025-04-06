#let supp = "supp"
#let Bernoulli = "Bern"
#let Binomial = "Bin"
#let Poisson = "Pois"
#let Hypergeometric = "Hypergeom"
#let Geometric = "Geom"
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

Notice that the function $P_C: Omega -> [0,1]$, $P_C (A) = P(A|C)$, given $C subset Omega$ is also a probability in the same space $E$, so both Baye's theorem and LOTP assume conditional versions written in terms of $P_C$.

= Discrete Distributions

"The key to anihilating distributions problems in exams or wherever the fuck you find them is just to remember the stories behind them, so you can morph those stories into the conditions you currently have. So take your time and get those fucking stories in your memory." 

-A guy with a P.h.D that asked not to have his name written here

== Bernoulli

=== Story

A random variable $X: Omega -> RR$ has a #text(weight: "bold")[Bernoulli] distribution if we can think about it as an event with two and only two possible outcomes: succes or failure. Ex: Tossing a coin, throwing a 2-sided dice (a fucking coin).

=== PMF, CDF, Expected Value and Variance

A random variable $X: Omega -> RR$ is said to have a Bernoulli distribution if $supp(X) := {v_1 , v_2}, v_i in RR$ and X's PMF is:

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
Ps: In the very common situation where $supp(X) = {1,0}$, we have $E(X) = p$ and $V(X)$ = np.


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

The expected value of X is are:

$
  E(X) = sum_(phi in RR) phi P(X = phi) = sum_(phi in RR) phi p^phi (1-p)^(n-phi) binom(n, phi) = n p\
  
  V(X) = E(X^2) - [E(X)]^2 = sum_(phi in RR) phi^2 P(X = phi) = sum_(phi in RR) phi^2 p^phi (1-p)^(n-phi) binom(n, phi) - (n p)^2\
  = n p q
$

== Geometric
=== Story

Still on the Bernoulli universe, suppose we perform a bernoulli trial with parameter $p$ (probability of sucess), and let $X$ be the quantity of experiments performed until the first sucess (inclusive), then we say that $X: Omega -> RR$ has a #text(weight: "bold")[geometric] distribution with parameter $p$

=== PMF, CDF, Expected vale and Variance

The PMF and CDF of $X ~ Geometric(p)$ are:
$
  P(X = k) = Geometric(p) = p (1-p)^(k-1)\
  P(X <= k) = 1 - P(X > k) = 1 - q^k.
$

The Expected Value and Variance:

$
  E(X) = sum_(phi in RR) phi P(X = phi) = sum_(phi in RR) phi p (1-p)^(phi -1) = 1/p\

  V(X) = E(X^2) - [E(X)]^2 = (1-p)/p^2
$

== Hypergeometric

=== Story

If we have an urn flled with $w$ white and $b$ black balls, then drawing n balls out of the urn with replacement yields a $Binomial(n, w/(w+b))$ distribution for the number of white balls obtained in $n$ trials, since the draws are independent Bernoulli trials, each with probability $w/(w+b)$ of success. If we instead sample without replacement, then the number of white balls follows a #text(weight: "bold")[Hypergeometric] distribution. A good example is written below:

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

- The number of emails you receive in an hour, There are a lot of people who could potentially email you in that hour, but it is unlikely that any specifc person will actually email you in that hour. Alternatively imagine subdividing the hour into milliseconds. There are 3.6⇥106 seconds in an hour, but in any specifc millisecond it is unlikely that you will get an email.

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

To see why this is true, let $X$ be a c.r.v, we know by the naive definition of probability that $P(X = k)$ is "the occurences of k in the support of X divided by the size of the sample space". But $|Omega| in.not RR$! ($= infinity$), therefore $P(X = k) = 0, forall k in RR$!

WE now proceed with new concepts and a definition:

=== Definition

A random variable $X: Omega -> RR$ is said to be #text(weight: "bold")[continuous] if its CDF is differentiable.

=== PDF, CDF of a c.r.v

Let $X: Omega -> RR$ be a c.r.v with a differentiable $F: RR -> [0,1]$ CDF, let $epsilon > 0$