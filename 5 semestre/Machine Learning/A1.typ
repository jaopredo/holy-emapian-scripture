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
    Revisão para A1
  ]
]

#align(bottom + center)[
  Rio de Janeiro

  2026
]

#pagebreak()

#block(
  width: 100%,
  fill: rgb(255, 148, 162),
  inset: 1em,
  stroke: 1.5pt + rgb(117, 6, 21),
  radius: 5pt
)[
  *Nota*: Esse resumo é uma adaptação das notas da disciplina disponibilizadas pelo veterano Eduardo Adame junto de adições feitas por João Pedro Jerônimo, para acessar as notas originais, acesse #link("https://drive.google.com/drive/folders/1Rg2rzPukCe4-IDpu6agLrJ-e1S7EwWQA?usp=share_link", "aqui"). Eu também estou fazendo um repositório contendo modelos de machine learning que estão sendo estudados nessa disciplina, para acessar o repositório, clique #link("https://github.com/jaopredo/machine-learning", "aqui")
]

// ============================ PÁGINAS POSTERIORES =========================
#outline(title: "Conteúdo")

#pagebreak()

#align(center + horizon)[
  = Método dos Vizinhos mais próximos (k-NN)  
]

#pagebreak()

== Introdução Intuitiva
O método dos vizinhos mais próximos (k-NN) é um algoritmo de aprendizado de máquina simples e eficaz usado para classificação e regressão. Ele funciona com base na ideia de que objetos semelhantes estão próximos uns dos outros no espaço de características. Para classificar um novo ponto, o k-NN identifica os k pontos mais próximos no conjunto de treinamento e atribui a classe mais comum entre esses vizinhos ao novo ponto.

O valor de k é um hiperparâmetro que pode ser ajustado para melhorar o desempenho do modelo. O k-NN é fácil de entender e implementar, mas pode ser computacionalmente caro para grandes conjuntos de dados, pois requer o cálculo das distâncias entre o novo ponto e todos os pontos do conjunto de treinamento.

Um das hipóteses fundamentais em ML é que existe algum nível de suavidade no mapeamento entre o espaço de entrada $cal(X)$ e o de saída $cal(Y)$. Em outras palavras, se dois elementos $x, x' in cal(X)$ são semelhantes, então eles devem ter saídas $y, y' in cal(Y)$ similares. O método dos k vizinhos mais próximos (k nearest neighbors, k-NN), proposto por Cover e Hart (1967), aplica diretamente esse conceito.

Nesse capítulo, vamos estudar como k-NN pode ser usados para problemas de classificação e regressão. Discutiremos o impacto do k e também da escolha de distância (ou métrica) para o espaço $cal(X)$, que é primordial para a aplicação do método. Finalmente, estudaremos o comportamento do método k-NN quando a dimensionalidade do espaço $cal(X)$ é alta

== Classificação
Seja $cal(D) := {(x_1, y_1), ..., (x_N, y_N)} subset cal(X) times cal(Y)$ o conjunto de treinamento e $d: cal(D) times cal(D) -> RR^+ union {0}$ uma função de *distância*. Vamos supor que queremos classificar um vetor $x in cal(X)$ arbitrário. 

O método k-NN classifica o vetor $x$ atribuindo a ele a classe mais comum entre os rótulos dos pontos em $cal(V)_k (x)$, ou seja:
$
  h(x) := "argmax"_{y in cal(Y)} sum_{(x_i, y_i) in cal(V)_k (x)} II_{y_i = y}
$
(De forma simplificada, o rótulo mais comum dentro do conjunto de vizinhos é o rótulo atribuído ao ponto $x$)

#figure(
  image("images/knn-classification.png", width: 60%),
  caption: [Exemplo de classificação usando o método k-NN. O ponto $x$ é o ponto a ser classificado, os pontos azuis e vermelhos são os pontos do conjunto de treinamento, e as linhas tracejadas indicam as fronteiras de decisão do modelo. Aqui, se $k=5$, ele vai classificar como *Classe 1* (vermelho)]
)

== Regressão
O k-NN pode também ser empregado em problemas de regressão. Para isso, precisamos de
uma forma de combinar as saídas em $cal(V)_k(·)$. Uma das estratégias mais comuns consiste em
computar a média ponderada pelo inverso da distância:
$
  h(x) := 1/Z sum_((x', y') in cal(V)_k (x)) y' / d(x, x')

  wide

  Z := sum_((x', y') in cal(V)_k (x)) 1 / d(x, x')
$

permitindo que pontos mais próximos a $x$ exerçam maior influência no cômputo da predição $h(x)$. Ideia semelhante pode também ser aplicada a classificação.

Observe que o algoritmo k-NN não necessita de treinamento, ou equivalentemente, o treinamento consiste em simplesmente armazenar o conjunto de dados $cal(D)$. Por conta disso, k-NN é dito ser uma abordagem de lazy learning (Atkeson et al., 1997)

== Qual distância escolher?
Até então, descrevemos o k-NN sem especificar exatamente o formato da função de distância $d$. No entanto, a escolha de uma distância apropriada pode ser crítica para o sucesso do método. Por exemplo, se os dados de entrada estão dispostos na superfície do globo terrestre, gostariamos de usar uma distância que considere a curvatura da terra (e.g., a distância esférica).

No entanto, raramente temos esse tipo de conhecimento sobre $cal(X)$ e as escolhas mais comuns para $d$ incluem casos particulares da distância de Minkowski:
$
  d_p (x, z) = ||x - z||_p = (sum_(i=1)^D |x_i - z_i|^p)^(1/p)
$

que para valores de $p = 1$ chama-se distância quarteirão ou Manhattan; $p = 2$ resulta na
distância euclidiana; e $p -> infinity$ retorna o máximo da diferença entre as componentes dos vetores.
A notação $|| dot ||_p$ é também chamada de norma $L^p$ de um vetor.

Uma possível deficiência de normas $L^p$ é que elas não incorporam nenhuma informação sobre a distribuição $PP_x : cal(X) -> RR^+ union {0}$ (Que é a distribuição que os vetores $x$ foram extraídos) — além do fato do suporte ser subconjunto dos reais. Por exemplo, se uma componente $x_i$ tiver escala muito maior às demais $x_(j!=i)$, ela pode dominar o cálculo da distância, ofuscando diferenças nas demais componentes $x_(j!=i)$. Além disso, $L^p$ são agnósticas a correlações entre componentes de $x ~ PP_x$ (Quando falamos em relação, dizemos da relação entre os componentes de um $x$. Por exemplo, digamos que $x_i=(x_(1 i), x_(2 i), ..., x_(D i))$ então a feature $2$ e $3$ são altura e peso respectivamente, sabemos que quando altura cresce, peso tende a crescer, mas a distância de Minkowski não captura essa relação). Uma alternativa para cobrir esses problema é utilizar a distância de Mahalanobis:
$
  d_M (x, z) = sqrt((x - z)^T Sigma^(-1) (x - z))
$
em que $Sigma$ é a matriz de covariância dos dados de treinamento. Uma escolha típica para $Sigma$ é a matriz de covariância amostral, não viezada:
$
  Sigma = 1/(N-1) sum_(i=1)^N (x_i - accent(x, -)) (x_i - accent(x, -))^T
$
onde $accent(x,-):= 1/N sum_(i=1)^N x_i$ é o vetor de médias amostrais. Observe que quando $Sigma$ é igual à matriz identidade, temos a distância euclidiana. Mas, afinal, qual distância utilizar? De modo geral, a
menos que tenhamos profundo conhecimento sobre a geometria de $cal(X)$ , é impossível dar uma resposta direta. O melhor que podemos fazer é testar opções diferentes.

=== Normalização para média zero e variância um
Subtrair a média $accent(x,-):= 1/N sum_(i=1)^N x_i$ de
cada vetor $x_1, ... , x_N$ e, subsequentemente, multiplicá-los pela inversa da matriz diagonal $C$ com entradas:
$
  C_(j j) = sqrt(1/(N-1) sum^N_(i=1) (x_(i j) - accent(x, -)_j)^2)
$
é um procedimento comum em ML, sendo geralmente chamado de normalização ou padronização (standardization). Aplicar
k-NN com $d(x, z) = ||x - z||_2$ em dados transformados dessa maneira equivale a aplicar k-NN nos dados originais usando a distância de Mahalanobis com $Sigma^(-1) = C^(-2)$

=== Similaridade Cosseno
As distâncias estudadas até aqui são consideradas medidas de dissimilaridade (Qualidade ou estado do que é diferente, desigual ou heterogêneo) entre vetores. De modo análogo, podemos definir a vizinhança de um ponto em termos de medidas de similaridade. Uma importante medida de similaridade entre dois vetores quaisquer $x$ e $z$ é dada pelo coseno do ângulo $gamma$ entre eles:
$
  cos(gamma) = (x^T z) / (||x||_2 ||z||_2)
$
A similaridade coseno é particularmente útil quando estamos interessados na orientação, e não na magnitude, dos vetores. Ela tem sido bastante utilizada em aplicações que envolvem dados textuais (Manning & Schütze, 1999). Note também que $cos(gamma)$ pode ser escrito como uma função do tipo $k(x, z) = Phi(x)^T Phi(z)$, i.e., como uma generalização do produto interno entre $x$ e $z$. Medidas de similaridade que podem ser descritas dessa forma são chamadas funções de kernel.

=== Aprendendo Métricas
Além de usar distâncias clássicas, como as $L^p$ e a de Mahalanobis, é possível aprender métrica (ou pseudo-métrica) de distância de modo supervisionado, com base na taxa de classificacão. Existe uma área de pesquisa em ML conhecida como aprendizado de métrica (metric learning) que se dedica a essa finalidade. Nesse nicho, um
dos métodos mais comuns é o chamado large margin nearest neighbor #link("https://jmlr.csail.mit.edu/papers/volume10/weinberger09a/weinberger09a.pdf", [(Weinberger et al., 2006)]).


== Maldição da Dimensionalidade
A expressão maldição da dimensionalidade foi introduzida por Bellman (1957) e é comumente usada para descrever problemas causados pelo aumento exponencial do volume associado em função da dimensionalidade em espaços euclidianos. No caso do k-NN, esse aumento implica na esparsidade dos exemplos de treino, fazendo com que os k-vizinhos que procuramos estejam muito distantes.

Para ilustrar tal efeito, suponha que a distribuição $PP_x$ sobre os vetores de entrada $x_1,...,x_N$ seja uniforme sobre uma hiperbola $D$-dimensional $S_D$ centrada na origem e com raio unitário (Ou seja, todo ponto dentro dessa bola é uniformemente provável de ser escolhida para ser um vetor de entrada). Suponha também que queremos classificar o vetor de origem $z = (0,...,0)^T$. Defina $r$ como o raio da hiperbola $S'_D subset.eq S_D$ que *contém os k vizinhos mais próximos de $z$*. Em esperança, o quão grande devemos esperar que $r$ seja? Antes, é intuitivo notar que $PP (x_i in S'_D)$ é a razão dos volumes de $S'_D$ e $S_D$, ou seja:
$
  PP (x_i in S'_D) = EE_(x_i ~ PP_x) [II_(x_i in S'_D)] = (pi^(D/2) r^D) / (pi^(D/2) 1^D) = r^D
