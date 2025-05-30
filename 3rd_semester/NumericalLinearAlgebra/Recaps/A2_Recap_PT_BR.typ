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
// ATALHOS:
#let herm(term) = $term^*$
#let inv(term) = $term^(-1)$
#let transp(term) = $term^T$


// ============================ PRIMEIRA PÁGINA =============================
#align(center + top)[
  FGV EMAp

  João Pedro Jerônimo e Arthur Rabello Oliveira
]

#align(horizon + center)[
  #text(17pt)[
    Algebra Linear Numérica
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
#outline()

#pagebreak()

// ========================== CONTEÚDO ======================================

#block(
  width: 100%,
  fill: rgb(255, 148, 162),
  inset: 1em,
  stroke: 1.5pt + rgb(117, 6, 21),
  radius: 5pt
)[
  *Nota*: Os *computadores ideais* que mencionaremos, são computadores nos quais o _axioma fundamental da aritmética de ponto flutuante_ é satisfeito. Convidamos o leitor a ler sobre isso no resumo anterior (A1), especificamente na *lecture 13*
]

Esse é um resumo feito por João Pedro Jerônimo (Ciência de Dados) e Arthur Rabello (Matemática Aplicada) com objetivo de traduzir os hieróglifos contidos no livro de #underline[#link("https://gvmail-my.sharepoint.com/:b:/g/personal/b435911_fgv_edu_br/EWLInlwjad1IqYMi_cDcTcsBvwp2_fzO6Oq8-YAEtjV6pg?e=UbXOk8")[Álgebra Linear Numérica do Trefthen e do Bau]]

#align(center + horizon)[
  #text(30pt)[\u{1F44D}]
]

#pagebreak()

#align(center + horizon)[
  = Lecture 16 - Estabilidade da Triangularização de Householder
]

#pagebreak()

Nesse capítulo, a gente tem uma visão mais aprofundada da análise de *erro retroativo* (Backwards Stable). Dando uma breve recapitulada, para mostrar que um algoritmo $accent(f, ~): X -> Y$ é *backwards stable*, você tem que mostrar que, ao aplicar $accent(f, ~)$ em uma entrada $x$, o resultado retornado seria o mesmo que aplicar o problema original $f: X->Y$ em uma entrada levemente perturbada $x + Delta x$, de forma que $Delta x = O(epsilon_"machine")$.

== O Experimento
O livro nos mostra um experimento no matlab para demonstrar a estabilidade em ação e alguns conceitos importantes, irei fazer o mesmo experimento, porém, utilizarei código em python e mostrarei meus resultados aqui.

Primeiro de tudo, mostraremos na prática que o algoritmo de *Householder* é *backwards stable*. Vamos criar uma matriz $A$ com a fatoração $Q R$ conhecida, então vamos gerar as matrizes $Q$ e $R$. Aqui, temos que $epsilon_"machine" = 2.220446049250313 times 10^(-16)$:

```python
  import numpy as np
  np.random.seed(0)  # Ter sempre os mesmos resultados
  # Crio R triangular superior (50 x 50)
  R_1 = np.triu(np.random.random_sample(size=(50, 50)))
  # Crio a matriz Q a partir de uma matriz aleatória
  Q_1, _ = np.linalg.qr(np.random.random_sample(size=(100, 50)), mode='reduced')
  # Crio a minha matriz com fatoração QR conhecida (A = Q_1 R_1)
  A = Q_1 @ R_1
  # Calculo a fatoração QR de A usando Householer
  Q_2, R_2 = householder_qr(A)
```<hh-comparison>

Sabemos que, por conta de erros de aproximação, a matriz $A$ que temos no código não é *exatamente* igual a que obteríamos se tivéssemos fazendo $Q_1 R_1$ na mão, mas é preciso o suficiente. Podemos ver aqui que elas são diferentes:

#grid(
  columns: (60%, 40%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      offset-from: <hh-comparison>,
      inset: 0.25em
    )
    ```python
      print(np.linalg.norm(Q_1 - Q_2))
      print(np.linalg.norm(R_1 - R_2))
    ```<matrices-differences>
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
      7.58392995752057e-8
      8.75766271246312e-9
    ```
  ]
)

Perceba que é um erro muito grande, não é tão próximo de $0$ quanto eu gostaria, se eu printasse as matrizes $Q_2$ e $R_2$ eu veria que, as entradas que deveriam ser $0$, tem erro de magnitude $approx 10^(17)$. Bem, se ambas tem um erro tão grande, então o resultado da multiplicação delas em comparação com $A$ também vai ser grande, correto? 

#grid(
  columns: (60%, 40%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      offset-from: <matrices-differences>,
      inset: 0.25em
    )
    ```python
      print(np.linalg.norm(A - Q_2 @ R_2))
    ```<difference-A>
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
    3.8022328832723555e-14
    ```
  ]
)

Veja que, mesmo minhas matrizes $Q_2$ e $R_2$ tendo erros bem grandes com relação às matrizes $Q_1$ e $R_2$, conseguimos uma aproximação de $A$ bem precisa com ambas. Vamos agora dar um destaque nessa acurácia de $Q_2 R_2$:

