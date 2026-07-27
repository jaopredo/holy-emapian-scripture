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
    + }
  ],
)

O algoritmo do K-means é baseado na distância euclidiana para medir a discrepância entre os pontos e os centróides. No entanto, essa medida não é adequada em todos os cenários. Por exemplo, se os clusters forem labels? Além de que torna $J$ não resistente à outliers. Para lidar com isso, podemos utilizar o _K-medoids_, que é uma variação do K-means que utiliza uma outra distorção qualquer $cal(V)(x, x')$ em vez da média para calcular os centróides.
$
  tilde(J) = sum_(n=1)^N sum_(k=1)^K r_(n k) cal(V)(x_n, mu_k)
$

#pagebreak()

#align(center + horizon)[
  = Gaussian and Bernoulli Mixture Models
]

#pagebreak()

== Introdução e Definição
No k-means, cada ponto é atribuído a um único cluster, o que significa que a fronteira entre os clusters é rígida. No entanto, em muitos casos, pode ser mais apropriado permitir que cada ponto tenha uma probabilidade de pertencer a cada cluster. Isso nos leva aos Modelos de Mistura Gaussiana (GMMs), que é uma generalização do K-means.

Aqui, nós supomos que cada ponto *pode* ter saído de um dos $K$ clusters, mas não sabemos de qual, cada cluster esse sendo representado por uma distribuição gaussiana. Cada cluster $k$ é caracterizado por uma média $mu_k$ e uma matriz de covariância $Sigma_k$. Além disso, cada cluster tem um peso $pi_k$, que representa a proporção de pontos que pertencem a esse cluster.

#definition([Modelo de Mistura Gaussiana])[
  Um Modelo de Mistura Gaussiana é definido como:
  $
    p(x) = sum_(k=1)^K pi_k N(x | mu_k, Sigma_k)
  $
  onde $N(x | mu_k, Sigma_k)$ é a densidade da distribuição gaussiana com média $mu_k$ e covariância $Sigma_k$, e $pi_k$ são os pesos dos clusters, que satisfazem $sum_(k=1)^K pi_k = 1$.
]

#theorem([Validade da distribuição])[
  Seja $p(x)$ um Modelo de Mistura Gaussiana com $K$ componentes. Então, $p(x)$ é uma distribuição de probabilidade válida, ou seja, $p(x) >= 0$ para todo $x$ e $integral p(x) dif x = 1$.
]
#proof[
  Para mostrar que $p(x) >= 0$, note que cada termo na soma é não-negativo, pois $pi_k >= 0$ e $N(x | mu_k, Sigma_k) >= 0$. Portanto, $p(x) >= 0$ para todo $x$.

  Para mostrar que a integral de $p(x)$ sobre todo o espaço é igual a 1, usamos a linearidade da integral:
  $
    integral p(x) dif x &= integral sum_(k=1)^K pi_k N(x | mu_k, Sigma_k) dif x    \
    &= sum_(k=1)^K pi_k integral N(x | mu_k, Sigma_k) dif x   \
    &= sum_(k=1)^K pi_k * 1   \
    &= sum_(k=1)^K pi_k   \
    &= 1 
  $
]

Vamos também introduzir o conceito de *variável latente*. Intuitivamente, uma variável latente é uma variável que não observamos diretamente, mas que influencia os dados que observamos. Por exemplo, a classe de um documento em uma análise de tópicos, já que podemos não saber que um documento fala sobre biologia, mas ele influencia nosso modelo a aprender sobre o assunto.

No caso dos GMMs, podemos introduzir uma variável latente $z_n$ para cada ponto $x_n$, que indica de qual cluster o ponto foi gerado. Especificamente, $z_n$ é um vetor one-hot de dimensão $K$, onde $z_(n k) = 1$ se o ponto $x_n$ foi gerado pelo cluster $k$, e $z_(n j) = 0$ para $k != j$.

Vamos definir a distribuição conjunta de $x_n$ e $z_n$ como:
$
  p(x_n, z_n) = p(z_n) p(x_n | z_n)
$

a distribuição marginal de $z_n$ é definida em termo dos coeficientes de mistura $pi_k$:
$
  PP(z_(n k) = 1) = pi_k
$

de forma que $pi_k >= 0$ e $sum_(k=1)^K pi_k = 1$ para que $p(z_n)$ seja uma distribuição de probabilidade válida. Por conta da forma que definimos $z_n$ como vetor one-hot, podemos reescrever sua distribuição como:
$
  p(z_n) = product_(k=1)^K pi_k^(z_(n k))
$

Similarmente, a distribuição condicional de $x_n$ dado $z_(n k)=1$ é definida como:
$
  p(x_n | z_(n k)=1) = N(x_n | mu_k, Sigma_k)
$

que também pode ser escrita na forma:
$
  p(x_n | z_n) = product_(k=1)^K N(x_n | mu_k, Sigma_k)^(z_(n k))
$

A distribuição conjunta é escrita então como $p(z_n)p(x_n | z_n)$ e a marginal sobre $x$ é obtida somando sobre todas as possíveis configurações de $z_n$:
$
  p(x_n) = sum_(z_n) p(x_n, z_n) = sum_(z_n) p(z_n)p(x_n | z_n) = sum_(k=1)^K pi_k N(x_n | mu_k, Sigma_k)
$

Pode até parecer que, representando a distribuição de $x_n$ como uma mistura de gaussianas, estamos apenas complicando as coisas, mas a introdução da variável latente $z_n$ nos permite trabalhar com a conjunta (que vai se mostrar ser bem mais fácil de lidar) e também nos dá uma interpretação probabilística do modelo.

Outra quantidade que será importante é a probabilidade posterior de $z_n$ dado $x_n$ (chamaremos de $gamma(z_(n k))$), que é dada pelo Teorema de Bayes:
$
  gamma(z_(n k)) &= PP(z_(n k) = 1 | x_n)   \
  
  &= frac(p(z_(n k) = 1)p(x_n | z_(n k) = 1), p(x_n))    \
  
  &= frac(pi_k N(x_n | mu_k, Sigma_k), sum_(j=1)^K pi_j N(x_n | mu_j, Sigma_j))
$

Vamos interpretar $pi_k$ como a probabilidade de que o ponto $x_n$ tenha sido gerado pelo cluster $k$ *a posteriori* e $gamma(z_(n k))$ como a probabilidade de que o ponto $x_n$ pertença ao cluster $k$ *a posteriori*. Também podemos chamar $gamma(z_(n k))$ de _responsabilidade_ do cluster $k$ pelo ponto $x_n$, pois ela indica o quanto o cluster $k$ é responsável por gerar o ponto $x_n$.

