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

  João Pedro Jerônimo
]

#align(horizon + center)[
  #text(17pt)[
    Otimização para Ciência de Dados
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
  = Otimização Irrestrita
]

#pagebreak()

#block(
  width: 100%,
  fill: rgb(255, 148, 162),
  inset: 1em,
  stroke: 1.5pt + rgb(117, 6, 21),
  radius: 5pt
)[
  *Nota*: Esse capítulo será cheio de definições e teoremas um atrás do outro, já que ele é mais uma revisão de coisas que já vimos em cursos passados. Todas as definições, teoremas e provas aqui escritas podem ser encontradas nas anotações do professor (Phillip Thompson). O intuito desse documento é esclarecer alguns conceitos que podem parecer confusos e dar intuições para vários conceitos bastante abstratos
]

== Introdução
Otimização é um ramo da matemática preocupada em resolver problemas em que você possui várias opções de escolha, de forma que cada uma tem o custo associado, e queremos escolher a escolha com menor custo possível, ou seja, queremos resolver:
$
  min_(x in C)f(x)
$
Com $f:C subset.eq RR^n -> RR$ sendo a *função objeto* e C sendo o *conjunto viável*.

== Definições e Revisões de Cálculo
Nesse capítulo, vamos rever alguns conceitos de cálculo e introduzir a otimização irrestrita, onde queremos trabalhar em uma função $f$ sem nenhuma restrição

#definition("Ponto de Mínimo")[
  Seja $f:C subset.eq RR^n -> RR$

  - $x^* in C$ é um *ponto de mínimo global* de $f$ em $C <=>$
    $
      forall x in C, "     " f(x^*) <= f(x)
    $
  
  - $x^* in C$ é um *ponto de mínimo global estrito* de $f$ em $C <=>$
    $
      forall x in C, "     " f(x^*) < f(x)
    $
  
  - $x^* in C$ é um *ponto de mínimo local* de $f$ em $C <=>$
    $
      exists r > 0 and forall x in C inter B(x^*, r), "     " f(x^*) <= f(x)
    $
  
  - $x^* in C$ é um *ponto de mínimo local estrito* de $f$ em $C <=>$
    $
      exists r > 0 and forall x in C inter B(x^*, r) \\{x^*}, "     " f(x^*) <= f(x)
    $
]

#definition("Bola")[
  Uma bola $B subset RR^n$ de raio $r>0 in RR$ e centro $p in RR^n$ é o conjunto:
  $
    B(p, r) = { x in RR \/ ||x - p|| <= r }
  $
]

Ou seja, qual é a diferença dos dois? Pontos de mínimo globais são menores que todo e qualquer outro ponto no domínio $C$ da função, enquanto os pontos locais são os menores em uma determinada vizinhança, a partir do ponto de mínimo local em questão, qualquer direção que eu tomar eu vou começar a subir o valor de $f$, mesmo que existam pontos em outros locais do domínio que sejam menores que o ponto de mínimo local que eu estava analisando

Agora vamos lembrar algumas coisas que vimos em cálculo (Alguns teoremas que são apenas revisão não serão demonstrados)

#definition("Derivada direcional")[
  Dada $f: RR^n -> RR$ e $d != 0 in RR^n$ e $||d|| = 1$. Se
  $
    exists lim_(t->0^+) (f(x+t d) - f(x))/t
  $
  Isso é chamado de derivada direcional de $f$ na direção $d$ ($(dif f)/(dif d)$)
]

#definition("Gradiente")[
  Dada $f: RR^n -> RR$ e $exists (diff f)/(diff x_i)$, $i = 1,...,n$, o vetor gradiente de $f$ é definido como:
  $
    nabla f(x) = mat(
      (diff f)/(diff x_1);
      (diff f)/(diff x_2);
      dots.v;
      (diff f)/(diff x_n);
    )
  $
]

#definition("Continuamente Diferenciável")[
  Uma função $f: RR^n -> RR$ é continuamente diferenciável se:
  $
    forall x in RR^n, space exists (diff f)/(diff x_i)(x)
  $
  e $(diff f)/(diff x_i)$ são contínuas $forall i$
]

#theorem("Aproximação de Primeira Ordem")[
  Quando $f$ é continuamente diferenciável, em uma vizinhança de um ponto $x$ podemos mostrar que:
  $
    forall d in RR^n "com" ||d||=1 wide space (dif f)/(dif d) = nabla f(x)^T d
  $
  e, além disso, temos:
  $
    forall y in RR^n "na vizinhança" wide f(y) = f(x) + nabla f(x)^T (y-x) + o(||y-x||)
  $
  Onde $o: RR_+ -> RR$ satisfaz $lim_(t->0^+) (o(t))/t = 0$
]

Apenas para relembrar, esse teorema está nos dando uma forma de aproximar uma função:

#figure(
  caption: [ Função $f(x,y)=(x+y)/(x^2 + y^2 + 1\/5)$ ],
  image(width: 50%, "images/function-example-1.png")
)

Perceba que, próximo do ponto, a distância entre os pontos da curva e os do plano não são tão grandes, por isso que definimos a aproximação linear como mostrado anteriormente

#definition("Funções duas vezes continuamente diferenciáveis")[
  Podemos também expressar uma definição similar para uma função $f : C -> R$$$ definida num conjunto $C subset RR^n $. Dizemos que $f : C -> R$$$ é duas continuamente diferenciável em $C$ se existe $U supset C$ conjunto aberto tal que existem todas derivadas parciais de primeira e segunda ordem em todo ponto $x in U$ e, além disso, as funções $(diff^2 f)/(diff x_i diff x_j) : U -> RR$ são contínuas
]

#definition("Matriz Hessiana")[
  Seja $f: U -> RR$ com $U subset RR$ e duas vezes continuamente diferenciável, a matriz hessiana de $f$ no ponto $x in U$ é definida como:
  $
    nabla^2 f(x) := mat(
      (diff^2 f)/(diff x_1^2), (diff^2 f)/(diff x_1 diff x_2), ..., (diff^2 f)/(diff x_1 diff x_n);

      (diff^2 f)/(diff x_2 diff x_1), (diff^2 f)/(diff x_2^2), dots.down, dots.v;

      dots.v;

      (diff^2 f)/(diff x_n diff x_1), (diff^2 f)/(diff x_n diff x_2), ..., (diff^2 f)/(diff x_n^2)
    )
  $

  Perceba que $nabla^2 f(x)$ é simétrica
]


#theorem("Aproximação Linear")[
  Seja $f: U -> RR$ uma função duas vezes continuamente diferenciável e $U subset.eq RR^n$, e seja $x in U$ e $r > 0$ tais que $B(x, r) subset U$ então:
  $
    forall y in B(x, r) space exists xi in [x, y] "tal que" \
    f(y) = f(x) + nabla f(x)^T (y - x) + 1/2 (y - x)^T nabla^2 f(xi) (y - x) 
  $
]<linear-approximation>

#theorem("Aproximação de Segunda Ordem")[
  Seja $f: U -> RR$ uma função duas vezes continuamente diferenciável e $U subset.eq RR^n$, e seja $x in U$ e $r > 0$ tais que $B(x, r) subset U$ então:
  $
    forall y in B(x, r) "vale" \
    f(y) = f(x) + nabla f(x)^T (y - x) + 1/2 (y - x)^T nabla^2 f(x) (y - x) + o(||y-x||^2)
  $
]<second-order-approximation>

== Soluções Locais: Condições de primeira ordem
Agora podemos começar a brincadeira. Quando falamos de condições de primeira ordem, estamos nos referindo a condições relacionadas a derivadas de primeiro grau, ou seja, funções que são continuamente diferenciáveis. Antes eu comentei que estávamos interessados em minimizar funções num conjunto $C$, porém, vamos primeiro ver sobre otimização *irrestrita*, ou seja, problemas do tipo:
$
  min_(x in RR^n) f(x)
$

Lembram que o vetor gradiente indica a direção que minha função tá crescendo? Quando estamos procurando um mínimo local, faz sentido dizer que a função cresça pra todos os lados, correto? Então faz sentido dizer que isso vai me dar um vetor gradiente $0$ (Apenas uma intuição)

#theorem("Condições de primeira ordem")[
  Seja $f: U -> RR$ uma função definida no conjunto aberto $U subset RR^n$. Se $x^* in U$ é um mínimo local de $f$ e todas as derivadas parciais de $f$ existem, então
  $
    nabla f(x^*) = 0
  $
]
#proof[
  Seja $i in [n]$ e defina a função $g(t) = f (x^* + t e_i  $. Temos que $g$ é diferenciável em $0$ e $ g'(0) = (diff f)/(diff x_i) (x^*)$. Sendo $x^*$ um ponto ótimo local de $f$ , segue que $0$ é um ponto ótimo local de $g$; portanto $0 = g'(0) = (diff f)/(diff x_i)(x^*)$. O argumento vale para todo $i in [n]$, implicando que $nabla f (x^*) = 0$
]

