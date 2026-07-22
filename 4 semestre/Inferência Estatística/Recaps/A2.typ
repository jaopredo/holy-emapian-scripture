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
#let example = thmplain("example", "Exemplo")
#let proof = thmproof("proof", "Demonstração")

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


// ============================ PRIMEIRA PÁGINA =============================
#align(center + top)[
  FGV EMAp

  João Pedro Jerônimo
]

#align(horizon + center)[
  #text(17pt)[
    Inferência Estatística
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

#align(center+horizon)[
  = Distribuição Amostral de Estimadores
]

#pagebreak()

Quando temos um estimador $delta$, e note que estamos falando de um *estimador* e não de uma *estimativa*, temos que, como ele é função de variáveis aleatórias, ele próprio é uma variável aleatória, que possui sua própria distribuição, seus próprios parâmetros, média, variância, etc. Essa distribuição própria da estimativa é o que chamamos de *Distribuição Amostral do Estimador*

#definition("Distribuição Amostral do Estimador")[
  Dadas as variáveis aleatórias $underline(X) = (X_1,...,X_n)$ e $T = r(underline(X))$ um estimador, onde $underline(X)$ tem uma distribuição indexada pelo parâmetro $theta$, então a distribuição de $T|theta$ chamada de Distribuição Amostral de $T$. ($EE_theta [T]$ é a média de $T$ na distribuição amostral)
]

O nome vem do fato que $T$ depende da amostra $underline(X)$. Na maioria das vezes, $T$ não depende de $theta$. Mas por que essa distribuição me é interessante?

Vamos supor que eu tenho um estimador $hat(theta)$ de $theta$, pode me ocorrer de eu querer saber a chance de o meu estimador estar próximo do meu $theta$ de verdade, por exemplo, qual a chance de a distância entre meu estimador e meu $theta$ ser de só $0.1$ medidas? Então podemos querer calcular:
$
  PP(|hat(theta)-theta|<0.1)
$
Pela lei da probabilidade total, temos também:
$
  PP(|hat(theta)-theta|<0.1) = EE[PP(|hat(theta)-theta|<0.1|theta)]
$

Outro uso que podemos derivar para a distribuição amostral é escolher entre vários experimentos qual será performado para obter o melhor estimador de $theta$. Por exemplo, podemos querer saber qual a quantidade de amostras necessárias para atingir um objetivo em específico

#figure(
  image("images/posterior-vs-mle.png", width: 80%),
  caption: [Imagem que representa $PP(|hat(theta)-theta)|<0.1)$ em função da quantidade de amostras em um dos exemplos do livro, mostrando que dependendo da nossa situação, podemos quere escolher estimadores diferentes]
)

Uma outra medida interessante que foi apresentada em um dos exemplos do livro é uma distância relativa:
$
  PP(|hat(theta)/theta - 1|<0.1)
$

Ou seja, a probabilidade de que meu estimador esteja a pelo menos $10%$ de $theta$ de distância de $theta$

#example[
  Vamos tentar condensar tudo o que vimos em um exemplo. Vamos supor que temos uma clínica que está a fim de identificar ou prever pacientes candidatos a um remédio específico para tratamento da depressão. Então podemos modelar a variável aleatória de um paciente usar ou não esse remédio como uma Bernoulli com $theta$ de chance de utilizar o remédio ($PP(X = 1) = theta$). Sabemos por capítulos anteriores que $T = 1/n sum^n_(i=1)X_i$ (A proporção de pacientes que vão utilizar o remédio) é uma estatística suficiente e também é o EVM (Estimador de Máxima Verossimilhança) de $theta$

  Porém, $T$ também é uma variável aleatória com distribuição própria, então ela pode assumir vários valores, mas queremos que ela seja o mais próximo possível de $theta$. Então, que tal calcularmos:
  $
    PP(|T - theta| < 0.1)
  $

  Para isso temos que saber exatamente a distribuição de $T$. Não é muito dificil, na verdade! Sabemos que $T = 1/n Y$ com $Y = sum^n_(i=1)X_i$ e $Y|theta ~ "Bin"(n,theta)$. Então sabemos que:
  $
    PP(T = t|theta) = PP(1/n Y = t|theta) = PP(Y = n t|theta)    \

    = mat(n; n t) theta^(n t) (1-theta)^(n - n t)
  $

  Assim, encontramos a nossa Distribuição Amostral do estimador $T$. Então agora poderíamos calcular a equação mencionada anteriormente
  $
    PP(|T-theta|<0.1)=PP(-0.1 < T-theta < 0.1) = PP(theta - 0.1 < T < theta + 0.1)
  $

  Podemos utilizar a distribuição amostral de $T$ que encontramos anteriormente, porém, por questões de praticidade, vou fazer um pouco diferente:
  $
    PP(theta-0.1 < T < theta + 0.1) = PP(ceil((theta-0.1)n) <= Y <= floor((theta+0.1)n))
  $
  Eu adicionei o piso e o teto por conta que $Y$ assume apenas valores inteiros. Então temos que:
  $
    PP(|T-theta| < 0.1) = sum_(k=ceil((theta-0.1)n))^(floor((theta+0.1)n)) mat(n ; k) theta^k (1-theta)^(n-k)
  $
]

#pagebreak()

#align(center+horizon)[
  = Distribuição Chi-Quadrado
]

#pagebreak()

Essa distribuição é muito utilizada dentro da estatística serve como base para uma outra distribuição que veremos posteriormente. Ela vai ser útil no próximo capítulo também pois ela é a distribuição do estimador de máxima verossimilhança da variância de uma Normal com média $mu$ conhecida
$
  hat(sigma^2) = 1/n sum^n_(i=1) (X_i - mu)^2
$

#definition[
  $forall m in RR$, uma distribuição Gamma$(m/2,1/2)$ é também chamada de $Chi^2_m$ (Chi quadrado com $m$ graus de liberadade). Ou seja, se $X ~ Chi^2_m$:
  $
    f_X (x) = (1/2)^(m/2) / Gamma(m/2) x^(m/2 - 1) e^(-1/2 x)
  $
]

== Propriedades

#theorem[
  Se $X~Chi_m^2$ então:
  $
    EE[X] = m wide VV[X] = 2m
  $
]
#proof[
  A esperança de uma Gamma$(alpha, beta)$ é $alpha/beta$, logo:
  $
    EE[X] = (m/2) / (1/2) = m
  $
  E a variância é $alpha/beta^2$, logo:
  $
    VV[X] = (m/2)/(1/4) = 2 m
  $
]

#theorem[
  A função geradora de momentos de uma $Chi_m^2$ é dada por
  $
    psi(t) = (1/(1-2t))^(m\/2) wide (t < 1/2)
  $
]

#theorem[
  Se $X_1,...,X_k$ são iid e $X_i ~ Chi^2_m_i$, então $Y = sum^k_(j=1)X_j ~ Chi^2_(sum^k_(j=1)m_j)$
]<sum-of-independent-chi-squares>
#proof[
  Sabemos que, dado a FGM de $X$ ($psi_X$) e de $Y$ ($psi_Y$) onde $X$ e $Y$ são iid, então a FGM de $X + Y$ é $psi_X psi_Y$. Sabendo disso, calculamos a FGM de $X_1 + ... + X_k$:
  $
    psi_Y (t) &= product^k_(j=1) (1/(1-2t))^(m_j\/2) wide (t < 1/2)  \

    &= (1/(1-2t))^(1/2 sum^(k)_(j=1) m_j) wide (t < 1/2)
  $
]

#theorem[
  Se $X ~ N(0,1)$, então $Y = X^2 ~ Chi^2_1$
]
#proof[
  Sabemos que se $X$ tem pdf $f_X (x)$ e $Z=h(X)$, então a pdf de $Z$ é
  $
    f_Z (z) = (f_X (x)) / (|h'(x)|)
  $
  Então, considerando $h(x) = x^2$ e $f_X (x) = 1/sqrt(2pi) e^(-x^2/2)$, temos que
  $
    f_Z (z) = (1/sqrt(2pi) e^(-x^2/2)) / (2 x ) = 1/(2 sqrt(pi z)) e^(-1/2 z)
  $
  Perceba que isso é a densidade de uma $Chi^2_1$, veja:
  $
    (1/2)^(1/2) / Gamma(1/2) z^(1/2 - 1) e^(-1/2 z) = 1/sqrt(2) / sqrt(pi) 1/sqrt(z) e^(-1/2 z) = 1/sqrt(2pi z) e^(-1/2 z)
  $
  Logo, $Z ~ Chi^2_1$. A função $f_Z (z)$ possui um termo $1/2$ pois preciamos lembrar que a normal vai de $[-infinity, infinity]$, então para que $h(x)$ seja monótona, precisamos restringir em $[-infinity, 0]$ e $[0, infinity]$ então obtemos duas funções que integram $1/2$ em cada intervalo, logo o resultado integra $1$
]

#corollary[
  Se $X_1,...,X_n ~ N(0,1)$, então:
  $
    X_1^2 + ... + X_n^2 ~ Chi_m^2
  $
]


#pagebreak()

#align(center+horizon)[
  = Distribuição Conjunta da Média e Variância Amostral
]

#pagebreak()

Vamos supor que estamos fazendo um experimento e coletamos amostras de uma distribuição normal com média $mu$ e variância $sigma^2$, porém, não sabemos nenhum dos dois, então queremos estimá-los! Podemos escolher vários estimadores, por exemplo, o EVM:
$
  hat(mu) = 1/n sum^n_(i=1) X_i wide hat(sigma^2) = 1/n sum^n_(i=1)(X_i - hat(mu))^2
$
Porém, como vimos na primeira parte, eles são variáveis aleatórias com distribuições próprias, então podemos utilizar técnicas para saber o quão bem eles aproximam $mu$ e $sigma^2$, mas antes, temos que descobrir suas distribuições amostrais! Acontece que a distribuição de $hat(mu)$ depende de $sigma^2$, porém, veremos que a distribuição conjunta de $hat(mu)$ e $hat(sigma^2)$ nos permite inferir $mu$ sem referenciar $sigma$

== Independência da Média e Variância Amostrais
#theorem[
  Suponha que as variáveis $X_1,...,X_n$ são iid, onde $X_j ~ N(0,1)$. Seja $Q$ uma matriz ortogonal $n times n$ e $underline(Y) = Q underline(X)$ onde $underline(X) = (X_1,...,X_n)^T$, então $Y_j ~ N(0,1)$ e $Y_1,...,Y_n$ são iid, além de que $sum X_i^2 = sum Y_i^2$
]<normals-orthogonal-transformation>
#proof[
  A distribuição conjunta de $X_1,...,X_n$ é dada por:
  $
    f_X (underline(x)) = 1/(2 pi)^(n/2) exp { -1/2 sum^n_(i=1)x_i^2 }
  $
  Sabemos que, se $Z = h(Y)$ com $h$ monótona, então
  $
    f_Z (z) = (f_Y (y)) / (|h'(y)|)
  $
  Se considerarmos $h(x) = Q x$, então $underline(Y) = h(underline(X))$, logo:
  $
    f_Y (y) = (f_X (Q^T y)) / (|det(Q)|)
  $
  Porém, $det(Q)=1$ pois $Q$ é ortogonal. Além disso, sabemos que $||x||^2 = ||Q x||^2$, então:
  $
    f_Y (y) = 1/(2 pi)^(n/2) exp {-1/2 sum^(n)_(i=1) y_i^2}
  $
  Logo, chegamos que $Y_j ~ N(0,1)$ e são iid
]

