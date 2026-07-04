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
    Revisão para A2
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
  = Problema de Aprendizagem
]

#pagebreak()

== Introdução
Em aprendizado supervisionado, o objetivo principal é criar uma aproximação $h : cal(X) -> cal(Y)$ para uma função $f : cal(X) -> cal(Y)$ a partir de amostras $D = {(x_n,y_n)}^N_(n=1)$, onde cada exemplo de treinamento é uma amostra independente proveniente de $PP_(x,y)$ e $y_n$ é uma observação (possivelmente ruidosa) de $f(x_n)$. No caso de regressão, poderíamos usar vários métodos distintos para construir $h$. Alguns exemplos que já vimos são $k$-NN, regressão linear e redes neurais RBF. Além disso, podemos alterar drasticamente o comportamento desses modelos alterando hiper-parâmetros. Isso nos leva às duas perguntas estruturantes desse capítulo:
  1. Qual é a melhor classe de modelos (e.g., regressão linear, rede RBF) para cada problema?
  2. Como escolher escolher os melhores híper-parâmetros para cada classe de modelos?

== Dilema viés-variância
De maneira geral, aprendemos $h$ usando o conjunto de treino $D$ com $N$ amostras (i.e., $|D| = N$), mas queremos que $h$ apresente boa performance em novas observações de $x ~ PP_x$. Em outras palavras, gostaríamos de um modelo que minimiza uma função de perda $cal(l)$ média $EE_x [cal(l)(h(x),f(x))]$. Esse valor é comumente chamado de erro de generalização.

Para a seguinte discussão, assuma que $cal(l)$ é o erro quadrático — i.e., $cal(l)(y, hat(y)) = (y - hat(y))^2$. Portanto o erro de generalização é dado por $EE_x [(h(x) - f(x) - epsilon)^2]$ ($epsilon$ é um ruído de *média $0$*). Como $h$ é o resultado de um processo de aprendizado, ele depende diretamente dos exemplos em $D$. Por exemplo, se estamos fazendo regressão linear, $h$ pode ser obtida aplicando via máxima verossimilhança. No entanto, podemos analisar $h$ de maneira mais geral, sem se prender aos valores específicos em $D$. Para tal, calculamos o valor esperado do erro tratando $D$ como uma variável aleatória. Isto é, calculamos uma média ponderada sobre todos os possíveis bancos de dado de tamanho $N$ — com pesos dados por $PP_(x,y)$. Usando a linearidade do operador de esperança e a independência de $D$ e $x$, segue que:
$
  EE_(x, D, epsilon) [(h_D (x) - f(x) - epsilon)^2] &= EE_x [EE_(D, epsilon) [(h_D(x) - f(x) - epsilon)^2]]    \
  
  &= EE_x [EE_D [(h_D (x) - f(x))^2] + EE_epsilon [epsilon^2]]   \

  &= EE_x [VV_D [h_D (x)]] + EE_x [(EE_D [h_D (x)] - f(x))^2] + EE_epsilon [epsilon^2]   \
$

Como isso muda nossa vida? Na maioria das aplicações, temos pouca informação sobre $f$. Nesse caso, nosso primeiro instinto talvez fosse escolher um método capaz de gerar aproximações arbitrariamente intrincadas. No entanto, métodos mais flexíveis costumam estar associados à uma maior variância no processo de aprendizado, o que influencia negativamente a performance esperada para novos dados de entrada. Por outro lado, métodos simples como regressão linear possuem baixa variância, mas podem apresentar alto viés caso f não possa ser bem aproximada por um (hiper-)plano. Em suma, não existe uma bala de prata. Precisamos de protocolos empíricos bem definidos para escolher o método mais adequado para cada situação.




#pagebreak()

#align(center + horizon)[
  = Processos Gaussianos
]

#pagebreak()