Esse teorema não vale na volta, já que, como vimos antes em cálculo, pontos de máximo e de sela também possuem essa característica, isso nos leva a criar a definição:

#definition("Ponto estacionário")[
  Seja $f: U -> RR$ uma função definida no conjunto aberto $U subset RR^n$ e todas as derivadas parciais de $f$ existem, então chamamos $x^* in U$ de ponto estacionário de $f$ em $U$ se
  $
    nabla f(x^*) = 0
  $
]

== Soluções Locais: Condições de segunda ordem
Nas anotações, o professor generaliza o conceito de que, se $x$ é estacionário e $f''(x) > 0$ então $x$ é mínimo local.

#definition("Positividade e Negatividade de uma matriz")[
  Seja $A$ uma matriz simétrica:

  - Dizemos que $A$ é positiva semidefinida, denotando-s por $A succ.eq 0 <=> forall x in RR^n, space x^T A x >= 0$

  - Dizemos que $A$ é positiva definida, denotando-s por $A succ 0 <=> forall x in RR^n, space x^T A x > 0$

  - Dizemos que $A$ é negativa semidefinida, denotando-s por $A prec.eq 0 <=> forall x in RR^n, space x^T A x <= 0$

  - Dizemos que $A$ é negativa definida, denotando-s por $A prec 0 <=> forall x in RR^n, space x^T A x < 0$

  - Dizemos que $A$ é indefinida, quando $exists x, y in RR^n$ tal que $x^T A x > 0$ e $y^T A y < 0$
]

Nas anotações do professor ele traz alguns conceitos que vimos em álgebra linear, mas eu não vou os abordar aqui.

#theorem("Condições necessárias de segunda ordem")[
  Seja $f: U->RR$ com $U subset RR^n$ e suponha que $f$ é duas vezes continuamente diferenciável sobre $U$ e seja $x^* in U$, então:
  + Se $x^*$ é mínimo local, então $nabla^2 f(x^*) succ.eq 0$
  + Se $x^*$ é máximo local, então $nabla^2 f(x^*) prec.eq 0$
]
#proof[
  Vamos apenas provar o item $1$ já que a prova para o $2$ é análoga (Basta aplicar a demonstração na função $-f$).
  
  Sendo $x^*$ um ponto de mínimo local, $exists B(x^*, r) subset U$ tal que:
  $
    forall x in B(x^*, r) wide f(x) >= f(x^*)
  $<minimal-on-ball-condition>
  Seja $0 != d in RR^n$. Para todo $0 < alpha < r/(||d||)$, vamos definir:
  $
    x_alpha^* := x^* + alpha d
  $
  $
    x_alpha^* in B(x^*, r) => f(x_alpha^*) >= f(x^*)
  $
  Pelo @linear-approximation, $exists xi_alpha in [x^*, x_alpha^*]$ tal que
  $
    f(x_alpha^*) - f(x^*) = nabla f(x^*)^T (x_alpha^* - x^*) + 1/2 (x_alpha^* - x^*)^T nabla^2 f(xi_alpha) (x_alpha^* - x^*)
  $
  Como $x^*$ é estacionário, temos:
  $
    f(x_alpha^*) - f(x^*) = alpha^2/2 d^T nabla^2 f(xi_alpha) d
  $<final-condition-to-minimal-point>
  Combinando as equações @minimal-on-ball-condition e @final-condition-to-minimal-point, temos que, para todo $alpha in (0, r/(||d||))$:
  $
    d^T nabla^2 f(xi_alpha) d >= 0
  $
  Usando de que $xi_alpha -> x^*$ quando $alpha -> 0^+$ e por continuidade da Hessiana, segue:
  $
    d^T nabla^2 f(x^*) d >= 0
  $
  Isso é válido pois eu assumi um $d$ genérico
]

Perceba que essa condição é necessária, mas não é suficiente. Por exemplo, a função $f(x)=x^3$ é tal que $f'(0) = 0$, $f''(0) = 0$, porém, não é um ponto de máximo nem de mínimo.

#theorem("Condições suficientes de segunda ordem")[
  Seja $f: U->RR$ com $U subset RR^n$ e suponha que $f$ é duas vezes continuamente diferenciável sobre $U$ e seja $x^* in U$ um ponto estacionário de $f$ em $U$, então:

  - Se $gradient^2 f(x^*) succ 0$ então $x^*$ é um ponto de mínimo local estrito
  - Se $gradient^2 f(x^*) prec 0$ então $x^*$ é um ponto de máximo local estrito
]
#proof[
  Provaremos apenas o primeiro item. O segundo segue do primeiro aplicado em $-f$

  Seja $x^* in U$ um ponto estacionário de $f$ em $U$ tal que $gradient^2 f(x^*) succ 0$. Como a Hessiana é contínua, segue que $exists B(x^*, r) subset U$ tal que $gradient^2 f(x^*) succ 0 space forall x in B(x^*, r)$. Pelo @linear-approximation, segue que $forall x in B(x^*, r) space exists xi in [x^*, x] subset B(x^*, r)$ tal que:
  $
    f(x) - f(x^*) = nabla f(x^*)^T (x - x^*) + 1/2 (x-x^*)^T nabla^2 f(xi) (x-x^*)
  $
  Como $x^*$ é estacionário, $nabla f(x^*) = 0$. Segue também que $nabla^2 f(xi) succ 0 space forall x in B(x^*, r)$. Isso significa que
  $
    forall x != x^*, wide f(x) > f(x^*)
  $
  Ou seja, $x^*$ é mínimo local estrito
]

Para clarear um pouco sobre a demonstração, os passos mais confusos pode ser a conclusão final. Principalmente essa conclusão $nabla^2 f(xi) succ 0$. Vamos tentar abstrair isso isso com $f: RR^2 -> RR$. Pega um ponto de mínimo estrito local, e faz uma bola em volta dele, todo ponto dentro daquele lugar vai ter hessiana positiva por conta da continuidade da Hessiana. Como assim? Imagina que a Hessiana é uma função $RR -> RR$, como ela é uma função contínua, não faz sentido eu mudar a entrada da função e ela bruscamente trocar de positivo pra negativo, certo? Claro que em um certo ponto, ela passa pelo 0 e o sinal troca, mas eu consigo aumentar minha bola até um pouquinho antes disso acontecer

#figure(
  caption: [Desenho de domínio qualquer de uma função $f$],
  image(width: 50%, "images/domain-example.png")
)

A partir dessa linha amarela, os pontos vão ter hessiana negativa e, em cima dela, eles tem hessiana igual a 0, ou seja, então eu consigo criar uma bola $B(x^*, r)$ de forma que ela não ultrapasse a linha amarela

#figure(
  caption: [Desenho de domínio qualquer de uma função $f$ com uma bola $B$],
  image(width: 70%, "images/domain-example-with-ball.png")
)

Ou seja, eu sei que todos os pontos dentro dessa bola tem Hessiana positiva. Depois disso, eu apenas utilizo do @linear-approximation para chegar na desigualdade $f(x) > f(x^*)$

Um teorema parecido pode ser usado para pontos que tem gradiente $0$, mas que não são nem máximo nem mínimo (Como vimos em $f(x) = x^3$)

#definition("Ponto de Sela")[
  Seja $f: U->RR$ definida num conjunto aberto $U subset RR^n$. Suponha que $f$ é duas vezes continuamente diferenciável. $x^* in U$ é ponto de sela de $f$ em $U$ se ele é um ponto estacionário, mas não é nem ponto de máximo nem ponto de mínimo
]

