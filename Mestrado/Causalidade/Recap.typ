#import "@preview/wrap-it:0.1.1"
#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages, stroke: 1pt + luma(100))

#import "@preview/tablex:0.0.9": tablex, rowspanx, colspanx, cellx

#set page(width: 21cm, height: 30cm, margin: 1.5cm)

#set par(
  justify: true
)

#set figure(supplement: "Figura")

#set heading(numbering: none)

#let theorem = thmbox("theorem", "Teorema")
#let corollary = thmplain(
  "corollary",
  "Corolário",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definição", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Exemplo").with(numbering: none)
#let proof = thmproof("proof", "Demonstração")

#set math.equation(
  numbering: "(1)",
  supplement: none,
)
#show ref: it => {
  // provide custom reference for equations
  if it.element != none and it.element.func() == math.equation {
    // optional: wrap inside link, so whole label is linked
    link(it.target)[(#it)]
  } else {
    it
  }
}

#set text(
  font: "Atkinson Hyperlegible",
  size: 12pt,
)

#show heading: it => {
  if it.level == 1 {
    [
      #block(
        width: 100%,
        height: 1cm,
        text(
          size: 1.5em,
          weight: "bold",
          it.body
        )
      )
    ]
  } else {
    it
  }
}


#align(center + top)[
FGV EMAp

João Pedro Jerônimo
]

#align(center + horizon)[
  #text(17pt)[
    Causalidade
  ]

  #text(14pt)[
    Resumo
  ]
]

#align(center + bottom)[
Rio de Janeiro

2026
]

#pagebreak()

#outline(title: "Sumário")

#pagebreak()

#align(center+horizon)[
  = Introdução
]

#pagebreak()

A matéria de causalidade não foi passada como outras. Na primeira parte do curso (A1), os alunos apresentam seminários baseados em papers que revolucionaram e tiveram marco dentro da área da causalidade, e na (A2) os alunos apresentam seminários baseados em papers que aplicam a causalidade em áreas específicas de seu interesse. Por isso, esse resumo será mais focado nos papers já estabelecidos da primeira parte do curso (As apresentações dos alunos se encontram aqui: \<link\>). Já sobre os temas da segunda parte, como é algo que sempre varia de semestre a semestre, apenas adicionarei as apresentações na pasta de materiais, para que os alunos possam consultar. Além disso, eu criei um repositório com alguns exemplos e testes que fiz para aprender melhor a matéria, para acessá-lo, basta clicar #link("https://github.com/jaopredo/causality", "aqui").
