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
    (1/2)^(1/2) / Gamma(1/2) e^(-1/2 z) = 1/sqrt(2) / sqrt(pi) e^(-1/2 z) = 1/sqrt(2pi) e^(-1/2 z)
  $
  Logo, $Z ~ Chi^2_1$
]

#corollary[
  Se $X_1,...,X_n ~ N(0,1)$, então:
  $
    X_1^2 + ... + X_n^2 ~ Chi_m^2
  $
]


