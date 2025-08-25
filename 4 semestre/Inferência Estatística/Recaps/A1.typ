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
    Revisão para A1
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
  = Definições
]

#pagebreak()

Primeiro de tudo, precisamos entender o que estuda a Inferência Estatística. Isso nada mais é que um nome bonitinho para "chutar". Na probabilidade, tinhamos uma variável aleatória com uma distribuição e um parâmetro bem-definidos, porém, na vida real, não é muito bem o que ocorre. Imagine que queremos saber o tempo de vida que as lâmpadas da minha fábrica vivem, a única coisa que vou ter como me basear são as lâmpadas que já tenho, é dessas informações que eu tenho que fazer uma inferência, seja ela qual for, como por exemplo, qual sua distribuição e qual é o parâmetro a ela associado

#definition("Modelo Estatístico")[
  Um modelo estatístico consiste em:
  + Identificar variáveis de interesse (Sejam elas observáveis ou hipoteticamente observáveis, como um parâmetro de distribuição)
  + Especificar a distribuição conjunta (Ou uma família de distribuições) para variáveis observáveis
  + Identificar os parâmetros de interesse em (2)
  + (Se desejado) especificar uma distribuição para os parâmetros descritos
]

#definition("Inferência Estatística")[
  É um procedimento que produz afirmações probabilísticas sobre algumas ou todas as partes de um modelo estatístico
]

#definition("Parâmetro e Espaço Paramétrico")[
  Em um problema de inferência estatística, uma característica (ou combinações de características) que determina(m) a distribuição conjunta da(s) variável(eis) de interesse é chamada de parâmetro. O conjunto $Theta$ de todos os possíveis valores de um parâmetro $theta$ (Ou vetor paramétrico $(theta_1, ..., theta_k)$) é chamado de *espaço paramétrico*
]

Dentro da estatística, podemos dividir os problemas que encontramos em algumas categorias:

- *Predição*: Podemos tentar prever o resultado de uma variável aleatória com base nas observações anteriores. Quando a variável é um parâmetro, chamamos de Estimação.

- *Problemas de Decisão Estatística*: Depois que dados experimentais foram analisados, podemos querer tomar decisões com base nos resultados do experimento. As consequências da decisão dependem dos resultados.

- *Design Experimental*: Em alguns problemas de inferência estatística, temos controle sobre o tipo de dados ou quantidade de dados experimentais coletados.

#definition("Estatística")[
  Suponha que as variáveis aleatórias observáveis de interesse são $X_1,...,X_n$. Seja $r:RR^n -> RR$. Então a variável aleatória $T=r(X_1,...,X_n)$ é chamada de estatística.
]

Há também uma discussão sobre se os parâmetros que estamos procurando serem variáveis aleatórias ou valores fixos. Por enquanto, assumiremos que os parâmetros são variáveis aleatórias. Essa discussão está mais bem detalhada no livro do *DeGroot*

#pagebreak()

#align(center + horizon)[
  = $theta$ como uma Variável Aleatória
]

#pagebreak()

== Introdução
Nesse primeiro momento, iremos fazer experimentos assumindo que, ao fazer experimentos e obter resultados $X_j$ eles estão saindo de uma distribuição com parâmetro (ou vetor paramétrico) $theta$, e esse $theta$ é uma variável aleatória da qual desconhecemos.

== Distribuições Priori e Posteriori
Quando fazemos um experimento em que $theta$ é uma V.A., é interessante chutar uma distribuição para ele antes de observar qualquer dado.

#definition("Distribuição a priori")[
  Dado um modelo estatístico com parâmetro $theta$, se $theta$ for uma variável aleatória, a distribuição de $theta$ antes de qualquer dado é chamada de distribuição a priori (Podemos denotar $xi(theta)$ ou $f_(theta)(theta)$).
]

Quando estamos trabalhando com observações $X_1,...,X_k$, denotamos a distribuição a priori dos dados como $X_1,...,X_k|theta ~ "Dist"(theta)$ onde *Dist* representa qualquer distribuição, Ué, como que condicionamos $X_j$ em $theta$? Qual o sentido disso? Imagine que cada experimento é o output de uma máquina industrial, porém, para que essa máquina funcione, alguém precisa passar algumas informações para ela, porém, o seu chefe não mandou você colocar as informações, então você não sabe quais são elas, mas você está vendo os resultados da máquina, e sabe que aqueles resultados só estão acontecendo porque aquela configuração foi colocada, então por mais que não sabemos o $theta$, ele os valores de $X_1,...,X_k$ só sairam como estamos vendo porque o parâmetro da distribuição é $theta$ (Que ainda queremos descobrir)

Assim como especificamos uma distribuição para θ antes de qualquer dado ser observado, podemos atualizar a distribuição conforme observamos dados.