== Máxima Verossimilhança
Suponha que temos um conjunto de dados $X = {x_1, x_2, ..., x_N}$ com $x_i in RR^D$ e queremos modelar essa matriz $N times D$ como uma mistura de $K$ gaussianas. As variáveis latentes $Z = {z_1, z_2, ..., z_N}$ que indicam de qual cluster cada ponto foi gerado também serão representadas por uma matriz $N times K$ de vetores one-hot. A função de log-verossimilhança do modelo é então dada por:
$
  ln p(X | mu, Sigma, pi) = sum_(n=1)^N ln p(x_n | mu, Sigma, pi) = sum_(n=1)^N ln {sum_(k=1)^K pi_k N(x_n | mu_k, Sigma_k)}
$

Acaba que maximizar essa verossimilhança diretamente é difícil, pois a presença da soma dentro do log torna a derivada complicada. Uma alternativa válida é maximizar a verossimilhança por métodos de otimização de gradiente, porém, nós vamos utilizar o algoritmo Expectation-Maximization (EM), que é um método iterativo para encontrar estimativas de máxima verossimilhança em modelos com variáveis latentes.

== Expectation-Maximization (EM) para GMMs
Para facilitar o entendimento das contas, defina $N_k = sum_(n=1)^N gamma(z_(n k))$

#theorem[
  Fixando os parâmetros do modelo e variando apenas $mu$, o valor ótimo de $mu_k$ é dado por:
  $
    mu_k = frac(sum_(n=1)^N gamma(z_(n k)) x_n, sum_(n=1)^N gamma(z_(n k))) = 1/N_k sum_(n=1)^N gamma(z_(n k)) x_n
  $
]<optimal-mean-k>
#proof[
  Para encontrar o valor ótimo de $mu_k$, derivamos a função de log-verossimilhança em relação a $mu_k$ e igualamos a zero:
  $
    frac(partial ln p(X | mu, Sigma, pi), partial mu_k) = sum_(n=1)^N underbrace(frac(pi_k N(x_n | mu_k, Sigma_k), sum_(j=1)^K pi_j N(x_n | mu_j, Sigma_j)), gamma(z_(n k))) frac(1, N(x_n | mu_k, Sigma_k)) frac(partial N(x_n | mu_k, Sigma_k), partial mu_k) = 0
  $
  A derivada da densidade gaussiana em relação a $mu_k$ é dada por:
  $
    frac(partial N(x_n | mu_k, Sigma_k), partial mu_k) = N(x_n | mu_k, Sigma_k) Sigma_k^(-1) (x_n - mu_k)
  $
  Substituindo isso na equação anterior, obtemos:
  $
    sum_(n=1)^N gamma(z_(n k)) Sigma_k^(-1) (x_n - mu_k) = 0
  $
  Multiplicando ambos os lados por $Sigma_k$, obtemos:
  $
    sum_(n=1)^N gamma(z_(n k)) (x_n - mu_k) = 0
  $
  Rearranjando os termos, obtemos:
  $
    mu_k sum_(n=1)^N gamma(z_(n k)) = sum_(n=1)^N gamma(z_(n k)) x_n
  $
  Dividindo ambos os lados por $sum_(n=1)^N gamma(z_(n k))$, obtemos a expressão desejada para $mu_k$.
]


#theorem[
  Fixando os parâmetros do modelo e variando apenas $Sigma$, o valor ótimo de $Sigma_k$ é dado por:
  $
    Sigma_k = frac(sum_(n=1)^N gamma(z_(n k)) (x_n - mu_k)(x_n - mu_k)^T, sum_(n=1)^N gamma(z_(n k))) = 1/N_k sum_(n=1)^N gamma(z_(n k)) (x_n - mu_k)(x_n - mu_k)^T
  $
]<optimal-covariance-k>
#proof[
  Para encontrar o valor ótimo de $Sigma_k$, derivamos a função de log-verossimilhança em relação a $Sigma_k$ e igualamos a zero:
  $
    frac(partial ln p(X | mu, Sigma, pi), partial Sigma_k) = sum_(n=1)^N underbrace(frac(pi_k N(x_n | mu_k, Sigma_k), sum_(j=1)^K pi_j N(x_n | mu_j, Sigma_j)), gamma(z_(n k))) frac(1, N(x_n | mu_k, Sigma_k)) frac(partial N(x_n | mu_k, Sigma_k), partial Sigma_k) = 0
  $
  A derivada da densidade gaussiana em relação a $Sigma_k$ é dada por:
  $
    frac(partial N(x_n | mu_k, Sigma_k), partial Sigma_k) = frac(1, 2) N(x_n | mu_k, Sigma_k) (Sigma_k^(-1) (x_n - mu_k)(x_n - mu_k)^T Sigma_k^(-1) - Sigma_k^(-1))
  $
  Substituindo isso na equação anterior, obtemos:
  $
    sum_(n=1)^N gamma(z_(n k)) (Sigma_k^(-1) (x_n - mu_k)(x_n - mu_k)^T Sigma_k^(-1) - Sigma_k^(-1)) = 0
  $
  Multiplicando ambos os lados por $Sigma_k$, obtemos:
  $
    sum_(n=1)^N gamma(z_(n k)) ((x_n - mu_k)(x_n - mu_k)^T Sigma_k^(-1) - I) = 0
  $
  Rearranjando os termos, obtemos:
  $
    sum_(n=1)^N gamma(z_(n k)) (x_n - mu_k)(x_n - mu_k)^T = sum_(n=1)^N gamma(z_(n k)) Sigma_k
  $
  Dividindo ambos os lados por $sum_(n=1)^N gamma(z_(n k))$, obtemos a expressão desejada para $Sigma_k$.
]


#theorem[
  Fixando os parâmetros do modelo e variando apenas $pi$, o valor ótimo de $pi_k$ é dado por:
  $
    pi_k = frac(sum_(n=1)^N gamma(z_(n k)), N) = frac(N_k, N)
  $
]<optimal-mixing-coefficient-k>
#proof[
  Sabendo que $sum_k pi_k = 1$, usamos de multiplicadores de lagrange para encontrar o valor ótimo de $pi_k$. Definimos a função lagrangiana como:
  $
    L(pi, lambda) = ln p(X | mu, Sigma, pi) + lambda (sum_(k=1)^K pi_k - 1)
  $
  Derivando em relação a $pi_k$ e igualando a zero, obtemos:
  $
    frac(partial L, partial pi_k) = frac(gamma(z_(n k)), pi_k) + lambda = 0
  $
  Isolando $pi_k$, obtemos:
  $
    pi_k = -frac(lambda, gamma(z_(n k)))
  $
  Usando a condição de normalização $sum_k pi_k = 1$, podemos encontrar o valor de $lambda$:
  $
    sum_(k=1)^K -frac(lambda, gamma(z_(n k))) = 1
  $
  Resolvendo para $lambda$, obtemos:
  $
    lambda = -frac(1, sum_(k=1)^K frac(1, gamma(z_(n k))))
  $
  Substituindo esse valor de $lambda$ na expressão para $pi_k$, obtemos:
  $
    pi_k = frac(gamma(z_(n k)), sum_(j=1)^K gamma(z_(n j))) = frac(N_k, N)
  $
]