== Revisitando a priori Gaussiana
Como discutimos anteriormente, prioris gaussianas são extremamente populares em modelos Bayesianos para regressão. Uma escolha comum, por exemplo, é colocar uma priori isotrópica $N(0, c I)$ sobre o vetor de pesos $theta$. Nesse caso, a priori sobre $theta$ também induz implicitamente uma priori sobre $f(X') = X' theta$ para qualquer $X' in RR^(N' times (D+1))$ e $N' in NN^+$. Mais especificamente, como $f(X')$ é uma transformação linear de variáveis Gaussianas, essa priori é Gaussiana com vetor de médias $mu(X')$ e matriz de covariância $Sigma(X', X')$ dados por:
$
  mu(X') &= EE_theta [X' theta] = X' EE_theta [theta] = 0   \

  Sigma(X', X') &= EE_theta [(X' theta - 0)(X' theta - 0)^T] = c X' X'^T
$

Com essas observações em mente, podemos abstrair $theta$ totalmente do nosso processo de aprendizado usando a seguinte priori sobre os valores de $f$:
$
  f(X') ~ N(0, Sigma(X', X')) space forall X' in RR^(N' times (D+1)), space N' in NN^+
$<priori-gp>
que é uma instância específica de um processo estocástico conhecido como *processo Gaussiano* (Gaussian process, GP). De forma geral, $(f(x))_(x in cal(X))$ define um processo Gaussiano se qualquer vetor $[f(x_1), ..., f(x_N)]^T$ com $x_1, ..., x_N in cal(X)$ segue uma distribuição normal multivariada.

#definition([Processo Gaussiano])[
  Seja $cal(X)$ um espaço de entradas. Dizemos que $(f(x))_(x in cal(X))$ é um processo Gaussiano se, para qualquer conjunto finito de pontos $x_1, ..., x_N in cal(X)$, o vetor $bold(f) = [f(x_1), ..., f(x_N)]^T$ segue uma distribuição normal multivariada.
]

É importante ressaltar que a matriz de covariância $Sigma(X', X')$ é proporcional à matriz Gramiana $K$ (de produtos internos) dos vetores linha de $X'$, i.e., $K_(i j) = x'_i dot x'_j$, onde $x'_i$ e $x'_j$ denotam os vetores nas linhas $i$ e $j$ de $X'$, respectivamente. Além disso, incorporar uma função de expansão de base $Phi$ no modelo da Equação @priori-gp apenas implica em redefinir as entradas de $K$ como $K_(i j) = k(x'_i, x'_j) = Phi(x'_i) dot Phi(x'_j)$. Em outras palavras, nosso GP sobre $f$ pode ser completamente caracterizado por uma função de produto interno generalizada $k$ — também conhecida como *função de kernel*. Por simplicidade notacional, denotaremos que $f$ segue uma priori de GP como $f ~ "GP"(0, k)$. Nesse capítulo, assumiremos que a média de $f$ é zero a priori; no entanto, seria possível utilizar uma função de média arbitrária $mu(dot)$ com poucas alterações nos nossos desenvolvimentos.

Do ponto de vista de interpretação, funções de kernel nos permitem diretamente expressar como regularidades no espaço de entrada devem ser refletidas no espaço de saída. Além disso, existem casos em que $Phi$ é computacionalmente intratável, mas seu kernel correspondente tem forma simples. Por exemplo, o kernel exponencial quadrático (ou Gaussiano), dado por $k(x, x') = exp{-||x - x'||_2^2 / (2 gamma^2)}$ é gerado a partir de uma expansão de base "infinita" — veja a Seção 4.2 do livro texto de #link("https://gaussianprocess.org/gpml/chapters/RW.pdf", [Rasmussen e Williams (2006)]) para mais detalhes.

=== Funções de kernel comuns
Na literatura de GPs, existe uma variedade de funções de kernel criadas para modelar fenômenos distintos. No entanto, alguns kernels são extremamente populares, como:

1. *Exponencial quadrático* (ou Gaussiano):
$
  k(x, x') = e^(-||x - x'||_2^2 / (2 gamma^2))
$
onde $gamma^2$ é um hiperparâmetro que controla a suavidade da função de kernel;

2. *Racional quadrático*:
$
  k(x, x') = sigma^2 (1 + (||x - x'||_2^2) / (2 alpha gamma^2))^(-alpha)
$
que corresponde a uma soma ponderada de kernels exponenciais quadráticos com diferentes larguras de banda;

3. *Periódico*:
$
  k(x, x') = e^(-2 gamma^(-2) sin^2(pi ||x - x'||_2 / p))
