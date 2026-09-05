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
    Aprendizado Profundo
  ]
  
  #text(14pt)[
    Revisão para A1
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
  = Segmentação Semântica 
]

#pagebreak()

== Introdução

A segmentação semântica é uma tarefa de visão computacional que consiste em classificar cada pixel de uma imagem em uma categoria específica. Essa tarefa é fundamental para diversas aplicações, como direção autônoma, análise médica e realidade aumentada.

#figure(
  image("images/computer-vision-areas.png", width: 100%),
  caption: "Áreas de visão computacional"
)

Dentro do contexto de segmentação, vale diferenciar entre segmentação semântica e segmentação de instâncias. A segmentação semântica atribui uma classe a cada pixel, enquanto a segmentação de instâncias não apenas classifica os pixels, mas também distingue entre diferentes objetos da mesma classe.

#figure(
  image("images/instance-vs-semantic.png", width: 100%),
  caption: "Diferença entre segmentação semântica e segmentação de instâncias"
)

== Métricas
Podemos utilizar algumas métricas para avaliar a performance de um modelo de segmentação semântica. As métricas mais comuns incluem:

#definition("Intersection over Union (IoU)")[
  $
    "IoU" = "TP" / ("TP" + "FP" + "FN")
  $
]

#definition("Precision")[
  $
    "Precision" = "TP" / ("TP" + "FP")
  $
]

#definition("Average Precision")[
  Dado que na minha imagem eu tenho mapeado $K$ classes, a métrica de Average Precision (AP) é definida como a média das precisões de cada classe:
  $
    "AP" = (1/K) * sum_(k=1)^(K) "Precision"_k
  $
]

== Abordagens progressivas
Vamos relembrar como é estruturada uma rede convolucional padrão para classificação de uma imagem.

#figure(
  image("images/conv-network.png", width: 100%),
  caption: "Estrutura de uma rede convolucional padrão"
)

A imagem passa por uma série de canais de convolução, pooling e normalização, que extraem características relevantes. No final, temos uma camada totalmente conectada que produz a classificação final. Isso nos faz pensar em uma ideia, que tal termos uma janela que percorre a imagem e classifica cada pixel individualmente? Essa abordagem é conhecida como "sliding window" e é uma das primeiras tentativas de segmentação semântica.

#figure(
  image("images/sliding-window.png", width: 100%),
  caption: "Abordagem de sliding window"
)

No entanto, essa abordagem é computacionalmente cara e não aproveita o contexto global da imagem. Para superar essas limitações, surgiram as Fully Convolutional Networks (FCNs), que substituem as camadas totalmente conectadas por camadas convolucionais, permitindo que a rede produza mapas de segmentação diretamente.

#figure(
  image("images/fcn.png", width: 100%),
  caption: "Estrutura de uma Fully Convolutional Network (FCN)"
)

Essa abordagem é interessante, já que permite que a rede aprenda a segmentar a imagem de forma mais eficiente, utilizando o contexto global e local. Além disso, as FCNs podem ser treinadas de forma end-to-end, o que simplifica o processo de treinamento. No entanto , as FCNs são MUITO pesadas, e por isso surgiu a ideia do *downsampling* e *upsampling* dentro da rede, onde basicamente diminuimos os tamanhos das features internas e depois vamos reconstruindo até o tamanho original da imagem. Essa abordagem é conhecida como *encoder-decoder*.

#figure(
  image("images/encoder-decoder.png", width: 100%),
  caption: "Estrutura de uma rede encoder-decoder"
)

== Upsampling
Antes de realmente mostrar as arquiteturas de redes encoder-decoder, vamos definir *bem* algumas técnicas de upsampling, assim não precisaremos interromper o raciocínio no meio do caminho

=== Max Unpooling
Relembrando o que é o *pooling*, ele é uma operação que reduz a dimensionalidade das features internas da rede, geralmente utilizando operações como *max pooling* ou *average pooling*. O *unpooling* é o processo inverso, onde tentamos reconstruir a dimensão original das features a partir das features reduzidas. No entanto, o *unpooling* não é uma operação trivial, pois não temos informações suficientes para reconstruir a dimensão original de forma precisa.

O que acontece é que, *antes* de fazer o *pooling*, nós guardamos os índices dos valores máximos (no caso do *max pooling*), e depois utilizamos esses índices para reconstruir a dimensão original durante o *unpooling*. Essa abordagem é conhecida como *max unpooling*.

