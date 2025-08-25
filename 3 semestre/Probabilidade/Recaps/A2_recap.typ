#import "@preview/ctheorems:1.1.3": *
#show: thmrules.with(qed-symbol: $square$)

#set page(width: 21cm, height: 30cm, margin: 1.5cm)
#set heading(numbering: "1.1.")

#set par(
  justify: true
)
#set page(numbering: "1")

#let theorem = thmbox("theorem", "Teorema", fill: rgb("#ab343447"))

#let corollary = thmplain(
  "corollary",
  "Corolário",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definição", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Exemplo").with(numbering: "1.")
#let property = thmplain("property", "Propriedade").with(numbering: "1.")
#let proposition = thmplain("proposition", "Proposição").with(numbering: "1.")
#let proof = thmproof("proof", "Demonstração")

// A bunch of lets here
#let int = $integral$
#let Expo = "Expo"

#set math.equation(
  numbering: "(1)",
  supplement: none,
)
#show ref: it => {
  // provide custom reference for equations
  if it.element != none and it.element.func() == math.equation {
    // optional: wrap inside link, so whole label is linked
    link(it.target)[eq.~(#it)]
  } else {
    it
  }
}

//atalhos

#let inv(var) = $var^(-1)$

#align(center, text(17pt)[
  Teoria da Probabilidade, Resumo da A2
])

#align(center, text(15pt)[
  jãopredo e artu\
  #datetime.today().display("[day]/[month]/[year]")
])

#outline()

#pagebreak()

= Variáveis Aleatórias Contínuas
== Definições

Definimos aqui o necessário sobre variáveis aleatórias contínuas para a compreensão dos conteúdos do teste:

#definition[(V.A Contínua)\
  Uma v.a $X: Omega -> RR$ é dita contínua se e somente se sua CDF $F_X$ for derivável
]<definiticao_variavel_aleatoria_continua>

#definition[(Função de Distribuição - CDF)\
  A função de distribuição de uma v.a contínua $X$ é dada por:
  $
    F_X (phi) = P(X <= phi)
  $
]<definicao_CDF>

#definition[(Função de Densidade - PDF)\
  Calculamos a densidade de probabilidade calculando a probabilidade de $X$ estar num intervalo, e dividimos pelo tamanho do intervalo:

  $
    (P(X in I = [psi,psi + epsilon])) / (norm(I) = epsilon) = (P(psi <= X <= psi + epsilon)) / epsilon = (F_X (psi + epsilon) - F_X (psi)) / epsilon
  $

  Tomando o limite quando $epsilon -> 0$, obtemos a _função de densidade de probabilidade_ PDF no ponto $psi$:

  $
    lim_(epsilon -> 0) (F_X (psi + epsilon) - F_X (psi)) / epsilon = F'_X (psi) = f_X (psi)
  $

  É importante notar que a PDF não é uma probabilidade, mas sim uma densidade de probabilidade. Veja:

  $
    P(X in I) = P(a <= X <= b) = F_X (b) - F_X (a)
  $

  Usamos a PDF e o teorema fundamental do cálculo para calcular a probabilidade de $X$ estar em um intervalo $I = [a,b]$:

  $
    P(X in I) = F_X (b) - F_X (a) = int_(a)^(b) f_X (phi) d phi
  $

  Logo a *a integral definida* da PDF é de fato uma probabilidade.
] <definicao_PDF>

== Propriedades da CDF e PDF
<secao_propriedades_CDF_PDF>

Dada uma v.a contínua $X$ com PDF $f_X$ e CDF $F_X$, é intuitivo que com $phi -> oo$, $P(X <= phi) = F_X (phi) -> 1$, e analogamente com $phi -> -oo$, $P(X <= phi) = F_X (phi) -> 0$. Então enunciamos as seguintes propriedades:

#property[
  $
    lim_(phi -> oo) F_X (phi) = 1\
    lim_(phi -> -oo) F_X (phi) = 0\
  $

Logo, $F_X (phi)$ é uma função crescente, e $F_X (phi) in [0,1]$.
] <propriedade_cdf_crescente>