#theorem("Condições suficientes para pontos de sela")[
  Seja $f: U->RR$ com $U subset RR^n$ e suponha que $f$ é duas vezes continuamente diferenciável sobre $U$ e seja $x^* in U$ um ponto estacionário de $f$ em $U$, se $gradient^2 f(x^*)$ é indefinda, então $x^*$ é ponto de sela
]
#proof[
  Seja $nabla^2 f (x^*)$ é indefinida. Portanto, $nabla^2 f (x^*)$ possui auto-valor positivo $lambda_1$ associado ao auto-vetor $v_1$ com norma $||v_1|| = 1$. Sendo $U$ aberto, existe $r > 0$ tal que $x^* + alpha v_1 in U$ para todo $alpha in (0, r)$. Pelo @second-order-approximation e usando que $nabla f(x^*) = 0$, sabemos que existe uma função $o: RR_+ -> RR$ satisfazendo:
  $
    lim_(t -> 0^+) o(t)/t = 0
  $<o-function-property>
  tal que para todo $alpha in (0, r)$:
  $
    f(x^* + alpha r) = f(x^*) + alpha^2/2 v_1^T nabla^2 f(x^*) v_1 + o(alpha^2 ||v_1||^2)   \
    = f(x^*) + (lambda_1 alpha^2)/2 ||v_1||^2 + o(alpha^2 ||v_1||^2)    \
    =  f(x^*) + (lambda_1 alpha^2)/2 + o(alpha^2)
  $
  Segue da equação @o-function-property que $exists epsilon_1 in (0, r)$ tal que:
  $
    forall alpha in (0, epsilon_1), wide g(alpha^2) > -(lambda_1 alpha^2)/2
  $
  Portanto,
  $
    forall alpha in (0, epsilon_1), wide f(x^* + alpha v_1) > f(x^*)
  $
  Ou seja, $x^*$ não pode ser máximo local sobre $U$. Um argumento análogo dizendo que $exists lambda_2 < 0$ sendo $lambda_2$ um autovalor da hessiana pode ser usado para mostrar que $x^*$ também não pode ser mínimo local
]

Essa prova parece complicada, então vou dar uma noção mais intuitiva. Vimos em álgebra linear que uma matriz é positiva definida se, e somente se, todos os seus autovalores são maiores que $0$ (O mesmo para matrizes negativas definidas), e que se elas possuem um autovalor positivo e outro negativo, então ela é indefinida. Mas o que isso me diz intuitivamente? Lembra que, se uma matriz tem multiplicidade algébrica igual a multiplicidade geométrica em todos os autovalores, então a gente pode dividir ela como:
$
  gradient^2 f(x) = Q^T Lambda Q
$
$Q$ é ortogonal pois $gradient^2 f(x)$ é simétrica (Teorema Espectral). Mas o que isso significa? De uma maneira intuitiva, isso significa que os autovetores indicam direções ortogonais e o autovalor indica se a hessiana está crescendo ou diminuindo *naquela direção*, então se ela é indefinida em um ponto de sela, quer dizer que eu tenho direções que a hessiana tanto cresce como diminui, como ela cresce e diminui em direções diferentes partindo do mesmo ponto, ele não é nem máximo, nem mínimo

#figure(
  caption: [Função $f(x,y) = a x^2 + b y^2$. Ponto laranja é ponto de sela (Ponto (0,0,0))],
  image("images/saddle-point.png", width: 50%)
)

== Existência de pontos ótimos
Até agora estávamos assumindo que pontos ótimos existiam, mas e se eles não existem?

#definition("Conjunto fechado")[
  Um conjunto $C$ é fechado se seu complementar $C^c$ é aberto
]

#definition("Conjunto limitado")[
  Um conjunto $C$ é limitado se $exists r > 0$ tal que $C subset B(0, r)$
]

#definition("Conjunto compacto")[
  Um conjunto $C$ é compacto se é fechado e limitado
]

#theorem("Weierstrass")[
  Seja $C subset RR^n$ um conjunto compacto e $f: C->RR$, então $f$ possui um ponto de mínimo global e de máximo global em $C$
]

Quando o conjunto não é compacto, o teorema de Weierstrass não garante a existência, então podemos usar essa outra definição:

#definition("Coercividade")[
  Seja $f: RR^n -> RR$. A função é dita coerciva se:
  $
    lim_(||x||->infinity) = infinity
  $
]

Ou seja, todo e qualquer vetor que eu pegar e aumentar seu tamanho, a função aumenta junto, formando o que parece uma grande bacia, onde você coloca água e ela nunca vaza

#figure(
  caption: [Exemplo de função coerciva $f(x,y)=0.1x^2+0.1y^2$],
  image(width: 50%, "images/coercive-function.png.png")
)

#theorem("Existência de soluções: Coercividade")[
  Seja $f : RR^n -> RR$ uma função contínua e coerciva e $C subset RR^n$ um conjunto fechado não-vazio. Então f tem um mínimo global em C
]
#proof[
  Seja $x_0 in C$ um ponto arbitrário. Como f é coerciva, segue que existe $M > 0$ tal que
  $
    f(x) > f (x_0) "para todo" x "tal que" ||x|| > M
  $
  Temos que $x^*$ é um ponto de mínimo global de $f$ sobre $C$. Portanto $f (x^*) ≥ f (x_0)$. Segue da afirmação em diplay que o conjunto de mínimos globais de $f$ sobre $C$ é exatamente o conjunto de mínimos globais de $f$ sobre $C inter B(0, M)$. O conjunto $C inter B(0, M)$ é fechado e limitado, portanto compacto. Segue do Teorema de Weierstrass que $f$ possui ponto de mínimo global sobre $C ∩ B(0, M)$, e portanto, sobre $C$ também
]

== Condições para soluções globais
#theorem[
  Seja $f: RR^n->RR$ duas vezes continuamente diferenciável. Suponha que:
  $
    gradient^2 f(x) succ.eq 0, space forall x in RR^n
  $
  Então, em todo ponto estacionário de $f$, esse ponto é um mínimo global
]<sufficient-condition-global-minimum>
#proof[
  Pelo @linear-approximation, seja $x^* in RR^n$ um ponto estacionário em $f$ e $forall x in RR^n$:
  $
    f(x) - f(x^*) = 1/2 (x-x^*)^T gradient^2 f(xi) (x - x^*)
  $
  Porém, vale que $forall x, space gradient^2 f(xi) succ.eq 0$. Temos então que:
  $
    forall x in RR^n, space f(x) >= f(x^*)
  $
  Logo, $x^*$ é ponto de mínimo global em $f$
]

== Funções quadráticas
Um conjunto interessante de funções com algumas propriedades convenientes são as funções quadráticas

#definition("Função quadrática")[
  Uma função é quadrática quando $exists A in RR^(n times n) "simétrica", b in RR^n, c in RR $ tal que a função $f: RR^n -> RR$ pode ser expressa como:
  $
    f(x) = x^T A x + 2b^T x + c
  $
]<quadratic-function>

#theorem("Derivadas de uma quadrática")[
  Seja $f$ uma função quadrática como na @quadratic-function, temos que:
  $
    gradient f(x) = 2 (A x + b) \
    gradient^2 f(x) = 2A
  $
]
#proof[
  Sabemos que $f(x) = x^T A x + 2b^T x + c$. Vamos definir que $x_i$ é a $i$-ésima entrada de $x$. Vamos primeiro calcular uma derivada parcial genérica de $f$. Como a derivada é uma operação linear, eu vou ver cada componente separadamente.
  $
    x^T A x =
    mat(x_1,...,x_n)
    
    mat(
      a_(1 1),...,a_(1 n);
      dots.v,dots.down,dots.v;
      a_(n 1),...,a_(n n)
    )

    mat(x_1;dots.v;x_n)

    =

    mat(x_1,...,x_n)

    mat(
      sum_(k = 1)^n a_(1 k)x_k;
      dots.v;
      sum_(k = 1)^n a_(n k)x_k
    )
  $

  Para facilitar nossa vida, vamos definir $ alpha_j = sum_(k = 1)^n a_(j k)x_k $. Então:
  $
    f(x) = alpha_1 x_1 + ... + alpha_n x_n + 2(b_1 x_1 +...+ b_n x_n) + c
  $
  Agora podemos tirar a derivada de $f(x)$ em $x_j$, mas antes, perceba que:
  $
    (diff alpha_i) / (diff x_j) = a_(i j)
  $
  Agora sim:
  $
    (diff f)/(diff x_j) = x_1 (diff alpha_1)/(diff alpha_j) + ... + diff / (diff x_j) (alpha_j x_j) + ... + x_n (diff alpha_n)/(diff x_j) + 2b_j \

    (diff f)/(diff x_j) = x_1 a_(1 j) + ... + (diff alpha_j) / (diff x_j)x_j + alpha_j + ... + x_n a_(n j) + 2b_j  \

    (diff f)/(diff x_j) = sum_(k = 1)^n a_(j k)x_k + sum_(k = 1)^n a_(k j)x_k + 2b_j
  $

  Como $A$ é simétrica, podemos reescrever isso como:
  $
    (diff f)/(diff x_j) = 2 (sum_(k = 1)^n a_(k j)x_k + b_j)
  $

  Ou seja, o gradiente da função é:
  $
    nabla f(x) = 2(A x + b)
  $

  E para a hessiana é bem mais fácil, dado o item anterior, basta que tiremos a derivada novamente para $x_i$:
  $
    (diff^2 f)/(diff x_j diff x_i) = 2a_(i j)
  $
  Ou seja:
  $
    nabla^2 f(x) = 2A
  $
]