#grid(
  columns: (60%, 40%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      inset: 0.25em
    )
    ```python
      delta_Q_1 = np.random.random_sample(size=Q_1.shape)
      delta_R_1 = np.random.random_sample(size=R_1.shape)
      Q_3 = Q_1 + delta_Q_1 * 1e-4
      R_3 = R_1 + delta_R_1 * 1e-4
      print(np.linalg.norm(A - Q_3 @ R_3))
    ```
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
    0.05197521348918455
    ```
  ]
)

Perceba o quão grande é esse erro, é *enorme*, então: $Q_2$ não é melhor que $Q_3$, $R_2$ não é melhor que $R_3$, mas $Q_2R_2$ é muito mais preciso do que $Q_3R_3$

== Teorema
Vamos ver que, de fato, o algoritmo de *Householder* é *backwards stable* para toda e qualquer matriz $A$. Fazendo a análise de backwards stable, nosso resultado precisa ter esse formato aqui:
$
  accent(Q, ~)accent(R, ~) = A + delta A
$
com $||delta A|| \/ ||A|| = O(epsilon_"machine")$. Ou seja, calcular a $Q R$ de $A$ pelo algoritmo é o mesmo que calcular a $Q R$ de $A + delta A$ da forma matemática. Mas aqui temos uns adendos.

A matriz $accent(R, ~)$ é como imaginamos, a matriz triangular superior obtida pelo algoritmo, onde as entradas abaixo de 0 podem não ser exatamente 0, mas *muito próximas*.

Porém, $accent(Q, ~)$ *não é aproximadamente* ortogonal, ela é *perfeitamente* ortogonal, mas por quê? Pois no algoritmo de Householder, não calculamos essa matriz diretamente, ela fica "_implícita_" nos cálculos, logo, podemos assumir que ela é perfeitamente ortogonal, já que o computador não a calcula, ou seja, não há erros de arredondamento. Vale lembrar também que $accent(Q, ~)$ é definido por:
$
  accent(Q, ~) = accent(Q, ~)_1accent(Q, ~)_2...accent(Q, ~)_n
$
De forma que $accent(Q, ~)$ é perfeitamente unitária e cada matriz $accent(Q, ~)_j$ é definida como o refletor de householder no vetor de floating point $accent(v_k, ~)$ (Olha a página 73 do livro pra você relembrar direitinho o que é esse vetor $accent(v_k, ~)$ no algoritmo). Lembrando que $accent(Q, ~)$ é perfeitamente ortogonal, já que eu não calculo ela no computador diretamente, se eu o fizesse, então ela não seria perfeitamente ortogonal, teriam pequenos erros.

#theorem("Householder's Backwards Stability")[
  Deixe que a fatoração QR de $A in CC^(m times n)$ seja dada por $A = Q R$ e seja computada pelo algoritmo de *Householder*, o resultado dessa computação são as matrizes $accent(Q, ~)$ e $accent(R, ~)$ definidas anterioremente. Então temos:
  $
    accent(Q, ~) accent(R, ~) = A + delta A
  $
  Tal que:
  $
    (||delta A||)/(||A||) = O(epsilon_"machine")
  $
  para algum $delta A in CC^(m times n)$
]

== Algoritmo para resolver $A x = b$
Vimos que o algoritmo de householder é backwards stable, show! Porém, sabemos que não costumamos fazer essas fatorações só por fazer né, a gente faz pra resolver um sistema $A x = b$, ou outros tipos de problemas. Certo, mas, se fizermos um algoritmo que resolve $A x = b$ usando a fatoração QR obtida com householder, a gente precisa que $Q$ e $R$ sejam precisos? Ou só precisamos que $Q R$ seja preciso? O bom é que precisamos apenas que $Q R$ seja precisa! Vamos mostrar isso para a resolução de sistemas $m times m$ não singulares.

#figure(
  kind: "algorithm",
  supplement: [Algoritmo],
  caption: [Algoritmo para calcular $A x = b$],
  pseudocode-list(booktabs: true)[
    + *function* ResolverSistema($A in CC^(m times n)$, $b in CC^(m times 1)$) {
      + $Q R = "Householder"(A)$
      + $y = Q^* b$
      + $x = R^(-1)y$
      + *return* $x$
    + }
  ]
)<solve-Axb-hh>

Esse algoritmo é *backwards stable*, e é bem passo-a-passo já que cada passo dentro do algoritmo é *backwards stable*.

#theorem[
  O @solve-Axb-hh para solucionar $A x = b$ é *backwards stable*, satisfazendo
  $
    (A + Delta A)accent(x, ~) = b
  $
  com
  $
    (||Delta A||)/(||A||) = O(epsilon_"machine")
  $
  para algum $Delta A in CC^(m times n)$
]
#proof[
   Quando computamos $accent(Q, ~)^* b$, por conta de erros de aproximação, não obtemos um vetor $y$, e sim $accent(y, ~)$. É possível mostrar (Não faremos) que esse vetor $accent(y, ~)$ satisfaz:
   $
    (accent(Q, ~) + delta Q)accent(y, ~) = b
   $
   satisfazendo $(||delta Q||)/(||accent(Q, ~)||) = O(epsilon_"machine")$
   
   Ou seja, só pra esclarecer, aqui (nesse passo de $y$) a gente ta tratando o problema $f$ de calcular $Q^* b$, ou seja $f(Q) = Q^* b$, então usamos um algoritmo comum $accent(f, ~)(Q) = Q^* b$ (Não matematicamente, mas usando as operações de um computador), daí reescrevemos isso como $accent(f, ~)(Q) = (Q + delta Q)^*b$, por isso podemos reescrever como a equação que falamos anteriormente.

   No último passo, a gente usa *back substitution* pra resolver o sistema $x = R^(-1)y$ e esse algoritmo é *backwards stable* (Isso vamos provar na próxima lecture). Então temos que:
   $
    (accent(R, ~) + delta R)accent(x, ~) = accent(y, ~)
   $
   satisfazendo $(||delta R||)/(||accent(R, ~)||) = O(epsilon_"machine")$

   Agora podemos ir pro algoritmo em si, temos um problema $f(A): "Resolver" A x = b$, daí usamos $accent(f, ~)(A): "Usando householder, resolve" A x = b$. Então, se o algoritmo nos dá as matrizes perturbadas que citei anteriormente ($Q + delta Q$ e $R + delta R$), ao substituir isso por $A$, eu tenho que ter um resultado $A + Delta A$ com $(||Delta A||)/(||A||) = O(epsilon_"machine")$, vamos ver:
   $
    b = (accent(Q, ~) + delta Q)(accent(R, ~) + delta R)accent(x, ~)
   $
   $
    b = (A + delta A + accent(Q, ~) (delta R) + (delta Q) accent(R, ~) + (delta Q) (delta R))accent(x, ~)
   $
   $
    b = (A + Delta A)accent(x, ~) <=> Delta A = delta A + accent(Q, ~) (delta R) + (delta Q) accent(R, ~) + (delta Q) (delta R)
   $

   Como $Delta A$ é a soma de 4 termos, temos que mostrar que cada um desses termos é pequeno com relação a $A$ (Ou seja, mostrar que $(||X||)/(||A||) = O(epsilon_"machine")$ onde $X$ é um dos 4 termos de $Delta A$).

   - $delta A$: Pela própria definição que o algoritmo de householder é backwards stable nós sabemos que $delta A$ satisfaz a condição de $O(epsilon_"machine")$
   - $(delta Q) accent(R, ~)$:
   $
    (||(delta Q) accent(R, ~)||)/(||A||) <= ||(delta Q)|| (||accent(R, ~)||)/(||A||)
   $
   Perceba que
   $
    (||accent(R, ~)||)/(||A||) <= (||accent(Q, ~)^*(A+delta A)||)/(||A||) <= ||accent(Q, ~)^*|| (||A+delta A||)/(||A||)
   $
   Lembra que, quando trabalhamos com $O(epsilon_"machine")$, a gente ta trabalhando com um limite implícito que, no caso, aqui é $epsilon_"machine" -> 0$. Ou seja, se temos que $epsilon_"machine" -> 0$, o erro de arredondamento diminui cada vez mais, certo? Então $delta A -> 0$ ou seja:
   $
    (||accent(R, ~)||)/(||A||) = O(1)
   $
   O que nos indica que
   $
    ||delta Q|| (||accent(R, ~)||)/(||A||) = O(epsilon_"machine")
   $
   - $accent(Q, ~) (delta R)$: Provamos de uma forma similar
   $
    (||accent(Q, ~) (delta R)||)/(||A||) <= ||accent(Q, ~)||(||delta R||)/(||A||) = ||accent(Q, ~)||(||delta R||)/(||accent(R, ~)||) (||accent(R, ~)||)/(||A||) <= ||accent(Q, ~)||(||delta R||)/(||accent(R, ~)||) = O(epsilon_"machine")
   $
   - $(delta Q) (delta R)$: Por último:
   $
    (||(delta Q) (delta R)||)/(||A||) <= ||delta Q|| (||delta R||) / (||A||) = O(epsilon_"machine"^2)
   $
   Ou seja, todos os termos de $Delta A$ são da ordem $O(epsilon_"machine")$, ou seja, provamos que resolver $A x = b$ usando householder é um algoritmo *backwards stable*. Se a gente junta alguns teoremas e temos que:
   
   #theorem[
     A solução $accent(x, ~)$ computada pelo algoritmo satisfaz:
     $
      (||accent(x, ~) - x||)/(||x||) = O(kappa(A) epsilon_"machine")
     $
   ]
]

#pagebreak()

#align(center + horizon)[
= Lecture 17 - Estabilidade da Back Substitution
]

#pagebreak()

Só para esclarecer, o termo *back substitution* se refere ao algoritmo de resolver um sistema triangular superior

$
mat(r_11, r_12, ..., r_(1m);,r_22,...,r_(2m);,,dots.down,dots.v;,,,r_(m m))
mat(x_1;dots.v;x_m) = mat(b_1;dots.v;b_m)
$

E é aquele esquema, a gente vai resolvendo de baixo para cima, o que resulta nesse algoritmo (A gente escreve como uma sequência de fórmulas por conveniência, mas é o mesmo que escrever um loop):

#figure(
  kind: "algorithm",
  supplement: [Algoritmo],
  caption: [Algoritmo de *Back Substitution*],
  pseudocode-list(booktabs: true)[
    + *function* BackSubstitution($R in CC^(m times m)$, $b in CC^(m times 1)$) {
      + $x_m = b_m \/ r_(m m)$
      + $x_(m - 1) = (b_(m - 1) - x_(m)r_(m-1, m)) \/ r_(m-1, m-1)$
      + $x_(m - 2) = (b_(m - 2) - x_(m-1)r_(m-2, m-1) - x_m r_(m-2, m))\/r_(m-2, m-2)$
      + $dots.v$
      + $x_j = (b_j - sum^m_(k=j+1)x_k r_(j k))\/r_(j j)$
    + }
  ]
)<back-substitution>

== Teorema da Estabilidade Retroativa (Backward Stability)
A gente viu no último tópico (Estabilidade de Householder) que a *back substitution* era um dos passos para chegar no resultado final, porém, nós apenas assumimos que ela era *backward stable*, mas a gente *não* provou isso! Porém, antes de provarmos isso, vamos estabelecer que as subtrações serão feitas da esquerda para a direita (Sim, isso pode influenciar). Mas, como o livro não explica muito bem o porquê de isso influenciar, vou dar uma breve explicação e exemplificação:

Quando realizamos uma sequência de subtrações pela *direita*, caso os números sejam muito próximos, pode ocorrer o chamado *cancelamento catastrófico*, que é a perca de muitos dígitos significativos, veja um exemplo:

#grid(
  columns: (50%, 45%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      inset: 0.25em
    )
    ```python
      a = 1e16
      b = 1e16
      c = 1
      print((a-b)-c)
    ```
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
    -1.0
    ```
  ]
)