#property[

  $
    F_X (phi) = int_(-oo)^(phi) f_X (psi) d psi\
    int_(-oo)^(oo) f_X (psi) d psi = 1\
  $
] <propriedade_pdf_integra_1>

#property[
  Seja $X$ uma v.a contínua com PDF $f_X$ e CDF $F_X$, tome $h:RR -> RR$ crescente e $Y = g(X)$ com PDF e CDF $f_Y, F_Y$, respectivamente. Então:

  $
    f_Y (y) = (f_X (phi)) / (h^' (phi))
  $

  Com $phi = inv(h)(y)$

  Caso $h$ seja decrescente:

  $
    f_Y (y) = - (f_X (phi)) / (h^' (phi))
  $

  Caso seja injetiva (pode ser crescente e decrescente em lugares diferentes):

  $
    f_Y (y) = (f_X (phi)) / (abs(h^' (phi)))
  $

  Caso seja uma função fudida quem nem injetiva é, mas pelo menos derivável, defina $forall y in "Im"(h)$:

  $
    I_y = {x in RR | h(x) = y}
  $

  Contendo um número finito de elementos $x_1 (y), dots, x_(k(y)) (y)$. Então a densidade de $Y$ é dada por:

  $
    f_Y (y) = sum_(i=1)^(k(y)) (f_X (x_i (y))) / (abs(h^' (x_i (y))))
  $
] <propriedade_derivada_inversa>



== LOTUS (Law of The Unconscious Statistician)
<secao_lotus>

Se $X$ é uma v.a contínua com PDF $f_X (phi)$ e $g: RR -> RR$ é contínua, então a esperança de $Y = g(X)$ é dada por:

$
  E(g(X)) = int_(-oo)^(oo) g(phi) f_X (phi) d phi
$

== Variância e Esperança

#definition[(Esperança)\
  Dada uma v.a contínua $X$ com PDF $f_X (phi)$, a esperança de $X$ é dada por:

  $
    E(X) = int_(-oo)^(oo) phi  f_X (phi) d phi
  $
]<definicao_esperanca>

#definition[(Variância, Desvio-Padrão)\
  A variância de uma v.a contínua $X$ com PDF $f_X (phi)$ e esperança $mu = E(X)$ é dada por:

  $
    V(X) = E[(X - E(X)^2] = int_(-oo)^(oo) [phi - mu]^2 f_X (phi) d phi
  $

  O desvio padrão é:

  $
    sigma(X) = sqrt(V(X))
  $
] <definicao_variancia_desviopadrao>

== Propriedades da Esperança e Variância
<secao_propriedades_esperanca_variancia>

Dadas v.a's contínuas $X, Y$ com PDF $f_X (phi), f_Y (phi)$ e $a,b in RR$, temos:

#property[
  
  $
    E(a X + b) = a E(X) + b\
    E(X + Y) = E(X) + E(Y)\
    V(a X + b) = a^2 V(X)\
  $

  E caso $X, Y$ sejam independentes:

  $
    E(X Y) = E(X) E(Y)\
    V(X + Y) = V(X) + V(Y)
  $

]<propriedade_esperanca_variancia>

#property[
  Podemos calcular a variância de $X$ usando a esperança:

  $
    V(X) = E(X^2) - E(X)^2\
  $

] <propriedade_varianca_via_esperanca>

= Distribuições Contínuas
== Distribuição Uniforme
<secao_dist_uniforme>

Uma v.a contínua $X$ tem distribuição uniforme no intervalo $[a,b]$ se sua PDF for da forma:

$
  f_X (phi) = cases(0"," "se" phi < a, 1/(b-a)"," "se" a <= phi <= b )
$

Desta forma sua CDF é:

$
  F_X (phi) = cases(0"," "se" phi < a, (phi - a)/(b-a)"," "se" a <= phi <= b, 1"," "se" phi > b )
$

O seguinte teorema é extremamente importante:

#theorem[(Universalidade da Uniforme)\
  Se $X$ é uma v.a contínua com PDF $f_X$ e CDF $F_X$, então $Y = F_X (X)$ é uma uniforme em $[0,1]$, ou seja: $Y ~ U[0,1]$
] <teorema_universalidade_uniforme>

#proof[

  $
    F_Y (y) = P(Y <= y) = P(F_X (X) <= y) = P(X <= F_X^(-1)(y)) = F_X (F_X^(-1)(y)) = y
  $

  Logo $Y$ é uma uniforme em $[0,1]$.
]