$
Segue então que o número esperado de amostra, dentre as $N$ que possuímos, dentro de $S'_D$ é:
$
  sum_(i=1)^N PP (x_i in S'_D) = N r^D
$
Então, para que tenhamos, em esperança, $k$ vizinhos dentro de $S'_D$, devemos escolher $r$ tal que $r = (k/N)^(1/D)$, e a medida que $D$ cresce, temos:
$
  lim_(D -> infinity) r = lim_(D -> infinity) (k/N)^(1/D) = 1
$
Ou seja, quanto maior é a dimensão, maior é o raio de $S'_D$, o que mostra que a propriedade de "vizinhos próximos tem propriedades parecidas" é quebrada em altas dimensões, o que é um grande problema para o método k-NN.

=== Manifolds de baixa dimensão.
Na prática, não é incomum ver k-NN sendo utilizado em espaços de alta dimensão, como de imagens, e atingindo boas taxas de acurácia. Uma explicação para esse fenômeno é que os dados não estão uniformemente distribuídos e, na verdade, residem em um subespaço de baixa dimensão. Por exemplo, suponha que $cal(X) subset RR^(256 times 256 times 3)$ é o espaço de imagens de tamanho $256 times 256$ com três canais de cores — red, green, and blue (RGB) — que contém um gato. Nós esperamos que $PP_x$ aloque massa zero para fotos de paisagens, obras de arte, etc

#pagebreak()

#align(center + horizon)[
  = Regressão Linear
]

#pagebreak()

Neste capítulo, vamos estudar o uso de modelos lineares para resolução de problemas deregressão. Enquanto modelos lineares são simples, eles são amplamente empregados em várias áreas de conhecimento e fornecem uma base para a construção de modelos mais expressivos, como modelos polinomiais, métodos de kernel e redes neurais de uma única camada oculta.

== O Problema
Suponha que você recebe um conjunto de dados $D$ com $N$ pares ordenados $(x_n, y_n)$, no qual $x_n in RR^D$ são as entradas (ou variáveis independentes), e $y_n in RR$ são amostras de uma variável de saída (ou variável dependente). Suponha ainda que cada variável de saída pode ser descrita aproximadamente como uma combinação afim do seu respectivo vetor de entradas, isto é:
$
  y_n = sum_(j=1)^D theta_j x_(n j) + theta_0 + epsilon_n = theta^T x_n + epsilon_n
$
onde $epsilon_n in RR$ é uma variável que reflete o grau de incerteza na observação de $y_n$

*Nota*: A partir daqui, insermos um $1$ no vetor $x$ para representar o _bias_, então vamos redefinir $x_n := (1, x_(n 1), ..., x_(n D))^T$ e $theta := (theta_0, theta_1, ..., theta_D)^T$, de modo que a expressão acima possa ser escrita de forma mais compacta como $y_n = theta^T x_n + epsilon_n$.

Uma das maneiras mais comuns de obter uma estimativa $hat(theta)$ para $theta$ é obter o aquele que minimiza a média (ou a soma) dos erros quadráticos entre as predições $hat(y)_n := hat(theta)^T x_n$ e as saídas observadas $y_n$:
$
  hat(theta)_"LS" := "argmin"_(theta in RR^(D+1)){cal(l)(theta) := 1/N sum_(n=1)^N (y_n - theta^T x_n)^2}
$
Esse método de otimização é chamado de *mínimos quadrados ordinários*
Podemos escrever a função de custo $cal(l)$ de forma matricial como:
$
  cal(l)(theta) &= 1/N ||y - X theta||_2^2    \
  &= 1/N (y - X theta)^T (y - X theta)    \
  &= 1/N (y^T y - 2 theta^T X^T y + theta^T X^T X theta)
$

Note que, quando $X^T X$ é positiva definida, a função de custo $cal(l)$ é estritamente convexa, o que garante a existência de um único mínimo global. Podemos encontrar uma solução analítica para $hat(theta)_"LS"$ derivando $cal(l)$ e igualando a zero:
$
  nabla_theta cal(l)(theta) &= 1/N (-2 X^T y + 2 X^T X theta) = 0    \

  &=> hat(theta)_"LS" = (X^T X)^(-1) X^T y
$<hat-theta-ls>

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *E se $X^T X$ não for positiva definida?*: Considere o caso em que $N > D$. Para que a inversa exista, precisamos que todas as colunas de $X$, nossas variáveis preditoras, sejam linarmente independentes. Caso contrário, não podemos calcular a inversa na Equação @hat-theta-ls. No entanto, essas variáveis não agregam nenhuma informação ao nosso modelo de regressão, e podemos pré-processar os dados de maneira a remover atributos redundantes. Uma outra alternativa, é substituir a inversa de $X^T X$ pela inversa de $X^T X + alpha I$, para algum pequeno escalar $alpha$ positivo. É possível provar que $X^T X + alpha I$ sempre possui inversa (verifique!)
]

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Casos $N = D$ e $N < D$*: No caso em que o número de dados é igual ao número atributos ($N = D$), existe uma solução ótima única, com $cal(l)=0$, se a matriz $X$ possuir inversa. Nesses casos, a função linear resultante, com $hat(theta)_"LS" = X^(-1)y$, intersecta todos as observações $D$.
  
  Quando $N < D$, no caso mais geral, o problema admite infinitas soluções com $cal(l) = 0$. Quando as linhas de $X$ são linearmente independentes — $"posto"(X) = N$ — uma opção comum é achar a solução que possui a menor norma L2, dada por $hat(theta)_"MN" = X^T (X X^T)^(-1) y$
]

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Em bancos de dados massivos*: Quando $N$ é um grande número, armazenar a matriz $X$ nas camadas de memória mais velozes de um computador se torna impraticável e, portanto, calcular $hat(theta)_"LS"$ usando a Equação @hat-theta-ls não é computacionalmente viável. Nesse caso, podemos utilizar SGD para minimizar $cal(l)$. Para tal, note que pode-se escrever $cal(l)(theta) = sum cal(l)_n (theta)$, no qual definimos $cal(l)_n (theta) := 1/N (y_n - theta^T x_n)^2$
]

#example([Regressão Linear Simples])[
  No ano 2020, o mundo foi tomado por uma pandemia do vírus Sars-Cov-2, causando milhões de infeções e centenas de milhares de mortos. No dia 29 de abril, a infeção ainda não havia atingido seu estado crítico no Ceará.

  Neste exemplo, utilizamos um modelo linear para descrever o logaritmo do número de novas infeções diárias no Ceará como uma função do número de dias que se passaram desde a data na qual o primeiro caso de infecção foi reportado. Uma das utilidades de um modelo como esse é produzir estimativas para o número de novos infectados nos próximos dias, o que pode auxiliar epidemiologistas e gestores públicos em seus processos de tomada de decisão.

  #figure(
    image("images/regression-ceara.png", width: 60%)
  )

  Vale a pena ressaltar que em geral a dinâmica de contágios em uma epidemia possui um ponto de inflexão no qual número de novos casos começa a diminuir. Portanto, um modelo linear como esse não descreve todo o processo epidemiológico e seu uso deve ser validado por um especialista.
]

#example([Antiruido])[
  O método de mínimos quadrados pode ser utilizado para remoção de ruído (denoising). Suponha que você recebe um sinal digital ruidoso $s_r (t)$ em que $t$ denota um instante de tempo discreto e $t = 1, ... , T$. Estamos interessados em encontrar a versão não ruidosa $s (t)$ de $s_r (t)$.

  Um sinal ruidoso $s_r (t)$ pode ser decrito como um sinal suave $s(t)$ adicionado de
  um ruído de alta frequência $r(t)$:

  #figure(
    image("images/ruido.png")
  )

  Queremos encontrar um sinal $s$ que seja:
  - Similar ao sinal ruidoso
  - Suave (a diferença entre os valores do sinal em instantes sucessivos seja pequena)

  Com essas propriedades em mente, podemos propor uma função custo a se minimizar da forma:
  $
    min_(s in RR^T) underbrace(||s - s_r||^2, "similar ao sinal ruidoso") + underbrace( mu sum_(t=1)^(T-1) (s(t+1) - s(t))^2, "suavidade")
  $
  onde $s$ é a representação vetorial do sinal $s(t)$. O termo $mu$ controla o peso que queremos dar a propriedade da suavidade. Essa função custo pode ser colocada na forma $min_s ||y - X s||^2$ escolhendo:
  $
    X = mat(
      I_(T times T);
      sqrt(mu) D_(T-1 times T)
    ),

    D = mat(
      -1, 1, 0, ..., 0;
      0, -1, 1, ..., 0;
      dots.v, 0, -1, 1, 0;
      0, 0, ..., -1, 1
    ),

    y = mat(
      s_r;
      0;
      0;
      dots.v;
      0
    ) in RR^(2T-1)
  $
]

Nesse formato, o valor ótimo $s^*$ para o sinal $s$ é obtido com a solução de mínimos quadrados $s^* = (X^T X)^(-1) X^T y$. As figuras abaixo mostram a solução ótima para valores de $mu in {0, 100, 20000}$. Para $mu = 0$, a solução ótima é o próprio sinal ruidoso. Com $mu = 20000$, o sinal fica muito suave, tendendo a um sinal constante. Finalmente, para $mu = 100$, temos um sinal filtrado com eliminação da componente de ruído.

#figure(
  image("images/denoising.png")
)