O que parece correto! Mas veja o que acontece se invertermos a ordem e executarmos $a - (b - c)$

#grid(
  columns: (50%, 45%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      inset: 0.25em
    )
    ```python
      a = 1e16
      b = 1e16
      c = 1
      print(a-(b-c))
    ```
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
    0.0
    ```
  ]
)

Veja que houve um problema no arredondamento! Então os sistemas, por 
convenção, utilizam o esquema de subtrações pela esquerda.

Voltando ao algoritmo de *back substitution*, temos o seguinte teorema:

#theorem[
  Deixe o @back-substitution ser aplicado a um problema de $R x = b$ com $R$ triangular superior em um *computador ideal*. Esse algoritmo é *backward stable*, ou seja, a solução $accent(x, ~)$ computada satisfaz:
  $
    (R + Delta R)accent(x, ~) = b
  $
  para alguma triangular superior $Delta R in CC^(m times m)$ satisfazendo
  $
    (||Delta R||)/(||R||) = O(epsilon_"machine")
  $
]
#proof[
  Essa prova não será muito rigorosa matematicamente, vamos montar a prova para matrizes $1 times 1$, $2 times 2$ e $3 times 3$, de forma que o raciocínio que aplicarmos poderá ser aplicado para matrizes de tamanhos maiores.

  - *$1 times 1$*: Nesse caso, $R$ é um único número escalar e, pelo *@back-substitution*, temos que:
    $
      accent(x_(1), ~) = b_1 div.circle r_11
    $
    E nós *já sabemos* que essa divisão é backward stable, mas vamos analisar melhor. Queremos manter $b$ fixo, então temos que expressar $accent(x_1, ~)$ como o $r_11$ original vezes uma leve perturbação. Expressamos então
    $
      accent(x_(1), ~) = b_1/r_11 (1+epsilon_1)
    $
    Se definirmos $epsilon_1^' = (-epsilon_1)/(1+epsilon_1)$, podemos reescrever a equação assim:
    $
      accent(x_1, ~) = b_1 / (r_11 (1+epsilon_1^')) <=> accent(x_1, ~) = b_1 / (r_11 (1 - epsilon_1/(1+epsilon_1))) <=> accent(x_1, ~) = b_1 / (r_11 (1 + epsilon_1 - epsilon_1)/(1+epsilon_1)) \
      <=> accent(x_1, ~) = b_1 / (r_11 1/(1+epsilon_1)) <=> accent(x_1, ~) = b_1 / r_11 (1+epsilon_1)
    $
    Se fizermos a expansão de taylor de $epsilon_1^'$, conseguimos ver:
    $
      -epsilon_1/(1+epsilon_1) = -epsilon_1 + epsilon_1^2 - epsilon_1^3 + epsilon_1^4 - ...
    $
    Ou seja, $-epsilon_1 + O(epsilon_1^2)$, o que mostra que $1+epsilon_1^'$ é uma perturbação válida para o teorema da estabilidade backwards, o que nos mostra também que
    $
      (r_11 + delta r_11)accent(x_1, ~)=b_1
    $
    Com
    $
      (||delta r_11||)/(||r_11||) <= epsilon_"machine" + O(epsilon_"machine"^2)
    $

  - *$2 times 2$*: Beleza, no caso $2 times 2$, o primeiro passo do algoritmo nós já vimos que é *backwards stable*, vamos para o segundo passo:
    $
      accent(x_1, ~) = (b_1 minus.circle (accent(x_2, ~) times.circle r_12)) div.circle r_22
    $
    Ai meu Deus, fórmula grande do djabo :\(. Relaxa, vamo transformar em fórmulas normais com umas perturbações pra gente falar de matemática normal né
    $
      accent(x_1, ~) = ((b_1 - accent(x_2, ~) r_12 (1+epsilon_2))(1+epsilon_3)) / r_22 (1+epsilon_4)
    $
    Aqui eu não iniciei os epsilons em $epsilon_1$ porque eu estou tomando intrínseco que esse $epsilon_1$ ta no $accent(x_2, ~)$ que a gente computa antes de computar o $accent(x_1, ~)$ (A gente computa igual o caso $1 times 1$)

    Podemos definir $epsilon_3^' = -epsilon_3/(1+epsilon_3)$ e $epsilon_4^' = - epsilon_4/(1+epsilon_4)$, assim, podemos reescrever:
    $
      accent(x_1, ~) = (b_1 - accent(x_2, ~) r_12 (1+epsilon_2))/(r_22 (1+epsilon_3^')(1+epsilon_4^'))
    $
    (Mesmo racicocínio que usamos no caso $1 times 1$). A gente viu em alguns exercícios da lista que $(1+O(epsilon_"machine"))(1+O(epsilon_"machine")) = 1 + O(epsilon_"machine")$, com isso em mente, podemos reescrever a equação como
    $
      accent(x_1, ~) = (b_1 - accent(x_2, ~) r_12 (1+epsilon_2))/(r_22 (1+2epsilon_5^'))
    $
    Esse $2epsilon_5$ se dá pois, como vimos no caso $1 times 1$:
    $
      1 + epsilon_3^' = 1 - epsilon_3 + O(epsilon_3^2) \
      1 + epsilon_4^' = 1 - epsilon_4 + O(epsilon_4^2) \
      => (1+epsilon_3^')(1+epsilon_4^') = (1 - epsilon_3 + O(epsilon_3^2))(1 - epsilon_4 + O(epsilon_4^2)) \
      => 1 - epsilon_4 + O(epsilon_4^2) - epsilon_3 + epsilon_3epsilon_4 - epsilon_3 O(epsilon_4^2) + O(epsilon_3^2) - epsilon_4 O(epsilon_3^2) + O(epsilon_4^2)O(epsilon_3^2)
    $
    Os termos diferentes de $1$, $epsilon_3$ e $epsilon_4$ são irrelevantes, pois são *MUITO* pequenos, o que nos dá
    $
      1 - epsilon_4 - epsilon_3 = 1 - 2epsilon_5
    $
    Voltando ao foco, acabamos de mostrar que, se $r_11$, $r_12$ e $r_22$ fossem perturbados por fatores $2epsilon_5$, $epsilon_2$ e $epsilon_1$ *respectivamente*, a conta feita para calcular $b_1$, no computador, seria *exata*. Podemos expressar isso na forma
    $
      (R + delta R)accent(x_1, ~) = b_1
    $
    De forma que
    $
      delta R = mat(2|epsilon_5|, |epsilon_2|; ,|epsilon_1|)
    $

  - *A Indução*: Suponha que, no ($j-1$)-ésimo passo do algoritmo, eu sei que o $accent(x, ~)_(j-1)$ é gerado com um algoritmo backward stable. Nós já mostramos, pelos casos bases, que os primeiros dois passos são backward stable.
    Vamos relembrar o @back-substitution para $m$ colunas:
    $
    accent(x, ~)_j = (b_j minus.circle sum^m_(k=j+1)x_k times.circle r_(j k)) div.circle r_(j j)
    $
    Usando o *Axioma Fundamental do Ponto Flutuante*:
    $
      accent(x, ~)_j = (
        (b_j - sum^m_(k=j+1)x_k r_(j k)(1+epsilon_k)) (1+epsilon_(m+1))
      ) / r_(j j) (1 + epsilon_(m+2))
    $
    Definindo $epsilon_(m+1)^'$ e $epsilon_(m+2)^'$ de forma análoga a que fizemos anteriormente:
    $
      accent(x, ~)_j = (
        b_j - sum^m_(k=j+1)x_k r_(j k)(1+epsilon_k)
      ) / (r_(j j) (1+epsilon_(m+1)^') (1 + epsilon_(m+2)^'))
    $
    Novamente, estamos expressando $accent(x, ~)_j$ como operações em $x_k$ e $b_j$ e com entradas *perturbadas* de $R$, mostrando que o algoritmo do *back substitution* é sim *backward stable*
]

#pagebreak()

#align(center + horizon)[
  = Lecture 18 - Condicionando Problemas de Mínimos Quadrados
]

#pagebreak()

#block(
  width: 100%,
  fill: rgb(255, 184, 106),
  inset: 1em,
  stroke: 1.5pt + rgb(202, 53, 0),
  radius: 5pt
)[
  *Nota*: Nessa lecture, quando escrevemos $||dot||$, estamos nos referindo a norma 2, *não a qualquer norma*, logo, $||dot|| = ||dot||_2$
]


Vamos relembrar o problema dos mínimos quadrados?

$
  "Dada" A in CC^(m times n) "de posto completo," m >= n " e " b in CC^(m),\
  "ache" x in CC^n "tal que" ||b - A x||_2 "seja a menor possível"
$<min-squares>

No resumo passado, vimos que o $x$ que satisfaz esse problema é
$
  x = (A^*A)^(-1)A^*b => y = A(A^*A)^(-1)A^*b <=> y = P b
$<min-squares-equations>
Ou seja, a projeção ortogonal de $b$ em $A$ resulta no vetor $y$. Queremos então saber o condicionamento de @min-squares de acordo com perturbações em $b$, $A$, $y$ e $x$. Tenha em mente que o problema recebe dois parâmetros, $A$ e $b$ e retorna as soluções $x$ e $y$

== O Teorema
Antes de estabelecer de fato o teorema, vamos relembrar alguns fatores-chave aqui. Vamos rever a imagem que representa o problema de mínimos quadrados visualmente (Mesma imagem do resumo anterior)

#image("images/Projection_Min_Squared.jpg")

Vamos relembrar algumas coisas que já vimos antes e algumas novas. Primeiro é lembrar que, como $A$ não é quadrada, definimos seu número de condicionamento como
$
  kappa(A) = ||A|| ||A^+|| = ||A|| ||(herm(A)A)^(-1)herm(A)||
$
Não está explicito na imagem, mas podemos, também, definir o ângulo $theta$ entre $b$ e $y$
$
  theta = arccos((||y||)/(||b||))
$
(A gente define assim pois $y$ é a hipotenusa do triangulo retângulo formado por $b$ e $y - b$)

E a segunda medida é $eta$, que representa por quanto $y$ não atinge seu valor máximo
$
  eta = (||A|| ||x||)/(||y||) = (||A|| ||x||)/(||A x||)
$
Show! E esses parâmetros tem esses domínios:
$
  kappa(A) in [1, infinity]"        "theta in [0, pi/2]"      "eta in [1, kappa(A)]
$

#theorem("Condicionamento de Mínimos Quadrados")[
  Deixe $b in CC^m$ e $A in CC^(m times n)$ de posto completo serem *fixos*. O problema de mínimos quadrados @min-squares possui a seguinte tabela de condicionamentos em norma-2:

  #figure(
    table(
      columns: (auto, auto, auto),
      inset: 10pt,
      align: horizon + center,
      table.header(
        [], [$y$], [$x$]
      ),
      [$b$], [$1/cos(theta)$], [$kappa(A)/(eta cos(theta))$],
      [$A$], [$kappa(A)/cos(theta)$], [$kappa(A) + (kappa(A)^2 tan(theta))/eta$]
    ),
    caption: [Sesibilidade de $x$ e $y$ com relação a perturbações em $A$ e $b$]
  )
  Vale dizer também que a primeira linha são igualdades exatas, enquanto a linha de baixo são arredondamentos para cima
]<conditioning-min-squared-problems>
#proof[
  Antes de provar para cada tipo de perturbação, temos em mente que estamos trabalhando com a norma-2, correto? Então nós vamos reescrever $A$ para ter uma análise mais fácil. Seja $A = U Sigma herm(V)$ a decomposição S.V.D de $A$, sabemos que $||A||_2 = ||Sigma||_2$ (As matrizes unitárias não afetam a norma), então podemos, sem perca da generalidade, lidar diretamente com $Sigma$, então podemos assumir que $A = Sigma$ (Não literalmente, mas como vamos ficar analisando as normas, isso vai nos facilitar bastante)
  $
    A = mat(sigma_1;,sigma_2;,,dots.down;,,,sigma_n;,;,) = mat(A_1;0)
  $
  Reescrevendo os outros termos, temos:
  $
    b = mat(b_1;b_2)"     "y = mat(b_1;0)"      "mat(A_1;0)x = mat(b_1;0) <=> x = A_1^(-1)b_1
  $<A-reduction-to-diagonal>

  - *Sensibilidade de $y$ com perturbações em $b$*: Vimos anteriormente na equação @min-squares-equations que $y = P b$, e podemos tirar o condicionamento disso se associarmos com a equação *genérica* $A x = b$. Lembra que em estabilidade vimos que o condicionamento desse sistema genérico quando perturbamos $x$ é:
    $
      (||A||)/(||x||\/||b||)
    $
    Então, fazendo simples substituições:
    $
      (||P||)/(||y||\/||b||) = 1/(cos theta)
    $
    O que até que faz sentido na intuição. Se fazemos com que $b$ fique muito próximo a um ângulo de $90 degree$ com $C(A)$, na hora que formos projetar, a projeção será minúscula, o que pode acarretar erros numéricos dependendo da precisão usada pelo computador
  - *Sensibilidade de x com perturbações em $b$*: Também tem uma relação bem direta pela equação @min-squares-equations: $x = A^+b$. Assim, temos o mesmo de antes:
    $
      (||A^+||)/(||x||\/||b||) = ||A^+||(||b||)/(||y||) (||y||)/(||x||) = ||A^+|| (1)/(cos theta) (||A||)/eta = kappa(A)/(eta cos theta)
    $

  Antes de continuar o resto da demonstração, temos que entender um pouco como as perturbações em $A$ podem afetar $C(A)$, porém, isso é um problema não-linear. Até daria pra fazer um monte de jacobiano algébrico, mas é melhor se manter numa pegada não muito formal e ter uma visão geométrica.

  Primeiro, quando perturbamos $A$, isso afeta o problema de mínimos quadrados de dois modos: 1 - As perturbações afetam como vetores em $CC^n$ ($A in CC^(m times n)$) são mapeados em $C(A)$. 2 - Elas alteram $C(A)$ em si. A gente pode imaginar as perturbações em $C(A)$ como pequenas inclinações que a gente faz, coisa bem pouquinha mesmo. Então fazemos a pergunta: Qual é o maior ângulo de inclinação $delta alpha$ (O quão inclinado eu deixei em comparação a como tava antes) que pode ser causado por uma pequena perturbação $delta A$? Aí a gente pode seguir do seguinte modo:

  #figure(
    grid(
      columns: (50%, 50%),
      rows: (auto),
      image("images/C(A)_Perturbation.png"),
      image("images/Angle_C(A).png")
    ),
    caption: [Perturbação em $C(A)$. $v_1$ é o vetor que está na divisão entre o plano azul e o vermelho, $v_2$ é o vetor mais destacado no plano azul e $v_3$ é o vetor pontilhado],
  )<CA-perturbation>
  
  Na @CA-perturbation, a gente consegue ver isso um pouco melhor. Nosso plano original é o *azul*, formado por $v_1$ e $v_2$, enquanto o plano *vermelho* é formado por $v_1$ e $v_3$, onde $v_3$ é o $v_2 + delta v_2$. Percebam que os planos tem uma abertura entre si, medimos aquela abertura por meio de $delta alpha$ que mostra a diferença de inclinação entre os dois planos. A segunda mostra mais explicitamente esse ângulo aplicado a outros dois planos diferentes, eu aumentei a diferença entre um e outro apenas para ilustrar melhor a visualização do ângulo, mas normalmente queremos trabalhar com ângulos minúsculos.

  Quando a gente projeta uma n-esfera unitária em $C(A)$, temos uma hiperelipse. Pra mudar $C(A)$ da forma mais eficiente possível, pegamos um ponto $p = A v$ que está na hiperelipse ($||v|| = 1$) e cutucamos ela em uma direção $delta p$ ortogonal a $C(A)$. A perturbação que melhor faz isso é $delta A = (delta p)v^*$, que resulta em $(delta A)v = delta p => ||delta A|| = ||delta p||$. Essa perturbação é a melhor por conta da norma 2 de um produto externo:
  $
    A = u v^* => ||A x|| = ||u v^* x|| <= ||u||||v|||| x||
  $
  Daí *para ter a igualdade*, basta pegar $x = v$. Agora a gente pode perceber que, se a gente quer a maior inclinação possível dado uma perturbação $||delta p||$ a gente tem q fazer com que $p$ fique perto da origem o máximo possível. Ou seja, queremos o menor $p$ possível com base na definição, que seria $p = sigma_n u_n$ onde $sigma_n$ é o menor valor valor singular de $A$ e $u_n$ a $n$-ésima coluna de $U$. Se tomarmos $A = Sigma$, $p$ é a última coluna de $A$, $v^* = e_n^* = (0, 0, ..., 1)$ e $delta A$ são perturbações na entrada de A. Essa perturbação inclina $C(A)$ pelo ângulo $delta A$ dado por $tan(delta alpha) = ||delta p||\/||sigma_n||$, temos então:
  $
    delta alpha <= (||delta A||)/(sigma_n) = (||delta A||)/(||A||) kappa(A)
  $<tilting-angle-maximum>
  Agora sim podemos continuar a demonstração
  - *Sensibilidade de $y$ com perturbações em $A$*: Podemos ver uma propriedades geométricas interessantes quando fixamos $b$ e mexemos $A$. Lembra que $y$ é a projeção *ortogonal* de $b$ em $C(A)$, ou seja, $y$ sempre é *ortogonal* a $y - b$.

    #figure(
      image("images/Projection_Circle.png"),
      caption: [Círculo de projeção de $y$. O círculo maior representa a inclinação de $C(A)$ no plano $0 y b$ e o círculo menor é quando inclinamos $C(A)$ em uma direção ortogonal a ele]
    )<projection-circle>

    Como eu posso rotacionar $C(A)$ em $360 degree$, eu posso visualizar todos os possíveis locais de $y$ estando nessa esfera. Quando eu inclino $C(A)$ por um ângulo $delta alpha$ no círculo maior, o meu ângulo $2theta$ vai ser alterado. Mais especificamente, vai ser alterado em $2 delta alpha$. Ou seja, a perturbação $delta y$ que eu vou obter ao inclinar $C(A)$ será a base de um triângulo isóceles.

    #figure(
      image("images/DeltaAlpha-Inclination.png"),
      caption: [$C(A)$ após rotação de $delta alpha$]
    )

    Podemos ver que o raio da esfera é $||b||\/2$, ou seja, podemos chegar que:
    $
      ||delta y|| <= ||b|| sin(delta alpha) <= ||b||(delta alpha) <= ||b||(||delta A||)/(||A||) kappa(A)\
      
      cos(theta) = (||y||)/(||b||) <=> ||b|| = (||y||)/cos(theta)\

      => ||delta y|| <= (||y||)/cos(theta)(||delta A||)/(||A||) kappa(A) <=> ((||delta y||)/(||y||))/((||delta A||)/(||A||)) = kappa(A)/cos(theta)
    $
    Concluímos assim, o 3º condicionamento
  - *Sensibilidade de $x$ com perturbações em $A$*: Quando a gente faz uma perturbação $delta A$ em $A$, podemos separar essa perturbação em duas outras: $delta A_1$ que ocorre nas primeiras $n$ linhas de $A$ e $delta A_2$ que ocorre nas $m-n$ linhas restantes.
    $
      A = mat(delta A_1;delta A_2)
    $
    Vamos ver $delta A_1$ primeiro. Quando vemos essa perturbação específica, pelo que vimos em @A-reduction-to-diagonal, temos que $b$ não é alterado, então estamos mantendo $b$ fixo e tentando calcular $x$ com perturbação $delta A_1$ em $A$. Esse condicionamento já vimos no último resumo:
    $
      ((||delta x||)/(||x||)) \/ ((||delta A_1||)/(||A||)) <= kappa(A_1) = kappa(A)
    $
    Já quando perturbamos por $delta A_2$ (Estamos perturbando $C(A)$ por inteiro, não somente $A_2$), acaba que o vetor $y$ e, consequentemente, o vetor $b_1$ são perturbados, porém, sem perturbação em $A_1$. Isso é a mesma coisa que a gente perturbar $b_1$ sem perturbar $A_1$. O condicionamento disso é:
    $
      ((||delta x||)/(||x||)) \/ ((||delta b_1||)/(||b_1||)) <= kappa(A_1)/(eta (A_1; x)) = kappa(A)/eta
    $
    Agora precisamos relacionar $delta b_1$ com $delta A_2$. Sabemos que $b_1$ é $y$ expresso nas coordenadas de $C(A)$. Ou seja, as únicas mudanças em $y$ que podem ser vistas como mudanças em $b_1$ são aquelas paralelas a $C(A)$. Se $C(A)$ é inclinado por um ângulo $delta alpha$ no plano $0b y$, $delta y$ não está em $C(A)$, mas tem um ângulo de $pi/2 - theta$. Ou seja, as mudanças em $b_1$ satisfazem:
    $
      ||delta b_1|| = sin(theta)||delta y|| <= (||b||delta alpha)sin(theta)
    $<deltab1-relation-to-deltay>
    Curiosamente se a gente inclina $C(A)$ na direção ortogonal ao plano $0b y$ (Círculo menor na @projection-circle) obtemos o mesmo resultado por motivos diferentes.

    Como vimos antes: $cos(theta) = ||y||\/||b|| <=> ||b_1|| = cos(theta)||b||$, então podemos reescrever @deltab1-relation-to-deltay como:
    $
      (||delta b_1||)/(||b_1||) <= (||b||delta alpha sin(theta))/(||b|| cos(theta)) <=> (||delta b_1||)/(||b_1||) <= delta alpha tan(theta)
    $
    Assim, podemos relacionar $delta alpha$ com $||delta A_2||$ da equação @tilting-angle-maximum
    $
      delta alpha <= (||delta A_2||)/(||A||) kappa(A) <=> (||delta b_1||)/(||b_1||) <= (||delta A_2||)/(||A||) kappa(A) tan(theta)\

      ((||delta x||)/(||x||)) \/ ((||delta b_1||)/(||b_1||)) <= kappa(A)/eta <=> (||delta x||)/(||x||) <= kappa(A)/eta (||delta b_1||)/(||b_1||) <=> (||delta x||)/(||x||) <= kappa(A)/eta (||delta A_2||)/(||A||) kappa(A) tan(theta)\
      
      <=> ((||delta x||)/(||x||)) \/ ((||delta A_2||)/(||A||)) <= (kappa(A)^2 tan(theta))/eta
    $

    Combinando os condicionamentos de $A_1$ e $A_2$ temos $kappa(A) + (kappa(A)^2 tan(theta))/eta$
]

#pagebreak()

#align(center + horizon)[
  = Lecture 19 - Estabilidade de Algoritmos de Mínimos Quadrados
]

#pagebreak()

A gente viu quem tem um monte de jeito de se resolver os problemas de mínimos quadrados (Resumo 1). Com isso, a gente pode calcular e estimar a estabilidade dos algoritmos que já vimos.

== Primeira Etapa
Vamos fazer isso na prática. Vamos montar um cenário para a aplicação de cada um dos algoritmos. Vamos pegar $m$ pontos igualmente espaçados entre $0$ e $1$, montamos a #underline[#link("https://en.wikipedia.org/wiki/Vandermonde_matrix")[matriz de vandermonde]] desses pontos e aplicamos uma função que tentaremos prever com polinômios:

#codly(
  header: [*CÓDIGO*],
  header-cell-args: (align: center),
  inset: 0.25em
)
```python
  import numpy as np
  m = 100
  n = 15
  t = np.linspace(0, 1, m)
  A = np.vander(t, n, True)
  b = np.exp(np.sin(4*t))/2.00678728e+03