Vale ressaltar que o @optimal-mean-k, @optimal-covariance-k e @optimal-mixing-coefficient-k não representam formas fechadas dos parâmetros do modelo, pois eles dependem de $gamma(z_(n k))$, que por sua vez depende dos próprios parâmetros do modelo. Portanto, não podemos resolver essas equações diretamente. Em vez disso, usamos o algoritmo EM, que alterna entre calcular $gamma(z_(n k))$ com os parâmetros atuais (passo E) e atualizar os parâmetros do modelo usando as fórmulas acima (passo M).

#figure(
  pseudocode-list(
    booktabs: true,
    title: [
      Algoritmo EM
    ]
  )[
    + *function* _EM_($X$) {
      + *initialize* $mu_k, Sigma_k, pi_k$
      + *\/\/ Passo E*
      + $gamma(z_(n k)) = frac(pi_k N(x_n | mu_k, Sigma_k), sum_(j=1)^K pi_j N(x_n | mu_j, Sigma_j))$
      + *\/\/ Passo M*
      + $N_k = sum_(n=1)^N gamma(z_(n k))$
      + $mu_k = 1/N_k sum_(n=1)^N gamma(z_(n k)) x_n$
      + $Sigma_k = 1/N_k sum_(n=1)^N gamma(z_(n k)) (x_n - mu_k)(x_n - mu_k)^T$
      + $pi_k = N_k / N$
      + *\/\/ Calcular a log-verossimilhança*
      + $ln p(X | mu, Sigma, pi) = sum_(n=1)^N ln{sum_(k=1)^K pi_k N(x_n | mu_k, Sigma_k)}$
    + }
  ],
)


== Algoritmo EM Variacional
O Algorimto EM que vimos agora é uma aplicação de uma versão mais geral do algoritmo EM. Ele tem como objetivo achar a verossimilhança de modelos com variáveis latentes

Representamos o conjunto de dados por uma matriz $X$ onde a $n$-ésima linha é representada por $x_n^T$. De forma similar, definimos o conjunto de variáveis latentes como uma matriz $Z$ onde a $n$-ésima linha é representada por $z_n^T$. A função de log-verossimilhança do modelo é então dada por:
$
  ln p(X | theta) = ln {sum_Z p(X, Z | theta)}
$<x-marginal-log-likelihood>

Note que nossa discussão também se aplica com variáveis latentes contínuas trocando a soma interna por uma integral. O problema central aqui é que o somatório/integral no interior do log torna a maximização da verossimilhança difícil. Chamamos o conjunto ${X, Z}$ de *dataset completo*, enquanto chamamos o conjunto ${X}$ de *dataset incompleto*. O problema é que não podemos observar $Z$, nosso conhecimento sobre as variáveis latentes se dá apenas a partir da posteriori $p(Z | X, theta)$. Como não conseguimos olhar diretamente para $ln p(X,Z|theta)$, então consideramos seu valor esperado sobre a distribuição posteriori de $Z$ dado $X$ e os parâmetros atuais $theta^((t))$. O foco desse capítulo não é dar uma derivação formal do algoritmo EM, porém, vamos deixar o framework geral escrito e mostrar ele sendo aplicado novamente ao caso das GMMs.

#figure(
  pseudocode-list(
    booktabs: true,
    title: [
      Algoritmo EM (Geral)
    ],
  )[
    + *function* _EM_($X$) {
      + *initialize* $theta^((0))$
      + *repeat* {
        + *\/\/ Passo E*
        + _calcular_ $p(Z | X, theta^((t)))$
        +
        + *\/\/ Passo M*
        + $cal(Q)(theta, theta^((t))) = sum_(z) p(z | X, theta^((t))) ln p(X, z | theta)$
        + $theta^((t+1)) = "argmax"_theta Q(theta, theta^((t)))$
        + *\/\/ Checando se convergiu*
        + *if* *not* converged *yet* {
          + $theta^((t)) = theta^((t+1))$
        + }
    + }
  ],
)

Revisitando o caso das GMMs, vamos primeiro considerar o problema de maximizar a verossimilhança do dataset completo, que é dado por:
$
  p(X, Z | mu, Sigma, pi) = product_(n=1)^N product_(k=1)^K {pi_k N(x_n | mu_k, Sigma_k)}^(z_(n k))
$
aplicando log
$
  ln p(X, Z | mu, Sigma, pi) = sum_(n=1)^N sum_(k=1)^K z_(n k) {ln pi_k + ln N(x_n | mu_k, Sigma_k)}
$
podemos ver que, em comparação com a equação @x-marginal-log-likelihood, o log da verossimilhança tem o somatório do lado de fora, o que facilita a derivada. O problema é que não podemos observar $Z$, então vamos considerar o valor esperado do log da verossimilhança do dataset completo sobre a distribuição posteriori de $Z$ dado $X$.

Pelo teorema de bayes, vamos chegar que a posteriori é obtida com:
$
  p(Z | X, mu, Sigma, pi) prop p(X, Z | mu, Sigma, pi) = product_(n=1)^N product_(k=1)^K {pi_k N(x_n | mu_k, Sigma_k)}^(z_(n k))
$
perceba que isso mostra que cada $z_n$ é independente dos outros $z_m$ dado $x_n$. Então podemos escrever a média de $z_(n k)$ sobre o regime da posteriori como:
$
  EE_(z_(n k) ~ p(z_n|x_n,...))[z_(n k)] &= frac(
    sum_(z_(n k)) z_(n k) [ pi_k N(x_n | mu_k, Sigma_k) ]^(z_(n k)),
    sum_(z_(n j)) [ pi_j N(x_n | mu_j, Sigma_j) ]^(z_(n j))
  )   \

  &= frac(
    pi_k N(x_n | mu_k, Sigma_k),
    sum_(j=1)^K pi_j N(x_n | mu_j, Sigma_j)
  )

  = gamma(z_(n k))
$

Então vamos ter que a esperança da log-verossimilhança do dataset completo sobre a distribuição posteriori de $Z$ dado $X$ é:
$
  EE_(Z ~ p(Z|X, mu, Sigma, pi))[ln p(X, Z | mu, Sigma, pi)] = sum_(n=1)^N sum_(k=1)^K gamma(z_(n k)) {ln pi_k + ln N(x_n | mu_k, Sigma_k)}
$<mean-log-likelihood-complete-data>

