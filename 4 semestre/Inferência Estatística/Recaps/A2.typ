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
    f_X(x) = (1/2)^(m/2) / Gamma(m/2) x^(m/2 - 1) e^(-1/2 x)
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
  Se $X_1,...,X_k$ são iid e $X_i ~ Chi^2_m_i$, então $Y = sum^k_(j=1)X_j ~ Chi^2_(sum^k_(j=1)m_j))$
]
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

Outra família interessante de distribuições! Imagine a situação: Dado um experimento com amostras aleatórias $N(mu, sigma^2)$, sabemos que $overline(X)_n ~ N(mu, sigma^2 / n)$, logo:
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
    f_(X W) (x, w) = f_(Y Z) (y, z) | (diff (y, z))/(diff (x, w)) |
  $
  então denotando $W = Y$, temos:
  $
    Z = X(W/m)^(1/2) wide Y = W
  $
  Então vamos ter que:
  $
    (diff y) / (diff x) = 0 wide (diff y) / (diff w) = 1    \

    (diff z) / (diff x) = (w/m)^(1/2)
  $
  então vamos ter que
  $
    | (diff (y, z))/(diff (x, w)) | = -(w/m)^(1/2)
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