#theorem("Pontos estacionários e ótimos de função quadrática")[ Seja uma função $f$ definida na @quadratic-function, então:

+ $x$ é ponto estacionário $<=> A x = -b$.
+ Suponha que $A succ.eq 0$. Então $x$ é ponto de mínimo global $<=> A x = -b$.
+ Suponha que $A succ 0$. Então $x = -A^(-1)b$ é ponto de mínimo global estrito.
]
#proof[
  + Segue imediatamente da fórmula do gradiente.
  + Suponha que $A succ.eq 0$. Da f́ormula da Hessiana, segue que $nabla^2 f (x) succ.eq 0 space forall x in RR^n$. O resultado segue então do @sufficient-condition-global-minimum e item 1.
  + Suponha que $A succ 0$. Então $x = -A^(-1)b$ é a única solução de $A x = -b$. Segue do item (ii) que $x = -A^(-1) b$ é o único ponto de mínimo global de $f$ e, portanto, mínimo global estrito.
]


#theorem("Coercividade de funções quadráticas")[
  Seja função $f$ definida como na @quadratic-function. Então $f$ é coerciva $<=> A succ 0$.
]
#proof[
  Precisamos do seguinte lema: Seja $A in RR^(n times n)$ simétrica, então $forall x != 0 in RR^(n times n)$
  $
    lambda_"min" (A) <= (x^T A x)/(||x||^2) <= lambda_"max" (A)
  $
  (Pode-se demonstrar pelo teorema espectral)

  Agora podemos começar a prova:

  $(<==) $ Suponha que $A succ 0$. Denote $alpha := lambda_"min" (A)$. Pelo lema àcima e Cauchy-Schwarz, segue que, para todo $x in RR^n$,
  $
    f (x) = x^T A x + 2b^T x + c >= alpha ||x||^2 - 2||b||||x|| + c
  $
  Segue que $f (x) -> infinity$ quando $||x|| -> infinity$; isto é, $f$ é coerciva.

  $(==>)$ Suponha que $f$ é coerciva. Suponha que $A$ tenha auto-valores negativos. Portanto, existem $v != 0$ e $lambda < 0$ tais que $A v = lambda v$. Portanto, para todo $alpha in RR$,
  $
    f(alpha v) = lambda||v||^2 alpha^2 + 2(b^T v)alpha + c -> infinity "quando" alpha -> infinity
  $

  Isto contradiz a hipótese de coercividade. Portanto, A possui todos auto-valores não-negativos. Provaremos agora que $0$ não é auto-valor de $A$, provando que $A succ 0$. Assuma que exista $v ̸= 0$ tal que $A v = 0$. Então, para todo $alpha in RR$,
  $
    f (alpha v ) = 2(b^T v) alpha + c.
  $
  Temos que:
  $
    f(alpha v) -> cases(
      c "quando" alpha -> infinity "se" b^T v = 0,
      -infinity "quando" alpha -> -infinity "se" b^T v > 0,
      infinity "quando" alpha -> infinity "se" b^T v < 0
    )
  $
  Em qualquer caso a coerção é violada, portanto, $0$ não pode ser autovalor de $A$
]

#pagebreak()

#align(center + horizon)[
  = Otimização Convexa
]

#pagebreak()

Agora vamos focar os nossos esforços em resolver um conjunto específico de problemas de otimização, os do tipo:
$
  min_(x in C) f(x) wide C subset.eq RR^n "convexo"
$
Ou seja, agora começaremos a aplicar as famosas restrições nos problemas que vamos abordar

== Convexidade

#definition("Conjunto convexo")[
  Um conjunto $C subset.eq RR^n$ é dito convexo se
  $
    forall x,y in C and forall lambda in (0,1) "vale" lambda x + (1 - lambda)y in C
  $
]

Ou seja, se eu pego dois pontos dentro do conjunto $C$ e fizer uma reta que interliga eles, todos os pontos nessa reta devem estar dentro de $C$

#figure(
  caption: [Exemplo de figuras convexas e não-convexas retirado das anotações do professor],
  image("images/convex-and-non-convex-example.png")
)

Porém, outra definição muito importante são as de *funções convexas*

#definition("Funções convexas")[
  Uma função $f: C subset.eq RR^n -> RR$ com $C$ convexo é dita convexa se:
  $
    forall x,y in C and forall lambda in (0, 1) "vale" f(lambda x + (1-lambda)y) <= lambda f(x) + (1-lambda)f(y)
  $
]

#definition("Funções estritamente convexas")[
  Uma função $f: C subset.eq RR^n -> RR$ com $C$ convexo é dita estritamente convexa se:
  $
    forall x,y in C and forall lambda in (0, 1) "vale" f(lambda x + (1-lambda)y) < lambda f(x) + (1-lambda)f(y)
  $
]

Mas o que isso quer dizer? Quer dizer que eu vou pegar o segmento entre meus pontos $x$ e $y$ e vou aplicar a função neles, depois eu vou pegar o segmento de reta entre $f(x)$ e $f(y)$ e comparar. Todos os pontos nesse segmento de reta tem que estar acima dos pontos da curva que eu fiz antes
#grid(
  columns: (50%, 50%), // Cria duas colunas, uma com 30% da largura para a imagem e outra com 70% para o texto
  column-gutter: 1em, // Adiciona um espaço (gutter) de 1em entre as colunas

  // Coluna 1: Imagem
  figure(
    caption: [Função convexa $f(x)=x^2$],
    image("images/convex-function-example.png", width: 100%)
  ),
  figure(
    caption: [Função não-convexa $f(x)=x^4 - 3x^2$],
    image("images/non-convex-function-example.png", width: 100%)
  )
)

Antes de continuar, vamos definir um conjunto simplex, que utilizaremos bastante daqui pra frente:

#definition("Conjunto simplex")[
  O conjunto simplex $Delta_k$ é definido como:
  $
    Delta_k := { lambda in RR^k_+ \/ sum^k_(i=1)lambda_i = 1 }
  $
]

Existe um teorema que mostra que isso vale não só para a combinação de dois pontos, mas para a combinação de quaisquer $n$ pontos

#theorem("Teorema de Jenssen")[
  Seja $f: C subset.eq RR^n -> RR$, com $C$ convexo, uma função convexa. Então dados quais quer coleção ${x_i}^k_(i=1) subset C$ de pontos de $C$ e qualquer $lambda in Delta_k$:
  $
    f(sum^k_(i=1)lambda_i x_i) <= sum^k_(i=1)lambda_i f(x_i)
  $
]
#proof[
  Faremos por indução. O caso base $k=1$ é bem óbvio. Agora vamos supor que vale para $k$. Sejam ${x_i}^(k+1)_(i=1) subset C$ e $lambda in Delta_(k+1)$. Para facilitar, definamos:
  $
    z := sum^(k+1)_(i=1) lambda_i x_i
  $
  Se $lambda_(k+1) = 1$, então $sum^(k)_(i=1) lambda_i = 0$; Como $lambda_i >= 0 space forall i in [k]$, tem-se que $lambda_i = 0$. Nesse caso, $x_(k+1) = z$ e a desigualdade é imediata
  Se $lambda_(k+1) < 1$. Nesse caso,
  $
    z = lambda_(k+1)x_(k+1) sum^(k)_(i=1) lambda_i x_i = lambda_(k+1)x_(k+1) + (1-lambda_(k+1)) underbrace(sum^(k)_(i=1) lambda_i / (1-lambda_(k+1))x_i, v) 
  $
  E é bem fácil de ver que
  $
    sum^(k)_(i=1) lambda_i / (1-lambda_(k+1)) = 1
  $
  Como $C$ é convexo e ${x_i}^k_(i=1) subset C$, então temos que:
  $
    1/(1-lambda_(k+1)) sum^k_(i=1)lambda_i x_i in C
  $
  Isso é um teorema que vou enunciar posteriormente e demonstrar também. Como $x_(k+1) in C$, pela convexidade de $f$,
  $
    f(z) = f( (1-lambda_(k+1))v + lambda_(k+1)x_(k+1) ) <= (1-lambda_(k+1))f(v) + lambda_(k+1)f(x_(k+1))  \

    = (1-lambda_(k+1))f(sum^(k)_(i=1) lambda_i / (1-lambda_(k+1))x_i) + lambda_(k+1)f(x_(k+1))   \

    <= (1-lambda_(k+1))f(sum^(k)_(i=1) lambda_i / (1-lambda_(k+1))f(x_i)) + lambda_(k+1)f(x_(k+1))  \

    = sum_(i=1)^(k+1) f(x_i)
  $
]