== Perspectiva Probabilística
Podemos obter o mesmo estimador de mínimos quadrados se assumirmos o seguinte modelo observacional para cada resposta dado sua respectiva entrada:
$
  y_n|x_n ~ N(theta^T x_n, sigma^2) forall n = 1, ... , N
$<modelo-observacional>
podemos então procurar o estimador de máxima verossimilhança $hat(theta)_"ML"$ para $theta$:
$
  => f_n (y|x, theta) &= product_(n=1)^N f (y_n|x_n, theta) = (1/(sqrt(2 pi sigma^2))^N) exp(- sum_(n=1)^N (y_n - theta^T x_n)^2 / (2 sigma^2))   \
$
$
  => log f_n (y|x, theta) = -N/2 log(2 pi sigma^2) - 1/(2 sigma^2) sum_(n=1)^N (y_n - theta^T x_n)^2
$
$
  => hat(theta)_"ML" = "argmax"_(theta in RR^(D+1)) log f_n (y|x, theta) = "argmin"_(theta in RR^(D+1)) underbrace(sum_(n=1)^N (y_n - theta^T x_n)^2, N dot cal(l)(theta))
$

ou seja, a estimativa que máximiza a verossimilhança do modelo descrito pela equação @modelo-observacional é equivalente à estimativa obtida minimizando a média dos erros quadrados. Mais importante, note que, quando fazemos regressão linear, estamos parametrizando um parâmetro (a média) do nosso modelo observacional como uma transformação linear do vetor de entrada.

== Modelo com expansão de base
O método de mínimos quadrados aplicado a modelos lineares é atraente por sua simplicidade e pelo fato de admitir uma solução ótima analítica. No entanto, a consideração que a relação entre as variáveis de entrada e de saída é linear pode não ser válida em diversos problemas. Um das formas de combinar a vantagem de termos uma solução ótima analítica com um modelo mais geral e flexível do que o linear é utilizar uma transformação não-linear das variáveis de entrada.

Nessa abordagem, de forma geral, o primeiro passo consiste em transformar as variáveis de entrada $x$ através de uma função $Phi : RR^D → RR^M$ , em que normalmente $M$ é maior que $D$. Em seguida, aplicamos um transformação linear sobre as variáveis transformadas para obtermos
as predições $hat(y)$ para as variáveis de saída $y$. Ou seja, considere as variáveis transformadas $z := Phi(x)$, o modelo preditivo é dado por:
$
  hat(y) = theta^T z = theta^T Phi(x)
$
onde o vetor $theta in RR^M$ denota os parâmetros do modelo

Note que o modelo é não linear com relação às entradas originais $x$, mas é linear no espaço das variáveis $z$. Quando a transformação $Phi$ é fixa, sem parâmetros a serem aprendidos, o modelo é dito ser linear nos parâmetros. Nesses casos, a solução de mínimos quadrados é obtida simplesmente substituindo a matriz original de regressores $X$ por uma matriz $Z = [z_1, ... , z_N ]^T$ de entradas transformadas na equação @hat-theta-ls:
$
  hat(theta)_"LS" = (Z^T Z)^(-1) Z^T y
$
A transformação $Phi$ atua como um pré-processamento das entradas $x_1, ... , x_N$ . A seguir, estudaremos algumas das escolhas mais comuns para $Phi$

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Por que $M > D$?*: As variáveis de entrada $x$ representam atributos de um objeto sob o qual queremos realizar predições. Em geral quando aplicamos a transformação não-linear $Phi$ queremos encontrar novos atributos $z$ que permitam ao modelo linear ser preciso. Dessa forma, é natural trabalharmos em espaços com dimensões maiores, aumentando a chance de encontrarmos atributos relevantes. Vale ressaltar que isso não constitui uma regra. Conforme veremos adiante, o aumento do valor M pode gerar problemas, especialmente quando temos poucas amostras proporcionalmente a $M$
]

=== Polinômios
Funções de expansão de base podem ser utilizadas para construir modelos polinômiais. Para entradas e saídas escalares, podemos descrever um modelo de regressão polinomial de grau dois como:
$
  hat(y) = theta_3 + theta_2 x + theta_1 x^2 = theta^T Phi(x) = theta^T z
$
onde $z = Phi(x)$ é dado por:
$
  z = Phi(x) = mat(
    x^2;
    x;
    1
  )
$
O mesmo pode ser feito para entradas multivariadas (A função $Phi$ fica um pouco mais complexa) e qualquer expansão de grau polinomial finito. Por exemplo, para entradas bidimensionais, obtemos um modelo de grau 2 se:
$
  Phi(x) = mat(
    x_1^2;
    x_2^2;
    x_1 x_2;
    x_1;
    x_2;
    1
  )
$

#example([Regressão Polinomial em funções não-lineares])[
  Considere o problema de regressão univariada $(D = 1)$ em que as entradas pertencem ao intervalo $[-10, 10]$ e a função alvo é dada por $f(x) = sin(x)\/x$, também conhecida como função _sinc_. Além disso, utilizamos um conjunto de dados com $200$ pares de entrada-saída $(x_i, y_i)$, em que as saídas estão corrompidas por um ruído aditivo gaussiano, ou seja, $y = f(x) + epsilon$ com $epsilon ~ N(0, 0.05)$. Nesse exemplo, empregamos modelos polinomiais com grau $d in {1, 2, 5, 10}$.

  A Figura abaixxo mostra as predições obtidas com
  os diferentes modelos. Observe que, para $d = 1$,
  temos o modelo de regressão linear básico que estudamos anteriormente, e a aproximação consiste em
  uma reta. Note que, à medida que aumentamos o
  grau do polinômio, o modelo se torna mais flexível,
  conseguindo aproximar melhor os dados (represen-
  tados por pequenos círculos pretos), e portanto o
  melhor modelo possui $d = 10$ (curva em vermelho)

  #figure(
    image("images/polynomial-regression.png")
  )
]

=== Funções de base radiais
Vamos agora estudar um novo formato para a transformação $Phi$. De forma simples, ele consiste em escolher $M$ pontos $c_1, c_2, ... , c_M$ do $RR^D$, também chamado de centros ou protótipos, e então criar o vetor de regressores $z = Phi(x)$ combinando funções radiais em torno de cada um dos centros.

#definition([Função radial no RR^D])[
  Dada uma métrica $||dot||$ no $RR^D$ e $c in RR^(D)$, dizemos que $f_c: RR^D -> RR$ é radial se existe uma função $f: [0, infinity) -> RR$ tal que $f_c (x) = f(||x - c||)$
]

Podemos então construir uma transformação $Phi$ que utiliza $M$ funções radiais da forma:
$
  Phi(x) = mat(
    f_(c_1) (x);
    f_(c_2) (x);
    dots.v;
    f_(c_M) (x)
  ) = mat(
    f(||x - c_1||);
    f(||x - c_2||);
    dots.v;
    f(||x - c_M||)
  )
$

Quando as funções $f_(c_1) (x), . . . f_(c_M) (x)$ são linearmente independentes, e a matriz
$
  mat(
    f_(c_1) (c_1), f_(c_2) (c_1), ..., f_(c_M) (c_1);
    f_(c_1) (c_2), f_(c_2) (c_2), ..., f_(c_M) (c_2);
    dots.v;
    f_(c_1) (c_M), f_(c_2) (c_M), ..., f_(c_M) (c_M)
  )
$
é não-singular, essas funções são chamadas de funções de base radiais (radial basis functions, RBFs).  modelo de regressão linear com transformações através de funções de base radiais constitui uma classe de rede neurais chamada redes RBF #link("https://sci2s.ugr.es/keel/pdf/algorithm/articulo/1988-Broomhead-CS.pdf", "(Broomhead & Lowe, 1988)")

A completa definição da transformação $Phi$ envolve duas escolhas: a localização dos centros
$c_1, ... , c_M$ e a função de base radial.

*Escolhendo os centros*. Um das formas mais simples de escolher $M$ protótipos consiste
em selecionar aleatoriamente entradas $x_i$ do próprio conjunto de dados. Nessa abordagem, o
conjunto de centros é um subconjunto ${c_1, . . . , c_M } subset.eq {x_1, . . . , x_N }$ qualquer de tamanho $M$.

No entanto, a estratégia mais comum e que se tornou padrão consiste em selecionar centros de forma a capturar a densidade dos vetores de entrada. Para isso, normalmente empregamos métodos de análise de agrupamentos (clustering), tais como o k-médias (Lloyd, 1982). A discussão sobre o impacto da escolha dos centros está fora do escopo deste material

*Escolhendo a função de base radial*. Existem diversas escolhas possíveis para $f_(c_i)$ , algumas das mais notórias são:
1. Gaussiana:
$
  f_(c_i) (x) = e^(-gamma||x-c_i||^2_2)
$
onde $gamma > 0$ é uma constante;

2. Multi-quadrática:
$
  f_(c_i) (x) = sqrt(1 + epsilon||x - c_i||^2_2)
$
onde $epsilon > 0$ é uma constante.

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Redes RBF e interpolação*: As redes RBF foram originalmente propostas para resolver problemas de interpolação: Dado um conjunto de $N$ pares entrada saída $(x_i, y_i)$, queremos encontrar uma função $g$ tal que
  $
    g(x_i) = y_i, wide i = 1, . . . , N
  $
  
  Escolhendo $g$ tal que $g(x) = theta^T Phi(x) = theta^T z$ com $N$ funções de base radiais e $c_i = x_i$ para todo $i = 1, ..., N$ , a matriz de regressores $Z : Z_(i j) = f_(c_j)(x_i)$ é quadrada e a condição de interpolação equivale ao sistema linear:
  $
    Z theta = y "com" Z = mat(
      f_(c_1) (x_1), f_(c_2) (x_1), ..., f_(c_N) (x_1);
      f_(c_1) (x_2), f_(c_2) (x_2), ..., f_(c_N) (x_2);
      dots.v;
      f_(c_1) (x_N), f_(c_2) (x_N), ..., f_(c_N) (x_N)
    )
  $
  Dessa forma, obtemos um interpolador com a rede RBF desde que a matriz $Z$ seja não-singular. Micchelli (1986) mostrou que matrizes $Z$ formadas usando tanto funções radiais gaussianas quanto multi-quadráticas são não-singulares (possuem inversa), e a única condição para isso é que os centros (ou equivalentemente as entradas) sejam distintos. Como consequência, no caso em que $M < N$ e os centros são um subconjunto das entradas, a matriz $Z^T Z$ utilizada na solução dos mínimos quadrados possui inversa.
]