Agora vamos demonstrar um dos teoremas mais surpreendentes da estatística

#theorem("Independência da Média e Variância Amostral")[
  Sejam $X_1,...,X_n ~ N(mu, sigma^2)$ e dados os estimadores:
  $
    hat(mu) = 1/n sum^n_(i=1)X_i wide hat(sigma^2) = 1/n sum^n_(i=1)(X_i - hat(mu))^2
  $
  As variáveis aleatórias $hat(mu)$ e $hat(sigma^2)$ são *INDEPENDENTES* entre si. Junto desse teorema, também mostraremos que:
  $
    1/sigma^2 sum^n_(i=1)(X_i - hat(mu))^2 ~ Chi^2_(n-1)
  $
]<sample-mean-and-sample-variance-independence>
#proof[
  Primeiro vamos provar considerando que $mu = 0$ e $sigma^2 = 1$, de forma que utilizaremos esse resultado para generalizar posteriormente.

  Vamos primeiro definir $u = mat(1/sqrt(n), ..., 1/sqrt(n))^T$, então construímos uma matriz $Q$ utilizando Gram-Schmidt de forma que $u$ seja a primeira linha dessa matriz. Então definimos:
  $
    mat(Y_1;dots.v;Y_n) = Q mat(X_1;dots.v;X_n)
  $
  Vimos pelo @normals-orthogonal-transformation que $Y_j$ são iid e são normais padrão também. Guarde essa informação! Não é difícil ver que:
  $
    Y_1 = 1/sqrt(n) sum^n_(i=1) X_i = hat(mu) sqrt(n)
  $
  Como $sum^(n)_(i=1) X_i^2 = sum^(n)_(i=1) Y_i^2$, então:
  $
    sum^(n)_(i=2) Y_i^2 = sum^(n)_(i=1) Y_i^2 - Y_1^2 = sum^(n)_(i=1)X_i^2 - n (hat(mu))^2 = sum^(n)_(i=1)(X_i - hat(mu))^2
  $
  Ou seja, $hat(mu)$ e $hat(sigma^2)$ são independentes! Dado esse resultado, consideremos agora média e variância não-padrões. Então vamos definir:
  $
    Z_i = (X_i - mu)/sigma
  $
  Então $Z_1,...,Z_n$ são iid. Sabemos que $overline(Z)_n$ e $sum(Z_i - overline(Z)_n)$ são independentes. Perceba também que, como $sum(Z_i - overline(Z)_n)$ = $sum_(i=2)^n Y_i$, então $sum(Z_i - overline(Z)_n) ~ Chi^2_(n-1)$. Porém, sabemos também que $overline(X)_n ~ N(mu, sigma^2 / n)$, então
  $
    overline(Z)_n = (overline(X)_n - mu)/sigma    \

    => sum (Z_i - overline(Z)_n)^2 = 1/sigma^2 sum (X_i - overline(X)_n)^2
  $
  Logo, $overline(X)_n$ e $1/n sum (X_i - overline(X)_n)^2$ são independentes e $1/sigma^2 sum (X_i - overline(X)_n)^2 ~ Chi^2_(n-1)$
]

Esse resultado é interessante pois, em certas ocasiões, podemos querer saber a seguinte probabilidade:
$
  PP(|hat(mu) - mu| <= 1/5 sigma, |hat(sigma) - sigma| <= 1/5 sigma) >= 1/2
$
Já que ela indica uma probabilidade de proximidade entre meus estimadores e meus parâmetros. Porém, pelo @sample-mean-and-sample-variance-independence, podemos separar essa probabilidade em:
$
  underbracket(
    PP(|hat(mu) - mu| <= 1/5 sigma),
    p_1
  )
  space
  underbracket(
    PP(|hat(sigma) - sigma| <= 1/5 sigma),
    p_2
  ) >= 1/2
$
e isso simplifica bastante nossas contas! Vamos definir $U ~ N(0,1)$, então podemos reescrever as probabilidades como:
$
  p_1 = PP(sqrt(n)/sigma |hat(mu) - mu| < 1/5 sqrt(n)) = PP(|U| < 1/5 sqrt(n))
$

definindo $V = n/sigma^2 hat(sigma^2)$, sabemos que $V ~ Chi^2_(n-1)$, então
$
  p_2 &= PP(-1/5 sigma <= hat(sigma) - sigma <= 1/5 sigma) = PP(4/5 sigma <= hat(sigma) <= 6/5 sigma)    \

  &= PP (16/25 sigma^2 <= hat(sigma)^2 <= 36/25 sigma^2) = PP(16/25 n <= V <= 36/25 n)
$

e como $V ~ Chi^2_(n-1)$, basta consultar uma tabela ou um software para descobrir esses quantis

#pagebreak()

#align(center+horizon)[
  = Distribuições $t$
]

#pagebreak()

$
  (sqrt(n) (overline(X)_n - mu)) / sigma ~ N(0,1)
$
Porém, podemos não saber $sigma$ e queremos substituir, por exemplo, por seu EMV, então qual seria a distribuição de
$
  (sqrt(n)(overline(X)_n - mu))/hat(sigma)
$

#definition([Distribuição $t$ com $m$ graus de liberdade])[
  Se $Z ~ N(0,1)$ e $Y ~ Chi^2_m$, então
  $
    X = Z / sqrt(Y / m) ~ t_m
  $
  onde dizemos $t$ com $m$ graus de liberdade
]

#theorem("PDF")[
  A pdf de $X~t_m$ é:
  $
    f_X (x) = Gamma((m+1)/2) / ( (m pi)^(1/2) Gamma(m/2) ) (1 + x^2 / m)^(-(m+1)\/2)
  $
]
#proof[
  Lembrando: $Y~Chi^2_m$ e $Z ~ N(0,1)$. Vamos aplicar as transformações! Sabemos que:
  $
    f_(X W) (x, w) = f_(Y Z) (y, z) | (partial (y, z))/(partial (x, w)) |
  $
  então denotando $W = Y$, temos:
  $
    Z = X(W/m)^(1/2) wide Y = W
  $
  Então vamos ter que:
  $
    (partial y) / (partial x) = 0 wide (partial y) / (partial w) = 1    \

    (partial z) / (partial x) = (w/m)^(1/2)
  $
  então vamos ter que
  $
    | (partial (y, z))/(partial (x, w)) | = -(w/m)^(1/2)
  $
  $
    f_(X W) (x, w) &= f_(W Z) (w, z) (w/m)^(1/2)    \
    
    &= f_(W) (w) f_Z (z) (w/m)^(1/2) wide ("Independência de Y e Z")    \

    &= f_(W) (w) f_Z (x (w/m)^(1/2)) (w/m)^(1/2)    \

    &=
      underbracket(
        (1/2)^(m/2) / Gamma(m/2) w^(m/2 - 1) e^(-1/2 w),
        f_W (w)
      )
      space
      underbracket(
        1/sqrt(2 pi) e^((-x^2 w)/(2m)),
        f_Z (z)
      )
      (w/m)^(1/2)
  $

  reescrevendo para ficar algo mais limpo e unir os termos comuns:
  $
    f_(X W) (x, w) = (1/2)^(m/2) / ( Gamma(m/2) sqrt(2 pi m) ) w^((m-1)/2) exp{ -1/2 (1 + x^2 / m) w }
  $
  Agora, para obtermos a marginal de $X$, precisamos integrar isso tudo com relação a $w$. Porém, basta integrarmos aquilo que é em função apenas de $w$, as constantes nós podemos adicionar novamente depois, então:
  $
    f_X (x) prop integral_0^(infinity) w^((m-1)/2) exp {-1/2 (1+x^2 / m)w} dif w
  $
  Se definirmos $alpha = (m+1)/2$ e $beta = 1/2 (1+x^2 / m)$, então a integral equivale a:
  $
    f_X (x) prop integral_0^infinity w^(alpha - 1) e^(-beta w) dif w = (Gamma(alpha)) / beta^alpha = Gamma((m+1)/2) / (1/2 [1 + x^2 / m])^((m+1)\/2)    \
  $
  $
    => f_X (x) = (1/2)^(m/2) / ( Gamma(m/2) sqrt(2 pi m) ) Gamma((m+1)/2) (1/2 [1 + x^2 / m])^(-(m+1)\/2)
  $
  juntando tudo, temos:
  $
    f_X (x) = Gamma((m+1)/2) / (sqrt(m pi) space Gamma(m/2)) (1+x^2 / m)^(-(m+1)\/2)
  $
]

== Propriedades

#theorem[
  Se $T ~ t_m$, então:
  $
    &EE[T] = 0 wide (m > 1)   \
    &VV[T] = m / (m-2) wide (m > 2)
  $
]
#proof[
  Seja $Z ~ N(0,1)$ e $W ~ Chi^2_m$, sabemos que
  $
    T = Z / sqrt(W / m) ~ t_m
  $
  porém, temos que $T|W=w ~ N(0, m/w)$, logo:
  $
    EE[T|W=w] = 0
  $
  pela lei de adão:
  $
    EE[EE[T|W=w]]=EE[T]=EE[0]=0
  $

  No mesmo raciocínio, lembrando a lei de EVA
  $
    VV[X] = EE[VV[X|Y]] + VV[EE[X|Y]]   \

    => VV[T] = EE[VV[T|W]] + VV[EE[T|W]]
  $
  sabemos que $EE[T|W] = 0$, então basta calcularmos $VV[T|W]$ que, como vimos antes, vai ser $W/m$, então:
  $
    VV[T] = EE[m/W]
  $
  Sabemos que $W$ é uma $Gamma(m/2, 1/2)$, então $W^(-1)$ é uma Gamma Inversa, logo, sua média vai ser:
  $
    EE[W^(-1)] = 1/2 / (m / 2 - 1) = (1/2) / ((m-2)/2) = 1/(m-2)
  $
  logo:
  $
    VV[T] = m / (m-2)
  $
]


#theorem("Divergência dos Momentos")[
  Se $T ~ t_m$, então $EE[|T|^p]$ diverge se $p>=m$. Se $m$ é inteiro, então apenas os $m-1$ primeiros momentos existem
]<moments-divergence>

#theorem[
  Sejam $X_1,...,X_n ~ N(mu, sigma^2)$ e $sigma' = (1/(n-1) sum(X_i - overline(X)_n)^2)^(1/2)$, então
  $
    (sqrt(n) (overline(X)_n - mu)) / sigma' ~ t_(n-1)
  $
]
#proof[
  Defina $S_n^2 = sum(X_i - overline(X)_n)^2$, $Z - sqrt(n)(overline(X)_n - mu)\/sigma$ e $Y = S_n^2\/sigma^2$. Sabemos que $Y$ e $Z$ são independentes e $Y ~ Chi^2_(n-1)$. Definimos então:
  $
    U = Z / sqrt(Y/(n-1))
  $
  que é uma $t_(n-1)$ por definição. Porém, perceba que:
  $
    U = (sqrt(n) (overline(X)_n - mu))/sigma / (1/sigma sqrt(S_n^2 / (n-1))) = (sqrt(n) (overline(X)_n - mu)) / sigma'
  $
]

Essa propriedade é interessante, pois saímos de variáveis que dependiam diretamente de $sigma$ para uma variável que tem distribuição que *não depende* de $sigma$

#theorem[
  Uma distribuição $t_1$ é equivalente a uma distribuição de _Cauchy_
]

