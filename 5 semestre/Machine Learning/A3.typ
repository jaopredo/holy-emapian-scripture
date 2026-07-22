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


#pagebreak()

#align(center + horizon)[
  = Generative Adversarial Networks
]

#pagebreak()



#pagebreak()

#bibliography("works.bib", title: "Referências")