```<min-squared-algorithms-init>

Oxe, por que que tem essa divisão esquisita no final? Quando a gente não faz essa divisão, ao fazer a previsão dos coeficientes que aproximam a função, temos que o último coeficiente previsto ($x_15$) é igual a `1.42775025e+07`, então, nós dividimos $b$ por esse valor para que o último coeficiente seja igual a $1$ no caso matematicamente correto (Sem erros numéricos), assim poderemos fazer comparações apenas visualizando o último número dos coeficientes calculados.

== Householder
O algoritmo padrão para problemas de mínimos quadrados. Vejamos:

#grid(
  columns: (50%, 45%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      inset: 0.25em,
      offset-from: <min-squared-algorithms-init>
    )
    ```python
      Q, R = householder_qr(A)
      x = np.linalg.solve(R, Q.T @ b)
      print(1-x[-1])  # Erro relativo
    ```
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
      1.9845992627054443e-09
    ```
  ]
)

Temos um erro de grandeza $10^(9)$, porém, no Python, trabalhamos com precisão IEEE 754 ($epsilon = 2.220446049250313e-16$), o que nos mostra um erro de precisão MUITO grande (Ordem de $10^(7)$ de diferença). Porém, aqui nós calculamos $Q$ explicitamente e, no resumo 1, foi comentado que isso normalmente não acontece, então vamos ver se o erro muda ao trocarmos $Q$ por uma versão implícita