#figure(
  image("images/max-unpooling.png", width: 100%),
  caption: "Exemplo de max unpooling"
)

=== Transpose Convolution
A desvantagem do *max unpooling* é que ele depende dos índices dos valores máximos, o que pode limitar a capacidade da rede de aprender representações mais complexas. Uma alternativa é utilizar a *transpose convolution*, também conhecida como *deconvolution*. Essa operação é semelhante à convolução, mas ao invés de reduzir a dimensionalidade das features, ela aumenta.

#figure(
  image("images/transpose-convolution.png", width: 80%),
  caption: "Exemplo de transpose convolution"
)

Como vimos na disciplina de *machine learning*, podemos obter uma matriz de filtro chamada $K_"col"$ a partir da operação _im2col_, que transforma a imagem em uma matriz de colunas. A *transpose convolution* é basicamente a operação inversa, onde aplicamos a matriz de filtro $K_"col"$ na matriz obtida anteriormente

Se $X$ é a entrada da convolução e $K$ é o filtro tal que
$
  Y = X * K
$

Já sabemos que
$
  Y = K_"col" X_"col"
$

temos então que a transpose convolution é definida como
$
  X_"col" = K_"col"^T Y
$

de tal forma que os $X_"col"$ são reconstruídos a partir dos $Y$ e do filtro $K_"col"$ (não de forma perfeita pois há perca de informação na compressão do $X$ para o $Y$, mas o objetivo é que a rede aprenda a reconstruir o $X$ da melhor forma possível)

== Contexto Global e Atrous Convolution
Antes de irmos de fato para as arquiteturas, temos que definir um conceito usado em algumas delas, se não vamos interromper o raciocínio no meio do caminho. O conceito é o de *contexto global*, que basicamente é a ideia de que, para classificar um pixel, precisamos levar em consideração não apenas os pixels vizinhos, mas também os pixels mais distantes da imagem. Só que usar filtros maiores consome mais memória, tempo de processamento e não permite que a rede aprenda a extrair características mais complexas. Para resolver esse problema, surgiu a ideia de *atrous convolution*, que é uma técnica que permite aumentar o tamanho do filtro sem aumentar o número de parâmetros da rede. A ideia é inserir "buracos" (ou *holes*) entre os pixels do filtro, permitindo que ele "veja" mais pixels da imagem sem aumentar o número de parâmetros.

#definition("Atrous Convolution")[
  Dado um filtro $K$ de tamanho $k x k$, e uma feature map $X$, a *atrous convolution* é definida como
  $
    Y(i, j) = sum_(m=0)^(k-1) sum_(n=0)^(k-1) X(i + r * m, j + r * n) K(m, n)
  $
  onde $r$ é o *rate* de atrous convolution, que determina o espaçamento entre os pixels do filtro.
]

#figure(
  image("images/atrous-convolution.png", width: 70%),
  caption: "Exemplo de atrous convolution"
)


== Arquiteturas
=== SegNet
A SegNet é uma arquitetura de rede neural convolucional projetada para segmentação semântica. Ela segue a arquitetura padrão que já demonstramos utilizando do método de max unpooling para realizar upscaling

#figure(
  image("images/segnet.png", width: 100%),
  caption: "Arquitetura da SegNet"
)

=== U-Net
Já na U-Net, a arquitetura é um pouco diferente, ela utiliza *skip connections* para conectar as camadas de downsampling com as camadas de upsampling, permitindo que a rede utilize informações de diferentes níveis de abstração para melhorar a segmentação.

#figure(
  image("images/unet.png", width: 100%),
  caption: "Arquitetura da U-Net"
)

Nas camadas de upsampling, a U-Net utiliza *transpose convolution* para aumentar a dimensionalidade das features unida com um *aumento* nos canais das features. Após o transpose convolution, a U-Net concatena as features da camada correspondente de downsampling, permitindo que a rede utilize informações de diferentes níveis de abstração para melhorar a segmentação, como se ela falasse: "depois de reconstruir a imagem, eu obtive o seguinte mapa de feature, mas lá atrás antes de eu ter feito o downsampling, eu tinha obtido o seguinte mapa de feature, então vou juntar os dois para melhorar a segmentação" (por exemplo, se eu tenho uma imagem 32x32 na escala de cinza, com apenas um canal de cor, na hora do último upsampling, a camada logo após a transpose convolution terá 2 canais "de cor", que seria o mapa obtido pela rede anteriormente e o mapa obtido na camada de upsampling).