=== Esperança

Com $X ~ U[a,b]$, temos

$
  E(X) = int_(-oo)^(oo) phi f_X (phi) d phi = int_(a)^(b) phi (1/(b-a)) d phi = (a + b) /2 
$

=== Variância

Com $X ~ U[a, b]$, temos:

$
  E(X^2) = int_(-oo)^(oo) phi^2 f_X (phi) d phi = int_(a)^(b) phi^2 (1/(b-a)) d phi = (1/(b-a)) int_(a)^(b) phi^2 d phi\

  = (1/(b-a)) [phi^3/3]_(a)^(b) = (1/(b-a)) [(b^3 - a^3)/3] = (b^2 + a b + a^2)/3
$ <esperanca_uniforme>

E a variância fica:

$
  V(X) = E(X^2) - E(X)^2 = (b^2 + a b + a^2)/3 - ((a + b)/2)^2 = (b-a)^2 / 12
$ <variancia_uniforme>

== Distribuição Exponencial
<secao_dist_exponencial>

Uma v.a contínua $X$ tem distribuição exponencial se sua PDF for da forma:

$
  f_X (phi) = cases(0"," "se" phi < 0, lambda e^(-lambda phi)"," "se" phi >= 0 )
$

$lambda > 0$ é o parâmetro da distribuição. A CDF é dada por:

$
  F_X (phi) = cases(0"," "se" phi < 0, 1 - e^(-lambda phi)"," "se" phi >= 0 )
$

#figure(
  image("images/pdf_cdf_expo.png", width: 70%),
  caption: [
    PDF e CDF Da Exponencial com $lambda = 2$
  ]
)

Isto também é útil:

#proposition[
  Se $X ~ Expo(lambda)$, $Y = a X$, então $Y ~ Expo(lambda / a)$
]

#proof[
  Pela @propriedade_derivada_inversa, temos:

  $
    f_Y (y) = (f_X (phi)) / (h^' (phi))\
    h^' (phi) = a\
    phi = inv(h)(y) = y/a
  $

  Então:

  $
    f_Y (y) = (lambda e^(-lambda (y/a))) / a = (lambda / a) e^(-lambda (y/a))\
    F_Y (y) = 1 - e^(-lambda (y/a))
  $

  O que conclui a prova.
] <proposicao_exponencial>

#corollary[
  Se $X ~ Expo(lambda)$, então $lambda X ~ Expo(1)$
] <corolario_exponencial>

=== Esperança

Com $X ~ Expo(lambda)$

$
  E(X) = int_(-oo)^(oo) phi f_X (phi) d phi = int_(0)^(oo) phi lambda e^(-lambda phi) d phi = 1/lambda
$

=== Variância

Com $X ~ Expo(lambda)$, temos:

$
  E(X^2) = int_(-oo)^(oo) phi^2 f_X (phi) d phi = int_(0)^(oo) phi^2 lambda e^(-lambda phi) d phi = 2/lambda^2  
$ <esperanca_exponencial>

E a variância fica:

$
  V(X) = E(X^2) - E(X)^2 = 2/lambda^2 - (1/lambda)^2 = 1/lambda^2
$ <variancia_exponencial>

=== Perda de Memória

Uma v.a $X$ tem a propriedade de *perda de memória* se:
$
  P(X > s + t | X > s) = P(X > t)
$
Isto é, a probabilidade de $X$ ser maior que $s + t$, dado que já passou $s$, é a mesma que a probabilidade de $X$ ser maior que $t$.