#grid(
  columns: (50%, 45%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      inset: 0.25em,
      offset-from: <min-squared-algorithms-init>
    )
    ```python
      Q, R = householder_qr(np.c_[A, b])
      print(R.shape)
      Qb = R[0:n, n]
      R = R[0:n, 0:n]
      x = np.linalg.solve(R, Qb)
      print(1-x[-1])
    ```
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
      1.989168163518684e-09
    ```
  ]
)

Deu pra ver que da quase a mesma coisa do resultado anterior, ou seja, os erros da fatoração de $A$ são maiores que os de $Q$. Pode ser provado que essas duas variações são *backward stable*. O mesmo vale para uma terceira variação que utiliza do *pivotamento* de colunas (Não é discutido nem no livro, tampouco nesse resumo)

#theorem[
  Deixe um problema de mínimos quadrados em uma matriz de posto completo $A$ ser resolvida por fatoração *Householder* em um computador ideal. O algoritmo é *backward stable* tal que:
  $
    ||(A + delta A)accent(x, ~) - b|| = min, space space (||delta A||)/(||A||) = O(epsilon_"machine")
  $
  para algum $delta A in CC^(m times n)$.
]

== Ortogonalização de Gram-Schmidt
A gente também pode tentar resolver pelo método de Gram-Schmidt modificado, vamos ver o que a gente consegue:

#grid(
  columns: (50%, 45%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      inset: 0.25em,
      offset-from: <min-squared-algorithms-init>
    )
    ```python
      Q, R = modified_gram_schmidt(A)
      x = np.linalg.solve(R, Q.T @ b)
      print(1-x[-1])
    ```
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
      -0.01726542
    ```
  ]
)

