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
#let proof = thmproof("proof", "Demonstração")

// A bunch of lets here
#set page(numbering: "1")

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
  Algebra Linear Numérica A2 Recap

  #datetime.today().display("[day]/[month]/[year]")
])

#outline()

#pagebreak()

#par[Olha só, agora é em português! Coisa boa. Esse documento se refere aos capítulos 16 e posteriores.]

= Lecture 16 - Estabilidade da Triangularização de Householder
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

#pseudocode-list(booktabs: true, title: [Algoritmo para resolver $A x = b$])[
  + *function* ResolverSistema($A in CC^(m times n)$, $b in CC^(m times 1)$) {
    + $Q R = "Householder"(A)$
    + $y = Q^* b$
    + $x = R^(-1)y$
    + *return* $x$
  + }
]<solve-Ax-hh>

Esse algoritmo é *backwards stable*, e é bem passo-a-passo já que cada passo dentro do algoritmo é *backwards stable*.

#theorem[
  O algoritmo descrito anterioremente para solucionar $A x = b$ é *backwards stable*, satisfazendo
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

= Lecture 24 - Problemas de Autovalores

Esse capítulo nada mais é do que uma revisão de resultados da A2 de álgebra linear.

== Definições

Dada uma matriz $A in CC^(m times n)$, pela decomposição SVD $A = U Sigma V^*$ sabemos que $A$ é uma transformação que *estica* e *rotaciona* vetores. Por isso, estamos interessados em subespaços de $CC^m$ nos quais a matriz age como uma multiplicação escalar, ou seja, estamos interessados nos $x in CC^n$ que são somente esticados pela matriz. Como $A x in CC^m$ e $lambda x in CC^n$, concluimos que $m = n$: A matriz *deve ser quadrada*. Afinal, não faz sentido se $lambda x$ e $A x$ estiverem em conjuntos distintos. Com isso, prosseguimos com a definição:

#definition[(Autovalores e Autovetores)
  Dada $A in CC^(m times m)$, um _autovetor_ de $A$ é $x in CC^m without {0}$ que satisfaz:

  $
    A x = lambda x
  $ <eq_autovalores_autovetores>

  $lambda in CC$ é dito _autovalor_ associado a $x$.
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

Da @eq_decomposicao_autovalores_matricial e da @def_autovalor_autovetor, decorre que $A x_i = lambda_i x_i$, então a i-ésima coluna de $X$ é um autovetor de $A$ e $lambda_i$ é o autovalor associado (a $x_i$).

A decomposição apresentada pode representar uma mudança de base: Considere $A x = b$ e $A = X Lambda X^(-1)$, então:

$
  A x = b <=> X Lambda X^(-1) x = b <=> Lambda (X^(-1) x) = X^(-1) b
$

Então para calcular $A x$, podemos expandir $x$ como combinação das colunas de $X$ e aplicar $Lambda$. Como $Lambda$ é diagonal, o resultado ainda vai ser uma combinação das colunas de $X$.

== Multiplicidades Algébrica e Geométrica

Como mencionado anteriormente, definimos os conjuntos nos quais a matriz atua como multiplicação escalar:

#definition[(Autoespaço)
  Dada $A in CC^(m times n), lambda in CC$, o definimos $S_lambda in CC^m$ como sendo o *autoespaço* gerado por todos os $v_ in CC^m$ tais que $A v = lambda v$
] <def_autoespaço>

Interpretaremos $dim(S_lambda)$ como a maior quantidade de autovetores L.I associados a um único $lambda$, e chamaremos isso de _multiplicidade geométrica_ de $lambda$. Então temos:

#definition[(Multiplicidade Geométrica)
  A multiplicidade geométrica de $lambda$ é $dim(S_lambda)$
] <def_multiplicidade_geometrica>

Note que da @eq_autovalores_autovetores:

$
  A x = lambda x <=> A x - lambda x = 0 <=> (A - lambda I) x = 0\
$

Mas como $x != 0$ e $x in N(A - lambda I)$, $(A - lambda I)$ não é injetiva. Logo não é inversível:

$
  det(A - lambda I) = 0
$ <eq_polinimio_caracteristico>

A @eq_polinimio_caracteristico se chama _polinômio característico_ de $A$ e é um polinômio de grau $m$ em $lambda$. Pelo teorema fundamental da Álgebra, se $lambda_1, dots, lambda_n$ são raízes de @eq_polinimio_caracteristico, então podemos escrever isso como:

$
  p(phi) = (phi - lambda_1)(phi - lambda_2)...(phi - lambda_n)
$

Com isso, prosseguimos com:

#definition[(Multiplicidade Algébrica)
  A multiplicidade algébrica de $lambda$ é a multiplicidade de $lambda$ como raiz do polinômio característico de $A$
] <def_multiplicidade_algebrica>

== Transformações Similares
== Diagonalização
== Autovalores e Matrizes Deficientes
== Determinante e Traço
== Diagonalização Unitária
== Forma de Schur

= Lecture 25 - Algoritmos de Autovalores
== Ideia da Iteração de Potência
== A ideia dos Algoritmos de Autovalores
Escrever pqq tem q ser iterativo. (pag 192 trefethen)
== Forma de Schur e Diagonalização
== As 2 fases do Cálculo de Autovalores, Forma de Hessenberg

= Lecture 26 - Redução à forma de Hessenberg
== A Redução
== Redução à Hessenberg via Householder
== Custo Computacional
== O Caso Hermitiano
== Estabilidade do Algoritmo

= Lecture 27 - Quociente de Rayleigh e Iteração Inversa
== Restrição à matrizzes reais e simétricas
== Quociente de Rayleigh
== Iteração de Potência com o Quociente de Rayleigh
== Iteração Inversa 


= Lecture 30 - Calculando a SVD

Calcular autovalores da matriz:

$
  mat(
    0, A;
    A^*, 0
  )
$

Retorna os valores singulares de $A$ com $kappa(A)$, e não $kappa^2(A)$ PQ CARALHOS