$
que tem natureza periódica, com período $p$.

=== Construindo funções de kernel
A família das funções de kernel é fechada por um número de operações. Isto é, é possível manipular um kernel $k$ de várias maneiras diferentes e ainda assim obter um kernel válido. Isso é extremamente útil em cenários em que precisamos, e.g., combinar propriedades de diferentes funções de kernel para refletir um fenômeno. Por exemplo, as seguintes operações resultam em kernels válidos:

1. Multiplicação por constante $c > 0$: $k'(x, x') = c k(x, x')$;
2. Produto: $k'(x, x') = k_1(x, x') k_2(x, x')$;
3. Soma: $k'(x, x') = k_1(x, x') + k_2(x, x')$;
4. Exponenciação: $k'(x, x') = e^(k_1(x, x'))$;
5. Multiplicação por função escalar avaliada em $x$ e $x'$: $k'(x, x') = f(x) f(x') k(x, x')$.

== GPs para regressão
Em problemas de regressão, é comum que a variável de resposta $y_n$ para a entrada $x_n$ seja observada com algum ruído. Seguindo o capítulo de regressão linear, suponha que $y = g(x) = f(x) + epsilon$ com $epsilon ~ N(0, sigma^2)$. Note que isso é equivalente a dizer que $y|x ~ N(f(x), sigma^2)$; portanto, podemos descrever um modelo qualquer de regressão com priori GP como:
$
  y|f, x &~ N(f(x), sigma^2)   \
  f &~ "GP"(0, k)
$<modelo-gp-regressao>

Como é de costume, estamos interessados em usar o modelo acima e o conjunto de treino $D = {(x_n, y_n)}_(n=1)^N$ para fazer predições para, e.g., a variável de resposta $y^*$ relativa a um novo vetor de atributos $x^*$. Em outras palavras, queremos avaliar $p(y^*|x^*, x_1, y_1, ..., x_N, y_N)$. No entanto, existe um detalhe no modelo acima que facilitará nossa vida: a nossa combinação de priori e verossimilhança induz um processo Gaussiano sobre $g$. Mais especificamente, para qualquer $X' in RR^(M times D)$, $g(X')$ pode ser descrito como uma soma de duas variáveis aleatórias Gaussianas: $f(X')$ e um vetor $M$-dimensional $epsilon$ com distribuição $N(0, sigma^2 I)$. Portanto, temos que $g(X') ~ N(0, k(X', X') + sigma^2 I)$.

Tomando $X' = mat(x_1^T; dots.v; x_N^T; (x^*)^T)$, segue que:
$
  mat(
    y^*;
    y_1;
    dots.v;
    y_N
  ) ~ N(
    mat(0; 0; dots.v; 0),
    mat(
      k(x^*, x^*) + sigma^2, k(x^*, x_1), ..., k(x^*, x_N);
      k(x_1, x^*), k(x_1, x_1) + sigma^2, ..., k(x_1, x_N);
      dots.v, dots.v, dots.v, dots.v;
      k(x_N, x^*), k(x_N, x_1), ..., k(x_N, x_N) + sigma^2
    )
  )
$
onde o lado direito está implicitamente condicionado nas entradas $x_1, ..., x_N$ e $x^*$. Portanto, podemos obter a distribuição $p(y^*|x^*, x_1, y_1, ..., x_N, y_N)$ simplesmente condicionando a Gaussiana acima nos valores observados $y_1, ..., y_N$, i.e., $p(y^*|x^*, x_1, y_1, ..., x_N, y_N) = N(mu^*, S^*)$ com parâmetros $mu^*$, $S^*$ dados por:
$
  mu^* &= k(x^*, X) (k(X, X) + sigma^2 I)^(-1) y   \

  S^* &= k(x^*, x^*) + sigma^2 - k(x^*, X) (k(X, X) + sigma^2 I)^(-1) k(x^*, X)^T
$<predicao-gp>
onde $X$ é a matriz com dados de treinamento e $y$ é o vetor de suas respectivas respostas.

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Interpretação de $mu^*$*: Uma observação interessante é que $mu^*$ é, essencialmente, uma combinação linear das respostas em $y$. Finalmente, vale ressaltar que $sigma^2$ é comumente tratado como um hiperparâmetro, que podemos escolher com auxílio de um conjunto de validação.
]

=== Escolhendo os parâmetros do kernel
Já sabemos como construir um GP simples para regressão. No entanto, não discutimos como escolher os parâmetros da nossa função de kernel (e.g., a largura de banda $gamma$ do kernel Gaussiano). Como fazer isso? Na literatura de GPs, a saída comum é maximizar a esperança da verossimilhança sob a nossa priori, i.e., $p(y_1, ..., y_N | x_1, ..., x_N) = EE_(f ~ "GP"(0,k)) [N(y | f(X), sigma^2 I)]$. Mais concretamente, denotando de maneira genérica os parâmetros da função de kernel por $omega$, os parâmetros ótimos podem ser calculados como:
$
  hat(omega) &= "argmax"_(omega in Omega) log p(y_1, ..., y_N | x_1, ..., x_N)   \

  &= "argmax"_(omega in Omega) log N(y | 0, k(X, X) + sigma^2 I)   \

  &= "argmax"_(omega in Omega) {-1/2 log det(k(X, X) + sigma^2 I) - 1/2 y^T (k(X, X) + sigma^2 I)^(-1) y}
$<evidencia-gp>

O procedimento descrito acima é comumente conhecido como *type II maximum likelihood*, *maximização da verossimilhança marginal* e *maximização da evidência* (note que estamos maximizando o denominador da regra de Bayes). Vale ressaltar que, ao contrário de MLE para regressão linear e logística, o problema acima costuma não ser convexo em $omega$. Por isso, é ideal conduzir otimização multi-start — e.g., rodando SGD usando diferentes pontos iniciais e escolhendo o melhor ótimo local obtido.

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Estimando $sigma^2$*: Note também que o procedimento que descrevemos assume que o ruído observacional $sigma^2$ é uma constante. Nesse caso, poderíamos estimar os parâmetros do kernel para cada valor de $sigma^2$ usando o conjunto de treino e escolher o $sigma^2$ que resulta na maior evidência. Outra opção é otimizar $sigma^2$ juntamente com $omega$, i.e.:
  $
    hat(sigma)^2, hat(omega) = "argmax"_(omega in Omega, sigma in RR) {-1/2 log det(k(X, X) + sigma^2 I) - 1/2 y^T (k(X, X) + sigma^2 I)^(-1) y}
  $
  No entanto, otimizar $sigma^2$ e $omega$ juntos pode tornar nosso processo de aprendizado instável. Para aliviar esse problema, a comunidade de GPs em ML costuma usar algumas heurísticas de inicialização. A heurística mais comum consiste em fixar (a priori) a razão $r^2$ entre a variância da verossimilhança e da priori. Assumindo que nosso kernel é da forma $k = c^2 k'$, o primeiro passo é inicializar $c$ com a variância das saídas de treinamento $y_1, ..., y_N$. Subsequentemente, inicializamos o ruído observacional $sigma^2$ com $c^2 / r^2$. Nesse contexto, repetimos o processo de otimização para diferentes valores de $r^2$ e escolhemos o resultado que leva ao melhor ótimo local.
]

