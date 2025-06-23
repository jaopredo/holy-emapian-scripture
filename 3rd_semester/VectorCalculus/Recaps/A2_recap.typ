#import "@preview/ctheorems:1.1.3": *
#import "@preview/plotst:0.2.0": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#codly(languages: codly-languages)

#show: codly-init.with()
#show: thmrules.with(qed-symbol: $square$)
#show link: underline
#show ref: underline

#set heading(numbering: "1.1.")
#set page(numbering: "1")
#set heading(numbering: "1.")
#set math.equation(
  numbering: "(1)",
  supplement: none,
)

#set par(first-line-indent: 1.5em,justify: true)
#show ref: it => {
  // provide custom reference for equations
  if it.element != none and it.element.func() == math.equation {
    // optional: wrap inside link, so whole label is linked
    link(it.target)[eq.~(#it)]
  } else {
    it
  }
}

#let theorem = thmbox("theorem", "Theorem", fill: rgb("#ffeeee")) //theorem color
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: "1.")
#let proof = thmproof("proof", "Proof")

//shortcuts

#let inv(arg, power) = $arg^(-power)$
#let herm(arg) = $arg^*$
#let transpose(arg) = $arg^T$
#let inner(var1, var2) = $angle.l var1, var2 angle.r$
#let Var(arg) = $"Var"(arg)$
#let int = $integral$
#let rot(arg) = $"rot"(arg)$
#let div(arg) = $"div"(arg)$
#let Jac(arg) = $"Jac"(arg)$

#align(center, text(20pt)[
 *Resumo da A2 de Cálculo Vetorial*
])

#align(center, text(15pt)[
  Arthur Rabello Oliveira\
  #datetime.today().display("[day]/[month]/[year]")
])

//  TABLE OF CONTENTS ----------------------------------
#outline()
#pagebreak()

= Revisão da A1
<section_revisao_a1>
== Integrais de Linha
<section_integral_linha>
=== Integrais de Linha Escalares
<section_integral_linha_escalar>

Dada $f: RR^n -> RR$ uma função escalar e $gamma: [a, b] -> RR^n$ uma curva, a integral de $f$ sobre $gamma$ é:

