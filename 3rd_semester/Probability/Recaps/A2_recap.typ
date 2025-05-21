#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages, stroke: 1pt + luma(100))

#set page(width: 21cm, height: 30cm, margin: 1.5cm)
#set heading(numbering: "1.1.")

#set par(
  justify: true
)
#set page(numbering: "1")

#let theorem = thmbox("theorem", "Teorema")
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

== Distribuição Gamma
<secao_dist_gamma>

== Distribuição Normal
<secao_dist_normal>

== Taxa de Falhas
<secao_taxa_falhas>

= Variáveis Aleatórias Contínuas Bidimensionais
== Função de Densidade Conjunta
<secao_fdc>

== Distribuições Marginais e Condicionais
<secao_distr_marginais_condicionais>

== Covariância e Correlação
<secao_covariancia_correlacao>

== Mudança de Variáveis Contínuas
<secao_mudanca_variaveis_continuas>

= Soluções de Exercícios de Testes Anteriores
== Teste 2022
<secao_exercicios_2022>

== Teste 2021
<secao_exercicios_2021>