#example([Redes RBF])[
  Este exemplo ilustra o impacto do número de funções de base na aproximação realizada por redes RBF com função radial Gaussiana. Para isso, vamos utilizar novamente o problema de regressão com função alvo _sinc_, com exatamente a mesma configuração descrita no último exemplo. Os centros das RBFs foram selecionados de forma igualmente espaçados no intervalo $[-10, 10]$.

  A Figura abaixo (lado esquerdo) mostra a aproximação obtida usando uma rede RBF com $M in {5, 20}$ e $gamma = 1$. Note que o modelo com $k = 20$ aproxima melhor os dados. O aumento no número de funções de base aumenta a flexibilidade do modelo em se ajustar aos dados. Na Figura à direita, percebemos que o aumento no valor de $gamma$ produz funções radiais com variância (ou largura de banda) pequena, resultando em um aspecto oscilatório da curva de aproximação

  #figure(
    image("images/rbf-regression.png")
  )
]

#pagebreak()

#align(center+horizon)[
  = Regressão Logística
]

#pagebreak()

Uma das maneiras mais naturais de criar um modelo de regressão consiste em escolher um modelo observacional para a variável de resposta $y$ cujos parâmetros dependam diretamente do seu respectivo vetor de entradas $x$. Por exemplo, na capítulo anterior, vimos que minimizar o MSE é equivalente a admitir uma verossimilhança da forma $y|x ~ N (theta^T x, sigma^2)$, na qual o parâmetro de média é uma função linear de $x$. Note também que esse escolha implica que $y$ pode tomar valores arbitrários em $RR$, já que esse é o suporte da distribuição normal (i.e., região
com densidade maior que zero).

Se $y$ é uma variável binária (0/1), a escolha mais comum é utilizar uma distribuição Bernoulli com parâmetro $r = g(x)$. Em outras palavras, falamos que $y$ assume valor 1 com probabilidade $r$ e $0$ com probabilidade $1 - r$. Adotando esse modelo observacional para $y|x$, resta-nos definir a função $g$ para completar nosso modelo de regressão. Para tal, iremos calcular uma função linear de $x$, como anteriormente, mas aplicaremos uma função que mapeie o valor resultante (comumente conhecido como logit) para $[0, 1]$, gerando valores válidos para a probabilidade $r$. Mais especificamente, usamos a função sigmoide $sigma(t) = (1 + e^(-t))^(-1)$ para definir a probabilidade de $y|x$ como
$
  p(y|x) = "Bern"(y|sigma(theta^T x)) = sigma(theta^T x)^y (1 - sigma(theta^T x))^(1-y)
$

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Propriedades da função sigmoide*
  $
    -> t < t' => sigma(t) < sigma(t')
  $
  $
    lim_(t -> infinity) sigma(t) = 1 wide lim_(t -> -infinity) sigma(t) = 0
  $
  $
    sigma(-t) = 1 - sigma(t)
  $
  $
    dif / (dif t) sigma(t) = sigma(t) (1 - sigma(t)) = sigma(t) sigma(-t)
  $
  $
    sigma(t) = 1/2 + 1/2 tanh(t/2)
  $
  $
    integral sigma(t) dif t = log(sigma(-t)) + C
  $
]

Dado um conjunto de treinamento $D$ com $N$ exemplos de treinamento $(x_n, y_n)$, podemos então definir a função de verossimilhança $cal(L)$ como
$
  cal(L)(theta) = product_(i=1)^N p(y_i|x_i) = product_(i=1)^N sigma(theta^T x_i)^(y_i) (1 - sigma(theta^T x_i))^(1-y_i)
$
e agora podemos encontrar o estimador de máxima verossimilhança $hat(theta)$ para $theta$:
$
  hat(theta) &= "argmax"_(theta in RR^(D+1)) cal(L)(theta) = "argmin"_(theta in RR^(D+1)) -log cal(L)(theta)    \

  &= "argmin"_(theta in RR^(D+1)) - sum_(i=1)^N [y_i log sigma(theta^T x_i) + (1-y_i) log (1 - sigma(theta^T x_i))]   \

  &= "argmin"_(theta in RR^(D+1)) -{ underparen(sum_(i=1)^N, y_i = 1) log sigma(theta^T x_i) - underparen(sum_(i=1)^N, y_i = 0) log sigma(-theta^T x_i) }
$

Similar ao MSE, que minimizamos no capítulo passado, a função objetivo $-log(cal(L))$ é uma convexa. No entanto, não possuímos uma solução analítica para $hat(theta)$ e, portanto, precisamos utilizar algum método de otimização númerica, como o SGD que já conhecemos. Para fins de
implementação, podemos definir a variável $y'_i = 2y_i - 1$. Com isso, conseguimos escrever o
gradiente $gradient theta cal(l)_i (theta)$ da log verossimilhança para o $i$-ésimo exemplo de treinamento $cal(l)_i$ como:
$
  gradient_theta cal(l)_i (theta) &= gradient_theta log sigma(y'_i theta^T x_i)   \
  
  &= (partial log sigma(y'_i theta^T x_i)) / (partial sigma(y'_i theta^T x_i)) dot (partial sigma(y'_i theta^T x_i)) / (partial (y'_i theta^T x_i)) dot (partial y'_i theta^T x_i) / (partial theta)   \

  &= sigma(-y'_i theta^T x_i) y'_i x_i
$

Aplicando o algoritmo gradiente descendente à função custo da regressão logística, obtemos o seguinte algoritmo:

#figure(
  kind: "algorithm",
  supplement: [Algoritmo],
  caption: [Regressão Logística],

  pseudocode-list(
    title: [Regressão Logística],
    booktabs: true,
  )[
    + $theta_0 <- 0$
    + $y' <- 2y - bold(1)$
    + *for* $t=0,1,2,...$ *do*
      + $g <- sum_(i=1)^N sigma(-y'_i theta_t^T x_i) y'_i x_i$
      + $theta^((t+1)) <- theta^((t)) - eta g$
      + Verifica condição de parada
    + *end for*
    + *return* $theta$
  ]
)

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Interpretação geométrica*: Uma vez que obtivemos $hat(theta)$, podemos estimar a probabilide de uma nova amostra $x^*$ pertencer à classe 1 como $sigma(hat(theta)^T x^*)$ e a de pertencer à classe 0 como $1 - sigma(hat(theta)^T x^*)$. Com isso em mente, se precisamos prever a classe de $x^*$, é razoável escolher aquela que achamos mais provável. Lembre que $sigma(0) = 0.5$. Portanto, o plano $hat(theta)^T x = 0$ caracteriza os pontos $x in cal(X)$ que cremos ter probabilidade idêntica de pertencer a ambas as classes. Isso implica que todos os vetores de entrada cujo ângulo $gamma$ com o vetor normal $hat(theta)$ é menor que noventa graus são classificados como positivos (classe 1) — lembre que $theta^T x = ||hat(theta)||_2 ||x||_2 cos(gamma)$. Os demais pontos são classificados como negativos (classe 0).
]

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Convexidade do problema de aprendizado*: Como a soma de funções convexas é também convexa, basta verificar que as $cal(l)_1, ... , cal(l)_N$ são convexas para provarmos que $-log cal(L)$ também o é. Para esse fim, podemos usar o fato de que a função composta $h = g compose f$ é convexa se $f$ é côncava e $g$ é convexa não-crescente. Note que $y'_i theta^T x_i$ é tanto côncava como convexa, como é o caso de funções lineares. Em contrapartida, $-log sigma(t)$ é convexa não-crescente já que ela descresce com $t$ e sua derivada $-sigma(-t)$ é estritamente crescente
]

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Entropia Cruzada Binária*: Na comunidade de ML, é comum se referir ao logaritmo negativo da verossimilhança Bernoulli como entropia cruzada binária (binary cross entropy, BCE). De forma geral, a entropia cruzada entre duas funções de massa/densidade $p$ e $q$ sobre a mesma variável aleatória $z$ e com suportes idênticos é definida como:
  $
    H(p, q) := - EE_(z ~ p) log q(z)
  $
  e dá-se o nome BCE para o caso especial em que p e q são distribuições Bernoulli.
  
  Em teoria da informação, é comum interpretar $log 1/q(z)$ como uma medida de surpresa, i.e., do quanto observar um valor específico $z$ contrasta com seu conhecimento prévio, representado por $q$. Nesse contexto, $H(p, q)$ é o valor dessa medida se os valores de $z$ são amostrados de $p$ (ao invés de q). Vale ressaltar que, para um $p$ fixo, $q = p$ minimiza $H(p, q)$. Nesse caso, a quantia $H(p) := H(p, p)$ é chamada de entropia. Por sua vez, a entropia também pode ser vista como uma medida de concentração de $p$, atingindo seu valor máximo quando $p$ é uma distribuição uniforme.
  
  Para concluir que a BCE generaliza $-log"Ber"(y|r)$, basta definir $p(z) = "Ber"(z|y)$ e tomar $q(z) = "Ber"(z|r)$. Com essas escolhas, obtemos:
  $
    H(p, q) &= -y log q(1) - (1 - y) log q(0)   \
    &= - (y log r + (1 - y) log (1 - r))
  $
  o que implica que:
  $
    e^(-H(p,q)) = r^y (1 - r)^(1-y) (1-y) = "Ber"(y|r)
  $
]

== Regressão Logística Bayesiana
Na seção anterior, discutimos como obter uma estimativa pontual $hat(theta)$ para $θ$ via máxima verossimilhança (MLE). Um problema com estimativas pontuais, no entanto, é que elas não refletem nossa incerteza sobre o valor estimado. Intuitivamente, por exemplo, esperamos que estimativas feitas com grandes quantidades de dados sejam mais confiáveis que as feitas com poucos dados. Para observar que MLE não captura esse aspecto, basta notar que repetir o conjunto de dados qualquer número arbitrário de vezes não causa impacto algum em $hat(theta)$.

