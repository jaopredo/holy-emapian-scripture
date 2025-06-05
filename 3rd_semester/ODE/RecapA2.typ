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

#let inv(var, expo) = $var^(-expo)$

#align(center, text(17pt)[
  Equações Diferenciais Ordinárias, Resumo A2
])

#align(center, text(15pt)[
  jãopredo e artu\
  #datetime.today().display("[day]/[month]/[year]")
])

#outline()

#pagebreak()

= Transformada de Laplace
<section_transformada_de_laplace>
== Definição
<section_definicao_transformada_de_laplace>

#definition[(Transformada de Laplace)\
  Dada $f: RR -> RR$ contínua por partes e $f in O(e^(s t))$, definimos a Transformada de Laplace como

  $
    L{f(t)} = int_0^oo e^(-s t) f(t) d t 
  $ 
]


== Propriedades Com derivada
<section_propriedades_com_derivada>

#property[
  Se $f: RR -> RR$ é derivável, então:

  $
    L{f'(t)} = s L{f(t)} - f(0)
  $

  Analogamente:

  $
    L{f''(t)} = s^2 L{f(t)} - s f(0) - f'(0)
  $

  E assim por diante.
]

Resolver EDO's com a transformada de Laplace se restringe a algebricamente buscar a inversa de $L {f(t)}$, justamente a função procurada.

== Função degrau
<section_funcao_degrau>

A função degrau $u_c$ é definida como:

$
  u_c(t) = cases(
    0 "se" t < c,
    1 "se" t >= c
  )
$

== Propriedades com Função degrau
<section_propriedades_com_funcao_degrau>

#property[
  Se $F(s) = L{f(t)}$ existe, dada $f: RR -> RR$, então:

  $
    L{u_c (t) f(t - c)} = e^(-s c) dot inv(L, 1) {f(t)}
  $
]

#property[
  Se $F(s) = L{f(t)}$ existe, dada $f: RR -> RR$, então:

  $
    L{e^(c t) f(t)} = F(s - c)
  $

  Ou equivalentemente:

  $
    e^(c t) f(t) = inv(L, 1) {F(s - c)}
  $
]

== Função Impulso
<section_funcao_impulso>


A função impulso $delta$ satifaz:

$
  delta(t) = 0, t != 0\

  int_(-oo)^oo delta(t) d t = 1
$

== Propriedades com Função Impulso
<section_propriedades_com_funcao_impulso>

A transformada de Laplace da função impulso é:

$
  L{delta(t - c)} = e^(-s c)
$


== Convolução
<section_convolucao>


Dadas $F(s) = L{f(t)}$ e $G(s) = L{g(t)}$, a transformada do produto pode ser calculada como:

$
  H(s) = F(s) G(t) = L{h(t)}
$

Onde:

$
  h(t) = int_0^t f(t - tau) g(tau) d tau = int_0^t f(tau) g(t - tau) d tau
$

A função $h$ é chamada de convolução de $f$ e $g$, denotada por $f * g$.

= Sistemas de EDO's de Primeira Ordem
<section_sistemas_de_edo_primeira_ordem>
== Sistemas Lineares
<section_sistemas_lineares>

Sistemas da forma:

$
  A x = x', A in RR^(n times n), x in RR^n
$ <system_ode_first_order>

Têm solução constante em $x' = 0$.

Fazendo uma analogia em $RR$, temos $x' = a x$ => x = $e^(a t) x_0$. O mesmo vale para exponenciais de matrizes. Buscamos então soluções da @system_ode_first_order da forma:

$
  x(t) = v e^(lambda t), v in RR^n, lambda in RR
$

Ou seja:

$
  A x = x' <=> A v e^(lambda t) = lambda v e^(lambda t)
$

Como $e^(lambda t) != 0, forall t in RR$:

$
  A v = lambda v
$

É exatamente o problema de autovalores da matriz de coeficientes $A$. Então seja $A in RR^(2 times 2)$, e $v_i, lambda_i$ o $i$-ésimo autovetor e autovalor de $A$, respectivamente. Então a solução gera de @system_ode_first_order é:

$
  x(t) = c_1 v_1 e^(lambda_1 t) + c_2 v_2 e^(lambda_2 t)
$ <general_solution_system>

Onde $c_i$ é determinado pela condição inicial $x(0) = x_0$.

A Bebel não gosta de notação @general_solution_system, então vamos escrever a solução do jeito da patroa:

$
  x(t) = X Lambda inv(X, 1) dot x_0
$

Onde $X Lambda inv(X, 1)$ é a decomposição espectral de $A$ e:

$
  Lambda = mat(
    e^(lambda_1 t), 0;
    0, e^(lambda_2 t)
  )
$