Meu amigo, esse erro é *terrível*. O resultado obtido é tenebroso de ruim. O livro comenta também de outro método que involve fazer umas manipulações em $Q$, mas como o próprio diz que involve trabalho extra, desnecessário e não deveria ser usado na prática, nem vou comentar sobre aqui.

Mas a gente pode usar um método parecido com o que fizemos antes em unir $A$ e $b$ numa única matriz:

#grid(
  columns: (50%, 45%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      inset: 0.25em,
      offset-from: <min-squared-algorithms-init>
    )
    ```python
      Q, R = modified_gram_schmidt(np.c_[A, b])
      Qb = R[0:n, n]
      R = R[0:n, 0:n]
      x = np.linalg.solve(R, Qb)
      print(1-x[-1])
    ```
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
      -1.3274502852489434e-07
    ```
  ]
)

Olha só! Já deu uma melhorada no algoritmo!

#theorem[
  Solucionar o problema de mínimos quadrados de uma matriz $A$ com posto completo utilizando o algoritmo de Gram-Schmidt (Fazendo de acordo como o código anterior mostra em que $Q^* b$ é implícito) é *backward stable*
]

== Equações Normais
A gente pode resolver por equações normais, que é o passo inicial para todos os outros métodos né? Vamos ver o que obtemos:

#grid(
  columns: (50%, 45%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      inset: 0.25em,
      offset-from: <min-squared-algorithms-init>
    )
    ```python
      x = np.linalg.solve(A.T @ A, A.T @ b)
      print(1-x[-1])
    ```
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
      1.35207472
    ```
  ]
)

Meu amigo, esse erro é *TENEBROSO*, não chegou nem *PERTO* do resultado. Claramente as equações normais são um método *instável* de calcular mínimos quadrados. Vamos dar uma visualizada no porquê isso ocorre:

Suponha que nós temos um algoritmo *backward stable* para o problema de mínimos quadrados com uma matriz $A$ de posto-completo que retorna uma solução $accent(x, ~)$ satisfazendo $||(A+delta A)accent(x, ~) - b|| = min$ para algum $delta A$ com $||delta A||\/||A|| = O(epsilon_"machine")$. Pelo teorema da acurácia de algoritmos backward stable (Resumo 1) e o @conditioning-min-squared-problems temos:
$
  (||accent(x,~) - x||)/(||x||) = O((kappa + (kappa^2tan(theta))/eta)epsilon_"machine")
$<normal-equation-algorithm-x-difference>

Suponha que $A$ é mal-condicionada. Dependendo dos valores dos híperparâmetros, podem acontecer duas situações diferentes. Se $tan(theta)$ for de ordem $1$, então o lado direito da equação @normal-equation-algorithm-x-difference troca e fica $O(kappa^2 epsilon_"machine")$. Porém, se $tan(theta)$ é próximo de 0, ou $eta$ é próximo de $kappa$, então então a equação muda para $O(kappa epsilon_"machine")$ (Usa um teorema mais la pra frente, mas é engraçado ver como tudo tá muito interconectado). Porém, a matriz $A^*A$ tem número de condicionamento $kappa(A)^2$, então o máximo que podemos esperar do problema é $O(kappa^2 epsilon_"machine")$

#theorem[
  A solução de um problema de mínimos quadrados com uma matriz $A$ de posto-completo utilizando de equações normais é *instável*. Porém a estabilidade pode ser alcançada ao restringir para uma classe de problemas onde $kappa(A)$ é pequeno ou $tan(theta)/eta$ é pequeno.
]

== SVD
O último algoritmo a ser mencionado foi utilizando a SVD de $A$, que nós vimos (no resumo 1) que parecia ser um algoritmo interessante:

#grid(
  columns: (60%, 35%),
  rows: (auto),
  gutter: 20pt,
  block[
    #codly(
      header: [*CÓDIGO*],
      header-cell-args: (align: center),
      inset: 0.25em,
      offset-from: <min-squared-algorithms-init>
    )
    ```python
      U, S, Vh = np.linalg.svd(A, full_matrices=False)
      S = np.diag(S)
      x = (Vh.T * 1/S) @ (U.T @ b)
      print(1-x[-1])
    ```
  ],
  block[
    #codly(
      inset: 0.25em,
      header: [*SAÍDA*],
      header-cell-args: (align: center),
    )```
      -2.3301211e-07
    ```
  ]
)

Olha só! Temos uma precisão ótima! (O algoritmo da SVD é o mais confiável e estável, mesmo que o erro mostrado seja maior do que alguns que obtivemos anteriormente)