A estatística Bayesiana propõe uma saída intuitiva para esse empasse. A ideia é modelar os parâmetros $theta$ do modelo como uma variável aleatória, usando uma distribuição a priori $p(theta)$ e aplicar a regra de Bayes para computar a distribuição de $theta$ condicionada nas observações $D$, que chamamos de posteriori:
$
  p(theta|D) = (p(D|theta) p(theta)) / p(D) = (cal(L)(theta) p(theta)) / (integral cal(L)(theta') p(theta') dif theta')
$
Informalmente, a posteriori representa a incerteza que temos sobre o valor da variável $theta$. Além disso, vale ressaltar que a priori nos permite encapsular conhecimento prévio, potencialmente subjetivo, sobre $theta$ (i.e., antes de ver os dados) e sua escolha é uma questão de modelagem estatística. Quando não possuímos informação significante sobre os dados, é comum escolher uma distribuição de alta entropia como priori. No caso em que $theta$ assume valores reais, e.g., poderíamos usar uma priori Gaussiana com alta variância.

No caso da regressão logística, é comum adotar uma priori Gaussiana sobre $theta$ e a verossimilhança que usamos na seção anterior, resultando no modelo
$
  theta ~ N(mu, Sigma)  \
  y_n|x_n, theta ~ "Bern"(sigma(theta^T x_n)) space forall n = 1, ... , N
$

cuja posteriori é dada por
$
  p(theta|D) = (product_(n=1)^N "Bern"(y_n|sigma(theta^T x_n)) N(theta|mu, Sigma)) / (integral_(x in RR^(D+1)) product_(n=1)^N "Bern"(y_n|sigma(theta'^T x_n)) N(theta'|mu, Sigma))
$

Notavelmente, computar a posteriori acima depende da resolução de uma integral que não possui forma fechada. Consequentemente, também não há uma forma analítica para $p(theta|D)$. Essa dificuldade técnica não é uma raridade em modelos Bayesianos. Apesar de algumas escolhas pareadas de verossimilhança e priori resultarem em posteriores com forma analítica, esse não é o caso geral. Para driblar esse problema, usaremos métodos numéricos para aproximar a posteriori com distribuição mais simples, de forma conhecida

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Prevendo a label $y^*$ para um novo input $x^*$*: Suponha que conseguimos computar a posteriori $p(theta|D)$, como podemos obter uma distribuição para $p(y^*|x^*)$? Quando estavamos usando uma estimativa pontual $hat(theta)$ (MLE), obtivemos uma distribuição sobre $y^*$ simplesmente encaixando $hat(theta)$ na nossa verossimilhança, i.e., tomamos $p(y^*|x^*) approx" Ber"(sigma(hat(theta)^T x^*))$. No paradigma Bayesiano, levamos em consideração a incerteza sobre $theta$ (codificada em nossa posteriori), ponderando cada valoração de $theta$ pela sua densidade posteriori. O resultado, é o que chamamos de posteriori preditiva
  $
    p(y^*|x^*) = integral p(y^*|x^*, theta) p(theta|D) dif theta
  $
]

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Máxima verossimilhança e máximo _a posteriori_*: Uma das maiores virtudes do paradigma Bayesiano é oferecer uma maneira de quantificar incerteza. No entanto, há situações nas quais computar a posteriori, mesmo que de maneira aproximada, pode se tornar computacionalmente indesejável. Nesses casos, é comum procurar o ponto que máximiza a posteriori e tomá-lo como estimativa pontual. Chama-se esse precedimento de máximo a posteriori (MAP). Mais concretamente, a estimativa $hat(theta)_"MAP"$ pode ser obtida como:
  $
    hat(theta)_"MAP" &= "argmax"_(theta) log p(theta|D)   \
    
    &= "argmax"_(theta) {log p(D|theta) + log p(theta) - log integral_theta p(D|theta) p(theta)}   \

    &= "argmax"_(theta) {log cal(L)(theta) + log p(theta)}
  $

  e, portanto, pode ser interpretada como uma versão regularizada do MLE, na qual $log p(theta)$ penaliza regiões pouco prováveis a priori
]

#example([Priori conjugada])[
  Para escolhas específicas de priori e verossimilhança, a distribuição posteriori possui forma analítica. Uma instância dessas ocorre quando $p(theta)$ é uma distribuição Beta e a verossimilhança $p(D|theta)$ é Bernoulli. Mais concretamente, suponha que escolhemos uma priori $"Beta"(alpha, beta)$ para $theta$, dada por:
  $
    Beta(theta|alpha, beta) = (Gamma(alpha + beta) / (Gamma(alpha) Gamma(beta))) theta^(alpha - 1) (1 - theta)^(beta - 1)
  $
  Podemos inferir, então, o seguinte sobre a posteriori do nosso modelo:
  $
    p(theta|D) &prop product_(n=1)^N "Bern"(y_n|theta) "Beta"(theta|alpha, beta)   \

    &prop product_(n=1)^N theta^(y_n) (1 - theta)^(1-y_n) theta^(alpha - 1) (1 - theta)^(beta - 1)   \

    &prop theta^(alpha + sum_(n=1)^N y_n - 1) (1 - theta)^(beta + N - sum_(n=1)^N y_n - 1)   \

    &prop theta^(alpha' - 1) (1 - theta)^(beta' - 1) = "Beta"(theta|alpha', beta')   \
  $

  onde $alpha' = alpha + sum_(n=1)^N y_n$ e $beta' = beta + N - sum_(n=1)^N y_n$.

  Portanto, concluimos que nossa posteriori é uma $"Beta"(alpha', beta')$. Para ilustrar o uso da regra de Bayes, a figura abaixo mostra atualizações da posteriori derivada acima para diferentes números de amostras $N$. Para tal, assumimos que a distribuição geradora dos dados é $"Bern"(0.25)$ e usamos uma priori $"Beta"(10, 10)$. Veja que, à medida que vemos mais amostras, a posteriori se afunila ao redor de $0.25$.

  #figure(
    image("images/beta-posterior.png")
  )
]

=== Aproximação de Laplace
A aproximação de Laplace é, possivelmente, a mais simples técnica de inferência Bayesiana aproximada. A ideia é construir uma aproximação simples $q(theta)$ para a posteriori $p(theta|D)$ usando uma expansão de Taylor de segunda ordem em $log p(theta|D)$ ao redor da moda $m$ da posteriori (i.e., o ponto de máxima densidade)
$
  log p(theta|D) approx log p(m|D) + (theta - m)^T gradient_theta log p(m|D) + 1/2 (theta - m)^T gradient^2_theta log p(m|D) (theta - m)
$

Note que $log p(m|D)$ é uma constante com respeito a $theta$ e lembre que o gradiente de uma função em sua moda, caso ela exista, é zero. Então, concluímos que:
$
  log p(theta|D) approx 1/2 (theta - m)^T bold(H) (theta - m) + C
$

onde $bold(H) = gradient^2_theta -log p(m|D)$. Por design, construímos $q$ tal que $log q$ difira da expansão acima apenas por uma constante aditiva, então:
$
  log q(theta) = 1/2 (theta - m)^T bold(H) (theta - m) + C' => q(theta) prop exp(1/2 (theta - m)^T bold(H) (theta - m))
$
e como $q(theta)$ é proporcional á uma densidade normal multivariada com média $m$ e matriz de
covariância igual á inversa de $H$, temos:
$
  q(theta) = N(theta|mu=m, Sigma=H^(-1)), "onde" m = "argmax"_(theta) p(theta|D) "e" H = gradient^2_theta -log p(m|D)
$

Note que o procedimento acima envolve inverter $H$. Como $m$ é um mínimo local para a função $-log p(dot|D)$, segue diretamente das condições de optimalidade de segunda ordem que $H$ é PSD. Caso $H$ não seja PD ou haja instabilidade numérica na inversão de $H$, uma prática comum é adicionar um pequeno valor $c > 0$ à sua diagonal.

Para aplicar o método de Laplace ao nosso modelo de regressão logística Bayesiano, podemos usar alguma variação de gradiente descendente para achar $m$ e, assumindo $mu = 0$ e $Sigma = c I$ para $c > 0$, as entradas $H_(i j)$ da Hessiana $H$ são dadas por
$
  H_(i j) = cases(
    sum_(n=1)^N sigma(theta^T x_n) sigma(-theta^T x_n) x_(n i) x_(n j) "se" i != j,
    sum_(n=1)^N sigma(theta^T x_n) sigma(-theta^T x_n) x_(n i)^2 + c^(-1) "se" i = j
  )
$

== Problemas multiclasse, classificador _softmax_
Nesse capítulo, nos focamos em problemas de classificação binária, em que $|cal(Y)| = 2$. No entanto, é fácil generalizar as técnicas que discutimos para problemas multi-classe (i.e., $|cal(Y)| > 2$). Para tal, basta substituir o nosso modelo observacional Bernoulli por uma distribuição categórica. Lembre que a Bernoulli é parametrizada por um parâmetro escalar que dita a probabilidade de cada classe. No caso da categórica, precisamos de um vetor de probabilidades, i.e., um vetor $r$ de tamanho $L = |cal(Y)|$, em que cada entrada $r_l$ denota a probabilidade da classe $l$. Naturalmente, todas as entradas de $r$ devem ser não-negativas e $sum_(l=1)^L r_l = 1$. Resta-nos, então, expressar $r$
como uma função de $x$. Para tal, podemos generalizar nosso o procedimento que usamos para
regressão logística.

Primeiro, calculamos um vetor de logits $z$, desta vez usando uma transformação linear para
cada uma das $L$ classes
$
  z = mat(
    x^T theta^((1));
    x^T theta^((2));
    dots.v;
    x^T theta^((L))
  )
$

Finalmente, aplicamos a função Softmax para transformar $z$ em um vetor de probabilidades e obter $r$, que é dado por:
$
  r_l = "Softmax"(z) = e^(z_l) / (sum_(l'=1)^L e^(z_(l')))
$


#pagebreak()

#align(center+horizon)[
  = Redes Neurais
]

#pagebreak()

Redes Neurais são modelos de regressão linear com transformações não-lineares parametrizadas. De forma intuitiva, é como se fossemos aplicando diversas transformações não-lineares $Phi_1, Phi_2, ... , Phi_K$ em sequência até obtermos uma representação de $x$ que seja adequada para a predição de $y$ através de um modelo linear ou logístico. Nesse capítulo, vamos introduzir a ideia mais simples de redes neurais, generalizar para inúmeras camadas e introduzir o algoritmo de retropropagação, que é a técnica mais comum para treinar redes neurais (Além de provar ele matematicamente)

== Estrutura Inicial
As redes neurais são estruturadas com base em camadas de neurônios interconectados, de forma que cada camada tem sua própria quantidade de neurônios e cada neurônio é conectado a todos os neurônios da camada seguinte.