#definition("Função de verossimilhança")[
  A função de verossimilhança $LL(theta)$ é definida por
  $
    LL(theta)=f_(X|theta) (x_1,...,x_k∣theta)
  $
  De forma que $f_(X|theta)(underline(x)|theta)$ é a f.d.p de $X_1,...,X_k$
]

#definition("Distribuição a posteriori")[
  Dado um modelo estatístico com variáveis aleatórias observáveis $X_1,...,X_n$, a distribuição de $X_1,...,X_n|theta$ é chamada de distribuição a posteriori
]

E agora, com o teorema de bayes, podemos relacionar essas nossas definições

#theorem("Bayes")[
  Suponha que $X_1,...,x_k$ são amostras de uma população com distribuição conhecida de parâmetro $theta$ tal que sua f.d.p é $f_(X|theta)(x_1,...,x_k|theta)$. Suponha também que $theta$ é desconhecido e a distribuição a priori de $theta$ é tal que sua f.d.p é $f_theta (theta)$, então a posteriori de $theta$ é tal que:
  $
    f_theta (theta|x_1,...,x_k) = ( f_X (x_1,...,x_k|theta) f_(theta) (theta) ) / (f_X (x_1,...,x_k))
  $
  ou
  $
    f_theta (theta|x_1,...,x_k) = (LL(theta) xi(theta)) / (integral LL(theta) xi(theta) d theta)
  $
  Perceba porém, que o termo do denominador não depende de $theta$, ou seja, podemos reescrever isso tudo como:
  $
    f_theta (theta|x_1,...,x_k) prop LL(theta) xi(theta)
  $
]
#proof[
  Usar teorema de Bayes
]

Por conta do teorema acima, todos os termos constantes que encontramos em nossa distribuição nós podemos pegar e jogar fora e, ao final, encontramos um termo constante geral, já que para descobrir essa constante $C$ basta fazer:
$
  1/C = integral_(|Theta|) LL(theta)xi(theta) d theta
$<finding-the-constant>

== Observações sequenciais e predições
Porém, perceba que, até agora, eu vi o caso em que eu tenho todas as amostras de uma vez, porém se, por exemplo, eu quero descobrir se uma vacina é eficaz, isso é inviável, faz muito mas sentido eu ir atualizando minha distribuição conforme recebo mais informações, mas será que isso vai dar a mesma coisa?

Vamos fazer com duas observações condicionalmente independentes, para generalizar se faz analogamente. Como vimos, a posteriori de $theta$ após eu observar o dado $x_1$ se dá como:
$
  f_theta (theta|x_1) prop f_(X|theta)(x_1|theta) f_theta (theta)
$

Agora queremos obter $f_theta (theta|x_1, x_2)$. Pelo teorema de bayes para várias condicionais, temos que:
$
  f_theta (theta|x_1, x_2) prop f_theta (theta|x_1) f_X (x_2|x_1, theta)
$

Porém, estamos assumindo que eles são condicionalmente independentes, ou seja:
$
  f_X (x_2|theta,x_1) = f_X (x_2|theta)     \
  => f_theta (theta|x_1, x_2)               \
  prop f_theta (theta|x_1) f_X (x_2|theta)  \
  prop f_theta (theta) f_(X|theta)(x_1|theta) f_X (x_2|theta) \
  prop f_theta (theta) f_(X|theta)(x_1, x_2|theta)
$

Ou seja, independentemente se eu estou recebendo dado após o outro ou se eu tenho todos de uma vez para trabalhar, o resultado final deve ser o mesmo.

Porém, se voltarmos na equação @finding-the-constant, podemos perceber algo interessante. Lembra da *Lei da Probabilidade Total*?
$
  PP(A) = sum_(i=1)^n PP(B_i)PP(A|B_i)
$
Com $B_i$ sendo disjuntos. Porém, temos também a versão contínua do teorema:
$
  f_X (x) = integral_(Omega) f_(X|Y)(x|y) f_Y (y) d y
$
Porém, se fizermos algumas substituições, nós obtemos:
$
  f(x_(k)|x_1,...,x_(k-1)) = integral_(|Theta|) f (x_k|theta) xi (theta|x_1,...,x_(k-1)) d theta
$

Ou seja, podemos utilizar essa equação caso tenhamos $n$ observações e estamos interessados em prever o resultado da próxima observação.

== Distribuições à Priori Conjugadas
São famílias de distribuições de tal forma que, quando selecionamos elas como distribuições para um modelo estatístico, a posteriori também será daquela distribuição