*A distribuição exponencial é a única distribuição contínua que tem a propriedade de perda de memória.*

== Distribuição Gamma
<secao_dist_gamma>

=== A função Gamma

A função $Gamma$ é definida como:

$
  Gamma(phi) = int_(0)^(oo) t^(phi - 1) e^(-t) d t
$

As propriedades abaixo serão muito úteis:

#property[
  $
    n in NN => Gamma(n) = (n - 1)!
  $
] <propriedade_natural_funcao_gamma>

#property[
  $
    Gamma(phi + 1) = phi Gamma(phi), forall phi > 0.
  $
] <propriedade_funcao_gamma_phimaisum>

Alguns valores úteis de $Gamma$ são:

$
  Gamma(1/2) = sqrt(pi)\
  Gamma(3/2) = (1/2) sqrt(pi)\
  Gamma(5/2) = 3/4 sqrt(pi)\
  Gamma(7/2) = 15/8 sqrt(pi)\
  Gamma(1) = 1\
  Gamma(2) = 1\
  Gamma(3) = 2\
  Gamma(4) = 6\
  Gamma(5) = 24\
  dots.v
$

=== A distribuição Gamma

Uma variável aleatória $X$ tem distribuição gamma com parâmetros $alpha, lambda > 0$ se sua PDF é dada por:

$
  f_X (phi) = cases(0"," "se" phi < 0, lambda^alpha / Gamma(alpha) phi^(alpha - 1) e^(-lambda phi)"," "se" phi >= 0 )
$

==== Esperança

A esperança de $Z ~ Gamma(alpha, lambda)$ é:

$
  E(Z) = int_(-oo)^(oo) phi f_Z (phi) d phi = int_(0)^(oo) phi lambda^alpha / Gamma(alpha) phi^(alpha - 1) e^(-lambda phi) d phi = 1 / Gamma(alpha) int_(0)^(oo) (lambda phi)^alpha e^(-lambda phi) d phi
$

Fazendo $x = lambda phi$, temos:

$
  E(Z) = 1 / Gamma(alpha) int_(0)^(oo) x^alpha e^(-x) (d x)/lambda = 1 /( lambda Gamma(alpha)) Gamma(alpha + 1) = alpha / lambda\
$

==== Variância

Dada $Z ~ Gamma(alpha, lambda)$:

$
  E(Z^2) = 1 / (lambda Gamma(alpha)) int_(0)^(oo) (lambda x)^(alpha + 1) e^(-lambda x) d x = (1 / lambda^2 Gamma(alpha)) int_(0)^(oo) x^(alpha + 1) e^(-x) d x\
  
  = (1 / lambda Gamma(alpha)) Gamma(alpha + 2) = (alpha (alpha + 1)) / lambda^2
$

E a variância fica:

$
  V(Z) = E(Z^2) - E(Z)^2 = (alpha (alpha + 1)) / lambda^2 - (alpha / lambda)^2 = alpha / lambda^2
$

Isso também pode ser útil:

#proposition[
  Se $X ~ Gamma(alpha, lambda)$ e $Z = lambda X$, então $Z ~ Gamma(alpha, 1)$
]

#proof[
  Pela @propriedade_derivada_inversa, temos:

  $
    f_Z (z) = (f_X (phi)) / (h^' (phi))\
    h^' (phi) = lambda\
    phi = inv(h)(z) = z/lambda
  $

  Então:

  $
    f_Z (z) = (lambda^alpha / Gamma(alpha) (z/lambda)^(alpha - 1) e^(-lambda (z/lambda))) / lambda = (1 / Gamma(alpha)) z^(alpha - 1) e^(-z)
  $

  Assim $Z ~ Gamma(alpha, 1)$.  
]

== Distribuição Normal
<secao_dist_normal>

$X$ v.a contínua tem distribuição normal com média $mu$ e variância $sigma^2$ se sua PDF é dada por:

$
  f_X (phi) = 1 / (sigma sqrt(2 pi)) e^(- ((phi - mu)^2) / (2 sigma^2))