$
  int_gamma f d S = int_a^b f(gamma(phi)) dot norm(gamma^' (phi)) d phi
$ <equation_line_integral>

=== Integrais de Linha Vetoriais
<section_integral_linha_vetorial>

Se for $F: RR^n -> RR^n$ um campo vetorial:

$
  int_gamma F d S = int_a^b F(gamma(phi)) dot gamma^' (phi) d phi
$ <equation_line_integral_vectorial>

=== Integral de Linha de um Campo Conservativo
<section_line_integral_conservativo>

Se $F: RR^n -> RR^n$ for conservativo, com $f::RR^n -> RR$, $gradient f = F$ e $c:[a, b] -> RR^n$, temos:

$
  int_c F d S = f(c(b)) - f(c(a))
$ <equation_line_integral_conservativo>

E são equivalentes:

+ $F$ é conservativo

+ $int_c F d S = 0$ para todo caminho fechado $c$

+ $integral.cont_c F = 0$

= Integrais de Superfície
<section_integral_superficie>
== Integrais de Superfície Escalares
<section_integral_superficie_escalar>

Lembrando que uma _superfície_ é uma função:

$
  phi: D subset RR^2 -> RR^3
$

Onde $D$ é fechado e limitado.

Se $f:RR^n -> RR$ é função escalar e $S$ uma superfície, a integral de $f$ sobre $S$ é:

$
  integral.double_S f d S = integral.double_D f(phi(u, v)) dot norm(phi_u times phi_v) d u d v
$

== Integrais de Superfície Vetoriais
<section_integral_superficie_vetorial>

Se for $F:RR^ -> RR^n$ um campo vetorial, o *fluxo* de $F$ sobre a superfície $S$ é:

$
  integral.double_S F d S = integral.double_S F dot hat(n) d S =  integral.double_D F(phi(u, v)) dot (phi_u times phi_v) d u d v
$

O vetor $hat(n)$ é o vetor unitário normal à superfície $S$. Note que $integral.double_S F dot hat(n) d S$ é uma integral escalar.

= Operadores Diferenciais
<section_operadores_diferenciais>

== Gradiente
<section_gradiente>

O gradiente $gradient$ de $f:RR^n -> RR$ é:

$
  gradient f = ((partial f) / (partial x_1), dots , (partial f) / (partial x_n))
$ <equation_definition_gradiente>

== Rotacional
<section_rotacional>

Dada $F: RR^3 -> RR^3, F = (F_1, F_2, F_3)$ um campo vetorial, o rotacional de $F$ é:

$
  rot(F) = gradient times F\

  = ((partial F_3) / (partial y) - (partial F_2) / (partial z), (partial F_1) / (partial z) - (partial F_3) / (partial x), (partial F_2) / (partial x) - (partial F_1) / (partial y))
$

Se for $F:RR^2 -> RR^2, F = (F_1, F_2)$, o rotacional fica:

$
  rot(F) = (partial F_2) / (partial x) - (partial F_1) / (partial y)
$

== Laplaciano
<section_laplaciano>

Dada $f:RR^ -> RR$, o laplaciano é:

$
  laplace f = div(gradient f) = (partial^2 f) / (partial x_1^2) + dots + (partial^2 f) / (partial x_n^2)
$ <equation_definition_laplaciano>

Se $laplace f = 0$, $f$ é dita _harmônica_.

= Propriedades dos Operadores Diferenciais
<section_propriedades_operadores_diferenciais>

+ div, rot, $gradient$ são lineares

+ $div(rot(F)) = 0$ para todo campo vetorial $F:RR^3 -> RR^3$

+ $gradient(f dot g) = f gradient g + g gradient f$

+ $gradient(f / g) = (g gradient f - f gradient g) / g^2$

+ $div(f dot F) = gradient f dot F + div(F) dot f$

+ $div(F times G) = G rot(F) - F rot(G)$

+ $rot(f dot F) = f rot(F) + gradient f times F$

+ $div(gradient f times gradient g) = 0$

+ $laplace (f dot g) = f laplace g + 2 gradient f gradient g + g gradient f$

= Teorema de Green
<section_teorema_de_green>

Seja $D$ fechada limitada de $RR^2$, com $partial D$ orientada positivamente, $C^1$ por partes de forma que $partial D$ seja percorrida _uma_ vez. Se $F = (F_1, F_2)$ é um campo vetorial definido num aberto que contém $D$, então:

$
  int_(partial D) F dot d S = integral.double_D rot(F) dot d S =  integral.double_D ((partial F_2) / (partial x) - (partial F_1) / (partial y)) d A
$ <equation_teorema_de_green>

= Teorema de Stokes
<section_teorema_de_stokes>

Analogamente ao Teorema de Green, temos:

$
  integral_(delta S) F dot d arrow(r) = integral.double_S rot(F) dot d S
$ <equation_teorema_de_stokes>

Mas aqui $F: RR^3 -> RR^3$.

= Teorema da Divergência
<section_teorema_da_divergencia>

Seja $V$ uma região fechada e limitada de $RR^3$, de forma que $partial D$ seja uma superfície com vetores normais exteriores, então:

$
  integral.double_(partial V) F dot hat(n) d S = integral.triple_V div(F) d V
$

= Fatos úteis
<section_fatos_uteis>

1. O campo $F(x, y, z) = (x^2 + y^2 + z^2)^(-3/2) dot (x, y, z)$ é tal que $integral.double_S F d S = 4 pi$, para toda superfície $S$ fechada que delimite um sólido e contenha a origem.

2. Coordenadas esféricas:

$
  x = rho sin(theta) cos(phi),\
  y = rho sin(theta) sin(phi),\
  z = rho cos(theta)\

  Jac = rho^2 sin(theta)
$ <equation_spherical_coordinates>

3. Coordenadas cilíndricas:

$
  x = r cos(theta),\
  y = r sin(theta),\
  z = z\
  Jac = r
$ <equation_cylindrical_coordinates>

4. O campo $F(x, y) = (x^2 + y^2)^(-1) dot (-y, x)$ é tal que $integral_c F$ é a variação de ângulo da curva $c$

5. 