#linebreak()
== GPs para classificação
Para classificações, vamos reformular como as saídas se comportam. Dessa vez, assumimos que
$
  y_i | f_i, x_i ~ "Bernoulli"(sigma(f_i (x_i)))
$
para simplificar notação, vou definir $sigma_i = sigma(f_i (x_i))$. Nós vamos aproximar $p(y|f, X)$ usando a aproximação de Laplace ou métodos de amostragem e depois achar a preditiva posteriori $p(y^*|X, y, x^*)$. Primeiro vamos achar a forma da verossimilhança
$
  p(y_n|f_n, x_n) = sigma_n^(y_n) (1 - sigma_n)^(1 - y_n) => p(y|f, X) = product_(n=1)^N sigma_n^(y_n) (1 - sigma_n)^(1 - y_n)
$
agora, vamos escrever a posteriori de $f$ dado $X$ e $y$ usando Bayes:
$
  p(f|X,y) prop p(y|f,X) p(f|X)
$
escrevendo em forma de $log$ para facilitar as contas
$
  ln p(f|X,y) &= ln p(y|f,X) + ln p(f|X) + C    \

  &= sum_(n=1)^N {y_n ln sigma_n + (1 - y_n) ln (1 - sigma_n)} - 1/2 f(x)^T K^(-1) f(x) + C   \