#theorem[
  Seja $C subset RR^n$ convexo, dados quaisquer coleção ${x_i}_(i=1)^(k) subset C$ de pontos em $C$ e qualquer $lambda in Delta_k$, então:
  $
    sum_(i=1)^k lambda_i x_i in C
  $
]
#proof[
  Caso base: $k=2$ é trivial. Vamos supor que vale para um determinado $k$, então:
  $
    sum_(i=1)^k mu_i x_i in C
  $
  Para qualquer $mu in Delta_k$. Já que esse ponto está em $C$, vamos pegar um novo vetor $x_(k+1)$ ainda em $C$. Já que ambos os vetores estão em $C$ e ele é convexo, vale:
  $
    forall alpha in (0,1), space alpha sum_(i=1)^k mu_i x_i + (1-alpha)x_(k+1) in C
  $
  Porém, perceba que
  $
    alpha sum_(i=1)^k mu_i + (1 - alpha) = alpha + 1 - alpha = 1
  $
  Ou seja, se eu denotar $lambda in RR^(k+1)$ de tal forma que $lambda_i = alpha mu_i$ para $i in [k]$ e $lambda_(k+1) = 1 - alpha$ eu obtenho uma coleção de números tal que $lambda in Delta_k$ e uma coleção ${x_i}_(i=1)^(k+1)$ tal que:
  $
    sum_(i=1)^(k+1)lambda_i x_i in C
  $
]

=== Caracterização de convexidade de primeira ordem
Funções convexas podem ser não-diferenciáveis. Funções convexas diferenciáveis possuem uma caracterização importante: hiperplanos tangentes ao seu gráfico são sempre estimativas abaixo da função.

#theorem("Desigualdade do gradiente")[
  Seja $f:C subset RR^n -> RR$ com $C$ convexa e $f$ continuamente diferenciável, então:
  $
    f "convexa" <=> forall x,y in C, space f(x)+gradient f(x)^T (y-x) <= f(y)
  $
]<gradient-inequality>
#proof[
  $(==>)$ Suponha que f seja convexa. Sejam $x,y in C and lambda in [0,1]$. A desigualdade enunciada vale trivialmente se $x=y$. Iremos então assumir que $x != y$. Da convexidade de $f$,
  $
    f(lambda x + (1 - lambda)y) <= lambda f(x) + (1 - lambda)f(y)
  $
  
  implicando que
  
  $
    ( f(x + lambda (y - x)) - f(x) )/( lambda ) <= f(y) - f(x)
  $
  Tomando $lambda -> 0^+$, obtemos
  $
    f'(x; y - x) = lim_(lambda -> 0^+) ( f(x + lambda(y - x)) - f(x) ) / lambda <= f(y) - f(x)
  $

  Como f é continuamente diferenciável, $f'(x;y-x)=nabla f(x)^T (y-x)$ e a desigualdade segue.

  $(<==)$ Assuma que a desigualdade vale. Sejam $x,y in C$ e $lambda in (0,1)$. Defina $z=lambda x+(1-lambda)y$. Temos:
  $
    x - z = z - (1 - lambda)y - z = (1 - lambda)(lambda)(y - z)
  $
  À seguir, usaremos a desigualdade nos pares $(x, z)$ e $(y, z)$. Temos
  $
    f(z) + nabla f(z)^T (x - z) <= f(x)
  $
  $
    f(z) + nabla f(z)^T (y - z) <= f(y)
  $
  Multiplicando-se a primeira desigualdade por $(lambda)(1 - lambda)$ e usando a igualdade na segunda desigualdade, obtemos
  $
    lambda/(1 - lambda)f(z) + lambda/(1 - lambda) nabla f(z)^T (x - z) <= (lambda)/(1 - lambda)f(x)
  $
  $
    f(z) - lambda/(1 - lambda) nabla f(z)^T (x - z) <= f(y)
  $
  Somando-se as duas desigualdades acima obtemos
  $
  lambda/(1 - lambda)f(z) + f(z) <= lambda/(1 - lambda)f(x) + f(y)
  $
  Isto é
  $
    f(z) <= lambda f(x) + (1 - lambda) f(y)
  $
  Segue que $f$ é convexa
]

#theorem("Desigualdade do gradiente estrito")[
  Seja $f:C subset RR^n -> RR$ com $C$ convexa e $f$ continuamente diferenciável, então:
  $
    f "estritamente convexa" <=> forall x,y in C, space f(x)+gradient f(x)^T (y-x) < f(y)
  $
]
#proof[
  Anáogo ao @gradient-inequality
]

#figure(
  caption: [Função $f(x,y)=1.3x^2+1.27y^2$ e um plano tangente à curva],
  image("images/tangent-plane.png", width: 50%)
)

A gente pode usar os teoremas anteriores pra caracterizar as funções quadráticas e quando elas são convexas

#theorem("Convexidade da quadrática")[
  Seja $f: RR^n -> RR$ uma função quadrática:
  $
    f(x) = x^T A x + 2b^T x + c
  $
  Onde $A$ é simétrica. Então:
  $
    f "(estritamente) convexa" <=> A succ.eq 0 (A succ 0)
  $
]
#proof[
  A prova para o caso Pelo @gradient-inequality e sabendo que $nabla f(x) = 2(A x + b)$, temos que $f$ é convexa $<=>$
  $
    forall x, y in RR^n, y^T A y + 2b^T y + c >= x^T A x + 2 b^T x + c + 2(A x + b)^T (y - x)
  $
  Rearranjando, obtemos:
  $
    forall x, y in RR^n (y-x)^T A (y-x) >= 0 => A succ.eq 0
  $
]

#theorem("Monotonicidade do gradiente")[
  Seja $f: C subset RR^n -> RR$ continuamente diferenciável, então:
  $
    f "convexa em" C <=> forall x,y in C, space (gradient f(x) - gradient f(y))^T (x - y) >= 0
  $<gradient-monotonicity-equation>
]
#proof[
  $(==>)$ Assuma que $f$ é convexa sobre $C$. Por @gradient-inequality:
  $
    f(x) >= f(y) + gradient f(y)^T (x-y)    \
    f(y) >= f(x) + gradient f(x)^T (y-x)
  $
  Somando ambas as igualdades, obtemos @gradient-monotonicity-equation

  $(<==)$ Suponha que @gradient-monotonicity-equation seja válida e sejam $x, y in C$, vamos definir a função:
  $
    g(t) := f(x + t(y - x)), wide t in [0,1]
  $
  Pelo Teorema Fundamental do Cálculo:
  $
    f(y) = g(1) = g(0) + integral_0^1 g'(t) dif t   \
    
    = f(x) + integral_0^1 (y-x)^T gradient f(x- t(y-x)) dif   \

    = f(x) + (y - x)^T gradient f(x) + integral_0^1 (y-x)^T ( gradient f(x- t(y-x)) - gradient f(x) ) dif   \

    = f(x) + (y - x)^T gradient f(x) + 1/t integral_0^1 t (y-x)^T ( gradient f(x- t(y-x)) - gradient f(x) ) dif   \

    >= f(x) + (y-x)^T nabla f(x)
  $
  Onde utilizamos @gradient-monotonicity-equation na última desigualdade
]

=== Caracterizações de convexidade de segunda ordem
#theorem("Caracterização de convexidade de segunda ordem")[
  Seja $f: C subset RR^n -> RR$ duas vezes continuamente diferenciável sobre um conjunto convexo C, então:
  $
    f "convexa em" C <=> forall x in C, space nabla^2 f(x) succ.eq 0
  $
]
#proof[
  $(<==)$ Suponha que $nabla^2 f (x) succ.eq 0$ para todo $x ∈ C$. Sejam $x, y in C$. Pelo teorema de aproximação linear, existe $xi in [x, y] subset C$ tal que
  $
    f (y) = f (x) + nabla f (x)^T (y - x) + (y - x)^T nabla^2 f (xi)(y - x)
  $

  Como $nabla^2 f (xi) succ.eq 0$, segue que
  $
    f (y) = f (x) + nabla f (x)^T (y - x)
  $
  
  Como o argumento vale para todo $x, y in C$, provamos que $f$ e convexa em $C$ pelo @gradient-inequality.

  $(==>)$ Suponha que $f$ é convexa em $C$. Sejam $x in C$ e $d in RR^n$ com $||d|| = 1$. Sendo C aberto, existe $epsilon > 0$ tal que $x + lambda d ∈ C$ para todo $0 < lambda < epsilon$. Para tal $lambda$, segue do @gradient-inequality
  $
    f (x + lambda d) >= f (x) + lambda nabla f (x)^T d
  $

  Além disso, pelo teorema de aproximação quadrática:
  $
    f(x + lambda d) = f(x) + lambda nabla f(x)^T d + lambda^2/2 d^T nabla^2f(x)d + o(lambda^2 ||d||^2)
  $

  Combinando as expressões, obtemos, para todo $lambda in (0, epsilon)$
  $
    lambda^2/2 d^T nabla^2 f(x) d + o(lambda^2) >= 0
  $
  Isso é:
  $
    d^T nabla^2 f(x) d + o(lambda^2)/lambda^2 >= 0
  $
  Fazendo com que $lambda -> 0$, temos:
  $
    d^T nabla^2 f(x) d >= 0
  $
  Ou seja, $nabla^2 f(x) succ.eq 0, space forall x$
]