Dado essa equação, podemos fixar valores iniciais para $mu$, $Sigma$ e $pi$ para calcular $gamma(z_(n k))$, depois maximizamos os valores dos parâmetros do modelo com base na equação @mean-log-likelihood-complete-data com as fórmulas já vistas anteriormente no @optimal-mean-k, @optimal-covariance-k e @optimal-mixing-coefficient-k e repetimos esse processo até que a convergência seja alcançada. Esse é o algoritmo EM aplicado aos GMMs.

== Bernoulli Mixture Models
Agora que vimos os GMMs e como derivar o algoritmo de resolução do problema, que tal analisarmos o caso de variáveis com distribuições discretas? Vamos considerar o caso de variáveis binárias, que podem ser modeladas com distribuições de Bernoulli. Esse modelo também é conhecido como *Análise de Classe Latentes*

#definition([Vetor Bernoulli])[
  Considere um conjunto de $D$ variáveis aleatórias binárias $X = {x_1, x_2, ..., x_D}$, onde cada variável $x_i$ segue uma distribuição de Bernoulli com parâmetro $mu_i$, ou seja, $PP(x_i = 1) = mu_i$ e $PP(x_i = 0) = 1 - mu_i$. O vetor aleatório $x$ é chamado de vetor Bernoulli e sua função de probabilidade conjunta é dada por:
  $
    p(x|mu) = product_(i=1)^D mu_i^(x_i) (1 - mu_i)^(1 - x_i)
  $
  onde $x in RR^D$ e $mu in RR^D$
]

#theorem([Validade da distribuição])[
  Seja $p(x|mu)$ um Modelo de Mistura de Bernoulli. Então, $p(x|mu)$ é uma distribuição de probabilidade válida, ou seja, $p(x|mu) >= 0$ para todo $x$ e $sum_(x in {0,1}^D) p(x|mu) = 1$.
]
#proof[
  Para mostrar que $p(x|mu) >= 0$, note que cada termo na multiplicação é não-negativo, pois $mu_i^(x_i) >= 0$ e $(1 - mu_i)^(1 - x_i) >= 0$. Portanto, $p(x|mu) >= 0$ para todo $x$.

  Para mostrar que a soma de $p(x|mu)$ sobre todos os possíveis vetores binários de dimensão $D$ é igual a 1, usamos a propriedade da distribuição de Bernoulli:
  $
    sum_(x in {0,1}^D) p(x|mu) = sum_(x in {0,1}^D) product_(i=1)^D mu_i^(x_i) (1 - mu_i)^(1 - x_i)
  $
  Como cada termo na multiplicação é independente dos outros termos, podemos reescrever a soma como um produto de somas:
  $
    = product_(i=1)^D sum_(x_i in {0,1}) mu_i^(x_i) (1 - mu_i)^(1 - x_i)
  $
  Cada soma interna é igual a 1, pois:
  $
    sum_(x_i in {0,1}) mu_i^(x_i) (1 - mu_i)^(1 - x_i) = mu_i + (1 - mu_i) = 1
  $
  Portanto, temos:
  $
    sum_(x in {0,1}^D) p(x|mu) = product_(i=1)^D 1 = 1
  $
]


Conseguimos ver também que:
$
  EE[x] &= mu    \
  "Cov"[x] &= "diag"(mu_i (1 - mu_i))
$

#definition([Modelo de Mistura de Bernoulli])[
  Um Modelo de Mistura de Bernoulli é definido como:
  $
    p(x|mu,pi) = sum^K_(k=1) pi_k p(x|mu_k) = sum_(k=1)^K pi_k product_(i=1)^D mu_(k i)^(x_i) (1 - mu_(k i))^(1 - x_i)
  $
  onde $pi_k$ são os pesos dos clusters, que satisfazem $sum_(k=1)^K pi_k = 1$, e $mu_(k i)$ são os parâmetros da distribuição de Bernoulli para o cluster $k$.
]

#theorem([Validade da distribuição])[
  Seja $p(x|mu,pi)$ um Modelo de Mistura de Bernoulli com $K$ componentes. Então, $p(x|mu,pi)$ é uma distribuição de probabilidade válida, ou seja, $p(x|mu,pi) >= 0$ para todo $x$ e $sum_(x in {0,1}^D) p(x|mu,pi) = 1$.
]
#proof[
  Para mostrar que $p(x|mu,pi) >= 0$, note que cada termo na soma é não-negativo, pois $pi_k >= 0$ e $p(x|mu_k) >= 0$. Portanto, $p(x|mu,pi) >= 0$ para todo $x$.

  Para mostrar que a soma de $p(x|mu,pi)$ sobre todos os possíveis vetores binários de dimensão $D$ é igual a 1, usamos a linearidade da soma:
  $
    sum_(x in {0,1}^D) p(x|mu,pi) = sum_(x in {0,1}^D) sum_(k=1)^K pi_k p(x|mu_k)
  $
  Podemos trocar a ordem das somas:
  $
    = sum_(k=1)^K pi_k sum_(x in {0,1}^D) p(x|mu_k)
  $
  Cada soma interna é igual a 1, pois $p(x|mu_k)$ é uma distribuição de probabilidade válida. Portanto, temos:
  $
    = sum_(k=1)^K pi_k * 1 = sum_(k=1)^K pi_k = 1
  $
]

A média e covariância dessa distribuição de mistura é dada por:
$
  EE[x] &= sum_(k=1)^K pi_k mu_k    \
  "Cov"[x] &= sum_(k=1)^K pi_k (Sigma_k + mu_k mu_k^T) - EE[x] EE[x]^T
$

onde $Sigma_k = "diag"(mu_(k i) (1 - mu_(k i)))$. Dado um conjunto de dados $X = {x_1, ..., x_N}$ que segue o modelo de mistura de Bernoulli, a função de log-verossimilhança é dada por:
$
  ln p(X | mu, pi) = sum_(n=1)^N ln p(x_n | mu, pi) = sum_(n=1)^N ln {sum_(k=1)^K pi_k p(x_n | mu_k)}
$

vemos novamente a mesma dificuldade de maximizar a verossimilhança diretamente, então vamos encontrar as fórmulas de atualização para o algoritmo EM aplicado ao modelo de mistura de Bernoulli.

Para isso, definimos, assim como no caso de mistura de gaussianas, a variável latente $z_n$ que indica de qual cluster o ponto $x_n$ foi gerado. A distribuição condicional de $x_n$ dado $z_n$ é dada por:
$
  p(x_n|z_n,mu) = product_(k=1)^K p(x|mu_k)^(z_(n k))
$
e priori aqui é a mesma usada no caso de mistura de gaussianas:
$
  p(z_n|pi) = product_(k=1)^K pi_k^(z_(n k))
$

Antes de enunciarmos os teoremas com os valores ótimos, precisamos escrever a função de log-verossimilhança do dataset completo, que é dada por:
$
  ln p(X, Z | mu, pi) = sum_(n=1)^N sum_(k=1)^K z_(n k) {ln pi_k + sum_(i=1)^D [x_(n i) ln mu_(k i) + (1 - x_(n i)) ln (1 - mu_(k i))]}
