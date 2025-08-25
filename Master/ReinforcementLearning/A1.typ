#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages, stroke: 1pt + luma(100))

#set page(width: 21cm, height: 30cm, margin: 1.5cm)

#set par(
  justify: true
)

#set figure(supplement: "Figura")

#set heading(numbering: "1.1.1")
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



// ============================ PRIMEIRA PÁGINA =============================
#align(center + top)[
  FGV EMAp

  João Pedro Jerônimo
]

#align(horizon + center)[
  #text(17pt)[
    Aprendizado por Reforço
  ]
  
  #text(14pt)[
    Anotações
  ]
]

#align(bottom + center)[
  Rio de Janeiro

  2025
]

#pagebreak()

// ============================ PÁGINAS POSTERIORES =========================
#outline()

#pagebreak()

= Introdução

O Aprendizado por Reforço pode ser entendido como um terceiro paradigma da aprendizagem estatística (Separado do aprendizado supervisionado e não-supervisionado). Uma das principais características dele é que ele envolve um objetivo final e meu modelo vai aprender de acordo com *recompensas* que ele receber, ou seja, meu modelo vai tentar sempre *maximizar* a recompensa que ele receber.

#image("images/rl-system.png")

Perceba que o agente interage com o ambiente e esse retorna dois tipos de output, o novo estado que o agente se encontra e o quanto de recompensa que este recebeu.

O modelo vai, com base nessas informações obtidas pelo meu ambiente, aprender a tomar decisões dependendo do estado que se encontra e da recompensa que recebeu de acordo com a última ação

== Aprendizado por Reforço como Cadeia de Markov
Estamos num sistema onde o estado atual e as ações que eu tomei anteriormente influenciam diretamente nas ações que tomarei. Ou seja, podemos pensar no modelo como uma *cadeia de markov*

== Elementos de um problema de Aprendizado por Reforço
#definition("Política/Policy")[
  É uma função $pi: S' -> A$ onde $S$ é o espaço de estados e $A$ é o espaço de ações, ou seja, é a função que dita qual será minha ação de acordo com o estado atual que eu estou. As políticas podem ser definidas em determinísticas (Sempre escolhem a mesma ação para determinados estados) ou estocásticas (Escolhem ações com base em uma distribuição de probabilidade)
]<policy>

#definition("Recompensa/Reward")[
  É um sinal numérico que o agente recebe do ambiente depois de tomar uma ação
]<reward>

#definition("Função de Valor/Value Function")[
  É uma função $omega: S -> RR$ que mapeia os estados para suas respectivas recompensas. Expressa a recompensa a longo-prazo que o agente pode receber a partir de um estado. Também podemos usá-la para saber a qualidade de uma *política*
]<value-function>

#definition("Modelo do Ambiente/Model of the Enviroment")[
  É um mapeamento $psi$ que mapeia estados e ações para próximos estados e recompensas. Indica como o ambiente se comporta de acordo com as ações do meu agente. Pode ser usado para simular o ambiente e prever as consequências das ações do meu agente
]

Então podemos resumir o processo de aprendizagem por reforço como encontrar uma política *ótima* para um problema

== Programação Dinâmica e Controle Ótimo

#definition("Programação Dinâmica")[
  Método de resolver um problema maior dividindo-o em subproblemas menores, combinando as soluções daqueles problemas menores em uma solução para o problema maior
]

#definition("Controle Ótimo")[
  Problema de encontrar a política que maximiza a recompensa esperada a longo-prazo. Esse problema pode ser resolvido utilizando de métodos da programação dinâmica
]