$

Note que $f(mu + a) = f(mu - a)$, então a PDF é simétrica em torno de $mu$ (a média).

A PROPOSIÇÃO ABAIXO É MUITO IMPORTANTE PARA RESOLVER PROBLEMS COM A NORMAL:

#proposition[
  Se $X ~  N(mu, sigma^2)$, então $Z = (X - mu) / sigma ~ N(0, 1)$
] <proposicao_magia_normal>

#proof[
  Pela @propriedade_derivada_inversa, temos:

  $
    f_Z (z) = (f_X (phi)) / (h^' (phi))\
    h^' (phi) = 1/sigma\
    phi = inv(h)(z) = mu + sigma z
  $

  Então:

  $
    f_Z (z) = (1 / (sigma sqrt(2 pi))) e^(- ((mu + sigma z - mu)^2) / (2 sigma^2)) / (1/sigma)\
    = 1 / sqrt(2 pi) e^(- z^2 / 2)
  $

  Logo $Z ~ N(0,1)$.
]


A @proposicao_magia_normal é muito útil para resolver problemas com uma tabela de valores da FDA de $N(0,1)$.

=== Esperança

Com $X ~ N(mu, sigma^2)$, temos:

$
  E(X) = int_(-oo)^(oo) phi f_X (phi) d phi = int_(-oo)^(oo) phi (1 / (sigma sqrt(2 pi))) e^(- ((phi - mu)^2) / (2 sigma^2)) d phi = mu
$

=== Variância

Com $X ~ N(mu, sigma^2)$, temos:
$
  E(X^2) = int_(-oo)^(oo) phi^2 f_X (phi) d phi = int_(-oo)^(oo) phi^2 (1 / (sigma sqrt(2 pi))) e^(- ((phi - mu)^2) / (2 sigma^2)) d phi = mu^2 + sigma^2
$

Logo a variância fica:

$
  V(X) = E(X^2) - E(X)^2 = mu^2 + sigma^2 - mu^2 = sigma^2
$

== Taxa de Falhas
<secao_taxa_falhas>

#definition[
  Seja $T$ o tempo de vida de um equipamento, ou seja o instante da sua primeira falha, cuja FDS é $F(t)$. A *confiabilidade* do equipamento é dada por:

  $
    R(t) = P(T > t) = 1 - F(t)
  $
] <definicao_confiabilidade>

#definition[
  A *taxa média de falhas* de um equipamento num intevalo $[t, t + Delta t]$, é a probabilidade de ele falhar nos próximos $Delta t$, dado que ainda não falhou:

  $
    "TMF" = (P(T <= t + Delta t | T > t)) / Delta t = P(T <= t + Delta t) / (Delta t dot P(T > t)) = (F(t + Delta t) - F(t)) / (Delta t [1 - F(t)])\

    = (R(t + Delta t) - R(t)) / (R(t) dot Delta t)
  $

  Quando $Delta t -> 0$, obtemos a *taxa de falhas*:
  $
    "TF" = lim_(Delta t -> 0) (R(t + Delta t) - R(t)) / (R(t) dot Delta t) = (-R'(t)) / R(t)
  $
]

= Variáveis Aleatórias Contínuas Bidimensionais
== Função de Densidade Conjunta
<secao_fdc>

#definition[(Função de Densidade Conjunta)\

  Uma função de densidade conjunta $f(x,y)$ das variáveis $X$ e $Y$ é uma função com a seguinte propriedade:

  $
    P((X,Y) in R) = integral.double_(R) f(x,y) d A
  $

  Onde $R subset RR^2$. Por conseguinte, $f$ deve satisfazer:

  $
    f(x,y) >= 0, forall (x,y) in RR^2\
    int_(-oo)^(oo) int_(-oo)^(oo) f(x,y) d x d y = 1\
  $
] <definicao_conjunta>

=== Esperança, Variância e Desvio-Padrão