$

E a esperança da log-verossimilhança do dataset completo sobre a distribuição posteriori de $Z$ dado $X$ é:
$
  EE_(Z ~ p(Z|X, mu, pi))[ln p(X, Z | mu, pi)] = sum_(n=1)^N sum_(k=1)^K gamma(z_(n k)) {ln pi_k \ + sum_(i=1)^D [x_(n i) ln mu_(k i) + (1 - x_(n i)) ln (1 - mu_(k i))]}
$
onde $gamma(z_(n k))$ é a probabilidade de $z_(n k) = 1$ sob a distribuição posteriori. No passo *E* do algoritmo, isso é calculado com o teorema de bayes:
$
  gamma(z_(n k)) = frac(p(z_(n k) = 1)p(x_n | z_(n k) = 1, mu_k), p(x_n | mu, pi)) = frac(pi_k p(x_n | mu_k), sum_(j=1)^K pi_j p(x_n | mu_j))
$

#theorem([Valor ótimo de $mu$])[
  Fixando os parâmetros do modelo e variando apenas $mu$, o valor ótimo de $mu_(k i)$ é dado por:
  $
    mu_(k i) = frac(sum_(n=1)^N gamma(z_(n k)) x_(n i), sum_(n=1)^N gamma(z_(n k))) = frac(1, N_k) sum_(n=1)^N gamma(z_(n k)) x_(n i)
  $
  ou
  $
    mu_k = frac(sum_(n=1)^N gamma(z_(n k)) x_n, sum_(n=1)^N gamma(z_(n k))) = frac(1, N_k) sum_(n=1)^N gamma(z_(n k)) x_n
  $
]
#proof[
  Para encontrar o valor ótimo de $mu_(k i)$, derivamos a função de log-verossimilhança em relação a $mu_(k i)$ e igualamos a zero:
  $
    frac(partial ln p(X, Z | mu, pi), partial mu_(k i)) = sum_(n=1)^N gamma(z_(n k)) frac(x_(n i) - mu_(k i), mu_(k i) (1 - mu_(k i))) = 0
  $
  Rearranjando os termos, obtemos:
  $
    sum_(n=1)^N gamma(z_(n k)) x_(n i) = mu_(k i) sum_(n=1)^N gamma(z_(n k))
  $
  Dividindo ambos os lados por $sum_(n=1)^N gamma(z_(n k))$, obtemos a expressão desejada para $mu_(k i)$.
]


#theorem([Valor ótimo de $pi$])[
  Fixando os parâmetros do modelo e variando apenas $pi$, o valor ótimo de $pi_k$ é dado por:
  $
    pi_k = frac(sum_(n=1)^N gamma(z_(n k)), N) = frac(N_k, N)
  $
]
#proof[
  Sabendo que $sum_k pi_k = 1$, usamos de multiplicadores de lagrange para encontrar o valor ótimo de $pi_k$. Definimos a função lagrangiana como:
  $
    L(pi, lambda) = ln p(X, Z | mu, pi) + lambda (sum_(k=1)^K pi_k - 1)
  $
  Derivando em relação a $pi_k$ e igualando a zero, obtemos:
  $
    frac(partial L, partial pi_k) = frac(gamma(z_(n k)), pi_k) + lambda = 0
  $
  Isolando $pi_k$, obtemos:
  $
    pi_k = -frac(lambda, gamma(z_(n k)))
  $
  Usando a condição de normalização $sum_k pi_k = 1$, podemos encontrar o valor de $lambda$:
  $
    sum_(k=1)^K -frac(lambda, gamma(z_(n k))) = 1
  $
  Resolvendo para $lambda$, obtemos:
  $
    lambda = -frac(1, sum_(k=1)^K frac(1, gamma(z_(n k))))
  $
  Substituindo esse valor de $lambda$ na expressão para $pi_k$, obtemos:
  $
    pi_k = frac(gamma(z_(n k)), sum_(j=1)^K gamma(z_(n j))) = frac(N_k, N)
  $
]

== Singularidades e Identificabilidade
É válido ressaltar a existência desse problema, que é intrínsseco do algoritmo que utilizamos (variáveis latentes) no problema de mistura de gaussianas. Para simplicidade e ilustrar o problema (também se aplica à casos mais gerais), considere uma mistura de gaussianas cujos componentes de covariância são matrizes escalares, ou seja, $Sigma_k = sigma_k^2 I$. Suponha também que um dos componentes da mistura (digamos, o $j$-ésimo) tem sua média $mu_j$ exatamente igual a algum dos pontos do banco ($x_n = mu_j$). Esse ponto então vai contribuir para a verossimilhança um termo:
$
  N(x_n | mu_j, Sigma_j) = frac(1, (2 pi)^(1/2) sigma_j)
$
se considerarmos $sigma_j -> 0$, então o termo vai para $infinity$ assim como a verossimilhança. Ou seja, o problema de maximização da log-verossimilhança não é bem definido, pois não existe um máximo global. Esse problema é conhecido como *singularidade* e é um problema clássico do algoritmo EM aplicado a modelos de mistura de gaussianas.

Outro problema é que, dado um ponto (não-degenerado) no espaço dos parâmetros, existem permutações dos parâmetros que geram a mesma distribuição de probabilidade. Por exemplo, considere uma mistura de duas gaussianas com parâmetros $mu_1, Sigma_1, pi_1$ e $mu_2, Sigma_2, pi_2$. Se permutarmos os índices das gaussianas, ou seja, trocarmos $mu_1$ com $mu_2$, $Sigma_1$ com $Sigma_2$ e $pi_1$ com $pi_2$, a distribuição de probabilidade gerada será a mesma. Esse problema é conhecido como *identificabilidade* e é um problema clássico do algoritmo EM aplicado a modelos de mistura de gaussianas.


#pagebreak()

#align(center + horizon)[
  = Variational Autoencoders
]

#pagebreak()

== Introdução

Autoencoders são modelos de aprendizado não supervisionado projetados para aprender representações compactas dos dados. Seu objetivo é comprimir uma entrada em uma representação de menor dimensão e, em seguida, reconstruir a entrada original a partir dessa representação.

A arquitetura de um autoencoder é composta por duas partes principais:

- *Encoder:* transforma a entrada original em uma representação latente, também chamada de *código* ou *embedding*.
- *Decoder:* utiliza essa representação latente para reconstruir uma aproximação da entrada original.

De forma simplificada, dado um dado de entrada (x), o encoder produz uma representação (z),

$
z = f(x),
$

e o decoder gera uma reconstrução ($hat(x)$),

$
 hat(x) = g(z).
$

Durante o treinamento, os parâmetros do modelo são ajustados para minimizar a diferença entre (x) e ($hat(x)$), fazendo com que a representação latente retenha as características mais relevantes dos dados.