#definition("Distribuição de Cauchy")[
  Se $X ~ "Cauchy"(x_0, gamma)$, então temos:
  $
    f_X (x) = 1/(pi gamma [1 + ((x-x_0)/gamma)^2])
  $
  $
    F_X (x) = 1/pi arctan((x-x_0)/gamma) + 1/2
  $
  Além do fato que:
  $
    EE[|X|^k] = infinity wide forall k
  $
]

#pagebreak()

#align(center+horizon)[
  = Intervalos de Confiança
]

#pagebreak()

Essa é uma parte que costuma gerar bastante confusão! Intervalos de confiança adicionam mais informações a um estimador $hat(theta)$ quando não conhecemos o $theta$, de forma que podemos encontrar um intervalo $[A,B]$ com alta probabilidade de conter $theta$

== Intervalo de Confiança para a média de uma Normal
Dada a amostra $X_1,...,X_n ~ N(mu, sigma^2)$, sabemos que $U = sqrt(n)(overline(X)-mu)\/sigma' ~ t_(n-1)$. Eu gostaria de achar um intervalo no qual eu tenho uma chance boa de encontrar minha média, então eu gostaria de algo do tipo:
$
  PP(-c < U < c) = gamma
$<normal-mean-conficence-interval>
O método mais comum é calcular diretamente o $c$ que torna a equação @normal-mean-conficence-interval verdadeira. Isso é equivalente a dizer:
$
  PP(overline(X)_n - (c sigma')/sqrt(n) < mu < overline(X)_n + (c sigma')/sqrt(n)) = gamma
$
Vale ressaltar que essa probabilidade é referente a distribuição conjunta de $overline(X)_n$ e $sigma'$ para valores *fixos* de $mu$ e $sigma$ (Independentemente de sabermos eles ou não). Então vamos tentar achar o $c$ que satisfaz isso
$
  PP(-c < U < c) = gamma <=> T_(n-1)(c) - T_(n-1)(-c) = gamma
$
Pela simetria de $t$ em $0$, posso reescrever como:
$
  2 T_(n-1)(c) - 1 = gamma => c = T_(n-1)^(-1)((1+gamma)/2)
$
Então, depois que descobrimos $c$, nosso intervalo de confiança vira:
$
  A = overline(X)_n - sigma' / sqrt(n) space T_(n-1)^(-1)((1+gamma)/2)    \

  B = overline(X)_n + sigma' / sqrt(n) space T_(n-1)^(-1)((1+gamma)/2)
$

Dada essa noção inicial, vamos definir formalmente esses intervalos:

#definition("Intervalo de confiança")[
  Seja $underline(X) = (X_1,...,X_n)$ uma amostra de uma distribuição indexada pelo(s) parâmetro(s) $theta$ e seja $g(theta): Omega -> RR$. Seja também $A$ e $B$ duas estatísticas $(A<=B)$ que satisfazem:
  $
    PP(A < g(theta) < B) >= gamma
  $<confidence-interval-property>
  O intervalo aleatório $(A,B)$ é chamado de intervalo de confiança $gamma$ para $g(theta)$ ou de intervalo de confiança $100 gamma %$ para $g(theta)$. Depois que $X_1,...,X_n$ foi observado e o intervalo $A=a$ e $B=b$ foi computado, chamamos o valor observado do intervalo de *valor observado do intervalo de confiança*. Se a equação @confidence-interval-property vale a igualdade $forall c in (A,B)$, então chamamos esse intervalo de *exato*
]

Aqui eu vou definir melhor a interpretação com relação a essa definição, que pode ser um pouco confusa. A interpretação do intervalo $A,B$ em si é bem direta, representa um intervalo *aleatório* que tem probabilidade $gamma$ de conter $g(theta)$. Porém, ao observamos as amostras e calcularmos $A=a$ e $B=b$, o intervalo $(a,b)$ *não necessariamente contém $g(theta)$ com probabilidade $gamma$*, como assim? Lembra que $(A,B)$ é um intervalo *aleatório*, enquanto $(a,b)$ é uma das muitas possíveis ocorrências desse intervalo! A interpretação correta é, que quanto mais repetimos o experimento e computamos $(a,b)$ e armazenamos esses valores observados de intervalo, uma fração $gamma$ deles contém $g(theta)$, porém, *não sabemos dizer quais contém e quais não contém*

#theorem[
  Dada a amostra $X_1,...,X_n ~ N(mu,sigma^2)$. $forall gamma in [0,1]$, o intervalo $(A,B)$ com seguintes pontos:
  $
    A = overline(X)_n - sigma' / sqrt(n) space T_(n-1)^(-1)((1+gamma)/2)    \

    B = overline(X)_n + sigma' / sqrt(n) space T_(n-1)^(-1)((1+gamma)/2)
  $
  é um intervalo de confiança $gamma$-exato
]


== Intervalos de Confiança Unilaterais
Nós vimos como encontrar intervalos aleatórios $(A,B)$ que tem probabilidade $gamma$ de conter o parâmetro $theta$, porém, podem acontecer situações que apenas obter um limite superior ou inferior seja suficiente para nós

Dados $gamma_1$ e $gamma_2$ com $gamma_2 > gamma_1$ e $gamma_2 - gamma_1 = gamma$, então:
$
  PP(T_(n-1)^(-1) (gamma_1) < U < T_(n-1)^(-1) (gamma_1)) = gamma
$
E então obtemos que, perante todos os intervalos aleatórios possíveis, o intervalo de confiança $gamma$ com o menor tamanho é o simétrico
$
  gamma_1 = 1 - gamma_2
$
Porém, há casos que um intervalo não-simétrico é útil (Como mencionei o caso anterior de apenas limites superiores ou intefiores)

#definition("Intervalo de Confiança Generalizado")[
  Seja $underline(X) = (X_1,...,X_n)$ uma amostra de uma distribuição parametrizada por $theta$. Seja $g(theta): Omega -> RR$ e seja $A$ uma estatística tal que:
  $
    PP(A < g(theta)) >= gamma  wide  forall theta
  $
  Então o intervalo aleatório $(A,+infinity)$ é chamado de intervalo de confiança unilateral $gamma$ de limite inferior $A$. A mesma definição vale para a estatística $B$ tal que:
  $
    PP(g(theta) < B) >= gamma
  $
  Então o intervalo aleatório $(-infinity, B)$ é chamado de intervalo de confiança unilateral $gamma$ de limite superior $B$. Se a desigualdade "$>=gamma$" é uma igualdade para todo $theta$, então tanto o intervalo quanto os limites são chamados de exatos
]

#theorem("Intervalo unilateral da média da normal")[
  Seja $X_1,...,X_n ~ N(mu, sigma^2)$, as estatísticas a seguir são, respectivamente, limites inferior e superior exatos com coeficiente $gamma$ para $mu$:
  $
    A = overline(X)_n - T_(n-1)^(-1)(gamma) sigma' / sqrt(n)    \

    B = overline(X)_n + T_(n-1)^(-1)(gamma) sigma' / sqrt(n)
  $
]

== Intervalo de confiança para outros parâmetros
Até agora, só vimos a aplicação de intervalos de confiança para a distribuição normal, mas por quê? Pois a normal possui propriedades que tornam encontrar os intervalos de confiança mais fáceis, como por exemplo, encontrarmos estatísticas (Por exemplo $T = sqrt(n)(overline(X)_n - mu)\/sigma'$) que não dependem do parâmetro que queremos estimar, e isso na verdade é uma definição útil que pode nos ajudar:

#definition("Pivô")[
  Seja $underline(X)=(X_1,...,X_n)$ uma amostra de uma distribuição parametrizada por $theta$ e $V(theta, underline(X))$ uma variável aleatória tal que sua distribuição *não depende de $theta$* e é a mesma $forall theta$, então chamamos $V(theta, underline(X))$ de *quantidade pivotal* ou *pivô*
]

Podemos então utilizar dessa definição para construir intervalos de confiança. Porém, para isso, precisamos de uma "função inversa" desse $V$, algo do tipo:
$
  r(V(theta, underline(X)), underline(X)) = g(theta)
$<v-pseudo-inverse>

#theorem[
  Seja $underline(X)=(X_1,...,X_n)$ uma amostra de uma distribuição parametrizada por $theta$. Suponha que existe um pivô $V$. Seja $F_V (v)$ a CDF de $V$ e contínua. Assuma também que a função $r$ tal qual a equação @v-pseudo-inverse existe e é estritamente crescente em $v$ para cada $underline(x)$. Seja $gamma in (0,1)$ e $gamma_2 > gamma_1$ tal que $gamma_2 - gamma_1 = gamma$, então as seguintes estatísticas são endpoints de um invervalo de confiança $gamma$-exato para $g(theta)$
  $
    A = r(F_V^(-1)(gamma_1), underline(x))    \

    B = r(F_V^(-1)(gamma_2), underline(x))    \
  $
  Se $r$ é estritamente decrescente, então invertemos $A$ e $B$
]
#proof[
  Se $r(theta, underline(x))$ é estritamente crescente em $v$ para todo $underline(x)$, então:
  $
    V(theta, underline(X)) < c <=> g(theta) < r(c, underline(X))
  $
  Defina $c = F_V^(-1)(gamma_i)$ para $i = 1, 2$, então obtemos:
  $
    PP(g(theta) < A) = gamma_1  \
    PP(g(theta) < B) = gamma_2
  $<intervals-pivots>
  Como $V$ tem distribuição contínua e $r$ é estritamente crescente, então:
  $
    PP(A = g(theta)) = PP(V(theta,underline(X)) = F_V^(-1)(gamma_1)) = 0
  $
  Similarmente com $PP(B = g(theta))$, então combinamos as duas equações na equação @intervals-pivots para obter $PP(A < g(theta) < B) = gamma$
]

#example[
  Seja $X_1,...,X_n$ uma amostra aleatória de uma distribuição normal com média $mu$ e variância $sigma^2$ desconhecidos. Vimos anteriormente que:
  $
    V(theta, underline(X)) = 1/sigma^2 sum^n_(i=1)(X_i - overline(X)_n)^2 ~ Chi^2_(n-1) wide forall theta=(mu,sigma^2)
  $
  Logo, $V$ é um pivô, de forma que conseguimos utilizá-lo para achar intervalos de confiança para $sigma^2$
]

Porém é bem comum que o pivô não exista em casos discretos

#example[
  Seja $theta$ a proporção de sucessos em uma população muito grande de pacientes tratados com imipramina. Suponha que os clínicos desejem uma variável aleatória $A$ tal que, para todo $theta$, tenhamos
  $
    Pr(A < θ) >= 0.9
  $

  Isto é, eles querem ter *$90%$ de confiança* de que a proporção de sucesso seja *pelo menos $A$*. Os dados observáveis consistem no número $X$ de sucessos em uma amostra aleatória de *$n = 40$* pacientes. Nenhuma variável pivotal existe neste exemplo, e os intervalos de confiança são mais difíceis de construir
]

#pagebreak()

#align(center+horizon)[
  = Análise Bayesiana de Amostras Normais
]

#pagebreak()

Nesse capítulo, vamos fazer uma análise bayesiana completa quando o problema trata de amostras de uma distribuição *Normal*. Para facilitar algumas contas, vamos trocar a definição usual com variância para a definição com *precisão*

#definition("Precisão")[
  A precisão de uma distribuição $N(mu, sigma^2)$ é
  $
    tau = 1/sigma^2
  $
]