#figure(
  image("images/neuron.png", width: 70%),
  caption: [Representação do neurônio $k$ da camada $j$. $"sum"(w,z) = b_k^((j)) + sum_(i=1)^D w^((j-1))_(i k) z^((j-1))_(i)$]
)

Na primeira camada, $Z = X$. Mas antes de continuarmos vendo isso, vamos definir as camadas em si:

#figure(
  image("images/layers.png", width: 70%),
  caption: [Camadas de entrada, escondidas e de saída]
)

Então a estrutura de uma rede neural com $K$ camadas escondidas é, pegar o datapoint, joga na camada de entrada, ele é processado dentro de todas as camadas e finalmente chega na camada de saída, onde é feita a predição.

== Estrutura Matemática
Vamos agora formalizar a estrutura matemática das Redes Neurais. Pelo que você viu na imagem anterior, cada camada $j$ tem um número de neurônios $M_j$. O número de neurônios da camada de entrada é $M_0 = D$ e o número de neurônios da camada de saída é $M_(K+1) = L$. Para cada camada $j in {1, ... , K+1}$, temos uma matriz de pesos $W^((j))$ de tamanho $M_(j-1) times M_j$ e um vetor de bias $b^((j))$ de tamanho $M_j$. Podemos escrever o resultado da última camada $Z^(K+1)$ como:
$
  Z^((3)) = h^((3))(h^((2))(h^((1))(X W^((1)) + b^((1)) bb(1)^T) W^((2)) + b^((2))bb(1)^T) W^((3)) + b^((3))bb(1)^T)
$

(Exemplo com 3 camadas, 1 de entrada, 1 escondida e 1 de saída)

De forma que a $i$-ésima coluna de $W^((j))$ representa os pesos de todas as conexões que chegam no neurônio $i$ da camada $j$ e a $i$-ésima entrada de $b^((j))$ é o bias do neurônio $i$ da camada $j$. A função $h^((j))$ é a função de ativação da camada $j$, que é aplicada elemento a elemento

== Não-linearidade
É importante ressaltar que, se as funções de ativação $h^((1)), ... , h^((K))$ forem todas lineares, então a rede neural é equivalente a um modelo de regressão linear sem camadas escondidas, pois, se $h$ é uma função linear:
$
  h(X) = A X
$

para algum $X$

== Treinamento
O treinamento da rede neural é divido em 3 passos:
1. *Forward Pass*: Não é nada além de passar os dados pela rede neural e armazenas os resultados de cada camada, que serão usados no passo seguinte
2. *Backward Pass*: Também conhecido como retropropagação, é o processo de calcular os gradientes de cada peso e bias da rede neural com respeito a função de custo, usando o algoritmo de retropropagação
3. *Atualização dos pesos*: Depois de obter os gradientes, basta usar um método de otimização, como o SGD, para atualizar os pesos e bias da rede neural

=== Forward Pass
O forward pass é o processo de passar os dados pela rede neural e armazenar os resultados de cada camada. Para isso, basta seguir a estrutura matemática que vimos anteriormente

#pseudocode-list[
  + *function* forward_pass($X in RR^(N times D)$, $W$, $b$) {
    + $Z^((0)) <- X$
    + *for* $j=1, ... , K+1$ *do*
      + $Z^((j)) <- h^((j))(Z^((j-1)) W^((j)) + b^((j)) bb(1)^T)$
    + *end for*
    + *return* $Z^((K+1))$
  + }
]

=== Backpropagation
O backward pass é o processo de calcular os gradientes de cada peso e bias da rede neural com respeito a função de custo, usando o algoritmo de retropropagação. Para isso, basta usar a regra da cadeia para calcular os gradientes de cada camada, começando pela última camada e indo para a primeira camada. Para calcular o gradiente das camadas, antes de tudo precisamos de uma função de perca, e isso vai variar dependendo do problema que estamos tentando resolver. Por exemplo, para um problema de regressão, podemos usar o MSE como função de perca, enquanto para um problema de classificação, podemos usar a entropia cruzada. Depois de escolher a função de perca, basta seguir o algoritmo de retropropagação para calcular os gradientes de cada camada.

*Lembrando* que, nesse momento, nós temos armazenado/sabemos os valores de:
- $Z^((j)) space forall j in {1, ... , K+1}$
- $W^((j)) space forall j in {1, ... , K+1}$
- $b^((j)) space forall j in {1, ... , K+1}$

==== Regressão
Em redes neurais, a regressão linear é obtida quando a função de ativação da última camada é a função identidade, ou seja, $h^((K+1))$ é a função identidade. Nesse caso, a saída da rede neural é dada por:
$
  Z^((K+1)) = Z^((K)) W^((K+1)) + b^((K+1)) bb(1)^T
$
ou seja, *não* é uma regressão linear na última camada como conhecemos, mas uma combinação linear dos valores da saída da camada anterior. Intuitivamente, é como se a rede neural aprendesse uma forma mais fácil dos dados, ao ponto que apenas uma combinação linear dos valores da última camada fosse suficiente para fazer uma boa predição

Para demonstrar o algoritmo, vamos usar o MSE como função de perca. Então, antes de tudo, vamos ter $X in RR^(N times D)$ que são meus dados e $T in RR^(N times L)$ que é a matriz de resultados que quero prever. Ao aplicar o forward pass, obtemos $Y = Z^((K+1)) in RR^(N times L)$ que é a matriz de predições da minha rede neural. Com isso, podemos calcular a função de perca como:
$
  E_n (w) = 1/2 sum_k (y_(n k) - t_(n k))^2
$

Que é o erro quadrático médio para o $n$-ésimo exemplo de treinamento e o erro total é dado por:
$
  E(w) = sum_(n=1)^N E_n (w) = ||Y - T||^2_F
$

O gradiente do erro total com respeito a $Y$ é dado por:
$
  (partial E_n) / (partial y_(n k)) = y_(n k) - t_(n k)  =>  nabla_Y E(w) = Y - T
$

==== Camadas Escondidas
Mostramos antes como calcular o gradiente da última camada na situação de uma *regressão linear*, mas saiba que pode variar dependendo das função de saída que você escolher. Agora vamos olhar como calcular a derivada das camadas escondidas.

Pegando o erro total
$
  E(w) = sum_(n=1)^N E_n (w)
$
vamos tirar a derivada do erro de acordo com a entrada $w_(i j)^((p))$, vamos primeiro considerar o erro linha-a-linha, ou seja, $E_n$ e depois somar os resultados para obter o gradiente total:
$
  (partial E_n) / (partial w_(i j)^((p))) = (partial E_n) / (partial z_(n j)^((p))) (partial z_(n j)^((p))) / (partial a_(n j)^((p))) (partial a_(n j)^((p))) / (partial w_(i j)^((p)))
$
E eu posso fazer essa regra da cadeia pois nada anterior a $w_(i j)^((p))$ depende dele, porém, tudo que vem depois, tem uma influência que ele aplicou em sua camada. Agora vamos calcular cada um desses termos:
$
  a_(n j)^((p)) = sum_(k=1)^(M_(p-1)) z_(n k)^((p-1)) w_(k j)^((p)) + b_j^((p) )    \

  (partial a_(n j)^((p))) / (partial w_(i j)^((p))) = z_(n i)^((p-1))
$

$
  z_(n j)^((p)) = h^((p))(a_(n j)^((p)))    \

  (partial z_(n j)^((p))) / (partial a_(n j)^((p))) = h'^((p))(a_(n j)^((p)))
$

Agora a parte mais delicada, qual é a derivada de $(partial E_n) \/ (partial z_(n j)^((p)))$? Por enquanto, vamos apenas atribuir um novo nome para ele:
$
  (partial E_n) / (partial z_(n j)^((p))) = delta_(n j)^((p))
$
perfeito! Jaja voltamos nele, agora vamos calcular o gradiente TOTAL em todas as linhas:
$
  (partial E) / (partial w_(i j)^((p))) = sum_(n=1)^N (partial E_n) / (partial w_(i j)^((p))) = sum_(n=1)^N delta_(n j)^((p)) h'^((p))(a_(n j)^((p))) z_(n i)^((p-1))
$
legal, obtemos uma fórmula para a derivada do erro total com respeito a $w_(i j)^((p))$, mas ainda não sabemos o que é $delta_(n j)^((p))$. Para isso, vamos usar a regra da cadeia para expressar $delta_(n j)^((p))$ em termos de $delta_(n k)^((p+1))$, como assim? Lembra que, quando eu calculo $z_(n j)^((p))$, eu vou mandar ele pra próxima camada, e a próxima camada vai usar ele para calcular $a_(n k)^((p+1))$ e depois $z_(n k)^((p+1))$. Então eu teria algo assim:
$
  z_(n k)^((p+1)) = h^((p+1))(a_(n k)^((p+1)))    \
  a_(n k)^((p+1)) = sum_(j=1)^(M_p) z_(n j)^((p)) w_(j k)^((p+1)) + b_k^((p+1))
$
olha só, o meu $z_(n j)^((p))$ ta ali no meio do somatório, e porque diabos isso me é útil? Calma que ainda vai fazer sentido. Com essa estrutura, concorda comigo que meu $z_(n j)^((p))$ não ta só no neurônio $k$, mas também ta no neurônio $1$, $2$, ... , $M_(p+1)$ (ou seja, eu mando ele pra todos os neurônios da camada seguinte)? Então, quando eu calcular a derivada de $E_n$ com respeito a $z_(n j)^((p))$, eu vou ter que somar a contribuição de cada um desses neurônios, ou seja:
$
  (partial E_n) / (partial z_(n j)^((p))) = sum_(k=1)^(M_(p+1)) (partial E_n) / (partial z_(n k)^((p+1))) (partial z_(n k)^((p+1))) / (partial a_(n k)^((p+1))) (partial a_(n k)^((p+1))) / (partial z_(n j)^((p)))
$
mas perceba que:
$
  a_(n k)^((p+1)) = sum_(j=1)^(M_p) z_(n j)^((p)) w_(j k)^((p+1)) + b_k^((p+1))   \

  => (partial a_(n k)^((p+1))) / (partial z_(n j)^((p))) = w_(j k)^((p+1))
$
$
  (partial z_(n k)^((p+1))) / (partial a_(n k)^((p+1))) = h'^((p+1))(a_(n k)^((p+1)))
$
e pela definição de $delta$ que fizemos antes, temos que:
$
  (partial E_n) / (partial z_(n k)^((p+1))) = delta_(n k)^((p+1))