#theorem("Caracterização de convexidade de segunda ordem")[
  Seja $f: C subset RR^n -> RR$ duas vezes continuamente diferenciável sobre um conjunto convexo C, então:
  $
    forall x in C, space nabla^2 f(x) succ 0 => f "estritamente convexa em" C
  $
]

A volta na questão anterior não vale, por exemplo, $f(x) = x^4$ tem mínimo em $0$, mas $f''(0)=0$

=== Convexidade forte
Vimos o conceito de convexidade aplicando a condição de pontos numa reta estarem acima da curva da função. Mas e se uma forma mais curvada ainda tivesse em cima da função?

#definition("Convexidade forte")[
  Uma função $f: C subset RR^n -> RR$ com $C$ convexo é $mu$-fortemente convexa ($mu$ > 0) se:
  $
    forall x,y in C and forall lambda in [0,1],   \
    f(lambda x + (1-lambda)y) + mu/2 lambda (1-lambda) ||y-x||^2 <= lambda f(x) + (1-lambda) f(y)
  $
]

Mas o que diabos isso significa? A gente agora, em vez de checar se os pontos na reta $t(x,f(x)) + (1-t)(y,f(y)) space (t in [0,1])$, imagine que tem uma cordinha entre esses dois pontos, a gravidade vai afetar ela e ela vai ficar curvada, e $mu$ dita o quão curvada a cordinha está. Se os pontos nessa cordinha estão acima da curva para todos os pontos na curva, então a função é $mu$-fortemente convexa

#grid(
  columns: (50%, 50%), // Cria duas colunas, uma com 30% da largura para a imagem e outra com 70% para o texto
  column-gutter: 1em, // Adiciona um espaço (gutter) de 1em entre as colunas

  // Coluna 1: Imagem
  figure(
    caption: [Função não-fortemente convexa, mas convexa $f(x)= ||x||$],
    image("images/not-strongly-convex.png", width: 100%)
  ),

  figure(
    caption: [Função fortemente convexa $f(x)= ||x||^2$],
    image("images/strongly-convex.png", width: 100%)
  ),
)

#theorem("Desigualdade do gradiente: fortemente convexa")[
  Seja $f: C subset RR^n -> RR$ continuamente diferenciável e $C$ convexo. Temos:
  $
    f space mu"-fortemente convexa" <=> forall x,y in C, space f(x) + nabla f(x)^T (y-x) + mu/2 ||y-x||^2 <= f(y)
  $
]

#theorem("Caracterização de convexidade forte de segunda ordem")[
  Seja $f: C subset RR^n -> RR$ duas vezes continuamente diferenciável e $C$ convexo. Então:
  $
    f space mu"-fortemente convexa" <=> nabla^2 f(x) - mu I succ 0
  $
]

== Otimização sobre conjuntos convexos
Com toda essa bagagem, conseguimos finalmente aplicar a otimização de $f$ em uma restrição convexa $C$
$
  min_(x in C)f(x)
$

=== Condição de primeira ordem: Caso geral
Vamos primeiramente ver uma condição sobre funções generalizadas. Algo que faz sentido pensar quando estamos sendo restringidos, é pensar que não necessariamente meu máximo ou mínimo vai ter derivada igual a 0, veja o exemplo:

#figure(
  caption: [Exemplo de restrição: $f(x)=x^2$ com $x in [2,3]$],
  image("images/restriction-example.png", width: 20%)
)

#theorem("Condição de primeira ordem: Caso restrito")[
  Seja $f: C subset RR^n -> RR$ continuamente diferenciável em $C$ convexo e fechado, então:
  $
    x^* in C "mínimo local" => forall x in C, space nabla f(x^*)^T (x - x^*) >= 0
  $
]<first-order-condition-convex-set>
#proof[
  Precisamos do seguinte lema:
  Seja $f : U -> RR$ função continuamente diferenciável sobre um aberto $U subset RR^n$. Se para algum $x in U$ e $d != 0$ tem-se
  $
    nabla f (x)^T d < 0
  $
  então existe $epsilon > 0$ tal que para todo $t in (0, epsilon)$, $x + t d in U$ e
  $
    f (x + t d) < f(x)
  $

  Continuemos a demonstração do teorema original. Assuma por contradição que exista $x in C$ tal que $nabla f (x^*)^T (x - x^* ) < 0$. Temos então que, para $d := x - x^* , f'(x^* ; d) = nabla f (x^*)^T (x - x^* ) < 0$. Segue do lema anterior, que existe $epsilon ∈ (0, 1)$ tal que
  $
    forall t ∈ (0, epsilon), f (x^* + t d) < f (x^*)
  $
  Sendo $C$ convexo, segue que $x^* + t d = (1 - t)x^* + t x in C$. Concluímos então que $x^*$ não é um ponto de mínimo local de $f$ em $C$ — uma contradição.
]

Mas o que esse teorema quer dizer??? Vamos por partes. Lembra do cosseno entre dois vetores $v$ e $u$?
$
  cos(theta) = (u^T v)/(||u|| ||v||)
$

Ou seja, quando o sinal do ângulo entre eles depende única e exclusivamente de $u^T v$. Lembre que, se $theta in [-pi/2, pi/2]$ então $cos(theta) >= 0$ e se $theta in [pi/2, (3pi)/2]$ então $cos(theta) <= 0$. Mas o que isso quer dizer? Espera mais um pouco. Lembra que vimos em cálculo 2 que o vetor gradiente indica a direção no domínio que eu devo seguir para que *a função aumente*? Show, agora a gente pode entender o que o teorema quer dizer para nós. 

Vamos considerar o caso mais básico, quando $x^*$ não ta na fronteira de $C$

#figure(
  caption: [Ponto mínimo $x^* in C$],
  image("images/minimal-on-convex-exemplification.png", width: 40%)
)

Na imagem temos o vetor gradiente e o vetor $x - x^*$. Quando variamos o nosso ponto $x$, podemos claramente perceber que o vetor $x - x^*$ faz vários ângulos com o gradiente, só que se o gradiente for desça forma, ao andarmos na direção oposta ao gradiente, nossa função vai diminuir, ou seja, $x^*$ não pode ser um ponto de mínimo! O que isso quer dizer? Que meu gradiente é 0!

Mas e se $x^*$ estiver na minha fronteira?

#grid(
  columns: (50%, 50%), // Cria duas colunas, uma com 30% da largura para a imagem e outra com 70% para o texto
  column-gutter: 1em, // Adiciona um espaço (gutter) de 1em entre as colunas

  // Coluna 1: Imagem
  figure(
    caption: [$x^*$ mínimo na fronteira],
    image("images/min-point-in-border-example.png", width: 100%)
  ),
  figure(
    caption: [Função não-convexa $f(x)=x^4 - 3x^2$],
    image("images/not-minimal-on-border.png", width: 100%)
  )
)

Perceba que na primeira figura, se eu vejo o ângulo do gradiente com qualquer outro ponto no meu conjunto eu tenho menos que 90 graus, ou seja, o meu gradiente aponta para *dentro do conjunt*, de forma que a única maneira de diminuir mais a função é *saindo da restrição*. Na outra figura isso é melhor ilustrado. Veja que existem vetores no conjunto que fazem mais que 90 graus com o vetor gradiente, ou seja, o vetor gradiente ta para fora do conjunto $C$, de forma que eu consigo andar na direção $-nabla^2 f(x^*)$ para que diminua ainda mais a função, ou seja, $x^*$ não seria um mínimo

Esse teorema nos da motivação para uma definição

#definition("Ponto estacionário")[
  Seja $f: C subset RR^n -> RR$ com $C$ convexo e fechado, chamamos $x^* in C$ de ponto estacionário quando
  $
    forall x in C, space nabla f(x^*)(x - x^*) >= 0
  $
]

=== Condições de primeira ordem: Caso convexo