#theorem("Densidade da Normal")[
  Seja $X ~ N(mu, tau)$, temos que a *função de densidade probabilística* de $X$ é:
  $
    f(x|mu,tau) = (tau / (2pi))^(1/2) exp(-tau/2 (x - mu)^2)
  $
]

#corollary("Likelihood")[
  Sejam $X_1,...,X_n|mu,tau ~ N(mu, tau)$, temos que a função de verossimilhança é dada por:
  $
    f(underline(x)|mu, tau) = (tau/(2pi))^(n/2) exp(-1/2 tau sum_(i=1)^n (x_i - mu)^2)
  $
]

== Família de Conjugados
#theorem("Família de Conjugados")[
  Suponha que $X_1,...,X_n|mu, tau ~ N(mu, tau)$ e temos que $mu|tau ~ N(mu_0, lambda_0 tau_0)$ e $tau ~ Gamma(alpha_0, beta_0)$, então a posteriori de $mu$ e $tau$ [$p(mu, tau|underline(x))$] é:
  $
    mu, tau|underline(x) ~ N(mu_1, lambda_1 tau)  \

    mu_1 = (lambda_0 mu_0 + n overline(x)_n)/(lambda_0 + n) wide lambda_1 = lambda_0 + n
  $
  $
    tau ~ Gamma(alpha_1, beta_1)    \
    alpha_1 = alpha_0 + n/2 wide beta_1 = beta_0 + 1/2 s^2_n + (n lambda_0 (overline(x)_n - mu_0)^2)/(2(lambda_0 + n))
  $
]

Essa família de conjugados é chamada de NormalGamma com parâmetros $alpha_0$, $beta_0$, $mu_0$ e $lambda_0$, de forma que a posteriori de $mu,tau$ é a NormalGamma com parâmetros $alpha_1$, $beta_1$, $mu_1$ e $lambda_1$. Vale lembrar também que:
$
  p(mu,tau) prop p(mu|tau) p(tau)
$

Outro ponto é que $mu$ e $tau$ *não* são independentes, e mesmo que a gente escolha eles de forma que eles sejam independentes a priori, mesmo após uma única observação, eles já viram dependentes

== Marginais
Nós encontramos as distribuições de $mu,tau$, $mu|tau$ e $tau$, porém, qual seria a marginal de $mu$?

#theorem([Marginal de $mu$])[
  Suponha que $mu, tau ~ "NormalGamma"(mu_0, lambda_0, alpha_0, beta_0)$, então:
  $
    ((lambda_0 alpha_0)/(beta_0))^(1/2) (mu - mu_0) ~ t_(2 alpha_0)
  $
]
#proof[
  $mu|tau ~ N(mu_0, lambda_0 tau)$, então temos que:
  $
    VV[mu|tau] = 1/(lambda_0 tau) => (mu - mu_0) dot (lambda_0 tau)^(1/2) ~ N(0,1)
  $
  Então seja $p(tau)$ a marginal de $tau$ e $p(mu|tau)$ a pdf condicional de $mu$ em $tau$
  $
    p(z, tau) = underbrace((lambda_0 tau)^(-1/2) dot p(mu=(lambda_0 tau)^(-1/2) z + mu_0 | tau), Phi(z) -> "pdf da" N(0,1)) p(tau)
  $
  Como eu consigo exprimir $p(z,tau)$ como a multiplicação de suas marginais, isso significa que $z$ e $tau$ são *independentes*. Definimos então $Y = 2 beta_0 tau => Y ~ Gamma(alpha_0, 1/2) ~ Chi^2_(2 alpha_0)$. Ou seja, vamos ter que:
  $
    U = Z / (Y/(2 alpha_0))^(1/2) ~ t_(2 alpha_0)
    
    = ( (lambda_0 tau)^(1/2) (mu-mu_0) )/( (2 beta_0 tau)/(2 alpha_0) )^(1/2)
    
    = ((lambda_0 alpha_0)/(beta_0))^(1/2)(mu - mu_0)
  $
]

Por conta disso, obtemos o seguinte

#corollary([Propriedades da Marginal de $mu$])[
  Se $alpha_0 > 1/2 => EE[mu] = mu_0$. Se $alpha_0 > 1 => VV[mu] = beta_0 / (lambda_0 (alpha_0 - 1))$
]

== Distribuições Impróprias
Utilizamos esses parâmetros mais por conveniência do que por qualquer outro motivo (Como uma convicção). Para a posteriori, utilizamos os seguintes hiperparâmetros:
$
  alpha_0 = -1/2 wide beta_0 = 0 wide mu_0 = 0 wide lambda_0 = 0
$
assim, obtemos as seguintes pdf's *a priori*:
$
  p(mu)=1

  wide

  p(tau)=1/2 tau^(-1)

  wide

  p(mu, tau)=1/tau
$
Dessa forma, a posteriori fica:
$
  p(mu, tau) prop {tau^(1/2) exp[-(n pi)/2 (mu - overline(x)_n)^2]} tau^((n-1)/2 - 1) exp[-tau s_n^2 / 2]
$

#pagebreak()

#align(center+horizon)[
  = Estimadores não-viezados
]

#pagebreak()

Nosso principal objetivo quando estamos fazendo inferência é fazer um estimador $delta(underline(X))$ de $g(theta)$ que a distribuição se concentra bem próximo de $theta$, ou seja, na maior parte do tempo, os valores retornados pelo estimador são próximos do verdadeiro valor de $g(theta)$. É com esse objetivo que criamos estimadores *não-viezados*

#definition("Estimador não-viezado")[
  Um estimador $delta(underline(X))$ é não-viezado para $g(theta)$ se $EE_theta [delta(underline(X))] = g(theta) space forall theta$
]

#definition("Viés")[
  O viés de um estimador $delta(underline(X))$ tem o seu *viés* definido como
  $
    "Bias"(g(theta)) = EE_theta [delta(underline(X))] - g(theta)
  $
]

Porém, um estimador *não-viezado* não significa que ele é um *bom* estimador ou sequer um estimador viável para a situação. Por exemplo, um estimador que subestima $g(theta)$ em $1000$ unidades ou superestima vai ser não-viezado, mas sempre retornará valores ruins de aproximação frequentemente. Então para um estimador ser *bom*, ele necessita ter uma baixa variância

#theorem[
  Seja $delta$ um estimador de variância finita, então $EE_theta [(delta - g(theta))^2] = VV_theta [delta] + ("Bias"(delta, g(theta)))^2$
]

== Estimador não-viezado da Variância
#theorem[
  Seja $X_1,...,X_n$ uma amostra de uma distribuição indexada por $theta$ e $VV[X_i] = sigma^2$, então o seguinte estimador é não-viezado:
  $
    hat(sigma)^2 = 1/(n-1) sum_(i=1)^n (X_i - overline(X)_n)^2
  $
]
#proof[
  Vamos utilizar do fato que:
  $
    sum^(n)_(i=1) (X_i - mu)^2 = sum^(n)_(i=1) (X_i - overline(X)_n)^2 + n(overline(X)_n - mu)^2
  $
  Então vamos ter que (Tirando a esperança nos dois lados da equação mostrada anteriormente):
  $
    EE[hat(sigma)^2_0] &= sigma^2 - sigma^2/n    \

    &= (n-1)/n sigma^2
  $
  logo, vamos ter que:
  $
    n/(n-1) EE[hat(sigma)^2_0] = EE[hat(sigma)^2] = sigma^2
  $
]

Esse estimador citado agora é chamado de *variância amostral* em diversas literaturas (No livro do DeGroot, a variância amostral é o estimador com $1\/n$)

== Limitações

- Muitas vezes os estimadores não-viezados possuem uma variância maior que os estimadores viezados, um bom exemplo é que $VV[hat(sigma)^2]>=VV[hat(sigma)^2_0]$

- Não há garantia que estimadores não-viezados existam em toda situação. Um exemplo é que, se $X_1,...,X_n ~ "Bern"(p)$, não existe estimador *não-viezado* de $sqrt(p)$

- Estimadores inapropriados, mesmo sendo não-viezados. Por exemplo, se eu tenho uma sequência de bernoullis, e tentar estimar $p$ pela quantidade de erros até o primeiro sucesso $X$ (Geométrica). O estimador não viezado seria: $
  delta(X) = cases(
    1 "se" X = 0,
    0 "se" X = 1
  )
$

- Os estimadores podem ignorar informações. Se você for medir a votlagem de um sistema com um multímetro, e ele retornar $2.5$, então podemos pensar que $theta$ é $2.5$, mas e se o multímetro arredonda tudo que é maior que $3$ para $3$? Isso muda completamente a distribuição da informação

#pagebreak()

#align(center+horizon)[
  = Análise e Teste de Hipóteses
]

#pagebreak()
De acordo com Natalia Pasternak, presidente do Instituto Questão de Ciência, a ciência pode ser definida como um processo de investigação que leva em conta experimento e observação da natureza, e a partir deles tirar *conclusões provisórias* de acordo com as evidências. Vamos supor que, ao fazermos um experimento, comprovamos a hipótese que estávamos analisando. Ao escrever o artigo científico, é correto afirmar que a nossa hipótese é verdadeira? *Não*! Pois ela foi comprovada em *nosso* estudo, sob as *nossas* condições, com as *nossas* amostras, mas dizer que nossa hipótese está confirmada/rejeitada apenas com o *nosso* estudo é muito subjetivo, então é aí que entra a estatística com a *Análise e Teste de Hipóteses*

== Hipóteses Nula e Alternativa
Nós temos $theta in Omega$ e vamos particionar o espaço em dois conjuntos disjuntos $Omega_0$ e $Omega_1$ e queremos testar as duas hipóteses:
$
  H_0: theta in Omega_0 wide H_1: theta in Omega_1
$

#definition[
  $H_0$ é chamada de *hipótese nula* e $H_1$ a *hipótese alternativa*. Se decidirmos que $theta in Omega_1$, então nós *REJEITAMOS* $H_0$, se $theta in Omega_0$, nós *NÃO REJEITAMOS* $H_0$
]

Ué, porque não falamos que *aceitamos* a hipótese $H_0$? Esse modo de visualizar o teste de hipóteses foi popularizado por Ronald Fisher, Jerzy Neyman e Egon Pearson. Essa visualização de assemelha muito ao sistema jurídico, onde seguimos o princípio da presunção de inocência:
- *Hipótese Nula $H_0$*: Representa o status quo, a crença estabelecida, o "nenhum efeito" ou a "igualdade". É a hipótese que se presume verdadeira até que haja evidência estatística suficiente para o contrário. (Ex: "O réu é inocente")

- *Hipótese Alternativa ($H_1$)*: É a afirmação que o pesquisador está tentando encontrar evidências para suportar. (Ex: "O réu é culpado.")

Ou seja, o teste foca em coletar dados que são *inconsistentes* a $H_0$. Vamos tentar esclarecer com um exemplo. Você quer saber se uma nova dieta reduziu o peso médio dos participantes.
- $H_0$: O peso médio não mudou (o efeito da dieta é zero).- $H_1$: O peso médio diminuiu.
Se os dados mostrarem uma grande redução de peso, você rejeita a $H_0$ e conclui que a dieta funcionou. Se os dados mostrarem apenas uma pequena redução, ou um aumento, você não rejeita a $H_0$. Você conclui: "Os dados não fornecem evidência suficiente para dizer que a dieta reduziu o peso." Você não conclui: "A dieta definitivamente não teve efeito."

