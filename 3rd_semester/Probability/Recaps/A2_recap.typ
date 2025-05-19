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
#let proof = thmproof("proof", "Demonstração")

// A bunch of lets here
#set page(numbering: "1")
#let int = $integral$

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
  Uma v.a contínua é uma variável aleatória $X: Omega -> RR$ com CDF $F_X (phi)$ é diferenciável
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

Dada uma v.a contínua $X$ com PDF $f_X (phi)$ e CDF $F_X (phi)$, é intuitivo que com $phi -> oo$, $P(X <= phi) = F_X (phi) -> 1$, e analogamente com $phi -> -oo$, $P(X <= phi) = F_X (phi) -> 0$. Então enunciamos as seguintes propriedades:

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

== Distribuição Exponencial
<secao_dist_exponencial>

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