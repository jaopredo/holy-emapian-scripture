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

  João Pedro Jerônimo e Eduardo Adame
]

#align(horizon + center)[
  #text(17pt)[
    Aprendizado de Máquina
  ]
  
  #text(14pt)[
    Revisão para A3
  ]
]

#align(bottom + center)[
  Rio de Janeiro

  2026
]

#pagebreak()

// ============================ PÁGINAS POSTERIORES =========================
#outline(title: "Conteúdo")

#pagebreak()

#align(center + horizon)[
  = K-means
]

#pagebreak()

== Introdução
A partir desse momento, vamos começar a estudar métodos de machine learning não supervisionados. Diferente do aprendizado supervisionado, onde temos um conjunto de dados rotulado, no aprendizado não supervisionado, os dados não possuem rótulos e o objetivo é encontrar padrões ou estruturas subjacentes nos dados.

O primeiro que vamo estudar é um dos algoritmos de machine learning não supervisionado mais simples que existe, o K-means. Ele é um algoritmo de clustering que busca particionar os dados em K grupos distintos com base em suas características.


#figure(
  image("images/kmeans-step.png")
)

== O Algoritmo
Considere o problema de classificar pontos em um espaço. Naturalmente, pensamos que os pontos mais próximos um do outro devem pertencer ao mesmo grupo. O K-means é um algoritmo que busca encontrar esses grupos de forma iterativa, ajustando os centróides dos clusters até que a convergência seja alcançada.

Suponha que temos um dataset $D = {x_1,...,x_N}$ com pontos aleatórios de um espaço euclidiano de dimensão $D$. O nosso objetivo é particionar o dataset em um conjunto de $K$ clusters, onde, no momento, vamos supor que $K$ é conhecido. Também definimos um conjunto de $K$ centróides $mu_1,...,mu_K$. Nosso objetivo então é associar cada um dos pontos $x_i$ a um dos centróides $mu_k$, de forma que a soma das distâncias quadradas entre os pontos e seus centróides seja minimizada. Definimos também uma variável de associação $r_(n k) in {0, 1}$, que indica se o ponto $x_n$ pertence ao cluster $k$ ou não. Então podemos definir nossa função de custo, também conhecida como _função de distorção_, como:
$
  J = sum_(n=1)^N sum_(k=1)^K r_(n k) || x_n - mu_k ||^2
$<kmeans-cost-function>
que é a soma das distâncias quadradas entre cada ponto e o centróide do cluster ao qual ele pertence. O objetivo do K-means é minimizar essa função de custo.

#theorem([Valor ótimo de $r_(n k)$])[
  Para um conjunto fixo de centróides $mu_1,...,mu_K$, a escolha ótima de $r_(n k)$ é dada por:
  $
    r_(n k) = cases(
      1 "se" k = "argmin"_j || x_n - mu_j ||^2, 0 "caso contrário")
  $
]
#proof[
  Perceba que @kmeans-cost-function é uma função linear de $r_(n k)$. Os termos envolvendo diferentes $n$ são independentes entre si, então podemos otimizar para cada $n$ separadamente de forma que $r_(n k) = 1$ para qualquer valor $k$ que minimize $|| x_n - mu_k ||^2$ e $r_(n k) = 0$ para todos os outros valores de $k$. Ou seja, simplesmente assinalamos cada ponto ao cluster cujo centróide está mais próximo (o que pode ser expresso como $k = "argmin"_j || x_n - mu_j ||^2$).
]

#theorem([Valor ótimo de $mu_k$])[
  Para um conjunto fixo de associações $r_(n k)$, a escolha ótima de $mu_k$ é dada por:
  $
    mu_k = frac(sum_(n=1)^N r_(n k) x_n, sum_(n=1)^N r_(n k))
  $
]<optimal-mu-k>
#proof[
  Perceba que @kmeans-cost-function é uma função quadrática de $mu_k$. Para encontrar o valor ótimo de $mu_k$, podemos derivar a função de custo em relação a $mu_k$ e igualar a zero:
  $
    frac(partial J, partial mu_k) = 2 sum_(n=1)^N r_(n k) (mu_k - x_n) = 0
  $
  Rearranjando os termos, obtemos:
  $
    mu_k sum_(n=1)^N r_(n k) = sum_(n=1)^N r_(n k) x_n
  $
  Dividindo ambos os lados por $sum_(n=1)^N r_(n k)$, obtemos a expressão desejada para $mu_k$.
]