#example("Exemplo simples")[
  Temos uma hipótese principal que é "Correr é diminui/intensifica os sintomas da depressão", então vamos dividir essa hipótese geral nas duas hipóteses que mencionamos anteriormente
  - $H_0$: Correr não afeta em nada os sintomas da depressão
  - $H_1$: Correr diminui/intensifica os sintomas da depressão

  Dividimos assim pois, até o momento, queremos comprovar que correr tem algum efeito nos sintomas da depressão, e enquanto não o comprovarmos, assumimos que a atividade física não faz efeito
]

#definition("Hipótese Simples e Composta")[
  Se $Omega_i$ contém apenas $1$ valor de $theta$, então $H_i$ é simples. Se $Omega_i$ contém mais que um valor, então $H_i$ é composta
]

Quando a hipótese é simples, a distribuição das observações é bem especificada. Já sob hipóteses compostas, dizemos que eles pertencem a uma classe. Uma hipótese nula simples tem a forma:
$
  H_0: theta = theta_0
$

#definition("Hipótese unilateral e multilateral")[
  Seja $theta in R$, hipóteses nulas unidimensionais são da forma $H_0: theta <= theta_0$ ou $H_0: theta >= theta_0$. Já hipóteses nulas simples ($H_0: theta = theta_0$) tem hipóteses multilaterais alternativas ($H_1: theta != theta_0$)
]

== Região Crítica e Testes Estatísticos
Considere o problema de testar as hipóteses:
$
  H_0: theta in Omega_0 wide H_1: theta in Omega_1
$
Seja $underline(X) = [X_1,...,X_n]$ uma amostra indexada por $theta$ desconhecido e $S$ o conjunto de *todas as saídas possíveis de* $underline(X)$. Um estatístico pode especificar um procedimento de teste particionando $S$ em dois grupos, onde $S_1$ contém os valores de $underline(X)$ onde $H_0$ será rejeitada e $S_0$ os valores que $H_0$ não é rejeitada

#definition("Região Crítica")[
  O conjunto $S_1$ é chamado de *região crítica*
]

Na maioria dos problemas, $S_1$ é definido usando uma estatística $T=r(underline(X))$

#definition("Estatística de Teste e Região de Rejeição")[
  Seja $T = r(underline(X))$ uma estatística e $R subset RR$. Suponha que o procedimento de teste das hipóteses seja de forma "Rejeite $H_0$ se $T in R$", então $T$ é uma *estatística de teste* e $R$ é a *região de rejeição*
]

Se definirmos o teste em termos de $T$ e $R$ como na definição, então a região crítica é:
$
  S_1 := {underline(x)|r(underline(x)) in R}
$

#example[
  Ainda na linha de raciocínio do exemplo da atividade física pro combate na depressão, vamos supor que definimos o procedimento $delta$ como:

  "Rejeite $H_0$ (Correr não afeta os sintomas da depressão) se o número de pessoas com os sintomas afetados for maior que um valor $c$"

  Então podemos definir a estatística de teste como $overline(X)$ e a região de rejeição é $R subset RR$ com os valores reais maiores que $c$. Logo, a região crítica é dada por:
  $
    S_1 := {underline(x)|overline(X) in R}
  $
]

== Função de Poder e Tipos de Erro
Seja $delta$ um procedimento de teste como definimos antes

#definition("Função de Poder")[
  A função $pi(theta|delta)$ é chamada de *função de poder*. Se $S_1$ é a região crítica de $delta$, então:
  $
    pi(theta|delta) = PP(underline(X) in S_1|theta) "ou" PP(T in R|theta)
  $
]<power-function>

Ou seja, é a probabilidade de que a minha amostra esteja na região crítica dado os meus parâmetros, ou seja, a probabilidade de que vou rejeitar $H_0$. A função de poder especial é aquela que:
$
  pi(theta|delta)=0 wide forall theta in Omega_0    \
  pi(theta|delta)=1 wide forall theta in Omega_1
$

Lembrando: Para cada valor $theta in Omega_0$, rejeitar $H_0$ é uma decisão *incorreta* e o mesmo para cada valor $theta in Omega_1$ e não rejeitar $H_0$

#definition("Tipos de Erro")[
  A decisão errônea de rejeitar uma hipótese nula *verdadeira* é de *Tipo I* (ou primeira ordem). Uma decisão errônea de *não rejeitar* uma hipótese nula *falsa* é chamada de *Tipo II* (ou segunda ordem)
]

#align(center)[
  #table(
    columns: 3,
    table.header(
      [], [*Aceitar a hipótese nula*], [*Rejeitar a hipótese nula*]
    ),
    [*Hipótese nula é verdadeira*], [\u{2705}], [Erro de Tipo I],
    [*Hipótese nula é falsa*], [Erro de Tipo II], [\u{2705}],
  )
]

Se $theta in Omega_0$, $pi(theta|delta)$ é a probabilidade de cometermos  um erro de Tipo I, já que ele representa a probabilidade de que a amostra esteja na região crítica (rejeitar $H_0$) e, se $theta in Omega_1$, $1-pi(theta|delta)$ é a probabilidade de cometermos um erro de Tipo II. No geral, queremos achar $delta$ tal que $pi(theta|delta)$ seja baixo para $theta in Omega_0$ e alto para $theta in Omega_1$, já que isso representa diminuir a probabilidade de cometer cada um dos erros.

Um método muito usado é escolher $alpha_0 in (0,1]$ tal que:
$
  pi(theta|delta) <= alpha_0 wide forall theta in Omega_0
$<level>
e depois procurar o teste que *maximiza* $pi(theta|delta)$ satisfazendo a condição (para $theta in Omega_1$)

#definition("Tamanho de um Teste")[
  Um teste que satisfaz a equação @level é chamado de *teste de nível $alpha_0$* e que o teste tem nível de significância $alpha_0$. O tamanho $alpha(delta)$ de um teste $delta$ é definido por:
  $
    alpha(delta) = sup_(theta in Omega_0) pi(theta|delta)
  $
]

Ou seja, o tamanho de um teste é a maior probabilidade de cometermos um erro de *Tipo I* possível (já que fazemos o supremo dentre todos os valores de $Omega_0$) e um teste ter nível de significância $alpha_0$ significa que, independente de qual parâmetro de $H_0$ seja o verdadeiro da distribuição, a chance de cometermos um erro de *Tipo I* sempre será menor que $alpha_0$

#corollary[
  Um teste $delta$ é de nível $alpha_0 <=> alpha(delta) <= alpha_0$
]

Se a hipótese nula é simples ($H_0: theta = theta_0$), então $alpha(delta) = pi(theta_0|delta)$

== Induzindo um nível de significância
Nós queremos testar:
$
  H_0: theta in Omega_0   \
  H_1: theta in Omega_1
$

Seja $T$ uma estatística e suponha que vamos rejeitar $H_0$ se $T>=c$. Vamos supor que queremos que nosso teste tenha um nível específico de significância $alpha_0$. Temos:
$
  pi(theta|delta) = PP(T>=c|theta) underbrace(->, "Queremos") sup_(theta in Omega_0) PP(T>=c|theta) <= alpha_0
$

perceba que o lado direito é não-crescente em $c$, então a desigualdade é satisfeita para altos valores de $c$, então devemos fazer $c$ o menor possível sem que a desigualdade seja desfeita, e também queremos que $pi(theta|delta)$ seja o maior possível para $theta in Omega_1$. Quando $T$ tem distribuição contínua, costuma ser fácil achar um $c$ apropriado

== p-valor
#definition("p-valor")[
  O p-valor é o menor nível $alpha_0$ ao qual rejeitaríamos a hipótese nula no nível $alpha_0$ *com os dados observados*. Também chamamos o p-valor de *nível de significância observado*
]

É o que, macho? Essa definição está muito objetiva e densa, então simplificando um pouco: p-valor é a *probabilidade* de se obter o padrão de resultados que encontramos no nosso estudo ou resultados mais extremos, *considerando a hipótese nula como verdadeira*. Vamos supor que observamos uma amostra $underline(x)$ e não fixamos um valor $alpha$ para rejeitarmos $H_0$, então nos perguntamos "Qual é o menor nível para o qual esses dados ainda seriam considerados extremos o suficiente para rejeitar $H_0$?". Então o $p$-valor segue uma linha diferente do procedimento de teste estabelecido anteriormente. Original:
- Escolhemos um nível $alpha$
- Define-se a *região crítica* associada a esse $alpha$
- Calcula-se a estatística de teste
- Verificamos se ela cai na região crítica
Agora nós invertemos a lógica
- Em vez de fixar um $alpha$, vamos perguntar "rejeito ou não?"
- Fixamos os dados
- Para quais valores de $alpha$ eu rejeitaria? O menor desses será meu $p$-valor

Mas por que essa definição é útil? Usamos isso pois, se eu faço um teste em um nível $alpha_0$ e rejeito $H_0$, simplesmente dizer que rejeitei $H_0$ no nível $alpha_0$  parece vago. Isso não diz o quão perto estávamos de tomar a outra decisão.

Um experimentador que rejeita a hipótese nula $<=>$ o p-valor é no máximo $alpha_0$, está usando um teste de significância $alpha_0$

== Calculando p-valores
Se nossos testes são da forma "Rejeite $H_0$ quando $T>=c$" para uma única estatística de teste, tem um jeito direto de calcular p-valores. Para cada $t$, deixe $delta_t$ o teste que rejeita $H_0$ quando $T>=t$. Então o p-valor quando $T=t$ é observado é o tamanho do teste $delta_t$, ou seja, o p-valor é:
$
  sup_(theta in Omega_0) pi(theta|delta_t) = sup_(theta in Omega_0) PP(T>=t|theta)
$

== Equivalência de testes e conjuntos de confiança
Os teoremas a seguir mostram a equivalência de intervalos e conjuntos de confiança (o nome é bem intuitivo). Intuitivamente, um intervalo de confiança é um tipo específico de conjunto de confiança (com um tipo específico de regra)

#theorem[
  Seja $underline(X) = [X_1,...,X_n]$ uma amostra de uma distribuição indexada por um parâmetro $theta$. Seja $g(theta)$ uma função e suponha que para todo possível valor $g_0$ de $g(theta)$, existe um teste $delta_(g_0)$ de nível $alpha_0$ da hipótese
  $
    H_(0,g_0): g(theta) = g_0   \
    H_(1, g_0): g(theta) != g_0
  $
  Para cada possível valor de $underline(x)$ de $underline(X)$, defina:
  $
    omega(underline(x)) = {g_0|delta_(g_0) "não rejeita" H_(0,g_0) "se" underline(X)=underline(x) "é visto"}
  $
  e seja $gamma = 1-alpha_0$, então o conjunto aleatório $w(underline(X))$ satisfaz
  $
    PP(g(theta_0) in omega(underline(X))|theta=theta_0) >= gamma wide forall theta_0 in Omega
  $
]
#proof[
  Seja $theta_0 in Omega$ um elemento arbitrário e defina $g_0 = g(theta_0)$. Como $delta_(g_0)$ é um teste de nível $alpha_0$, sabemos que:
  $
    PP(delta_(g_0) "não rejeitar" H_(0, g_0)|theta=theta_0) >= 1-alpha_0 = gamma
  $
  Para cada $underline(x)$, $g(theta_0) in omega(underline(x)) <=>$ o teste $delta_(g_0)$ não rejeitar $H_(0, g_0)$ quando $underline(X)=underline(x)$ é visto
  $
    => PP(g(theta_0) in omega(underline(X))|theta=theta_0) = A
  $
]