Ao aprender a reconstruir as entradas a partir de uma representação comprimida, os autoencoders podem descobrir estruturas e padrões presentes nos dados, sendo amplamente utilizados para redução de dimensionalidade, compressão, remoção de ruído, detecção de anomalias e aprendizado de representações.


== Autoencoders Determinísticos
Esses autoencoders são versões clássicas e mais simples. Eles consistem em uma rede neural que aprende a mapear entradas para saídas, passando por uma camada intermediária de menor dimensão. O objetivo é minimizar a diferença entre a entrada e a saída reconstruída, geralmente utilizando funções de perda como o erro quadrático médio (MSE).

=== Autoencoders Profundos
A principal ideia desse autoencoder é uma rede neural que recebe como input um vetor $x in RR^D$, passa ele por diversas camadas ocultas de menor dimensão e tenta, a partir de um novo vetor $z in RR^M$ ($M < D$) reconstruir o vetor original $x$. A função de perca utilizada nesses autoencoders é dada por:
$
  E(w) = 1/2 sum_(n=1)^N || x_n - y(x_n, w) ||^2
$
onde $y(x_n, w)$ é a saída da rede neural com pesos $w$ para a entrada $x_n$. A função de perda é minimizada utilizando o algoritmo de retropropagação (backpropagation) e métodos de otimização como o gradiente descendente.

#figure(
  image("images/deep-autoencoder.png"),
  caption: [
    Arquitetura de um autoencoder profundo. A entrada $x$ é comprimida em uma representação latente $z$ e, em seguida, reconstruída como $y(x, w)$.
  ]
)<deep-autoencoder>

Como podemos ver na @deep-autoencoder, a arquitetura do autoencoder profundo pode ser interpretada como dois mapeamentos distintos $F_1$ e $F_2$, onde $F_1$ é o encoder que mapeia a entrada $x$ para a representação latente $z$, e $F_2$ é o decoder que mapeia a representação latente $z$ de volta para a reconstrução da entrada original $y(x, w)$. A função de perda é então minimizada ajustando os pesos da rede neural para melhorar a qualidade da reconstrução.

=== Autoencoders Esparsos

Uma forma tradicional de limitar a capacidade de um autoencoder consiste em utilizar uma representação latente de dimensão menor que a dimensão dos dados de entrada. Entretanto, essa não é a única maneira de impor uma representação compacta. Nos *autoencoders esparsos*, em vez de restringir o número de neurônios da camada latente, utiliza-se uma regularização que incentiva apenas uma pequena fração desses neurônios a permanecer ativa para cada exemplo.

A ideia é permitir que a camada latente possua muitas unidades, mas forçar a maioria delas a assumir valores nulos ou próximos de zero. Dessa forma, cada amostra é representada por apenas alguns neurônios ativos, produzindo uma representação de baixa dimensionalidade efetiva.

Uma forma simples de obter esse comportamento é adicionar uma penalização $L_1$ sobre as ativações da camada latente. A função de custo passa a ser dada por

$
E(w) = tilde(E)(w) + lambda sum_(m=1)^M abs(z_m),
$

onde $tilde(E)(w)$ representa o erro de reconstrução, $z_m$ corresponde à ativação do neurônio latente $m$, e $lambda$ controla a intensidade da regularização.

Como a norma $L_1$ favorece soluções esparsas, o treinamento passa a buscar simultaneamente uma boa reconstrução dos dados e uma representação latente na qual poucos neurônios estejam ativos. Em consequência, o modelo é capaz de aprender características relevantes dos dados mesmo quando a camada latente possui um número elevado de unidades.

=== Denoising Autoencoders
Vimos que para o autoencoder aprender representações úteis, é necessário impor restrições à sua capacidade de reconstrução. Uma abordagem alternativa é treinar o autoencoder para reconstruir a entrada original a partir de uma versão corrompida dela. Essa técnica é conhecida como *denoising autoencoder*. Assim, intuitivamente, eu forço o meu autoencoder a aprender representações robustas dos dados, que capturam as características essenciais e ignoram o ruído.
$
  E(w) = 1/2 sum_(n=1)^N || x_n - y(tilde(x)_n, w) ||^2
$

Um método de impor ruído nas entradas é selecionar uma fração $tau in (0, 1)$ das amostras e colocar parte de suas entradas como $0$. Por exemplo, se $tau = 0.2$, então 20% das entradas de cada amostra selecionada serão corrompidas, ou seja, substituídas por zero. Outro método é adicionar ruído gaussiano às entradas, ou seja, para cada entrada $x_n$, adicionamos um ruído $epsilon$ proveniente de uma distribuição normal com média zero e desvio padrão $sigma$, resultando em uma entrada corrompida $tilde(x)_n = x_n + epsilon$.


== Autoencoders Variacionais
Agora chegamos na brincadeira de gente grande. Nós já vimos que, a função de verossimilhança de um modelo com variáveis latentes dada por:
$
  p(x|w) = integral p(x|z, w) p(z) dif z
$
onde $p(x|z,w)$ é definida por uma rede neural profunda, é intratável pois a integral em $z$ não tem forma fechada. Os autoencoders variacionais (VAEs) resolvem esse problema utilizando uma aproximação variacional para a posteriori $p(z|x,w)$, que é definida por outra rede neural profunda. A ideia é otimizar os parâmetros do modelo para maximizar a verossimilhança dos dados, enquanto simultaneamente aproximamos a posteriori das variáveis latentes. Existem 3 conceitos-chave dentro dos VAEs:

+ Utilizar o *ELBO* (Evidence Lower Bound) para aproximar a verossimilhança dos dados
+ *Inferência Amortizada* onde um segundo modelo, a *rede encoder*, é usada para aproximar a distribuição posteriori das variáveis latentes no passo *E* em vez de calcular para cada ponto
+ Fazer o treino da rede encoder tratável utilizando do *truque da reparametrização*

Considere um modelo generativo com distribuição $p(x|z,w)$ governado pela saída de uma rede $g(w,z)$ (Por exemplo, $g(w,z)$ retorna a média de uma distribuição gaussiana). Considere também $p(z) ~ N(0, I)$ sobre $z in RR^M$

Lembrando do documento da A1, vimos que:
$
  ln p(x|w) = cal(L)(w) + "KL"(q(z) || p(z|x,w))
$
onde $cal(L)(w)$ é o ELBO e $q(z)$ é a distribuição aproximada das variáveis latentes e $cal(L)(w)$ é dado por:
$
  cal(L)(w) = integral q(z) ln frac(p(x|z,w)p(z), q(z)) dif z
$
e $"KL"(p||q)$ é definido como:
$
  "KL"(p||q) = integral p(z) ln frac(p(z), q(z)) dif z
$