$
logo:
$
  (partial E_n) / (partial z_(n j)^((p))) = sum_(k=1)^(M_(p+1)) delta_(n k)^((p+1)) h'^((p+1))(a_(n k)^((p+1))) w_(j k)^((p+1))
$
beleza, e porque que isso é útil? Agora eu to escrevendo a derivada de $z_(n j)^((p))$ na camada $p$ em função da camada seguinte $p+1$. Por que isso ajudaria? Simples! Porque nós começamos já calculando o gradiente da última camada, lembra? Ou seja, nós calculamos $delta_(n k)^((K+1))$ para a última camada, e agora, usando a fórmula acima, podemos calcular $delta_(n j)^((K))$ para a camada anterior, e depois $delta_(n i)^((K-1))$ para a camada anterior a essa, e assim por diante, até chegar na primeira camada. Ou seja, nós conseguimos calcular o gradiente de todas as camadas usando apenas o gradiente da última camada e a estrutura da rede neural. E isso é o que chamamos de retropropagação! Mas antes de concluir, vamos reformular rapidinho de uma forma matricial, afinal, não vamos no computador fazer o cálculo de cada neurônio individualmente, mas sim de toda a camada de uma vez.

Para entendermos bem como e porque essa mudança pra matriz funciona, é interessante fazermos um passo-a-passo. Primeiro, na abordagem igênua, nós atualizamos cada peso individualmente, ou seja:
$
  w_(i j)^((p)) <- w_(i j)^((p)) - eta (partial E) / (partial w_(i j)^((p)))
$
ou seja, olhando numa abordagem mais matricial, mas ainda ingênua, podemos escrever:
$
  W^((p)) <- W^((p)) - eta mat(
    (partial E) / (partial w_(1 1)^((p))), (partial E) / (partial w_(1 2)^((p))), ..., (partial E) / (partial w_(1 M_p)^((p)));
    (partial E) / (partial w_(2 1)^((p))), (partial E) / (partial w_(2 2)^((p))), ..., (partial E) / (partial w_(2 M_p)^((p)));
    dots.v, dots.v,, dots.v;
    (partial E) / (partial w_(M_(p-1) 1)^((p))), (partial E) / (partial w_(M_(p-1) 2)^((p))), ..., (partial E) / (partial w_(M_(p-1) M_p)^((p)))
  )
$
Essa matriz maior, nós a chamamos de *jacobiana* de $E$ com respeito a $W^((p))$, ou seja, $J_(E, W^((p)))$. Agora, usando a fórmula que obtivemos para a derivada de cada peso, podemos escrever
$
  J_(E, W^((p))) = mat(
    sum_(n=1)^N delta'_(n 1)^((p)) z_(n 1)^((p-1)), sum_(n=1)^N delta'_(n 2)^((p)) z_(n 1)^((p-1)), ..., sum_(n=1)^N delta'_(n M_p)^((p)) z_(n 1)^((p-1));
    sum_(n=1)^N delta'_(n 1)^((p)) z_(n 2)^((p-1)), sum_(n=1)^N delta'_(n 2)^((p)) z_(n 2)^((p-1)), ..., sum_(n=1)^N delta'_(n M_p)^((p)) z_(n 2)^((p-1));
    dots.v, dots.v,, dots.v;
    sum_(n=1)^N delta'_(n 1)^((p)) z_(n M_(p-1))^((p-1)), sum_(n=1)^N delta'_(n 2)^((p)) z_(n M_(p-1))^((p-1)), ..., sum_(n=1)^N delta'_(n M_p)^((p)) z_(n M_(p-1))^((p-1))
  )
$
aqui, por questão de leitura, mas não muda em nada as fórmulas, eu defini $delta'_(n j)^((p)) = delta_(n j)^((p)) h'^((p))(a_(n j)^((p)))$. Tirando o somatório para fora, temos:
$
  J_(E, W^((p))) = sum_(n=1)^N mat(
    delta'_(n 1)^((p)) z_(n 1)^((p-1)), delta'_(n 2)^((p)) z_(n 1)^((p-1)), ..., delta'_(n M_p)^((p)) z_(n 1)^((p-1));
    delta'_(n 1)^((p)) z_(n 2)^((p-1)), delta'_(n 2)^((p)) z_(n 2)^((p-1)), ..., delta'_(n M_p)^((p)) z_(n 2)^((p-1));
    dots.v, dots.v,, dots.v;
    delta'_(n 1)^((p)) z_(n M_(p-1))^((p-1)), delta'_(n 2)^((p)) z_(n M_(p-1))^((p-1)), ..., delta'_(n M_p)^((p)) z_(n M_(p-1))^((p-1))
  )
$
reparem na matriz acima e nessa definição de produto externo:
$
  u = mat(u_1, u_2, ..., u_m)^T "e" v = mat(v_1, v_2, ..., v_n)^T   \
  => u v^T = mat(
    u_1 v_1, u_1 v_2, ..., u_1 v_n;
    u_2 v_1, u_2 v_2, ..., u_2 v_n;
    dots.v, dots.v,, dots.v;
    u_m v_1, u_m v_2, ..., u_m v_n
  )
$
então definindo $delta'_n^((p)) = mat(delta'_(n 1)^((p)), delta'_(n 2)^((p)), ..., delta'_(n M_p)^((p)))^T$ e $z_n^((p-1)) = mat(z_(n 1)^((p-1)), z_(n 2)^((p-1)), ..., z_(n M_(p-1))^((p-1)))^T$, temos que:
$
  J_(E, W^((p))) = sum_(n=1)^N delta'_n^((p)) (z_n^((p-1)))^T
$
agora, reparando melhor em $delta'_n^((p))$, vamos abrir sua definição:
$
  delta'_n^((p)) = mat(delta'_(n 1)^((p)), delta'_(n 2)^((p)), ..., delta'_(n M_p)^((p)))^T   \
  = mat(delta_(n 1)^((p)) h'^((p))(a_(n 1)^((p))), delta_(n 2)^((p)) h'^((p))(a_(n 2)^((p))), ..., delta_(n M_p)^((p)) h'^((p))(a_(n M_p)^((p))))^T
$
então definindo $h'^((p))(a_n^((p))) = mat(h'_(n 1)^((p)), h'_(n 2)^((p)), ..., h'_(n M_p)^((p)))^T$ onde $h'_(n j)^((p)) = h'^((p)) (a_(n j))$, também podemos escrever assim:
$
  delta'_n^((p)) = delta_n^((p)) dot.o h'^((p))(a_n^((p)))
$
onde $dot.o$ é o produto de Hadamard, ou seja, o produto elemento a elemento. Então, finalmente, temos que:
$
  J_(E, W^((p))) = sum_(n=1)^N (delta_n^((p)) dot.o h'^((p))(a_n^((p)))) (z_n^((p-1)))^T
$
ok, mas tem como simplificar MAIS AINDA. Por questão de leitura, vamos escrever usando $delta'$ em vez de $delta dot h'$. Se vocês lembram, em álgebra linear, existe um teorema chamado *decomposição em soma de matrizes de rank 1*

#theorem("Decomposição em soma de matrizes de posto 1")[
  Dada uma matriz $A in RR^(m times n)$ com colunas $a_1, a_2, ..., a_n$ e $B in RR^(n times p)$ com linhas $b_1^T, b_2^T, ..., b_p^T$, então o produto $A B$ é dado por:
  $
    mat(
      |,|,...,|;
      a_1, a_2, ..., a_n;
      |,|,...,|;
    )
    mat(
      -,b_1^T,-;
      -,b_2^T,-;
      ,dots.v,;
      -,b_p^T,-;
    ) = sum_(i=1)^n a_i b_i^T
  $
]

perceba como essa é a EXATA MESMA ESTRUTURA de $J_(E, W^((p)))$. Então, se definirmos $Delta'^((p))$ sendo a matriz com *linhas* $delta'_n^((p))$ e $Z^((p-1))$ sendo a matriz com *linhas* $z_n^((p-1))$, temos que:
$
  J_(E, W^((p))) = (Z^((p-1)))^T Delta'^((p))
$
não só isso, mas também, para calcular $Delta'^((p))$, vamos recaptular a fórmula de um $delta'_n^((p))$:
$
  delta'_n^((p)) = sum_(k=1)^(M_(p+1)) delta'_(n k)^((p+1)) w_(j k)^((p+1))
$
então, definindo $W^((p+1))$ como a matriz de pesos da camada seguinte onde cada *coluna* é o vetor de pesos de um neurônio da camada seguinte, temos que:
$
  delta'_n^((p)) = sum_(k=1)^(M_(p+1)) delta'_(n k)^((p+1)) w^((p+1))_j   \
  => Delta'^((p)) = Delta'^((p+1)) (W^((p+1)))^T
$
e para finalizar, precisamos também do resultado do gradiente com respeito ao bias, que é dado por:
$
  (partial E) / (partial b_j^((p))) = sum_(n=1)^N (partial E_n) / (partial b_j^((p))) = sum_(n=1)^N (partial E_n) / (partial z_(n j)^((p))) (partial z_(n j)^((p))) / (partial a_(n j)^((p))) (partial a_(n j)^((p))) / (partial b_j^((p)))   \

  a_(n j)^((p)) = sum_(k=1)^(M_(p-1)) z_(n k)^((p-1)) w_(k j)^((p)) + b_j^((p) ) => (partial a_(n j)^((p))) / (partial b_j^((p))) = 1  \

  => (partial E) / (partial b_j^((p))) = sum_(n=1)^N delta'_(n j)^((p))
$
ou seja, definindo $Delta'^((p))$ como a matriz com *colunas* $delta'_(n j)^((p))$, temos que:
$
J_(E, b^((p))) = sum_(n=1)^N delta'_(n j)^((p)) = sum_(n=1)^N (delta_n^((p)) dot.o h'^((p))(a_n^((p))))
$

=== O Algoritmo Completo