#definition("Conjunto de confiança")[
  Se um conjunto aleatório $omega(underline(X))$ satisfaz
  $
    PP(g(theta_0) in omega(underline(X))|theta=theta_0) >= gamma wide forall theta_0 in Omega
  $
  então o chamamos de conjunto de confiança com coeficiente $gamma$ para $g(theta)$. Se a desigualdade for igualdade, o chamamos de exato
]

#theorem[
  Seja $X_1,...,X_n$ uma amostra aleatória de uma distribuição indexada por $theta$ e $g: RR^n -> RR$ e seja $omega(underline(X))$ um conjunto de confiança $gamma$ para $g(theta)$. Para cada possível valor $g_0$ de $g(theta)$, construa o teste $delta_(g_0)$: $delta_(g_0)$ não rejeita $H_(0, g_0) <=> g_0 in omega(underline(X))$. Então $delta_(g_0)$ é um teste de nível $alpha_0 = 1-gamma$
]

== Testes de razão de verossimilhança
Não vou explicar formalmente todos os pontos da teoria, mas dar uma ideia intuitiva. Como vimos nos Estimadores de Máxima Verossimilhança, quanto mais próximo do verdadeiro valor de $theta$ a minha amostra estiver, maior será a verossimilhança. Então, intuitivamente, se a minha amostra tem uma verossimilhança muito maior para um valor de $theta$ que pertence a $H_1$ do que para um valor de $theta$ que pertence a $H_0$, isso é uma evidência contra $H_0$. O teste de razão de verossimilhança é justamente isso, ele rejeita $H_0$ quando a razão entre a máxima verossimilhança sob $H_1$ e a máxima verossimilhança sob $H_0$ é grande o suficiente. Como comentei antes, a gente tenta sempre achar evidências contra $H_0$
$
  H_0: theta in Omega_0   \
  H_1: theta in Omega_1
$

#definition("Teste de razão de verossimilhança")[
  A estatística
  $
    Lambda(underline(x)) = (sup_(theta in Omega_0) f_n (underline(x)|theta)) / (sup_(theta in Omega) f_n (underline(x)|theta))
  $
  é chamada de *estatística de teste de razão de verossimilhança* e o teste que rejeita $H_0$ quando $Lambda(underline(X)) <= k$ para alguma constante $k$ é chamado de *teste de razão de verossimilhança*
]

Botando em palavras simples, o teste de razão de verossimilhança rejeita $H_0$ quando a razão entre a máxima verossimilhança sob $Omega_0$ e a máxima verossimilhança sob $Omega$ é menor que um dado valor. Normalmente escolhemos $k$ de forma que o teste tenha nível de significância $alpha_0$, quando possível

#example([Teste da Razão de Verossimilhança para Hipóteses Bilaterais sobre um Parâmetro de Bernoulli])[
  Suponha que observemos $Y$, o número de sucessos em $n$ ensaios de Bernoulli independentes com parâmetro desconhecido $theta$. Considere as hipóteses
  $
    H_0: theta = theta_0
    wide "versus" wide
    H_1: theta in.not theta_0.
  $

  Após observar o valor $Y = y$, a função de verossimilhança é
  $
    f(y|theta) = binom(n, y) theta^y (1-theta)^(n-y).
  $

  Neste caso, o espaço paramétrico sob $H_0$ é $Theta_0 = {theta_0}$ e o espaço paramétrico completo é $Theta = [0,1]$. A estatística da razão de verossimilhança é

  $
    Lambda(y) =
    (theta_0^y (1 - theta_0)^(n-y))/
    (sup_(theta in [0,1]) theta^y (1 - theta)^(n-y)).
  $

  O máximo do denominador ocorre quando $theta$ é igual ao estimador de máxima verossimilhança (EMV), isto é,
  $
    hat(theta) = y/n.
  $

  Assim,
  $
    Lambda(y) =
    (theta_0^y (1-theta_0)^(n-y))/
    ((y/n)^y (1-y/n)^(n-y))

    =
    ((n theta_0) / y)^y ((n (1-theta_0)) / (n-y))^(n-y)
  $

  Não é difícil ver que $Lambda(y)$ é pequeno para valores de $y$ próximos de $0$ ou de $n$, e é maior quando $y$ está próximo de $n theta_0$.

  Como exemplo específico, suponha que $n = 10$ e $theta_0 = 0.3$. A tabela abaixo apresenta os $11$ possíveis valores de $Lambda(y)$ para $y = 0, dots, 10$.

  #table(
    columns: 12,
    [*y*],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],
    [*$Lambda(y)$*],[$0.028$], [$0.312$], [$0.773$], [$1.000$], [$0.797$], [$0.418$], [$0.147$], [$0.034$], [$0.005$], [$3 times 10^(-4)$], [$6 times 10^(-5)$],
    [*$PP(Y=y|theta=0.3)$*],[$0.028$], [$0.121$], [$0.233$], [$0.267$], [$0.200$], [$0.103$], [$0.037$], [$0.009$], [$0.001$], [$1 times 10^(-4)$], [$6 times 10^(-6)$]
  )

  Se desejarmos um teste com nível de significância $alpha_0$, ordenaríamos os valores de $y$ de acordo com os valores de $Lambda(y)$, do menor para o maior, e escolheríamos $k$ de modo que a soma das probabilidades
  $
    PP(Y = y|theta = 0.3)
  $
  correspondentes aos valores de $y$ tais que $Lambda(y) <= k$, fosse no máximo $alpha_0$.

  Por exemplo, se $alpha_0 = 0.05$, vemos na Tabela 9.1 que podemos somar as probabilidades correspondentes a $y = 10, 9, 8, 7, 0$, obtendo $0.039$. Entretanto, se incluirmos $y = 6$, correspondente ao próximo menor valor de $Lambda(y)$, a soma salta para $0.076$, que é maior do que $0.05$.

  O conjunto
  $
    {10, 9, 8, 7, 0}
  $
  corresponde a $Lambda(y) <= k$ para todo $k$ no intervalo semiaberto $[0.028, 0.147)$.

  O tamanho do teste que rejeita $H_0$ quando
  $
  y in {10, 9, 8, 7, 0}
  $
  é $0.039$
]

#pagebreak()

#align(center+horizon)[
  = Testes $t$
]

#pagebreak()

Nesse capítulo, vamos abordar um caso específico de teste de hipóteses para distribuições normais com média e variância desconhecida

#example[
  Um instituto médico quer saber a distribuição de quantos dias um paciente internado em UTI's de hospitais permanece internado. Foram coletadas informações de $n=30$ hospitais por todo o estado. Vamos supor que modelamos a quantidade de dias que a pessoa se mantém internada como uma variável normal com média $mu$ e variância $sigma^2$. Vamos dizer também que queremos testar as hipóteses:
  $
    H_0: mu >= 200 wide H_1: mu < 200
  $
  que teste seria apropriado de se utilizar? Quais são suas propriedades?
]<hospital-example-t-test>

== Testando Hipóteses sobre a Média de uma Normal quando a Variância é Desconhecida
Consideremos $X_1,...,X_n$ uma amostra de uma distribuição normal com média $mu$ e variância $sigma^2$ desconhecidas, e também que trabalhamos com as hipóteses:
$
  H_0: mu <= mu_0   \
  H_1: mu > mu_0
$<t-test-mu-hypothesis-1>

O espaço paramétrico $Omega$ suprime todo vetor bidimensiona $(mu, sigma^2)$ com $mu in (-infinity, infinity)$ e $sigma^2 > 0$. Aqui, definimos a estatística de teste $U$ como:
$
  U = sqrt(n) dot (overline(X)_n - mu_0) / sigma'
$<u-statistic>
onde o teste rejeita $H_0$ se $U>=c$. Sabemos que a distribuição de $U$ é uma $t$ com $n-1$ graus de liberdade, por isso os testes que utilizam de $U$ são chamados de *testes $t$*. Quando invertemos as hipóteses:
$
  H_0: mu >= mu_0   \
  H_1: mu < mu_0
$<t-test-mu-hypothesis-2>
o teste vira da forma "rejeite $H_0$ quando $U<=c$"

#example[
  No @hospital-example-t-test, se a gente quisesse um teste de tamanho $alpha_0$, a gente poderia usar o teste $t$ que rejeita $H_0$ se a estatística $U$ for menor ou igual a um $c$ (escolhemos $c$ de forma a fazer o teste ter tamanho $alpha_0$)
]

== Propriedades dos testes $t$
#theorem([Nível e Viés dos testes $t$])[
  Seja $underline(X)=(X_1,...,X_n)$ uma amostra aleatória de uma distribuição normal $X ~ N(mu, sigma^2)$ e $U$ ser a estatística definida anteriormente. Seja também $c$ o $1-alpha_0$ quantil da distribuição $t$ com $n-1$ graus de liberdade. Seja $delta$ o procedimento que rejeita $H_0$ na equação @t-test-mu-hypothesis-1 se $U>=c$. A função de poder $pi(mu, sigma^2|delta)$ tem as seguintes propriedades:
  
  #enum(numbering: "i.")[$pi(mu, sigma^2|delta) = alpha_0$ quando $mu=mu_0$][$pi(mu, sigma^2|delta) < alpha_0$ quando $mu<mu_0$][$pi(mu, sigma^2|delta) > alpha_0$ quando $mu>mu_0$][$pi(mu, sigma^2|delta) -> 0$ conforme $mu-> -infinity$][$pi(mu, sigma^2|delta) -> 1$ conforme $mu -> infinity$]

  Além disso, o teste $delta$ tem tamanho $alpha_0$ e é não-viezado
]
#proof[
  Se $mu=mu_0$, então $U ~ t_(n-1)$, portanto:
  $
    pi(mu_0, sigma^2|delta) = PP(U>=c|mu_0, sigma^2) = alpha_0
  $
  lembrando que a função de poder, quando $theta in Omega_0$ é a probabilidade de rejeitarmos $H_0$ (Erro de *Tipo I*), então vai ser a probabilidade de $U>=c$. Isso prova (i)

  Para provar (ii) e (iii), defina:
  $
    U^* = sqrt(n) dot (overline(X)_n - mu) / sigma' wide W = (sqrt(n)(mu_0 - mu))/sigma'
  $
  Logo, $U = U^* - W$. Primeiramente, assuma que $mu < mu_0$, então $W>0$, então segue que:
  $
    pi(mu, sigma^2|delta) &= PP(U>=c|mu,sigma^2) = PP(U^* - W|mu,sigma^2)   \
    &= PP(U^* >= c+W|mu,sigma^2) < PP(U^* >= c|mu,sigma^2)
  $
  Como $U^*$ tem distribuição $t_(n-1)$, a última probabilidade da equação é igual a $alpha_0$. Isso prova (ii). Para provar (iii), basta assumir que $mu > mu_0$, logo $W < 0$, então o sinal de *menor que* no final da equação vira um *maior que*. A prova de (iv) e (v) são mais complicadas e não serão abordadas
]