#theorem[
  A solução do problema de mínimos quadrados com uma matriz $A$ de posto-completo utilizando o algoritmo de SVD é *backward stable*.
]

== Problemas de Mínimos Quadrados com Posto-Incompleto
A gente viu a aplicação de algoritmos em problemas de mínimos quadrados utilizando matrizes de posto-completo, mas pode ter outros casos de matrizes com $"posto" < n$, ou até $m < n$. Para essa classe de problemas, é necessário definirmos outro tipo de solução, já que nem todos tem o mesmo comportamento. As vezes precisamos restringir a solução com uma condição. Por conta disso, nem todo algoritmo que vimos ser estável até agora vai ser estável nesse tipo de problema, na verdade, apenas o de SVD será e o de Gram-Schmidt com pivotamento nas colunas.



#pagebreak()

#align(center + horizon)[
  = Lecture 24 - Problemas de Autovalores
]

#pagebreak()

Esse capítulo nada mais é do que uma revisão de resultados da A2 de álgebra linear.

== Definições

Dada uma matriz $A in CC^(m times n)$, pela decomposição SVD $A = U Sigma V^*$ sabemos que $A$ é uma transformação que *estica* e *rotaciona* vetores. Por isso, estamos interessados em subespaços de $CC^m$ nos quais a matriz age como uma multiplicação escalar, ou seja, estamos interessados nos $x in CC^n$ que são somente esticados pela matriz. Como $A x in CC^m$ e $lambda x in CC^n$, concluimos que $m = n$: A matriz *deve ser quadrada*. Afinal, não faz sentido se $lambda x$ e $A x$ estiverem em conjuntos distintos. Com isso, prosseguimos com a definição:

#definition("Autovalores e Autovetores")[
  Dada $A in CC^(m times m)$, um *autovetor* de $A$ é $x in CC^m without {0}$ que satisfaz:

  $
    A x = lambda x
  $ <eq_autovalores_autovetores>

  $lambda in CC$ é dito *autovalor* associado a $x$.
] <def_autovalor_autovetor>

== Decomposição em Autovalores

Uma *decomposição em autovalores* de uma matriz $A in CC^(m times n)$ é uma fatoração:

$
  A = X Lambda X^(-1)
$ <decomposicao_autovalores>

Onde $Lambda$ é diagonal e $det(X) != 0$.

Isso é equivalente a:

$
  underbrace(mat(
    space, space, space, space;
    space, space, A, space, space;
    space, space, space, space
  ), A) dot underbrace(mat(
    bar, bar, bar, bar,;
    x_1, x_2, dots, x_n;
    bar, bar, bar, bar
  ), X) = underbrace(mat(
    lambda_1, 0, dots, 0;
    0, lambda_2, dots, 0;
    0, 0, dots, 0
  ), Lambda) dot underbrace(mat(
    bar, bar, bar, bar,;
    x_1, x_2, dots, x_n;
    bar, bar, bar, bar
  ), X)
$ <eq_decomposicao_autovalores_matricial>

Da @eq_decomposicao_autovalores_matricial e da @def_autovalor_autovetor, decorre que $A x_i = lambda_i x_i$, então a i-ésima coluna de $X$ é um autovetor de $A$ e $lambda_i$ é o autovalor associado a $x_i$.

A decomposição apresentada pode representar uma mudança de base: Considere $A x = b$ e $A = X Lambda X^(-1)$, então:

$
  A x = b <=> X Lambda X^(-1) x = b <=> Lambda (X^(-1) x) = X^(-1) b
$

Então para calcular $A x$, podemos expandir $x$ como combinação das colunas de $X$ e aplicar $Lambda$. Como $Lambda$ é diagonal, o resultado ainda vai ser uma combinação das colunas de $X$.

== Multiplicidades Algébrica e Geométrica

Como mencionado anteriormente, definimos os conjuntos nos quais a matriz atua como multiplicação escalar:

#definition("Autoespaço")[
  Dada $A in CC^(m times n), lambda in CC$, definimos $S_lambda in CC^m$ como sendo o *autoespaço* gerado por todos os $v in CC^m$ tais que $A v = lambda v$
] <def_autoespaço>

Interpretaremos $dim(S_lambda)$ como a maior quantidade de autovetores L.I associados a um único $lambda$, e chamaremos isso de _multiplicidade geométrica_ de $lambda$. Então temos:

#definition[(Multiplicidade Geométrica)
  A multiplicidade geométrica de $lambda$ é $dim(S_lambda)$
] <def_multiplicidade_geometrica>

Note que da equação @eq_autovalores_autovetores:

$
  A x = lambda x <=> A x - lambda x = 0 <=> (A - lambda I) x = 0\
$

Mas como $x != 0$ e $x in N(A - lambda I)$, $(A - lambda I)$ não é injetiva. Logo não é inversível:

$
  det(A - lambda I) = 0
$ <eq_polinimio_caracteristico>

#definition("Polinômio Característico")[
  A equação @eq_polinimio_caracteristico se chama *polinômio característico* de $A$ e é um polinômio de grau $m$ em $lambda$. Pelo teorema fundamental da Álgebra, se $lambda_1, dots, lambda_n$ são raízes de @eq_polinimio_caracteristico, então podemos escrever isso como:
  $
    p(lambda) = (lambda - lambda_1)(lambda - lambda_2)...(lambda - lambda_n)
  $<characteristical-polynomial>
  (Nota: $lambda$ é uma variável, enquanto $lambda_j$ é uma raíz do polinômio, fique atento)
]

Com isso, prosseguimos com:

#definition("Multiplicidade Algébrica")[
  A multiplicidade algébrica de $lambda$ é a multiplicidade de $lambda$ como raiz do polinômio característico de $A$
] <def_multiplicidade_algebrica>

A definição de polinômio característico e de multiplicidade algébrica faz a gente ter um jeito muito fácil de contar a quantidade de autovalores de uma matriz

#theorem[
  Se $A in CC^(m times m)$, então $A$ tem $m$ autovalores, contando com a multiplicidade algébrica.
]

Isso mostra que *toda matriz* possui *pelo menos* 1 autovalor

== Transformações Similares
#definition("Transformação Similar")[
  Se $X in CC^(m times m)$ é inversível, então o mapeamento $A |-> X^(-1) A X$ é chamado de *transformação similar* de A.
]

Dizemos que duas matrizes $A$ e $B$ são *similares* se existe uma matriz inversível $X$ que relacione as transformações similares entre $A$ e $B$, i.e:
$
  X^(-1) A X = X^(-1) B X
$

#theorem[
  Se $A in CC^(m times m)$ é inversível, então $A$ e $X^(-1) A X$ o mesmo polinômio característico, os mesmos autovalores e multiplicidades geométrica e algébrica.
]<similarity-theorem>
#proof[
  $
    p_(X^(-1)A X)(z) = det(z I - X^(-1)A X) = det(X^(-1)(z I - A)X)\
    = det(X^(-1))det(z I - A)det(X) = det(z I - A) = p_A(z))
  $

  Suponha que $E_lambda$ é o autoespaço de $A$, então $X^(-1)E_lambda$ é autoespaço de $X^(-1)A X$, ou seja, ambos tem mesma multiplicidade geométrica
]

Agora podemos correlacionar a multiplicidade geométrica e a algébrica

#theorem[
  A multiplicidade algébrica de um autovalor $lambda$ é sempre maior ou igual a sua multiplicidade geométrica
]
#proof[
  Deixe $n$ ser a multiplicidade gemétrica de $lambda$ para a matriz $A$. Forme uma matriz $accent(V, \^) in CC^(m times n)$ de tal forma que as suas $n$ colunas formam uma base ortonormal do autoespaço ${x: A x = lambda x}$. Se extendermos $accent(V, ~)$ para uma matriz ortogonal quadrada, temos:
  $
    B = V^* A V = mat(lambda I, C;0, D)
  $
  Pela definição e propriedades do determinante (Não cabe mostrá-las aqui), temos que:
  $
    det(mu I - B) = det(mu I - lambda I)det(mu I - D) = (mu - lambda)^n det(mu I - D)
  $
  Ou seja, a multiplicidade algébrica de $lambda$ como um autovalor de $B$ é, no mínimo, $B$. Como transformações similares mantém a multiplicidade, o mesmo vale para $A$
]