Pelo que tinhamos visto no primeiro documento, sabemos que $ln p(x|w) >= cal(L)$ (Por isso o nome EVIDENCE *LOWER BOUND*). Mesmo que $ln p(x|w)$ seja intratável, podemos aproximar ela utilizando de $cal(L)$ aproximado por *monte carlo*.

Considere o conjunto de dados $x_1,...,x_N$. Temos então que
$
  ln p(D|w) = sum_(n=1)^N cal(L)_n + sum_(n=1)^N "KL"(q_n (z_n|x_n) || p(z_n|x_n,w))
$<elbo-dataset-likelihood>

onde
$
  cal(L)_n = integral q_n (z_n|x_n) ln {frac(p(x_n|z_n,w) dot p(z_n), q_n (z_n|x_n))} dif z_n
$

Perceba que agora, cada $x_n$ tem sua variável latente, o que indica que cada variável $z_n$ tem sua distribuição $q_n (z_n|x_n)$. Como a equação @elbo-dataset-likelihood é mantida independente da escolha de $q_n (z_n|x_n)$, podemos escolher $q_n (z_n|x_n)$ para cada ponto $x_n$ de forma à maximizar $cal(L)_n$ ou, equivalentemente, minimizar $"KL"(q_n (z_n|x_n) || p(z_n|x_n,w))$. EM GMMs, conseguimos achar $q_n (z_n|x_n)$ de forma exata ($q_n (z_n|x_n) = p(z_n|x_n,w)$)
$
  p(z_n|x_n,w) = frac(p(x_n|z_n,w)p(z_n), p(x_n|w))
$

o numerador é trivial de calcular, mas o denominador é intratável. Então precisamos de um método diferente para aproximar $q_n (z_n|x_n)$.

=== Inferência Amortizada
Nessa abordagem, nós treinamos *uma única* rede neural para aproximar todas as posterioris $p(z_n|x_n,w)$, chamada de *Encoder Network*. Essa abordagem se chama *inferência amortizada* que requer um encoder que gera uma única distribuição $q(z|x,phi)$ condicionada em $x$, onde $phi$ são os parâmetros da rede neural. Nessa abordagem, a função-objetivo (dada pelo ELBO) depende tanto de $phi$ quanto de $w$, assim ela faz a otimização conjunta dos parâmetros com abordagens baseadas em gradiente.

#figure(
  image("images/autoencoder.png", width: 80%),
  caption: [
    Arquitetura de um autoencoder variacional
  ]
)

Um encoder variacional é então composto por duas redes, um *encoder* que mapeia do espaço dos dados para um espaço latente e um *decoder* que mapeia do espaço latente de volta para o espaço dos dados e ambas as redes são treinadas simultaneamente para maximizar o ELBO.

Certo, mas agora temos que decidir ao menos qual espaço latente nós gostariamos de mapear nossos dados pra termos uma base, correto? Sim! Uma escolha muito comum de se usar para o encoder é uma Gaussiana $N(mu_j, sigma_j^2 I)$ onde $mu_j$ e $sigma_j$ são outputs de uma rede neural
$
  q(z|x,phi) = product_(j=1)^M N(z_j | mu_j (x,phi), sigma_j^2 (x,phi))
$

=== Truque da Reparametrização
Infelizmente, temos que o lower bound ainda é intratável
$
  cal(L)_n (w, phi) = integral q(z_n|x_n,phi) ln {frac(p(x_n|z_n,w)p(z_n), q(z_n|x_n,phi))} dif z_n
$
porque envolve integrar sobre as variáveis latentes ${z}$ e ele depende de forma complexa dos parâmetros da rede neural. Porém, podemos decompor essa integral em duas partes:
$
  cal(L)_n (w, phi) = EE_(z_n ~ q) [ln p(x_n|z_n,w)] - "KL"(q(z_n|x_n,phi) || p(z_n))
$<elbo-decomposition>

Se nós escolhemos $q(z_n|x_n,phi)$ como uma Gaussiana, e $p(z_n)$ também, então a divergência KL entre elas tem uma forma fechada, que é dada por:
$
  "KL"(q(z_n|x_n,phi) || p(z_n)) = frac(1,2) sum_(j=1)^M {1 + ln sigma_j^2 (x_n,phi) - sigma_j^2 (x_n,phi) - mu_j^2 (x_n,phi)}
$
Já com relação à primeira parte, podemos tentar aproximar ela utilizando *monte carlo*
$
  EE_(z_n ~ q) [ln p(x_n|z_n,w)] = integral q(z_n|x_n,phi) ln p(x_n|z_n,w) dif z_n approx frac(1, L) sum_(l=1)^L ln p(x_n|z_n^((l)),w)
$
onde ${z_n^((l))}$ são amostras de $q(z_n|x_n,phi)$. Toda essa equação @elbo-decomposition é diferenciável com relação a $w$, no entanto, ela tem uma relação complexa em $phi$ para ser facilmente diferenciável.

#figure(
  image("images/autoencoder-structure-without-reparametrization.png"),
  caption: [
    Esquema de como o erro se espalha no autoencoder. O fato de $z$ depender de $phi$ de forma complexa impede que o gradiente seja propagado através do processo de amostragem.
  ]
)

Para consertar isso, utilizamos do *truque da reparametrização*. Nessa abordagem, nós não vamos amostrar $z_n^((l))$ diretamente. Em vez disso, vamos amostrar $epsilon ~ N(0,1)$. Após amostrar $epsilon$, nós podemos reparametrizar $z_n^((l))$ como:
$
  z_(n j)^((l)) = mu(x_n,phi) + sigma(x_n,phi) dot epsilon_(n j)^((l))
$
pois sabemos que $z_n^((l)) ~ N(mu(x_n,phi), sigma^2(x_n,phi))$. Dessa forma, a amostragem de $z_n^((l))$ é feita de forma diferenciável com relação a $phi$, permitindo que o gradiente seja propagado através do processo de amostragem. Dessa forma, a função de erro do autoencoder variacional, depois de todas nossas premissas, é dada por:
$
  cal(L) = sum_n { frac(1, 2) sum_(j=1)^M {1 + ln sigma_(n j)^2 - sigma_(n j)^2- mu_(n j)^2} + frac(1, L) sum_(l=1)^L ln p(x_n|z_n^((l)), w) }
$
onde, para simplificar a notação, nós escrevemos $mu_(n j) = mu_j (x_n,phi)$ e $sigma_(n j) = sigma_j (x_n,phi)$ e $z_n^((l)) = mu(x_n,phi) + sigma(x_n,phi) dot epsilon^((l))$.

#figure(
  image("images/autoencoder-structure-with-reparametrization.png"),
  caption: [
    Esquema de como o erro se espalha no autoencoder após o truque da reparametrização. Como a amostragem não depende mais de $phi$, o gradiente pode ser propagado através do processo de amostragem.
  ]
)