#corollary[
  Seja $underline(X)=(X_1,...,X_n)$ uma amostra aleatória de uma distribuição normal $X ~ N(mu, sigma^2)$ e $U$ ser a estatística definida anteriormente. Seja também $c$ o $1-alpha_0$ quantil da distribuição $t$ com $n-1$ graus de liberdade. Seja $delta$ o procedimento que rejeita $H_0$ na equação @t-test-mu-hypothesis-2 se $U<=c$. A função de poder $pi(mu, sigma^2|delta)$ tem as seguintes propriedades:
  
  #enum(numbering: "i.")[$pi(mu, sigma^2|delta) = alpha_0$ quando $mu=mu_0$][$pi(mu, sigma^2|delta) > alpha_0$ quando $mu<mu_0$][$pi(mu, sigma^2|delta) < alpha_0$ quando $mu>mu_0$][$pi(mu, sigma^2|delta) -> 1$ conforme $mu-> -infinity$][$pi(mu, sigma^2|delta) -> 0$ conforme $mu -> infinity$]

  Além disso, o teste $delta$ tem tamanho $alpha_0$ e é não-viezado
]

#example[
  Para o @hospital-example-t-test, se quiséssemos um teste de nível de significância $alpha_0=0.1$, então pelas propriedades, rejeitariamos $H_0$ se $U<=c$ onde $c = T^(-1)_(n-1)(0.1)$.
]

Calcular $p$-valores para os testes $t$ é bem direto ao ponto!

#theorem([$p$-valores para testes $t$])[
  Suponha que estamos testando ou as hipóteses da equação @t-test-mu-hypothesis-1 ou da @t-test-mu-hypothesis-2. Seja $u$ o valor observado da estatística $U$ e $T_(n-1)(dot)$ a cdf da distribuição $t_(n-1)$. Então o $p$-valor para as hipóteses da equação @t-test-mu-hypothesis-1 é $1-T_(n-1)(u)$ e para as hipóteses da equação @t-test-mu-hypothesis-2 é $T_(n-1)(u)$
]
#proof[
  Seja $T_(n-1)^(-1)(dot)$ a função quantil da $t_(n-1)$. Nós rejeitaríamos a hipótese na equação @t-test-mu-hypothesis-1 em um nível $alpha_0$ se, e somente se $u >= T_(n-1)^(-1)(1-alpha_0)$, que é equivalente a $alpha_0 >= 1-T_(n-1)(u)$. Similarmente, rejeitamos as hipóteses da equação @t-test-mu-hypothesis-2 se, e somente se $u <= T_(n-1)^(-1)(alpha_0)$, que é equivalente a $alpha_0 >= T_(n-1)(u)$
]

#example("Tamanho de Fibras")[
  Suponha que os comprimentos, em milímetros, de fibras metálicas produzidas por um determinado processo tenham distribuição normal, com média desconhecida ( $mu$ ) e variância desconhecida ( $sigma^2$ ), e que as seguintes hipóteses devam ser testadas:
  $
    H_0: mu <= 5.2
    wide
    H_1: mu > 5.2
  $

  Suponha que os comprimentos de 15 fibras selecionadas aleatoriamente sejam medidos e que se observe que a média amostral ( $overline(X)_(15)$ ) é $5.4$ e que ( $sigma' = 0.4226$ ). Com base nessas medições, realizaremos um teste *$t$* ao nível de significância ( $alpha_0 = 0.05$ ).

  Como ( $n = 15$ ) e ( $mu_0 = 5.2$ ), a estatística ( $U$ ) terá distribuição *$t$* com $14$ graus de liberdade quando ( $mu = 5.2$ ). Verifica-se na tabela da distribuição *$t$* que
  $
  T^(-1)_(14)(0.95) = 1.761.
  $
  Assim, a hipótese nula ( $H_0$ ) será rejeitada se ( $U > 1.761$ ). Como o valor numérico de ( $U$ ) é 1,833, a hipótese nula ( $H_0$ ) seria rejeitada ao nível de $0.05$.

  Com o valor observado ( $u = 1.833$ ) para a estatística ( $U$ ) e ( $n = 15$ ), podemos calcular o *p-valor* para as hipóteses utilizando um software computacional que inclua a função de distribuição acumulada das várias distribuições *$t$*. Em particular, obtemos
  $
  1 - T_(14)(1.833) = 0.0441.
  $
]<length-fibers-example>

Legal, mas será que conseguimos dizer algo sobre a *função poder* de um teste $t$? Se conseguirmos determinar a distribuição de $U$, nós conseguimos sim!

#definition([Distribuição $t$ não-central])[
  Seja $Y$ e $W$ variáveis aleatórias independentes onde $W ~ N(psi, 1)$ e $Y ~ Chi^2_(m)$, então a distribuição de:
  $
    X = W / (Y/m)^(1\/2)
  $
  é chamada de *distribuição $t$ não-central com $m$ graus de liberdade e parâmetro de não-centralidade $psi$*. Chamaremos a sua cdf de $T_(m)(t|psi)$ ($T_(m)(t|psi) = PP*(X<=t)$)
]

#theorem[
  Seja $X_1,...,X_n$ uma amostra aleatória de uma distribuição normal com média $mu$ e variância $sigma^2$. A distribuição da estatística $U$ é dada por uma distribuição $t$ não-central com $n-1$ graus de liberdade e parâmetro de não-centralidade $psi=sqrt(n)(mu-mu_0)\/sigma$. Seja $delta$ o teste que rejeita $H_0: mu <= mu_0$ quando $U>=c$. Então a função de poder de $delta$ é $pi(mu,sigma^2|delta) = 1-T_(n-1)(c|psi)$. Seja $delta'$ o teste que rejeita $H_0: mu >= mu_0$ quando $U <= c$, então a função de poder de $delta'$ é $pi(mu,sigma^2|delta') = T_(n-1)(c|psi)$
]

== Teste $t$ pareado
Em vários experimentos, podemos desejar comparar a mesma variável em condições distintas na mesma amostra, então estaríamos interessados em comparar qual condição possui maior média. Nesses casos é comum fazer a subtração entre os valores de cada condição e tratar como uma variável aleatória normal

#example("")[
  O *National Transportation Safety Board* coleta dados de testes de colisão referentes à quantidade e à localização dos danos em bonecos (*dummies*) colocados nos carros testados. Em uma série de testes, um boneco foi colocado no banco do motorista e outro no banco do passageiro dianteiro de cada carro. Uma das variáveis medidas foi o grau de lesão na cabeça de cada boneco. Entre outros aspectos, há interesse em saber se, e/ou em que medida, a quantidade de lesão na cabeça difere entre o banco do motorista e o banco do passageiro.

  Sejam $( X_1, dots, X_n )$ as diferenças entre os logaritmos das medidas de lesão na cabeça do lado do motorista e do lado do passageiro. Podemos modelar $( X_1, dots, X_n )$ como uma amostra aleatória de uma distribuição normal com média ( $mu$ ) e variância ( $sigma^2$ ). Suponha que desejamos testar a hipótese nula ( $H_0: mu <= 0$ ) contra a alternativa ( $H_1: mu > 0$ ), ao nível de significância ( $alpha_0 = 0.01$ ).

  Há $n = 164$ carros. O teste consiste em rejeitar ( $H_0$ ) se
  $
  U >= T^(-1)_(163)(0.99) = 2.35.
  $

  A média das diferenças é $overline(x)_n = 0.2199$. O valor de $sigma'$ é $0.5342$. A estatística $U$ é então igual a $5.271$. Esse valor é maior que $2.35$, e a hipótese nula seria rejeitada ao nível de $0.01$. De fato, o *p-valor* é menor que $1.0 dot 10^(-6)$.

  Suponha também que estamos interessados na função poder sob $H_1$ do teste de nível $0.01$. Suponha que a diferença média entre os logaritmos das lesões na cabeça do lado do motorista e do lado do passageiro seja $sigma/4$. Então, o parâmetro de não centralidade é $(164)^(1/2)/4 = 3.20$
]

== Testando uma alternativa bilateral
#example[
  Vamos retomar o @length-fibers-example, mas agora vamos alterar as hipóteses para:
  $
  H_0: mu = 5.2,
  wide
  H_1: mu != 5.2
  $

  Assumiremos novamente que os comprimentos de 15 fibras são medidos, e que o valor de $U$, calculado a partir dos valores observados, é 1,833. Testaremos as hipóteses ao nível de significância $alpha_0 = 0.05$.

  Como $alpha_0 = 0.05$, nosso valor crítico será o quantil $1 - 0.05/2 = 0.975$ da distribuição *$t$* com $14$graus de liberdade. Pela tabela das distribuições *$t$* deste livro, encontramos
  $
    T^(-1)_(14)(0.975) = 2.145.
  $

  Assim, o teste *t* especifica a rejeição de $H_0$ se $U <= -2.145$ ou se $U >= 2.145$. Como $U = 1.833$, a hipótese $H_0$ *não* seria rejeitada.

  Os valores numéricos nos exemplos enfatizam a importância de decidir se a hipótese alternativa apropriada em um dado problema é unilateral (*one-sided*) ou bilateral (*two-sided*). Quando as hipóteses do @length-fibers-example foram testadas ao nível de significância $0.05$, a hipótese nula $H_0$, de que $mu <= 5.2$, foi rejeitada. Quando as hipóteses desse exemplo foram testadas ao mesmo nível de significância, utilizando os mesmos dados, a hipótese nula $H_0$, de que $mu = 5.2$, não foi rejeitada.
]

#theorem([Função de poder de testes $t$ bilaterais])[
  A função de poder do teste $delta$ que rejeita $H_0: mu = mu_0$ quando $|U| >= c$, onde $c = T_(n-1)^(-1)(1-alpha_0\/2)$ pode ser encontrada utilizando a distribuição $t$ não-central. Se $mu!=mu_0$, então $U$ tem distribuição $t$ não-central com $n-1$ graus de liberdade e parâmetro de não-centralidade $psi = sqrt(n)(mu-mu_0)\/sigma$. A função de poder é:
  $
    pi(mu, sigma^2|delta) = T_(n-1)(-c|psi) + 1 - T_(n-1)(c|psi)
  $
]

#theorem([$p$-valores de testes $t$ bilaterais])[
  Suponha que estamos testando as hipóteses bilaterais $H_0: mu = mu_0$, $H_1: mu != mu_0$. Seja $u$ o valor observado da estatística $U$ e seja $T_(n-1)(dot)$ a cdf de uma $t_(n-1)$. Então o $p$-valor é $2[1-T_(n-1)(|u|)]$
]
#proof[
  Deixe $T^(-1)_(n-1)(dot)$ denotar a função quantil da $t_(n-1)$. Nós rejeitariamos a hipótese nula no nível $alpha_0$ se, e somente se, $|u| >= T_(n-1)^(-1)(1-alpha_0\/2)$ que é equivalente a $T_(n-1)(|u|)>=1-alpha_0\/2$ que é equivalente a $alpha_0 >= 2[1-T_(n-1)(|u|)]$
]