#definition("Famílias/Hiperparâmetros Conjugados")[
  Seja $X_1,X_2,...|theta$ serem *i.i.d* com mesma f.d.p ou f.m.p $f(x|theta)$. Seja $Psi$ uma família de distribuições no espaço paramétrico $Theta$. Suponha que, não importa qual seja a distribuição à priori $xi$ que eu escolher de $Psi$, não importa quantas observações $underline(X) = (X_1,...,X_n)$ nós registramos e não importa seus valores observados $underline(x) = (x_1,...,x_n)$, a distribuição à posteriori $xi(theta|underline(x))$ está em $Psi$. Então $Psi$ é chamada de uma *família de distribuições à priori conjugadas* para amostras de com distribuições $f(x|theta)$. Finalmente, se as distribuições em $Psi$ possuem parâmetros associados, estes são chamados de *hiperparâmetros à priori* e os associados à distribuição posteriori são *hiperparâmetros à posteriori*
]

Vamos ver as principais famílias de distribuições conjugadas

#theorem[
  Suponha que $X_1,...,X_n|theta$ são uma amostra aleatória de variáveis de Bernoulli com parâmetro $theta$ (Desconhecido). Suponha também que a distribuição a priori de $theta$ é uma *beta* com parâmetros $alpha > 0$ e $beta > 0$. Então a distribuição a posteriori de $theta|x_1,...,x_n$ é a distribuição beta com parâmetros $alpha + sum_(i=1)^n x_i$ e $beta + n - sum_(i=1)^n x_i$
]
#proof[
  $
    f(theta|x_1,...,x_n) prop xi(theta) f(x_1,...,x_n|theta)
  $
  $
    <=> f(theta|x_1,...,x_n) prop theta^(alpha-1)(1-theta)^(beta-1) product_(i=1)^n theta^(x_i) (1-theta)^(1-x_i)
  $
  $
    <=> f(theta|x_1,...,x_n) prop theta^(alpha - 1 + sum_(i=1)^n x_i) (1 - theta)^(beta - 1 + n - sum_(i=1)^n x_i)
  $
  Ou seja, $theta|x_1,...,x_n ~ "Beta"(alpha + sum_(i=1)^n x_i, space beta + n - sum_(i=1)^n x_i)$
]


#theorem[
  Suponha que $X_1,...,X_n|theta$ são uma amostra aleatória de variáveis com distribuição Poisson com parâmetro $theta$ (Desconhecido). Suponha também que a distribuição a priori de $theta$ é uma *Gamma* com parâmetros $alpha > 0$ e $beta > 0$. Então a distribuição a posteriori de $theta|x_1,...,x_n$ é a distribuição Gamma com parâmetros $alpha + sum_(i=1)^n x_i$ e $beta + n$
]
#proof[
  Seja $y = sum^n_(i=1) x_i$, então a função de verossimilhança de $LL(theta)$ satisfaz:
  $
    PP(underline(x)|theta) prop e^(-n theta) theta^(y)
  $
  A priori $xi(theta)$ se estrutura assim:
  $
    xi(theta) prop theta^(alpha-1)e^(-beta theta) "para" theta > 0
  $
  Temos então que:
  $
    f(theta|underline(x)) prop e^(-n theta) theta^(y) theta^(alpha - 1) e^(-beta theta)   \

    <=> f(theta|underline(x)) prop theta^(alpha + y - 1) e^(-(n + beta)theta)
  $
  Ou seja, $theta|underline(x) ~ "Gamma"(alpha+y, n+beta)$
]

