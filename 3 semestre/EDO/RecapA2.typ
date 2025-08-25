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
#show link:underline

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
    L{u_c (t) f(t - c)} = e^(-s c) dot F(s)
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

E também vale:

$
  L{delta(t - c) f(t)} = f(c) e^(-s c)
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

Fazendo uma analogia em $RR$, temos $x' = a x => x = e^(a t) x_0$. O mesmo vale para exponenciais de matrizes. Buscamos então soluções da @system_ode_first_order da forma:

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

É exatamente o problema de autovalores da matriz de coeficientes $A$.

=== Autovalores Reais e Distintos
<section_autovalores_reais_distintos>

Então seja $A in RR^(2 times 2)$, e $v_i, lambda_i$ o $i$-ésimo autovetor e autovalor de $A$, respectivamente. A solução geral da @system_ode_first_order é:

$
  x(t) = c_1 v_1 e^(lambda_1 t) + c_2 v_2 e^(lambda_2 t)
$ <general_solution_system>

Onde $c_i$ é determinado pela condição inicial $x(0) = x_0$.

A Bebel não gosta da notação proposta na @general_solution_system, então vamos escrever a solução do jeito da patroa:

$
  x(t) = X Lambda inv(X, 1) dot x_0
$ <equation_bebel>

Onde $X Lambda inv(X, 1)$ é a decomposição espectral de $A$ e:

$
  Lambda = mat(
    e^(lambda_1 t), 0;
    0, e^(lambda_2 t)
  )
$

=== Autovalores Reais Repetidos
<section_autovalores_reais_repetidos>

Seja $A in RR^(2 times 2)$ com autovalor $lambda$ de multiplicidade $2$. Seja $v_1$ um autovetor associado. Para montar a solução da forma @equation_bebel, precisamos de _2_ autovetores. Vamos usar a matriz:

$
  B = mat(
    lambda, t;
    0, lambda
  )
$

#property[
Se $A$ possui autovalor $lambda$ de multiplicidade 2 e apenas um autovetor $v_1$,
escolha um vetor qualquer $v_2$ tal que $(A - lambda I) v_2 = v_1$.

A solução geral é

$
  x(t) = e^(lambda t) · ( c_1 v_1 + c_2 · ( v_2 + t v_1 ) )
$.
]

=== Autovalores Complexos
<section_autovalores_complexos>

#property[
Para autovalores $lambda_{1,2} = alpha ± i beta$ ($beta ≠ 0$) com autovetor complexo
$v = u + i w$, obtém-se a solução real

$
  x(t) =
    e^(alpha t)
    [
      c_1 · ( u · cos(beta t) − w · sin(beta t) )
      +
      c_2 · ( u · sin(beta t) + w · cos(beta t) )
    ].
$

Classificação rápida:

- *Espiral estável*: $alpha < 0$
- *Espiral instável*: $alpha > 0$
- *Centro*: $alpha = 0$
]

=== Classificação de Pontos Críticos (2 × 2)
<section_classificacao_pontos_criticos>

#property[
Seja $A in RR^(2 times 2)$ com autovalores $lambda_1$ e $lambda_2$.

- *Nó estável*: $lambda_1 < 0$, $lambda_2 < 0$ (com $t -> oo$ a porra toda vai pra $0$)

- *Nó instável*: $lambda_1 > 0$, $lambda_2 > 0$ (com algum autovalor positivo, $t -> oo => $ a porra toda diverge)

- *Ponto de sela*: $lambda_1 · lambda_2 < 0$ (se tiver um negativo e outro positivo, converge de ladinho e diverge de ladinho também)

- *Espiral estável*: $alpha < 0$ e $beta ≠ 0$ (com $t -> oo$ a porra toda vai pra $0$)

- *Espiral instável*: $alpha > 0$ e $beta ≠ 0$ (com algum autovalor positivo, $t -> oo => $ a porra toda diverge)

- *Centro*: $alpha = 0$ e $beta ≠ 0$ (mó paz)
]