== Autovalores e Matrizes Deficientes
Um autovalor é deficiente quando sua MA é maior que sua MG. Se uma matriz $A$ tem autovalor deficiente, ela é uma matriz deficiente. Matrizes deficientes não podem ser diagonalizáveis (Próximo tópico)

== Diagonalizabilidade
#theorem("Diagonalizabilidade")[
  Uma matriz $A in CC^(m times m)$ é não-deficiente $<=>$ ela tem uma decomposição $A = X Lambda X^(-1)$
]
#proof[
  $arrow.l.double$\) Dada uma decomposição $A = X Lambda X^(-1)$, sabemos, pelo @similarity-theorem, que $Lambda$ sendo similar a $A$, logo, $A$ tem os mesmos autovalores, MA e MG de $Lambda$. Como $Lambda$ é diagonal, eu tenho que $Lambda$ é não-deficiente, logo, o mesmo vale para $A$

  $=>$\) Uma matriz não-deficiente deve ter $m$ autovetores linearmente independentes, pois autovetores com diferentes autovalores precisam ser L.I, e cada autovalor pode se associar com autovetores a quantidade de vezes que sua MA permitir. Se esses $m$ autovetores independentes formam as colunas de uma matriz $X$, então X é inversível e $A = X Lambda X^(-1)$
]

== Determinante e Traço
#theorem[
  Seja $lambda_j$ um autovalor de $A in CC^(m times m)$:
  $
    det(A) = product_(j=1)^m lambda_j\
    tr(A) = sum_(j=1)^m lambda_j
  $
]
#proof[
  $
    det(A) = (-1)^m det(-A) = (-1)^m p_A(0) = product_(j=1)^m lambda_j
  $
  Olhando a equação @characteristical-polynomial, podemos observar que o coeficiente do termo $lambda^(m-1)$ é igual a $-sum_(j=1)^m lambda_j$ e na equação @eq_polinimio_caracteristico o termo é o negativo da soma dos termos da diagonal, ou seja, $-tr(A)$, ou seja, $tr(A) = sum_(j=1)^m lambda_j$
]

== Diagonalização Unitária
Acontece as vezes que, ao fazer a diagonalização de uma matriz, nós podemos cair com um conjunto de autovetores ortogonais entre si.

#definition[
  $A$ é diagonalizável unitariamente quando $A = Q Lambda Q^*$ com $Q$ ortogonal e $Lambda$ diagonal (Pode ter entradas complexas)
]

#theorem("Teorema Espectral")[
  Uma matriz hermitiana é diagonalizável unitariamente e seus autovalores são reais.
]
Não cabe aqui a prova desse teorema, porém um resumo de Álebra Linear do 2º período será feito e essa demonstração estará lá.

#definition("Matrizes Normais")[
  Uma matriz $A$ é normal se $A^*A = A A^*$
]
#theorem[
  Uma matriz é diagonalizável unitariamente $<=>$ ela é normal
]


== Forma de Schur
Essa forma é *muito útil* em análise numérica tendo em vista que *toda matriz* pode ser fatorada assim

#definition("Fatoração de Schur")[
  Dada uma matriz $A in CC^(m times m)$, sua fatoração de schur é tal que:
  $
    A = Q T Q^*
  $
  onde $Q$ é ortogonal e $T$ é triangular superior
]

#theorem[
  Toda matriz quadrada $A$ tem uma fatoração de Schur
]
#proof[
  Vamos fazer indução em $m$.
  - *Casos base*: $m=1$ é trivial, então suponha que $m >= 2$.
  - *Passo Indutivo*: Deixe $x$ ser um autovetor de $A$ com autovalor $lambda$. Normalize $x$ e faça com que seja a primeira coluna de uma matriz ortogonal $U$. Então podemos fazer as contas e conferir que o produto $U^* A U$ é tal que:
    $
      U^* A U = mat(lambda, B; 0, C)
    $
    Pela hipótese indutiva, existe uma fatoração $V T V^*$ de $C$, agora escrevemos:
    $
      Q = U mat(1, 0; 0, V)
    $
    $Q$ é uma matriz unitária e temos que
    $
      Q^* A Q = mat(lambda, B V; 0, T)
    $
    Essa era a fatoração de Schur que procurávamos
]

#pagebreak()

#align(center + horizon)[
= Lecture 25 - Algoritmos de Autovalores
]

#pagebreak()

Essa Lecture é focada em mostrar a ideia geral dos algoritmos que são divididos em duas fases

1. Redução da forma completa para uma forma estrategicamente estruturada
2. Aplicação de um processo iterativo que leva à convergência dos autovalores

Ela também foca em explicar as vantagens desses métodos

== Algoritmos Óbvios (Ou nem tanto)
Por mais que os autovetores e autovalores tenham propriedades bonitas e simples, calcular eles de uma maneira numericamente estável não é algo tão simples e os algoritmos não são os mais óbvios. O mais óbvio que pensamos é calcular o polinômio característico da matriz e achar suas raízes, acontece que isso é uma péssima ideia, já que achar as raízes de um polinômio é um problema mal-condicionado.

Agora a gente pode tirar vantagem do fato que a sequência
$
  (x)/(||x||), (A x)/(||A x||), (A^2 x)/(||A^2 x||),...,(A^n x)/(||A^n x||)
$
converge, sobre certas condições, para o maior autovalor (Em valor absoluto) de $A$. Esse método é chamado de *Iteração sob Potências*, mas não é um método muito eficiente e não é utilizado em situações muito usuais.

== A ideia dos Algoritmos de Autovalores
Escrever pqq tem q ser iterativo. (pag 192 trefethen)
== Forma de Schur e Diagonalização
== As 2 fases do Cálculo de Autovalores, Forma de Hessenberg

#pagebreak()

#align(center + horizon)[
  = Lecture 26 - Redução à forma de Hessenberg
]

#pagebreak()
== A Redução
== Redução à Hessenberg via Householder
== Custo Computacional
== O Caso Hermitiano
== Estabilidade do Algoritmo

#pagebreak()

#align(center + horizon)[
  = Lecture 27 - Quociente de Rayleigh e Iteração Inversa
]

#pagebreak()
== Restrição à matrizes reais e simétricas
== Quociente de Rayleigh
== Iteração de Potência com o Quociente de Rayleigh
== Iteração Inversa 


#pagebreak()

#align(center + horizon)[
  = Lecture 31 - Calculando a SVD
]

#pagebreak()
== SVD de A via autovalores de $herm(A) A$

Calcular a SVD de $A$ usando que $herm(A) A = V herm(Sigma) Sigma V$ igual a um sagui disléxico não é a melhor ideia, pois reduzimos o problema de SVD a um problema de autovalores, que é sensível à perturbações.

Um algoritmo estável para calcular a SVD de $A$, usa a matriz

$
  H = mat(
    0, A;
    herm(A), 0
  )
$

Se $A = U Sigma herm(V)$ é uma SVD de $A$, então $A V = Sigma U$ e $herm(A) U = herm(Sigma) V = Sigma V$, portant

$
  mat(
    0, A;
    herm(A), 0
  ) dot mat(
    V, V;
    U, -U
  ) = mat(
    V, V;
    U, -U
  ) dot mat(
    Sigma, 0;
    0, -Sigma
  )
$

Ou:

$
  H = mat(
    0, A;
    herm(A), 0
  ) = mat(
    V, V;
    U, -U
  ) dot mat(
    Sigma, 0;
    0, -Sigma
  ) dot inv(mat(
    V, V;
    U, -U
  ))
$

É uma decomposição em autovalores de $H$, e fica claro que os autovalores de $H$ são os valores singulares de $A$, em módulo.

Agora note que ao calcular os autovalores de $H$, pagamos $kappa(A)$, e não $kappa^2(A)$, Pois

$
  kappa(H) = norm(H)_2 dot norm(inv(H))_2 = (sigma_1 (H)) / (sigma_m (H)) = (sigma_1 (A)) / (sigma_m (A)) = kappa(A).
$