#theorem[
  Suponha que $X_1,...,X_n|theta$ são uma amostra aleatória de variáveis com distribuição Normal com média $theta$ (Desconhecido) e variância $sigma^2 > 0$ conhecido. Suponha também que a distribuição a priori de $theta$ é uma *Normal* com média $mu_0$ e variância $v_0^2$. Então a distribuição a posteriori de $theta|x_1,...,x_n$ é a distribuição normal com média $mu_1$ e variância $v_1^2$ onde:
  $
    mu_1 = (sigma^2 mu_0 + n v_0^2 accent(x, ~ )_n) / (sigma^2 + n v_0^2)
  $<normal-posterior-mu1>
  e
  $
    v_1^2 = (sigma^2 v_0^2) / ( sigma^2 + n v_0^2 )
  $<normal-posterior-v0-squared>
]
#proof[
  Temos que:
  $
    LL(theta) prop exp( -1/(2 sigma^2) sum^n_(i=1)(x_i - theta)^2 )
  $
  Temos que:
  $
    sum^n_(i=1)(x_i - theta)^2 = sum^n_(i=1)x_i^2 - 2x_i theta + theta^2
  $
  Definimos então $accent(x, ~)_n := 1/n sum^n_(i=1) x_i$ e assim temos que:
  $
    sum^n_(i=1)x_i^2 - 2x_i theta + theta^2 = n theta^2 - 2 n accent(x, ~)_n theta + sum^n_(i=1)x_i^2   \

    = n(theta^2 - 2 theta accent(x, ~)_n) + sum^n_(i=1)x_i^2

    = n(theta^2 - 2 theta accent(x, ~)_n + accent(x, ~)_n^2) - n accent(x, ~)_n + sum^n_(i=1)x_i^2    \

    = n(theta - accent(x, ~)_n)^2 + sum^n_(i=1)(x_i - accent(x, ~)_n)^2
  $

  Temos então:
  $
    LL(theta) prop exp( -1/(2 sigma^2) sum^n_(i=1)(x_i - theta)^2 )   \

    <=> LL(theta) prop exp(-1/(2 sigma^2) (n(theta-accent(x, ~)_n)^2 + sum^n_(i=1)(x_i - accent(x, ~)_n)^2))
  $
  Temos que $sum^n_(i=1)(x_i - accent(x, ~)_n)^2$ não depende de $theta$ então pode ir para a constante de proporcionalidade. De forma que
  $
    LL(theta) prop exp(-n/(2 sigma^2) (theta-accent(x, ~)_n)^2)
  $
  Sabemos que a priori de $theta$ segue a forma:
  $
    xi(theta) prop exp( -1/(2 v_0^2) (theta - mu_0)^2 )
  $
  Então temos que
  $
    f(theta|underline(x)) prop exp{-1/2 [ n/sigma^2 (theta - accent(x, ~)_n)^2 + 1/v_0^2 (theta - mu_0)^2 ]}
  $
  Se abrirmos os termos em quadrado, retirar as constantes, e completar os quadrados, chegamos nos resultados das equações @normal-posterior-mu1 e @normal-posterior-v0-squared, de forma que:
  $
    f(theta|underline(x)) prop exp[-1/(2 v_1^2) (theta - mu_1)^2]
  $
  Ou seja, $f(theta|underline(x)) ~ N(mu_1, v_1^2)$
]

Conseguimos dividir $mu_1$ da seguinte forma:
$
  mu_1 = sigma^2 / (sigma^2 + n v_0^2) mu_0 + (n v_0^2) / (sigma^2 + n v_0^2) accent(x, ~)_n
$
Isso nos mostra que, conforme nossa amostra vai aumentando, o termo da direita referente à média amostral vai dominando. Mas o que isso quer dizer? Quer dizer que, independente do quanto você acredita que $mu_0$ seja a média verdadeira de $theta$, mais a média após a observação dos dados vai se aproximando de $accent(x, ~)_n$, de forma que acabamos mudando de ideia aos poucos

#theorem[
  Suponha que $X_1,...,X_n|theta$ são uma amostra aleatória de variáveis com distribuição Exponencial com parâmetro $theta > 0$ (Desconhecido). Suponha também que a distribuição a priori de $theta$ é uma *Gamma* com parâmetros $alpha > 0$ e $beta > 0$. Então a distribuição a posteriori de $theta|x_1,...,x_n$ é a distribuição Gamma com parâmetros $alpha + n$ e $beta + sum_(i=1)^n x_i$
]
#proof[
  Novamente vamos chamar $y := sum_(i=1)^n x_i$. Então temos que a função de verossimilhança é:
  $
    LL(theta) = theta^(n)e^(-theta y)
  $
  E a priori tem a forma:
  $
    xi(theta) prop theta^(alpha - 1)e^(-beta theta) "para" theta > 1
  $
  Então temos que:
  $
    f(theta|underline(x)) prop theta^(alpha - 1)e^(-beta theta) theta^(n)e^(-theta y)   \

    <=> f(theta|underline(x)) prop theta^(n + alpha - 1) e^(-(beta + y)theta)
  $
  Ou seja, $f(theta|underline(x)) ~ "Gamma"(n+alpha, space beta+y)$
]

== Distribuições Impróprias
#definition("Distribuição Imprópria")[
  Seja $xi: C -> RR$ uma função não-negativa cujo domínio inclui o espaço paramétrico ($Omega subset C$) de um modelo estatístico. Suponha também que:
  $
    integral_(C) xi(theta) dif theta = infinity
  $
  Se nós imaginarmos que $xi$ é a f.d.p à priori de $theta$, então $xi$ é uma *distribuição imprória* de $theta$
]

Um bom exemplo é utilizar a distribuição *beta* assumindo que $alpha = beta = 0$. Mesmo que isso viole a condição da distribuição beta, o resultado da posteriori ainda sim é uma distribuição beta. Porém, existem diversos métodos para se escolher uma distribuição imprópria para $theta$. O mais comum é se utilizar de uma família de conjugados para o modelo estatístico, e forma a adaptarmos seus parâmetros para obter uma distribuição imprópria.