#theorem[
  Seja $f: C subset RR^n -> RR$ continuamente diferenciável e convexa com $C$ convexo e fechado e $x^* in C$, então:
  $
    x^* "mínimo global" <=> x^* "é ponto estacionário"
  $
]
#proof[
  Precisamos provar apenas $(<==)$ do @first-order-condition-convex-set. Seja $x^* in C$ um ponto estacionário de $f$ em $C$. Obtemos que, para todo $x in C$,
  $
    f (x) >= f (x^*) + nabla f (x^*)^T (x - x^*) >= f (x^*)
  $
  onde a primeira desigualdade segue da desigualdade do gradiente (@gradient-inequality) e a segunda desigualdade segue de que $x^*$ é ponto estacionário. Sendo que
  $
    forall x in C, space f (x) >= f (x^*)
  $
  segue que $x^* ∈ C$ é ponto de mínimo global de $f$ em $C$.
]


#pagebreak()

#align(center + horizon)[
  = Otimização com restrições lineares
]

#pagebreak()

Aqui nós vamos introduzir um teorema muito importamte no ramo da otimização, o *teorema das condições KKT*. Esse teorema generaliza as condições *necessárias* para um problema de minimização *genérico*, porém, vamos começar por baixo, em vez de ja ir para o caso geral, vamos começar a passos pequenos

Primeiramente, queremos minimizar problemas do tipo:
$
  min_x f(x) \
  x "sujeito a restrições do tipo" a_i^T x <= b_i, space i = 1,...,m
$<optimization-with-linear-conditions>

onde $f$ é continuamente diferenciável em $RR^n, space {a_i}_(i=1)^m subset RR^n, {b_i}_(i=1)^m subset RR$. Ou seja, o conjunto viável $C$ é o poliédro:
$
  C = inter_(i=1)^m { x in RR^n \/ a_i^T x <= b_i }
$

Há um exemplo nas anotaçẽos sobre convexidade do Phillip que mostram que $C$ é convexo.

== Condições KKT

#theorem("Condições KKT para restrições lineares: condições necessárias de otimalidade")[
  Considere o problema de minimização @optimization-with-linear-conditions onde $f$ é uma função continuamente diferenciável em $RR^n$, ${a_i}^m_(i=1) subset RR$ e ${b_i}_(i=1)^m subset R$. Então, *se* $x^*$ é um ponto de *mínimo local* do problema, $exists lambda_1 , . . . , lambda_m >= 0$ tais que
  $
    nabla f (x^*) + sum_(i=1)^m lambda_i a_i = 0, \
    
    lambda_i (a_i^T x^* - b_i) = 0, wide i = 1,...,m  \
    a_i^T x^* - b_i <= 0, wide i = 1,...,m
  $
]<kkt-linear-conditions>

Como esse teorema necessita de vários outros resultados, não vou escrever a sua demonstração aqui. Se estiver curioso para saber a demonstração, confira o apêndice das anotações do Phillip

== Condições KKT: Problema convexo
#theorem("Condições KKT para restrições lineares: condições necessárias de otimalidade com função convexa")[
  Considere o problema de minimização
  $
    min_x f (x)   \
    "sujeito à" a_i^T x <= b_i , i = 1, ... , m
  $
  onde $f$ é uma função continuamente diferenciável *convexa* em $RR^n$ ${a_i}^m_(i=1) subset RR and {b_i}_(i=1)^m subset R$. Então, se $x^*$ é um ponto de mínimo local do problema $<=> exists lambda_1 , . . . , lambda_m >= 0$ tais que
  $
    nabla f (x^*) + sum_(i=1)^m lambda_i a_i = 0, \
    
    lambda_i (a_i^T x^* - b_i) = 0, wide i = 1,...,m  \
    a_i^T x^* - b_i <= 0, wide i = 1,...,m
  $
]<kkt-convex-conditions>
#proof[
  $(==>)$ Segue do @kkt-linear-conditions

  $(<==)$ Definamos a função:
  $
    h(x) := f(x) + sum_(i=1)^m lambda_i (a_i^T x - b_i)
  $
  Temos que:
  $
    nabla h(x^*) = nabla f(x^*) + sum^m_(i=1) lambda_i a_i
  $
  Como $h$ é convexa (Soma de funções convexas), segue que $x^*$ é ponto mínimo de $h$ em $RR^n$. Em particular, dado qualquer $x in RR^n$ tal que:
  $
    a_i^T x <= b_i, space i=1,...,m
  $
  Tem-se que:
  $
    f(x^*) = f(x^*) + sum_(i=1)^m lambda_i (a_i^T x - b_i)    \

    <= f(x^*) + sum_(i=1)^m lambda_i (a_i^T x - b_i)    \

    <= f(x)
  $
  Na primeira equação utilizamos a segunda condição e na segunda desigualdade usamos o fato que $lambda_i >= 0$. Concluímos então que $x^*$ é solução do sistema
]

== Condições KKT com restrições lineares de igualdade
Show! Vimos as restrições afins de *desigualdade*, porém, em alguns casos, é possível que tenhamos restrições de igualdade:
$
  min_x f(x) \

  x "sujeito a restrições do tipo":   \
  
  a_i^T x <= b_i, space i = 1,...,m   \
  c_j^T x = d_j, space j = 1,...,p
$<optimization-with-linear-equality-conditions>

onde $f$ é continuamente diferenciável em $RR^n, space {a_i}_(i=1)^m subset RR^n, {b_i}_(i=1)^m subset RR, {c_j}_(j=1)^p subset RR^n$

Esse caso é o que costumamos aprender em cálculo dois como o *método de Lagrange*, porém vamos ver que esse método é *bem* mais geral do que viamos antes. Do problema que estabelecemos antes, segue um teorema bem parecido com @kkt-linear-conditions

#theorem[
  Considere o problema @optimization-with-linear-equality-conditions, onde $f$ é continuamente diferenciável em $RR^n, space {a_i}_(i=1)^m subset RR^n, {b_i}_(i=1)^m subset RR, {c_j}_(j=1)^p subset RR^n$. Então:

  a) Se $x^*$ é um ponto de mínimo local do problema, então existem $lambda_1,...,lambda_m >= 0$ e $mu_1,...,mu_p in RR$ tais que
  $
    gradient f(x^*) + sum^m_(i=1) lambda_i a_i + sum^p_(j=1) mu_j c_j = 0   \
    
    lambda_i (a_i^T x^* - b_i) = 0, space i = 1,...,m   \

    a_i^T x^* - b_i <= 0, space i = 1,...,m   \

    mu_j (c_j^T x^* - d_j) = 0, space j=1,...,p
  $<kkt-with-linear-equalities-conditions>

  b) Suponha adicionalmente que $f$ é convexa, então $x^*$ é um mínimo global do problema $<=>$ existem $lambda_1,...,lambda_m >= 0$ e $mu_1,...,mu_p in RR$ tais que as condições @kkt-with-linear-equalities-conditions ainda valem
]
#proof[
  Primeiro demonstraremos o (a). Demonstrar essa parte é equivalente a resolver o problema:
  $
    min_x f(x) \

    x "sujeito a restrições do tipo" a_i^T x <= b_i, space i = 1,...,m   \
    space c_j^T x <= d_j and -c_j^T x <= -d_j, space j = 1,...,p
  $
  onde $f$ é continuamente diferenciável em $RR^n, space {a_i}_(i=1)^m subset RR^n, {b_i}_(i=1)^m subset RR, {c_j}_(j=1)^p subset RR^n$

  Sendo $x^*$ uma solução do problema descrito anteriormente, pelo @kkt-linear-conditions, temos:
  $
    nabla f(x^*) + sum^m_(i=1) lambda_i a_i + sum_(j=1)^p mu^+_j c_j - sum_(j=1)^p mu^-_j c_j = 0   \

    lambda_i (a_i^T x^* - b_i) = 0    \
    mu^+_j (c_j^T x^* - d_j) = 0    \
    mu^-_j (-c_j^T x^* + d_j) = 0
  $<kkt-equality-gradient-equivalent>

  Como $x^*$ é viável, então as segundas e terceiras condições mencionadas na reformulação anterior são satisfeitas. Definindo então $mu_j = mu^+_j - mu^-_j$, então temos que $ sum^p_(j=1) mu^+_j c_j - sum^p_(j=1) mu^-_j c_j = sum^p_(j=1) mu_j c_j$. Então segue que as condições estabelecidas originalmente no teorema são satisfeitas

  Para a demonstração de (b), Suponha que $x^*$ viável e existem $lambda_1 , ... , lambda_m >= 0$ e $mu_1 , ... , mu_p in RR$ tais que as condições do teorema sejam satisfeitas. Defina
  $
    mu^+_j := (mu_j)_+ = max{mu_j , 0}, wide mu^-_j := (mu_j)_- = max{-μ_j , 0}
  $
  Como $mu_j = mu_j^+ - mu_j^-$ e $c_j^T x^* - d_j = 0$ para $j in [p]$, segue em particular que @kkt-equality-gradient-equivalent é satisfeito. Sendo $f$ convexa, segue do @kkt-convex-conditions que $x^*$ é solução do problema reformulado e, em particular, do problema original do teorema
]

