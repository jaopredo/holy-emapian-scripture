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


= Integrais de Superfície
<section_integral_superficie>

== Integrais de Superfície Escalares
<section_integral_superficie_escalar>

== Integrais de Superfície Vetoriais
<section_integral_superficie_vetorial>

= Operadores Diferenciais
<section_operadores_diferenciais>

= Teorema de Green
<section_teorema_de_green>

= Teorema de Stokes
<section_teorema_de_stokes>

= Teorema da Divergência
<section_teorema_da_divergencia>