$

Agora podemos derivar para conseguir achar a moda $m$
$
  partial / (partial f_n) ln p(f|X,y) = y_n (1 - sigma_n) - (1 - y_n) sigma_n - (K^(-1) f(x))_n = 0   \

  => nabla ln p(f|X,y) = y - sigma(f(x)) - K^(-1) f(x) = 0   \
$

essa equação não tem solução analítica, então utilizamos de métodos numéricos para achar a moda $m$ que satisfaz
$
  y - sigma(m) - K^(-1) m = 0
$

Agora, para continuar com a aproximação de Laplace, precisamos achar a matriz Hessiana da posteriori de $f$ dado $X$ e $y$. A matriz Hessiana é dada por
$
  H = nabla^2 ln p(f|X,y) = -W - K^(-1)
$
onde $W$ é uma matriz diagonal com entradas $W_(n n) = sigma_n (1 - sigma_n)$. A aproximação de Laplace nos diz que a posteriori de $f$ dado $X$ e $y$ pode ser aproximada por uma Gaussiana centrada na moda $m$ com covariância $Sigma = -H^(-1) = (K^(-1) + W)^(-1)$. Sabendo que $p(f|X,y) approx cal(N) (m, Sigma)$, temos que:
$
  p(y^*|X,y,x^*) = integral underbrace(p(y^*|f^*), cal(N)(f^* (x^*), sigma^2)) underbrace(p(f^*|X,y,x^*), cal(N)(m', Sigma')) dif f^*
$
$m'$ e $Sigma'$ representam as mesmas contas que fizemos antes, porém adicionando o ponto $x^*$ no conjunto de dados. A integral acima não tem solução analítica, então podemos utilizar métodos de amostragem para aproximar a integral.

#pagebreak()

#align(center + horizon)[
  = Graph Neural Networks
]

#pagebreak()

Toda essa seção é um resumo e escolha dos pontos mais importantes do artigo @introducaoAmigavelGNN. Se você quiser se aprofundar mais no assunto, recomendo fortemente a leitura do artigo original. Um ótimo vídeo para ver antes de ler esse resumo é o vídeo do canal Alex Foo @gnnVideo

== Introdução
Graph neural networks (GNNs) são uma classe de redes neurais projetadas para trabalhar com dados estruturados em grafos. Diferentemente das redes neurais tradicionais, que operam em dados tabulares ou sequenciais, as GNNs são capazes de capturar a complexidade das relações entre os nós de um grafo, permitindo a modelagem de interações complexas e dependências entre os elementos do grafo.