#figure(
  kind: "algorithm",
  supplement: [Multilayer Perceptron],
  caption: [Multilayer Perceptron],

  pseudocode-list(
    title: [Multilayer Perceptron],
    booktabs: true,
  )[
    + $bold(W) <- [W^((1)),...,W^((P+1))]$
    + $bold(b) <- [b^((1)),...,b^((P+1))]$
    + $bold(h) <- [h^((1)),...,h^((P+1))]$
    + $bold(h') <- [h'^((1)),...,h'^((P+1))]$
    + $bold(A) <- [A^((1))=0,...,A^((P+1))=0]$
    + $bold(Z) <- [Z^((1))=0,...,Z^((P+1))=0]$
    + \/\/ Forward pass
    + *for* $j=1, ... , P+1$ *do*
      + $A^((j)) <- Z^((j-1)) W^((j)) + b^((j)) bb(1)^T$
      + $Z^((j)) <- h^((j))(A^((j)))$
    + *end for*
    + \/\/ Backward pass
    + $Delta'^((P+1)) <- nabla_Z E dot.o h'^((P+1))(A^((P+1)))$
    + *for* $j=P, P-1, ... , 1$ *do*
      + $Delta'^((j)) <- Delta'^((j+1)) (W^((j+1)))^T dot.o h'^((j))(A^((j)))$
    + *end for*
  ]
)

=== Exemplo em código
Para um exemplo em código, acesse #link("https://github.com/jaopredo/machine-learning/", "Machine Learning - João Pedro Jerônimo")


#pagebreak()

#align(center+horizon)[
  = Inferência Variacional
]

#pagebreak()

== Introdução
Na inferência variacional, nosso objetivo é aproximar uma distribuição $p$ através de outra distribuição $q$ que conseguimos manipular mais facilmente. Fazemos isso minimizando alguma medida de discrepância entre as duas distribuições, a forma mais comum de fazer isso é através da divergência de Kullback-Leibler, que é dada por:
$
  "KL"(q||p) = integral q(x) ln {q(x) / p(x)} dif x = EE_(x ~ q)[ln {q(x) / p(x)}]
$

== Propriedades da divergência de Kullback-Leibler
#theorem("Não-negatividade")[
  A divergência de Kullback-Leibler é não-negativa, ou seja, $"KL"(q||p) >= 0$
]
#proof[
  A desigualdade de Jensen fala que, para uma função convexa $f$ e uma variável aleatória $X$, temos que:
  $
    f(EE[X]) <= EE[f(X)]
  $
  sabemos que $-ln(x)$ é uma função convexa, então, aplicando a desigualdade de Jensen, temos que:
  $
    -ln(EE_(x ~ q)[p(x) / q(x)]) <= EE_(x ~ q)[-ln(p(x) / q(x))] = EE_(x ~ q)[ln(q(x) / p(x))] = "KL"(q||p)
  $
  porém:
  $
    EE_(x ~ q)[p(x) / q(x)] = integral q(x) {p(x) / q(x)} dif x = integral p(x) dif x = 1
  $
  logo:
  $
    -ln(EE_(x ~ q)[p(x) / q(x)]) = -ln(1) = 0
  $
  chegando à conclusão que:
  $
    0 <= "KL"(q||p)
  $
]

#theorem("Identidade")[
  $
    "KL"(q||p) = 0 <=> q = p "quase certamente"
  $
  ou seja, a divergência de Kullback-Leibler é zero se, e somente se, $q$ e $p$ são iguais
]
#proof[
  $==> )$ Se $q = p$, então:
  $
    "KL"(q||p) = integral q(x) ln {q(x) / p(x)} dif x = integral q(x) ln {1} dif x = integral q(x) 0 dif x = 0
  $

  $<== )$ Se $"KL"(q||p) = 0$, então:
  $
    EE_(x ~ q)[ln q(x)] = EE_(x ~ q)[ln p(x)]
  $
  como $-ln$ é uma função estritamente convexa, então, pela desigualdade de Jensen, temos que:
  $
    0 <= -EE_(x ~ q)[ln(p(x) / q(x))]
  $
  porém, a desiguldade de Jensen enuncia que:
  $
    EE[f(X)] = f(EE[X]) <=> X = c
  $
  ou seja, temos que
  $
    p(x) / q(x) = c
  $
  entretanto ambas são densidades, assim:
  $
    integral q(x) c dif x = c = integral p(x) dif x = 1 => c = 1 => p(x) / q(x) = 1 => p(x) = q(x)
  $
]

#theorem("KL e Entropia Cruzada")[
  A divergência de Kullback-Leibler pode ser escrita como a diferença entre a entropia cruzada e a entropia de $q$, ou seja:
  $
    "KL"(q||p) = H(q, p) - H(q)
  $
  onde $H(q, p) = -EE_(x ~ q)[ln p(x)]$ é a entropia cruzada entre $q$ e $p$ e $H(q) = -EE_(x ~ q)[ln q(x)]$ é a entropia de $q$. Um ótimo vídeo que fala sobre isso é o #link("https://youtu.be/KHVR587oW8I?si=HdtlJh1BHLMH7Has", "The Key Equation Behind Probability") do canal #link("https://www.youtube.com/@ArtemKirsanov", "Artem Kirsanov")
]
#proof[
  $
    "KL"(q||p) &= integral q(x) ln {q(x) / p(x)} dif x    \
    &= integral q(x) ln {q(x)} dif x - integral q(x) ln {p(x)} dif x    \
    &= -H(q) + H(q, p)    \
    &= H(q, p) - H(q)
  $
]

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Divergência KL _forward_ vs _reverse_*: É importante notar que, de forma geral, a divergência KL não é simétrica — i.e., $"KL"(q||p) != "KL"(p||q)$. Na literatura de ML, é comum chamar $"KL"(q||p)$ de divergência KL reversa. Conversamente, $"KL"(p||q)$ é conhecida como a divergência forward. Empiricamente, é bem estabelecido que minimizar a divergência reversa costuma resultar em resultados que focam em alguma(s) modas. Por outro lado, minimizar a divergência forward costuma promover aproximações que cobrem melhor o suporte de $p$. A figura abaixo ilustra esse fenômeno com $p(theta) = 1/2 cal(N)(theta|3,1) + 1/2 cal(N)(theta| -3,(1/2)^2)$ e $q$ sendo Gaussiana univariada
  
  #figure(
    image("images/kl_approximations.png")
  )
]

== Cota Inferior (ELBO)
Normalmente estamos realizando inferência bayesiana, ou seja, queremos calcular a distribuição posterior $p(theta|D)$, mas isso é difícil de fazer diretamente. Então, vamos usar a divergência KL para encontrar uma aproximação $q(theta)$ para $p(theta|D)$. Para isso, vamos minimizar a divergência KL reversa:
$
  "KL"(q(theta)||p(theta|D)) &= EE_(theta ~ q(theta))[ln {q(theta) / p(theta|D)}]   \
  
  &= EE_(theta ~ q(theta))[ln q(theta)] - EE_(theta ~ q(theta))[ln p(theta|D)]   \

  &= EE_(theta ~ q(theta))[ln q(theta)] - EE_(theta ~ q(theta))[ln (p(D|theta) p(theta)) / p(D)]   \

  &= EE_(theta ~ q(theta))[ln q(theta)] - EE_(theta ~ q(theta))[ln p(D,theta)] + ln p(D)   \
$
Vamos definir $L(q)$ como:
$
  L(q) = EE_(theta ~ q(theta))[ln p(D,theta)] - EE_(theta ~ q(theta))[ln q(theta)]
$
então temos que a distribuição $q$ que minimiza a divergência KL seria:
$
  hat(q) &= "argmin"_q "KL"(q(theta)||p(theta|D))    \
  
  &= "argmin"_q EE_(theta ~ q(theta))[ln q(theta)] - EE_(theta ~ q(theta))[ln p(D,theta)] + ln p(D)   \

  &= "argmin"_q -L(q) + ln p(D)   \

  &= "argmax"_q L(q)   \
$

algo interessante de se ressaltar é que, como $"KL" >= 0$, temos que:
$
  ln p(D) - L(q) = "KL" >= 0 => L(q) <= ln p(D)
$
logo, $ln p(D)$ (conhecido como evidência) é uma cota superior para $L(q)$, e como queremos maximizar $L(q)$, estamos na verdade tentando encontrar a melhor aproximação para a evidência. Por isso, chamamos $L(q)$ de *Evidence Lower Bound* (ELBO), ou cota inferior da evidência.

== Lidando com ELBO intratável
Com relação à escolha de $Q$, costuma-se adotar uma família de distribuições paramétricas. Deste modo, podemos maximizar $L$ sobre um espaço de parâmetros $Omega$. Por exemplo, se $Q$ é o conjunto das distribuições Gaussianas univariadas, $Omega = RR times R^+$ e $omega in Omega$ é um par média/variância. De maneira geral, os termos envolvidos no ELBO podem ser intratáveis e, até meados da década passada, desenvolver soluções customizadas para posterioris diferentes era considerado uma contribuição técnica em ML.

Atualmente, existem metodologias genéricas, que viabilizam inferência variacional quase como uma tecnologia _off-the-shelf_. A mais famosa dentre essas, é o truque reparametrização. Essa técnica assume que é possível descrever a amostragem de $theta ~ q$ a partir de uma transformação g de uma variável aleatória auxiliar $epsilon$. Além disso, precisamos que g seja diferenciável com respeito aos parâmetros $omega$ de $q$. Por exemplo, se q é uma distribuição normal com parâmetros $omega = (mu,sigma^2)$, podemos obter uma amostra $theta ~ q$ definindo $theta = g(epsilon;omega) = sigma epsilon + mu$ e amostrando $epsilon$ de numa gaussiana padrão — i.e., com média zero e variância um.

Com isso, podemos aproximar os termos do ELBO amostrando M variáveis auxiliares $epsilon(1), . . . , epsilon(M)$ e estimar o gradiente de $L(q)$ com respeito a $omega$ como:

$
  nabla_omega L(q) = nabla_omega 1/M sum_(m=1)^M ln p(D|theta^((m))) + ln p(theta^((m))) - ln q(theta^((m));omega)
$

Note que, na notação acima, $q$ também depende diretamente de $omega$. Em posse dessa estimativa, podemos utilizar nosso algoritmo de gradiente preferido para otimizar o ELBO. Naturalmente, essa aproximação deve ser refeita com novas amostras a cada passo de gradiente. Para evitar incluir restrições explícitas para garantir que parâmetros restritos sejam válidos (e.g., variâncias devem ser não-negativas), nós também as modelamos como a transformação de uma variável real. No caso citado acima, podemos ter $omega = (mu, sigma^2 = u(z))$ com $u(z) = e^z$ ou $u(z) = beta^(-1) ln(1+e^(beta z))$ para algum $beta > 0$.