#definition[(Esperança)\
  Dadas $X, Y$ com densidade conjunta $f(x,y)$, a esperança de $X$ é:

  $
    E(X) = integral.double_(RR^2) x f(x,y) d A
  $
] <definicao_esperanca_conjunta>

#definition[(Variância, Desvio-Padrão)\
  A variância de $X$ é análoga ao caso anterior:

  $
    V(X) = E(X^2) - E(X)^2
  $

  O desvio padrão é:

  $
    sigma(X) = sqrt(V(X))
  $
] <definicao_variancia_desviopadrao_conjunta>

=== LOTUS 2

Dadas $X, Y$ com densidade conjunta $f(x,y)$, o valor esperado de uma função qualquer $g(X,Y)$ é:

$
  E(g(X,Y)) = integral.double_(RR^2) g(x,y) f(x,y) d A
$ <lotus2>

Quando a densidade conjunta é constante em $S subset RR^2$ e $0$ fora de $S$, dizemos que $f(x,y)$ é uma função de densidade uniforme em $S$:

$
  f(x,y) = cases(0"," "se" (x,y) in.not S, 1/"Área"(S)"," "se" (x,y) in S )
$

== Distribuições Marginais e Condicionais
<secao_distr_marginais_condicionais>

Lembrando o caso discreto, dadas $X, Y$ v.a's discretas com densidade conjunta $p(x,y) = P(X = x inter Y = y)$, temos os conceitos e covariância e correlação:

$
  "Cov"(X,Y) = E(X Y) - E(X) E(Y)\
  rho(X, Y) = "Cov"(X,Y) / (sigma(X) sigma(Y))\
$

Também temos as distribuições marginais e condicionais (Pelo teorema de Bayes e a Lei da Probabilidade Total):

$
  p_X (x) = P(X = x) = sum_(y) p(x,y)\
  p_Y (y) = P(Y = y) = sum_(x) p(x,y)\
  p_(X|Y) (x|y) = P(X = x | Y = y) = p(x,y) / (p_Y (y))\
$

Com $f(x,y)$ sendo uma densidade conjunta, a diferença agora é a transição de $sum -> int$:

#definition[(Distribuição Marginal)\
  A distribuição marginal de $X$ é dada por:

  $
    f_X (x) = int_(-oo)^(oo) f(x,y) d y
  $
] <definicao_distr_marginal>

#definition[(Distribuição Condicional)\
  A distribuição condicional de $X$ dado $Y$ é dada por:

  $
    f_(X|Y) (x|y) = f(x,y) / (f_Y (y))
  $
] <definicao_distr_condicional>


== Covariância e Correlação
<secao_covariancia_correlacao>

A Covariância e correlação são *análogas* ao caso discreto:

#definition[(Covariância)\
  A covariância de $X$ e $Y$ é dada por:

  $
    "Cov"(X,Y) = E(X Y) - E(X) E(Y)
  $
] <definicao_covariancia>

#definition[(Correlação)\
  A correlação de $X$ e $Y$ é dada por:

  $
    rho(X,Y) = "Cov"(X,Y) / (sigma(X) sigma(Y))
  $
] <definicao_correlacao>

== Esperança Condicional

Isso é bem útil:

#definition[
  A esperança condicional de $X$ na certeza de $Y = y$ é:

  $
    E(X | Y = y) = int_(-oo)^(oo) x f_(X|Y) (x|y) d x 
  $

  (As vezes denotado por $E[X|y]$).
]

Os teoremas da gênesis também são úteis:

#theorem[(Lei de Adão)\
  $forall$ v.a's $X, Y$ temos:

  $
    E(E(X|Y)) = E(X)
  $
]

#proof[
  Trivial
]

#theorem[(Lei de Eva)\
  $forall$ v.a's $X, Y$, temos:

  $
    V(Y) = E(V(Y|X)) + V(E(Y|X))
  $
]

#proof[
  Trivial
]

== Independência

As v.a's contínuas $X$ e $Y$ são ditas *independentes* se e somente se a densidade conjunta $f(x,y)$ for o produto das marginais:

$
  f(x,y) = f_X (x) f_Y (y)
$