#pagebreak()

#align(center+horizon)[
  = Otimização com restrições genéricas
]

#pagebreak()

Vimos minimizações para condições lineares e convexas, mas nem sempre isso acontece, muitas vezes temos conjuntos de restrições completamente genéricas. Nesse capítulo vamos ver como as condições KKT podem ser generalizadas para esses tipos de problemas (Vão perceber que elas ainda se aplicam ao que foi estabelecido anteriormente nas condições lineares). Vamos, então, redefinir o problema que tinhamos anteriormente:
$
  min_(x) f(x)    \

  g_i (x) <= 0, space forall i = 1,...,m    \
  h_j (x) = 0, space forall j = 1,...,p
$<optimization-with-generic-restrictions>

== Lagrangeano
O lagrangeando é uma função que será de grande importância, ela pode parecer meio confusa (Pois ela é), mas, a partir de agora, ela será nossa definição de "Derivar e igualar a $0$". Como assim? Sempre que queríamos minimizar/maximizar uma função, derivávamos e igualávamos a $0$, só que vimos que, com restrições, isso não funciona mais, porém, essa função ainda se aplica (Com algumas ressalvas) no lagrangeano (Como veremos)

#definition("Lagrangeano")[
  O *Lagrangeano* associado à função $f$ é a função $L: RR^n times RR^m times RR^p -> RR$ tal que:
  $
    L(x, lambda, mu) = f(x) + lambda^T g(x) + mu^T h(x)
  $
  Onde:
  $
    lambda = mat(lambda_1;dots.v;lambda_m), space mu = mat(mu_1;dots.v;mu_p), space g(x) = mat(g_1 (x);dots.v; g_m (x)), space h(x) = mat(h_1 (x);dots.v;h_p (x))
  $
]<lagrange-function>

#theorem("Gradiente Lagrangeano")[
  Dado o Lagrangeano de uma função $f$, temos que o gradiente do lagrangeano *somente em relação a $x$* se da por:
  $
    nabla_x L(x, lambda, mu) = nabla f(x) + sum_(i=1)^m lambda_i nabla g(x) + sum^p_(j=1) mu_j nabla h(x)
  $
]

== As generalizações do KKT
Agora queremos generalizar totalmente o KKT, então vamos aos poucos. Lembre que, até que falemos o contrário, estamos considerando o problema @optimization-with-generic-restrictions

Antes de entrarmos diretamente no teorema KKT generalizado, vamos agora fazer uma definição que tem uma razão matemática, mas acaba por nos ajudar em alguns casos. Essa definição evita condições redundantes no nosso problema, ja que elas podem acabar nos atrapalhando. Faremos um exemplo para mostrar essa ajuda

#definition("Condições de qualificação de independência linear")[
  Sejam $g_1,...,g_m: RR^n -> RR$ e $h_1,...,h_p: RR^n -> RR$ continuamente diferenciáveis e $x^* in RR^n$, defina:
  $
    I(x^*) := {i in [m]: g_i (x^*) = 0}
  $
  Dizemos que LICQ (Linear Independent Condition Qualification) é satisfeita em $x^*$ para as funções $g_1,...,g_m$ e $h_1,...,h_p$ se
  $
    { nabla g_i (x^*) : i in I(x^*) } union { nabla h_j (x^*) : j in [p] } "é linearmente independente"
  $
]<licq>

Definição feita, vamos enunciar o novo teorema KKT

#theorem("KKT")[
  Se $x^*$ é um ponto de mínimo local de $f(x)$ no problema @optimization-with-generic-restrictions e a @licq é satisfeita em $x^*$, isso implica que:
  $
    exists lambda_1,...,lambda_m >= 0, space exists mu_1,...,mu_p in RR   \
    
    nabla f(x^*) + sum^m_(i=1)lambda_i nabla g_i (x^*) + sum^p_(j=1)mu_j nabla h_j (x^*) =0   \
    
    lambda_i g_i (x^*) = 0 wide i in [m]    \

    g_i (x^*) <= 0 wide i in [m]    \

    h_j (x^*) = 0 wide j in [p]
  $
]<generic-kkt>

#example("Utilidade da LICQ")[
  aaaaaaaaaaa preencher aqui aaaaaaaaaaaaa
]

Agora que vimos esses teoremas e condições, vamos fazer uma definição para facilitar em algumas terminologias:

#definition("Ponto KKT")[
  Considere o problema @optimization-with-generic-restrictions, onde $f$, $g_1$, ..., $g_m$, $h_1$, ..., $h_p$ são continuamente diferenciáveis no $RR^n$. Um ponto $x^*$ viável, ou seja, que satisfaz as condições do cojunto viável, é chamado de *ponto KKT* quando $exists lambda_1,...,lambda_m >= 0$ e $exists mu_1,...,mu_p in RR$ tais que:
  $
    nabla f(x^*) + sum^m_(i=1) lambda_i nabla g_i (x^*) + sum^p_(j=1) mu_j nabla h_j (x^*) &= 0   \

    lambda_i g_i(x^*) &= 0 wide i in [m]
  $
]

Isso facilita um pouco a terminologia pois podemos resumir o @generic-kkt em dizer que um ponto de LICQ não pode ser um ponto de mínimo se ele não for KKT

== Caso Convexo
Claro, não poderíamos de falar do caso convexo aqui, sempre tem algo de especial nele, vamos então enunciar novamente o nosso problema mudando ele um pouco
$
  min_(x) f(x)    \

  g_i (x) <= 0, space forall i = 1,...,m    \
  h_j (x) = 0, space forall j = 1,...,p   \

  "onde" f, space g_i " e " h_j "são convexas" forall i " e " forall j
$<optimization-with-generic-convex-restrictions>

Vale ressaltar também que $h_j$ são convexas

#theorem("KKT Convexo")[
  Se $x^*$ é um ponto de mínimo local de $f$ dado o problema @optimization-with-generic-convex-restrictions e a @licq é satisfeita em $x^*$, então $x^*$ é uma solução do problema se, e somente se:
  $
    exists lambda_1,...,lambda_m >= 0, space exists mu_1,...,mu_p in RR   \
    
    nabla f(x^*) + sum^m_(i=1)lambda_i nabla g_i (x^*) + sum^p_(j=1)mu_j nabla h_j (x^*) =0   \
    
    lambda_i g_i (x^*) = 0 wide i in [m]    \

    g_i (x^*) <= 0 wide i in [m]    \

    h_j (x^*) = 0 wide j in [p]
  $
]

#definition("Condição de Slater")[
  Dizemos que a condição de Slater é satisfeita para as funções $g_1,...,g_m$ (convexas) se
  $
    exists accent(x, \^) in RR^n space \/ space g_i (accent(x, \^)) < 0, space forall i in [m]
  $
]<slater-condition>

#theorem("KKT e Slater")[
  Se $x^*$ é mínimo local de $f(x)$ (Nas restrições $g_i (x) <= 0$ e $h_j (x) = 0$ sendo funções continuamente diferenciáveis e convexas) e $x^*$ satisfaz @slater-condition, então $x^*$ é ponto KKT (A volta não vale)
]<kkt-and-slater>

Porém, não faz sentido falarmos de funções convexas de igualdade ($h_j (x) = 0$), isso nos permite reescrever o problema de uma forma interessante:
$
  min_(x) f(x)    \
  g_i (x) <= 0 wide i in [m]   \
  h_j (x) = 0 wide j in [p]   \
  s_k (x) = 0 wide k in [q]    \

  "Onde" f, space g_i "são convexas e" h_j, space s_k "são afins"
$

Então podemos adaptar a condição de slater:

#theorem("Condição de Slater")[
  Dizemos que a condição de Slater é satisfeita para as funções $g_1,...,g_m$ (convexas) e $h_1,...,h_p$ e $s_1,...,s_q$ (afins) quando:
  $
    exists accent(x, \^) in RR^n "tal que"    \

    g_i (accent(x,\^)) < 0, space forall i in [m]    \
    h_j (accent(x,\^)) <= 0, space forall j in [p]   \
    s_k (accent(x,\^)) = 0, space forall k in [q]
  $
]

De forma que o @kkt-and-slater continua valendo
