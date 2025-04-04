// Lembrar que não estamos usando o latex, ou seja, não devemos usar "\" para comandos e não devemos deixar letras juntas com comandos, como em "\mathbb{R}^m" que deve ser escrito como "RR^m".

// #set heading(numbering: "1.")

#let int = $integral$
#let supp = "supp"
#let cl = "cl"
#let qed = align(right, text(12pt)[$square$])
#let dx = $d x$
#let dif = $d/dx$
#let cdot = $dot.c$

#set page(numbering: "1")

#align(right, text(12pt)[
  FGV - EMAP
])


#align(center, text(17pt)[
  A1 2020 Pobrebilidade - To aprendendo typst

  #datetime.today().display("[day]/[month]/[year]")
])

= Exercício 1
== A probabilidade de uma pessoa que fuma ter câncer de pulmão é 20 vezes maior doque as que não fumam. Em uma certa população, 10% das pessoas fumam. Se uma pessoa escolhida ao acaso nessa população tem câncer de pulmão, qual é a probabilidade de que ela seja fumante?

=== Solução

Queremos $P(F|C)$, onde C é o evento no qual a pessoa tem câncer de pulmão e F o evento na qual ela fuma, sabemos que vale $P(C|F) = 20 P(C|F^c)$, logo façamos:

$
  P(C|F) + P(C|F^c) = 20 P(C|F^c) + P(C|F^c)\ = P(C) = 21P(C|F^c),
$

E pelo Teorema de Bayes:

$
  P(F|C) = (P(C|F)P(F)) / P(C)  = (20 P(C|F^c) 1/10) / (21 P(C|F^c)) = 2/21.
$