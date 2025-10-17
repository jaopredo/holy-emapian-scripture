#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)
#import "@preview/wrap-it:0.1.1"

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

#set heading(numbering: "1.1.1")

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

// ============================ PRIMEIRA PÁGINA =============================
#align(center + top)[
  FGV EMAp

  Escrita:  Thalis Ambrosim Falqueto ]

#align(horizon + center)[
  #text(17pt)[
    Projeto e Análise de Algoritmos
  ]
  
  #text(14pt)[
    Revisão para A2
  ]
]

#align(bottom + center)[
  Rio de Janeiro

  2025
]

#pagebreak()

// ============================ PÁGINAS POSTERIORES =========================
#outline(title: "Conteúdo")

#pagebreak()

#align(center + horizon)[
  = Técnicas de Projeto
]

#pagebreak()

== Método guloso (Greedy)

O método guloso é uma famoso paradigma utilizado para projetos de algoritmo, onde a estratégia consiste em escolher a cada iteração a opção com maior valor, e avaliar se deve ser adicionada ao resultado final.

Seguindo essa abordagem, as opções precisam ser ordenadas pro algum critério. Costuma ser simples e eficiente, porém nem todo projeto pode ser resolvido através dessa abordagem.

#example[  Agendamento de tarefas

 Dado o conjunto de tarefas $T = {t_1, t_2, ... ,t_n}$ com $n$ elementos, cada uma ocm tempo de ínicio ```start [tk]```, e um tempo de término ```end [tk]```, encontre o maior subconjunto de tarefas que pode ser alocado sem sobreposição temporal.

#figure(
  caption: [Exemplo do problema de agendamento],
  image("images/agendamentoexample.png",width: 80%)
)
]

Vamos projetar a solução!

Perguntas: 
+ Quais serão as opções a serem avaliadas a cada iteração? 
  - Conjunto de tarefas que ainda não foi alocada ou descartada.
+ Qual critério iremos utilizar para ordenar as opções? 
  - Tempo de ínicio?
  - Menor duração?
  - Menor número de projetos?
  - Tempo de término?

Vamos analisar cada critério tentando construir ao menos um cenário que demonstre que o critério gera um resultado não-ótimo.

Que tal se colocarmos o critério de seleção como o tempo de início do agendamento?

#figure(
  caption: [Exemplo do problema de agendamento],
  image("images/agendamentoexruim1.png",width: 80%)
)

Isso não daria certo, 
=== pq

E se escolhessemos pela menor duração?

#figure(
  caption: [Exemplo do problema de agendamento],
  image("images/agendamento-ex-ruim-2.png",width: 80%)
)

Tudo deu errado... Mas e se nosso critério fosse o tempo do término?

Ideia geral:

- Ordene a lista pelo tempo de término em uma lista $T$.
- Crie um conjunto $T_a$ para armazenar as tarefas a serem alocadas
- Insira a primeira tarefa da lista $t_0$ em $T_a$ e defina $t_"prev" = t_0$
- Para cada tarefa $t_k$ em $T$:
  - se `start[`$t_k$`]` $>=$ `end[`$t_"prev"$`]:`
    - adicione $t_k$ em $T_a$
    - defina $t_"prev" = t_k$
- retorne $T_a$.

Essa ideia não é muito difícil. Como a lista é ordenada pelo horário de saída, então o primeiro elemento a ser adicionado é simplesmente o primeiro elemento. Note que, como o objetivo é apenas a quantidade máxima de tarefas, e não o tempo máximo que podemos otimizar para todas as tarefas que temos, então pegar o menor término *desde o início* é o que realmente faz o algoritmo funcionar (por exemplo, se tivéssemos os horários `[(5,10),(5,12)]`,
pegar o menor tempo de saída nos ajudaria no caso de termos outra tarefa, coomo `(11,14)`).

Após selecionarmos a primeira tarefa da lista, basta compararmos os tempos de entrada das próximas tarefas, já que, pelo mesmo raciocínio do porque escolher a menor saída, se a próxima tarefa não colidir com a saída passada, então podemos pegar nossa nova tarefa e atulizar com o tempo de saída da nova tarefa atual.

Nosso pseudocódigo usa apenas um for sem nada demais dentro dele, mas precisamos ordenar a lista antes. Isso nos traz uma complexidade de $Theta(n log(n))$.

#figure(
  grid(
  columns: 2,
  column-gutter: 1em,
  image("images/tarefa-example.png", width: 100%),
  image("images/tarefa-example-correta.png", width: 100%),
),
  caption: [Solução para o problema de tarefas usando o algoritmo proposto]
)

=== explicar pq é ótima

Vamos a um segundo problema:

#example[ Mochila fracionária

Dado um conjunto de itens $II = {1,2,3,...,n}$ em que cada item $i in II$ tem um peso $w_i$ e um valor $v_i$, e uma mochila com capacidade de peso $W$, encontre o subconjunto $S subset.eq II$ tal que $sum_(i in S)^(|S|) alpha_i w_i <= W $ e $sum_(i in S)^(|S|) alpha_i v_i $ seja máximo, considerando que $0 < alpha_k <= 1$.

#figure(
  caption: [Tabela de exemplo para o exemplo da mochila],
  image("images/tabela-mochila.png",width: 40%)
)

Exemplo:
  - W = 9
    - A escolha ${1,2,3}$ tem peso 8, valor 12 e cabe na mochila;
    - A escolha ${3,5}$ tem peso 11, valor 14 e *não* cabe na mochila 
    - A escolha ${}$

]