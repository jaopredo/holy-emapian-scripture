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
  size: 12pt,
)

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