== Testes $t$ como testes de razão de verossimilhança
#example([Teste da Razão de Verossimilhança para Hipóteses Unilaterais sobre a Média de uma Distribuição Normal])[
  Considere as hipóteses unilaterais sobre a média de uma distribuição normal:
  $
    H_0: mu <= mu_0 wide H_1: mu > mu_0
  $
  
  Neste caso, $Omega_0 = {(mu, sigma^2) : mu <= mu_0}$ e $Omega_1 = {(mu, sigma^2) : mu > mu_0}$. A função de verossimilhança é:
  $
    f_n (underline(x)|mu, sigma^2) = 1/(2pi sigma^2)^(n/2) exp[-1/(2sigma^2) sum_(i=1)^n (x_i - mu)^2]
  $
  
  Após observar os valores $x_1, ..., x_n$, a estatística de teste de razão de verossimilhança é:
  $
    Lambda(x) = (sup_{(mu,sigma^2) in Omega_0} f_n (underline(x)|mu,sigma^2))/(sup_{(mu,sigma^2) in Omega} f_n (underline(x)|mu,sigma^2))
  $
  
  Chamemos $hat(mu)_0$ e $hat(sigma)^2_0$ os EMVs de $mu$ e $sigma^2$ sob $H_0$, e $hat(mu)$ e $hat(sigma)^2$ os EMVs de $mu$ e $sigma^2$ sob o espaço paramétrico completo.
  
  Suponha primeiro que os valores amostrais observados são tais que $overline(x)_n <= mu_0$. Então temos que $(hat(mu), hat(sigma)^2) in Omega_0$, se isso acontecer, então temos que $hat(mu)_0 = hat(mu)$ e $hat(sigma)^2_0 = hat(sigma)^2$, por tanto, nesse cenário, $Lambda(underline(x))$ é igual a $1$.

  Agora, suponha que os valores amostrais observados são tais que $overline(x)_n > mu_0$, logo, $(hat(mu), hat(sigma)^2) in.not Omega_0$. Nesse cenário, é possível demonstrar que $f_n (underline(x)|mu, sigma^2)$ atinge seu valor máximo entre os pontos $(mu, sigma^2) in Omega_0$ se escolhermos $mu$ o mais próximo possível de $overline(x)_n$. O valor de $mu$ mais próximo de $overline(x)_n$ é $mu_0$, pois $mu_0$ é o valor máximo possível de $mu$ sob $H_0$, por isso $hat(mu)_0 = mu_0$. Logo, podemos mostrar que:
  $
    hat(sigma)^2_0 = 1/n sum_(i=1)^n (x_i - mu_0)^2
  $
  nesse cenário, o valor do numerador de $Lambda(underline(x))$ é:
  $
    sup_({(mu, sigma^2)|mu>mu_0}) f_n (underline(x)|mu, sigma^2) = 1/(2pi hat(sigma)^2)^(n\/2) exp(-n/2)
  $

  Tirando a razão em ambos os casos mencionados anteriormente, temos que:
  $
    Lambda(underline(x)) = cases(
      (hat(sigma)^2/hat(sigma)^2_0)^(n\/2) -> overline(x)_n > mu_0,
      1 -> "do contrário"
    )
  $

  Agora, usamos seguinte relação:
  $
    sum_(i=1)^n (x_i - mu_0)^2 = sum_(i=1)^n (x_i - overline(x)_n)^2 + n(overline(x)_n - mu_0)^2
  $
  para reescrever a parte de cima da estatística $Lambda(underline(x))$ como:
  $
    [1+ n(overline(x)_n - mu_0)^2 / (sum_(i=1)^n (x_i - overline(x)_n)^2)]^(-n\/2)
  $

  Se $u$ é o valor observado da estatística $U$ (Equação @u-statistic), então podemos checar que:
  $
    n(overline(x)_n - mu_0)^2 / (sum_(i=1)^n (x_i - overline(x)_n)^2) = u^2 / (n-1)
  $

  Ou seja, segue que $Lambda(underline(x))$ é uma função *não-crescente* de $u$. Por isso, para $k<1$, $Lambda(underline(x)) <= k <=> u >= c$ onde:
  $
    c = sqrt((n-1) dot ((1/k)^(2\/n) - 1))
  $
  Segue então que o teste de razão de verossimilhança é um teste $t$
]


#pagebreak()

#align(center+horizon)[
  = Comparando as médias de duas Distribuições Normais
]

#pagebreak()

No mundo da estatística, é bem comum ocorrer de querermos comparar duas distribuições, suas médias, propriedades, etc. Quando utilizamos duas distribuições normais, os testes e intervalos de confiança são bem similares com os que aparecem quando consideramos apenas uma distribuição

== O $t$-teste biamostral
Primeiramente, considere o problema em que temos duas amostras de variáveis normais (com mesma variância) e queremos saber qual distribuição tem maior média. Especificamente, assumimos que $underline(X)=(X_1,...,X_m)$ é uma amostra aleatória de $m$, onde $X ~ N(mu_X, sigma^2)$ (com $mu_X$ e $sigma^2$ desconhecidos) e $underline(Y) = (Y_1,...,Y_n)$ formam uma amostra independente da primeira de $n$ observações, onde $Y ~ N(mu_Y, sigma^2)$. Estamos interessados em testar as hipóteses:
$
  H_0: mu_X <= mu_Y wide H_1: mu_X > mu_Y
$<two-sample-hypothesis-1>

para cada procedimento $delta$, vamos deixar que $pi(mu_X,mu_Y,sigma^2|delta)$ seja a *power function* (@power-function) de $delta$. Vamos assumir que $sigma^2$ é igual para ambas as distribuições, se esse requisito não fosse apropriado para o cenário analisado (posteriormente citarei um exemplo que esse caso é plausível), os testes $t$ que vamos derivar nas próximas seções não seriam apropriados.

Pensando em um $delta$ intuitivo, se a diferença entre as médias ($mu_Y - mu_X$) for alta, faz sentido rejeitarmos $H_0$, certo?

#theorem([Estatística $t$ para amostras duplas])[
  Assumindo a estrutura descrita nos parágrafos anteriores e definindo:
  $
    overline(X) = 1/m sum^(m)_(i=1) X_i wide overline(Y) = 1/n sum^(n)_(j=1) X_j
  $
  $
    S^2_X = sum^(m)_(i=1)(X_i - overline(X))^2 wide S^2_Y = sum^(n)_(j=1)(Y_j - overline(Y))^2
  $
  defina então o teste estatístico:
  $
    U = ((m+n-2)^(1\/2) (overline(X) - overline(Y))) / ((1/m + 1/n)^(1\/2) (S^2_X + S^2_Y)^(1\/2))
  $<two-sample-u-statistic>
  Para todos os valores de $theta=(mu_X,mu_Y,sigma^2)$ tais que $mu_X=mu_Y$, temos então que:
  $
    U ~ t_(m+n-2)
  $
]
#proof[
  Assuma que $mu_X = mu_Y$. Defina as seguintes variáveis aleatórias:
  $
    Z = (overline(X)-overline(Y))/((1/m + 1/n)^(1\/2)sigma)   \

    W = (S_X^2 + S_Y^2)/sigma^2
  $
  Agora podemos representar $U$ como:
  $
    U = Z/(W\/(m+n-2))^(1\/2)
  $
  perceba que se provarmos que $Z ~ N(0,1)$, $W ~ Chi^2_(m+n-2)$, e $Z$ e $W$ são independentes que o teorema está concluído. Desde o começo estamos assumindo que $X$ e $Y$ são independentes dado $theta$. Desse fato, segue que toda função de $X$ é independente de toda função de $Y$, em particular, $(overline(X), S^2_X)$ é independente de $(overline(Y), S^2_Y)$. Pelo @sample-mean-and-sample-variance-independence, sabemos que $overline(X)$ e $S^2_X$ são independentes, assim como $overline(Y)$ e $S^2_Y$, ou seja, todos $overline(X)$, $overline(Y)$, $S^2_X$ e $S^2_Y$ são independentes entre si, logo, $Z$ e $W$ também são independentes.

  Segue também do @sample-mean-and-sample-variance-independence que:
  $
    S^2_X / sigma^2 ~ Chi^2_(m-1) wide S^2_Y / sigma^2 ~ Chi^2_(n-1)
  $
   e pelas propriedades da $Chi^2$ (@sum-of-independent-chi-squares), temos que $W ~ Chi^2_(m+n-2)$. Utilizando das propriedades que vimos no curso de Probabilidade, sabemos que $overline(X) - overline(Y)$ tem média $mu_X - mu_Y = 0$ e variância $sigma^2\/n + sigma^2\/m$, logo, segue que $Z ~ N(0,1)$
]

Um teste $t$ biamostral com nível de significância $alpha_0$ é o procedimento $delta$ que rejeita $H_0$ se $U>=T^(-1)_(m+n-2)(1-alpha_0)$. O próximo teorema estabelece algumas propriedades interessantes sobre a *função de poder* de testes $t$ biamostrais análogos aos do :

#theorem([Nível e Viés de Testes $t$ biamostrais])[
  Seja $delta$ um teste $t$ biamostral definido antes. A função de poder $pi(mu_X, mu_Y, sigma^2|delta)$ tem as seguintes propriedades:
  - $pi(mu_X,mu_Y,sigma^2|delta) = alpha_0$ quando $mu_X=mu_Y$
  - $pi(mu_X,mu_Y,sigma^2|delta) < alpha_0$ quando $mu_X<mu_Y$
  - $pi(mu_X,mu_Y,sigma^2|delta) > alpha_0$ quando $mu_X>mu_Y$
  - $pi(mu_X,mu_Y,sigma^2|delta) -> 0$ conforme $mu_X-mu_Y -> -infinity$
  - $pi(mu_X,mu_Y,sigma^2|delta) -> 1$ conforme $mu_X-mu_Y -> infinity$
  além disso, o teste $delta$ tem tamanho $alpha_0$ e é não-viezado
]

Vale ressaltar que, se as hipóteses forem:
$
  H_0: mu_X >= mu_Y wide H_1: mu_X < mu_Y
$<two-sample-hypothesis-2>
o teste $delta$ correspondente de tamanho $alpha_0$ é *rejeitar $H_0$ quando $U<=-T^(-1)_(m+n-2)(1-alpha_0)$*. $P$-valores são computados de forma muito parecida da forma como se eles fossem de testes $t$ uniamostral

#theorem([$p$-valores de testes $t$ biamostrais])[
  Suponha que estejamos testando as hipóteses da equação @two-sample-hypothesis-1 ou @two-sample-hypothesis-2. Seja $u$ o valor observado da estatística $U$ (equação @two-sample-u-statistic) e seja $T_(m+n-2)(dot)$ a cdf da distribuição $t$ com $m+n-2$ graus de liberdade. Então o $p$-valor das hipóteses em @two-sample-hypothesis-1 é $1-T_(m+n-2)(u)$ e o $p$-valor das hipóteses em @two-sample-hypothesis-2 é $T_(m+n-2)(u)$
]

== Poder do Teste
Para cada parâmetro do vetor $theta=(mu_X, mu_Y, sigma^2)$, a função de poder do teste $t$ biamostral pode ser computada usando a distribuição $t$ não-central

#theorem([Poder do teste $t$ biamostral])[
  Seja a estatística $U$ ser definida como na equação @two-sample-u-statistic, então $U$ tem distribuição não-central $t$ com $m+n-2$ graus de liberdade e parâmetro de não-centralidade
  $
    psi = (mu_X - mu_Y) / (sigma (1/m + 1/n)^(1\/2))
  $
]

== Alternativas Bilaterais
Podemos adaptar os testes $t$ biamostrais para o caso de hipóteses bilaterais:
$
  H_0: mu_X = mu_Y wide  H_1: mu_X != mu_Y
$

O teste $t$ bilateral de tamanho $alpha_0$ rejeita $H_0$ se $|U| >= c$ onde $c = T^(-1)_(m+n-2)(1-alpha_0\/2)$ e a estatística $U$ é a mesma definida anteriormente. O $p$-valor quando $U=u$ é observado é igual a $2[1-T_(m+n-2)(|u|)]$