Perceba que no @optimal-mu-k, o centróide $mu_k$ é simplesmente a média de todos os pontos que pertencem ao cluster $k$. Isso faz sentido intuitivamente, pois queremos que o centróide represente o "centro" do cluster.

Perceba, porém, que o @kmeans-cost-function não é uma função convexa de $r_(n k)$ e $mu_k$ juntos, então não podemos otimizar ambos ao mesmo tempo. O K-means resolve isso alternando entre otimizar $r_(n k)$ e $mu_k$ iterativamente até que a convergência seja alcançada.

Além disso, o K-means é sensível à inicialização dos centróides. Diferentes inicializações podem levar a diferentes soluções locais, então é comum executar o algoritmo várias vezes com diferentes inicializações e escolher a melhor solução encontrada.

Note que eu mostrei uma forma de aplicar o K-means em batch, ou seja, considerando todos os pontos de uma vez. Existe também uma versão estocástica online do K-means, onde os centróides são atualizados à medida que novos pontos chegam. Não entraremos em detalhes da derivação, mas esse método se utiliza do procedimento de Robbins-Monro para atualizar os centróides de forma incremental. Esse procedimento é utilizado para resolver equações do tipo
$
  EE[Z(theta)] = 0
$<robbins-monro>
onde não observamos $Z(theta)$ diretamente, mas sim uma amostra $Z_n(theta)$ ruidosa de $Z(theta)$. Em Machine Learning Pattern and Recognition@mlPatternRecognition, Bishop nota que a equação do gradiente de $nabla J$ é exatamente no formato de @robbins-monro
$
  sum_(n=1)^N r_(n k) (mu_k - x_n) = 0
$
então chegamos no procedimento de atualização estocástico do K-means, que é dado por:
$
  mu_k^(t+1) = mu_k^(t) + eta_n (x_n - mu_k^(t))
$
onde $eta_n$ é a taxa de aprendizado, que deve ser escolhida de forma que ela diminua quanto mais pontos forem vistos, para garantir a convergência do algoritmo.

#figure(
  pseudocode-list(
    booktabs: true,
    title: [
      Algoritmo K-means (Batch)
    ]
  )[
    + *function* _K-means_($D$, $K$) {
      + *initialize* $mu_1,...,mu_K$ *randomly*
      + *repeat* {
        + *for* $n = 1$ *to* $N$ {
          + $r_(n k) = 0$ for all $k$
          + $r_(n k) = 1$ for $k = "argmin"_j || x_n - mu_j ||^2$
        + }
        + *for* $k = 1$ *to* $K$ {
          + $mu_k = frac(sum_(n=1)^N r_(n k) x_n, sum_(n=1)^N r_(n k))$
        + }
      + }
      + *until* convergence
    }
  ],
)

O algoritmo do K-means é baseado na distância euclidiana para medir a discrepância entre os pontos e os centróides. No entanto, essa medida não é adequada em todos os cenários. Por exemplo, se os clusters forem labels? Além de que torna $J$ não resistente à outliers. Para lidar com isso, podemos utilizar o _K-medoids_, que é uma variação do K-means que utiliza uma outra distorção qualquer $cal(V)(x, x')$ em vez da média para calcular os centróides.
$
  tilde(J) = sum_(n=1)^N sum_(k=1)^K r_(n k) cal(V)(x_n, mu_k)
$

#pagebreak()

#align(center + horizon)[
  = Gaussian Mixture Models
]

#pagebreak()


#pagebreak()

#align(center + horizon)[
  = Variational Autoencoders
]

#pagebreak()


#pagebreak()

#align(center + horizon)[
  = Generative Adversarial Networks
]

#pagebreak()



#pagebreak()

#bibliography("works.bib", title: "Referências")