== Notações
Para facilitar a compreensão, vamos definir algumas notações comuns usadas em GNNs:
- $G = (V, E)$: Um grafo onde $V$ é o conjunto de nós e $E$ é o conjunto de arestas.
- $A$: Matriz de adjacência do grafo, onde $A_{i j} = 1$ se houver uma aresta entre os nós $i$ e $j$, e $0$ caso contrário.
- $X$: Matriz de características dos nós, onde cada linha representa as características de um nó. (Por exemplo, $x_i$ pode ser o conjunto *idade*, *peso*, *altura* de uma pessoa representada pelo nó $i$).
- Normalmente, é utilizada a matriz de adjacência normalizada com self loops, dada por $A' = (D+I)^(-1/2) (A+I) (D+I)^(-1/2)$, onde $D$ é a matriz diagonal de grau dos nós e $I$ é a matriz identidade onde $D_(i i) = sum_j A_(i j) = delta(v_i) = "Grau de" v_i$

== Usos de GNNs
*Classificação de nós*. Seja $cal(Y) = {1,...,L}$ um conjunto finito de classes, $G = (V,E)$ um grafo e $V_l subset.eq V$ um subconjunto de nós anotados com classes em $cal(Y)$. Classificacão de nós consiste no problema de classificar os nós em $V_l^c = V \\ V_l$. Como exemplo, sistemas de detecção de fraude na Internet objetivam verificar a legitimidade da identidade de usuários; para isso, esses sistemas binariamente classificam como legítimo ou fraudulento os nós de uma rede de pessoas que interagem com alguma interface on-line. Existem duas diferenças essenciais entre classificação de nós em um grafo e os cenários canônicos de classificação em problemas de aprendizado supervisionado. Primeiro, supomos que o grafo, e logo seus nós/amostras, é inteiramente observado e que apenas não conhecemos as classes de algum subconjunto dos nós; em contraste, métodos convencionais de classificação não permitem a classificação de amostras não observadas durante o treinamento do modelo —i.e., classificação de nós costuma ser uma tarefa transdutiva, enquanto métodos convencionais focam em aprendizado indutivo. Segundo, as amostras em um grafo são intrinsecamente correlacionadas e então descumprem a típica suposição de independência distribucional assumida pelos métodos historicamente relevantes de classificação - como os modelos lineares; essa inconsistência explica a efetiva inutilidade destes métodos à classificação de nós em grafos e, no passado, incentivou o desenvolvimento de procedimentos que incorporam a estrutura correlacional das amostras em seus mecanismos de inferência. Circunstancialmente,
as GNNs exploram a correlação induzida nas amostras pelo seu grafo subjacente e as informações não estruturais para classificar os nós não anotados em um grafo.

*Inferência relacional (predição de aresta)*. Seja $G = (V,E)$ um grafo e suponha que observamos o grafo parcial $hat(G)=(V, hat(E))$ com $hat(E) subset E$; o objetivo da inferência relacional é identificar as arestas (relações) não observadas $E \ hat(E)$. Por exemplo, a estimativa da probabilidade de que um par de indivíduos se conhece em uma mídia social é crucial para aumentar o engajamento dos usuários com a plataforma e corresponde a uma instanciação do problema de inferência relacional. Em outra direção, a descrição de como as diferentes proteínas interagem para permitir o desenvolvimento de um organismo é um dos problemas fundacionais de biologia molecular e é equivalente à predição de arestas no grafo de interação entre proteínas (chamado de interatoma). Enfaticamente, a inferência relacional, como a classificação de nós, transcende as fronteiras dos algoritmos tradicionais de aprendizagem de máquina ao exigir o tratamento de amostras correlacionadas para identificar as arestas prováveis em um espaço combinatoriamente grande de arestas possíveis. Em contraste, as GNNs eficientemente utilizam a topologia da rede e os atributos dos nós para precisamente inferir a existência de arestas de G não observadas em $hat(G)$.