#figure(
  pseudocode-list(
    booktabs: true,
    title: [
      Treinamento do VAE
    ]
  )[
    + *function* _train_VAE_($D$, $w$, $phi$) {
      + *for* $x_n in D$ {
        + $cal(L) <- 0$
        + *for* $j in {1, 2, ..., M}$ {
          + $epsilon_(n j) ~ N(0,1)$
          + $z_(n j) <- mu_(n j) + sigma_(n j) dot epsilon_(n j)$
          + $cal(L) <- cal(L) + 1/2 (1 + ln sigma_(n j)^2 - sigma_(n j)^2 - mu_(n j)^2)$
        + }
        + $cal(L) <- cal(L) + ln p(x_n|z_n, w)$
        + $w <- w - eta * gradient_w cal(L)$
        + $phi <- phi - eta * gradient_phi cal(L)$
    + }
  ]
)

#pagebreak()

#align(center + horizon)[
  = Generative Adversarial Networks
]

#pagebreak()

== Introdução
Esse capítulo trata de um método de aprendizado não supervisionado usado para treinar modelos *generativos*. Esses modelos são capazes de gerar novos exemplos que se assemelham aos dados de treinamento. A ideia central é simples. Queremos que as novas amostras geradas por nosso modelo generativo sejam tão boas que seja difícil afirmar qual é a amostra real e qual é a amostra gerada. Para isso, utilizamos uma abordagem de aprendizado adversarial, onde dois modelos competem entre si: um gerador e um discriminador.

Enquanto o modelo generativo cria imagens, o discriminador tenta distinguir entre imagens reais e imagens geradas. O objetivo do gerador é enganar o discriminador, enquanto o objetivo do discriminador é identificar corretamente as imagens reais e falsas. Esse processo de competição leva a uma melhoria contínua de ambos os modelos, resultando em um gerador capaz de produzir amostras realistas.

== Treinamento Adversarial
Vamos considerar um modelo generativo baseado numa transformação de uma variável latente $z$ para o espaço dos dados $x$. Por simplicidade, vamos definir
$
  p(z) = N(0, I)
$
juntamente de uma transformação não-linear $g(z, w)$ definida por uma rede neural profunda com parâmetros $w$ conhecida como *gerador*. Essas definições implicam que há uma distribuição de probabilidade sobre $x$ que queremos encaixar em cima dos nossos dados. No entanto, nós não conseguimos determinar $w$ maximizando a verossimilhança, já que em geral não tem forma fechada.

Como já explicamos, a ideia das GANs é introduzir uma segunda rede que vai ser treinada em conjunto com a rede *geradora*, a chamada *discriminadora*. Seu trabalho é distinguir entre amostras reais e amostras geradas. O discriminador é definido como uma rede neural profunda $d(x, phi)$ com parâmetros $phi$ que retorna a probabilidade de $x$ ser uma amostra real. O discriminador é treinado para maximizar a probabilidade de classificar corretamente as amostras reais e falsas, enquanto o gerador é treinado para fazer com que a probabilidade seja a mais próxima possível de $0.5$, ou seja, o gerador quer enganar o discriminador.

== Função de Custo
Para definir isso precisamente, vamos definir uma variável binária:
$
  t = cases(
    1 "se" x "é real",
    0 "se" x "é sintética"
  )
$

a rede discriminadora possui um único output com uma ativação sigmoidal. Esse output representa a probabilidade de $x$ ser real, ou seja
$
  d(x, phi) = PP(t=1|x, phi)
$

nós treinamos a rede discriminadora usando a clássica função cross-entropy
$
  E(w, phi) = - frac(1, N) sum_(n=1)^N {t_n ln d(x_n, phi) + (1 - t_n) ln (1 - d(x_n, phi))}
$

O dataset utilizado tem tanto as amostras reais $x_n$ quanto as sintéticas $z_n$ geradas pelo gerador. Então podemos separar o dataset $D$ em $D_"real"$ e $D_"sintético"$. Dessa forma, como definimos que $t=1$ para amostras reais e $t=0$ para amostras sintéticas, podemos reescrever a função de custo como:
$
  E(w, phi) = - frac(1, N_"real") sum_(n in D_"real") ln d(x_n, phi) - frac(1, N_"sintético") sum_(n in D_"sintético") ln (1 - d(z_n, phi))
$<gan-cost-function>

onde (normalmente) $N_"real" = N_"sintético"$, ou seja, o dataset é balanceado. O interessante desse método é que podemos otimizar a função com base no gradiente, no entanto, nós a minimizamos com relação a $phi$ e *maximizamos* com relação a $w$. Ou seja, o gerador quer maximizar a função de custo, enquanto o discriminador quer minimizar. Isso é conhecido como *jogo de soma zero*.

O modo de treino que apresentamos até o momento faz com que o gerador aprenda distribuições não-condicionais $p(x)$. Por exemplo, se ele for treinado com imagens de cachorros, ele vai aprender a gerar imagens de cachorros. No entanto, podemos criar GANs condicionais, onde o gerador aprende uma distribuição $p(x|c)$ onde $c$ pode, por exemplo, representar um vetor que especifica a raça do cachorro.

== Treinamento do GAN
Por mais que essa abordagem de treinamento seja interessante e gere ótimos resultados, ela possui algumas dificuldades por conta do aprenzidado adversarial.

Um desafio que pode surgir durante o treinamento é o *colapso do modo* (mode collapse). Isso ocorre quando o gerador aprende a produzir apenas um conjunto limitado de amostras, ignorando a diversidade presente nos dados reais. Como resultado, o gerador pode gerar imagens muito semelhantes entre si, mesmo que os dados reais sejam variados. Por exemplo, num dataset de digitos, o gerador pode aprender a gerar apenas o dígito "3", mesmo que o dataset contenha todos os dígitos de 0 a 9. Isso indica que o gerador não está capturando a diversidade dos dados reais, resultando em uma representação limitada do espaço de entrada. Isso ocorre pois o gerador encontra um ponto ótimo local que engana o discriminador, mas não representa a distribuição real dos dados.

#figure(
  image("images/gan-learning.png"),
)

Essa imagem mostra um exemplo dos dados reais provindos da distribuição *fixa*, mas *desconhecida*, $p_"Data" (x)$ e os dados do gerador $p_G (x)$. Podemos ver que, como os dados são muito distintos, o discriminador consegue facilmente distinguir entre eles. No entanto, justamente por conta dos dados iniciais do gerador serem tão diferentes e o discriminador classificá-los tão bem, o treinamento do gerador não é eficiente, pois pequenas aleterações no seu processo de geração de amostras não vão enganar o discriminador. Para contornar isso, podemos utilizar de uma função discriminadora mais suave, na imagem representada por $tilde(d)(x)$


#pagebreak()

#bibliography("works.bib", title: "Referências")