*Classificação e regressão de grafos*. Alguns problemas exigem o tratamento de bases de dados relacionais em que as instâncias são objetos representados como grafos. O químico que almeja enumerar os efeitos colaterais de determinado medicamento, por exemplo, está tipicamente equipado com um conjunto de outros medicamentos com efeitos colaterais metabolicamente reconhecíveis; e cada medicamento é epistemicamente representado por uma estrutura molecular equivalente a um grafo. Esta categoria de problemas de inferência em grafos é a mais similar e receptiva à abordagem tradicional de aprendizagem de máquina; neste caso, cada grafo corresponde a uma amostra independente e presumivelmente identicamente distribuída  as outras. A dificuldade incide na geração de representações vetoriais suficientemente informativas dos grafos para maximizar a eficácia de procedimentos de classificação e de regressão subsequentemente aplicados a estas representações. Notadamente, as redes neurais para grafos naturalmente aprendem representações latentes dos nós que podem ser sucessivamente agregadas e então exploradas em algoritmos de inferência canônicos de aprendizagem de máquina.

#figure(
  image("images/gnn-uses.png"),
  caption: [
    Representação visual de cada um dos três usos de GNNs discutidos
  ],
)

== Passagem de Mensagem
As redes em grafo funcionam de forma que as informações de cada nó são passadas para seus vizinhos, que por sua vez passam as informações para seus vizinhos, e assim por diante. Esse processo é chamado de *passagem de mensagem* (message passing). A passagem de mensagem é um processo iterativo que ocorre em $T$ rodadas, onde $T$ é um hiperparâmetro do modelo. Em cada rodada $t$, cada nó $v$ recebe mensagens de seus vizinhos $cal(N)(v)$ e atualiza seu estado com base nessas mensagens. Podemos dividir o processo aplicado à cada nó como:
$
  m_v^((t)) &= "AGGREGATE"^((t)) ({h_u^((t-1)), forall u in cal(N)(v)}) wide &forall v in V   \

  h_v^((t)) &= "UPDATE"^((t)) (h_v^((t-1)), m_v^((t))) wide &forall v in V
$
de forma que $h_v^((0)) = x_v$

As funções $"AGGREGATE"$ e $"UPDATE"$ são funções que variam dependendo da implementação, de forma que diferentes implementações de GNNs podem ser obtidas. A função $"AGGREGATE"$ é responsável por agregar as informações dos vizinhos de um nó, enquanto a função $"UPDATE"$ é responsável por atualizar o estado do nó com base nas informações agregadas. A escolha dessas funções é crucial para o desempenho da GNN e pode ser feita de várias maneiras, incluindo somas, médias, máximos ou redes neurais.

Podemos reformular de forma mais compacta a passagem de mensagem definindo:
$
  H^((t)) = mat(
    -,h_1^((t)),-;
    ,dots.v,;
    -,h_(|V|)^((t)),-
  )

  \

  M^((t)) = mat(
    -,m_1^((t)),-;
    ,dots.v,;
    -,m_(|V|)^((t)),-
  )
$
então reescrevemos os passos anteriores como
$
  M^((t)) = "AGGREGATE"^((t)) (A, H^((t-1)))   \

  H^((t)) = "UPDATE"^((t)) (H^((t-1)), M^((t)))
$

== Graph Convolutional Network (GCN)
Popularizou as GNNs por sua simplicidade. É um modelo baseado em message-passing, onde a função de agregação é uma média ponderada dos vizinhos de um nó e a função de atualização é uma rede neural simples. A GCN é definida como:
$
  m_v^((t)) &= sum_(u in cal(N)(v)) (h_u^((t-1)))/(sqrt(overline(d)_u overline(d)_v)) wide &forall v in V   \

  h_v^((t)) &= sigma((1/overline(d)_v h_v^((t-1)) +  m_v^((t))) Theta_t) wide &forall v in V
$

onde $Theta_t$ é uma matriz de pesos aprendida durante o treinamento e $overline(d)_v$ é o grau do nó $v$ com self-loops. A função de ativação $sigma$ é geralmente uma função não-linear como ReLU ou sigmoid. Podemos reescrever a GCN de forma matricial como:
$
  H^((t)) = sigma(D^(-1/2) A D^(-1/2) H^((t-1)) Theta_t)
$


#pagebreak()

#bibliography("works.bib", title: "Referências")
