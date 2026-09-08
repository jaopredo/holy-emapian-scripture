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
    Séries Temporais
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
  = Introdução às Séries Temporais
]

#pagebreak()

== Definições

#definition("Série Temporal de Tempo Discreto")[
  Conjunto de observações $y_t$ registradas em intervalos de tempo específico $t$ medidas de forma *discreta*.
  $
    {y_t}|_(t=1)^T
  $
]

#example[
  A temperatura de uma região registrada *diariamente*
]

#definition("Modelo de Séries Temporais")[
  Um modelo de séries temporais para ${y_t}$ é a *especificação da distribuição conjunta* de uma *sequência de variáveis aleatórias* ${Y_t}$ das quais ${y_t}$ é esperada ser uma realização
  $
    PP(X_1 <= x_1,...,X_n<=x_n), -infinity < x_1,...,x_n < infinity, n=1,2,...
  $
]

Modelar essa distribuição é muito complexo, pois temos acesso apenas à uma realização da série temporal ${Y_t}$. Para contornar essa limitação, focamos nos momentos de *primeira* e *segunda* ordem
$
  EE[Y_t] "e" EE[Y_t Y_(t+h)]
$

== Por que modelar séries temporais é importante?
Até agora, discutimos principalmente o tratamento de dados que não possuem uma estrutura temporal. No entanto, muitas vezes nos deparamos com dados onde o tempo desempenha um papel crucial.

=== Dependência Temporal dos Resíduos
Quando os modelos discutidos anteriormente não conseguem capturar completamente a estrutura dos dados, pode restar uma dependência temporal nos resíduos. Isso significa que as
observações ao longo do tempo estão correlacionadas, e essa dependência não foi removida.

Modelar essa dependência temporal pode levar a previsões mais precisas, pois aproveitamos a
informação contida na sequência temporal dos dados.

=== Como identificar dependência temporal nos resíduos?
Podemos utilizar ferramentas que vamos conhecer ao longo do curso, como gráficos de
autocorrelação (ACF) e testes estatísticos (como o teste de Ljung-Box) para identificar padrões
temporais nos resíduos. Esses métodos nos ajudam a verificar se há correlação significativa entre os resíduos em diferentes lags temporais.

=== Como modelar essa dependência?
Uma vez identificada a dependência temporal, podemos usar modelos de séries temporais, como
por exemplo os modelos auto-regressivos (AR), modelos de média móvel (MA) ou modelos
ARIMA, que são projetados para capturar e modelar essas dependências de maneira eficaz.

=== Usos
Existem $3$ usos complementares *principais* para séries temporais:

*Descrever*. Entender o que aconteceu na série: tendência, sazonalidade, choques, mudanças de regime. A pergunta é interpretativa — _o que o traço temporal revela?_

*Diagnosticar*. Avaliar se um modelo (clássico com covariáveis, baseline ingênuo, etc.) ainda deixou memória no tempo nos resíduos. Se os erros em $t$ e em $t+h$ ainda se relacionam de forma sistemática, a estrutura temporal não foi absorvida. Ferramentas formais de identificação (por exemplo ACF e testes como Ljung-Box) entram mais adiante no curso; o ponto conceitual já agora é: diagnóstico temporal é parte do trabalho, não um acessório opcional.

*Prever*. Produzir expectativas para $t+1,...,t+h$ com base no passado disponível até .
Previsão boa não é apenas “ajustar bem o histórico”; é generalizar para a frente, sob a mesma seta do tempo



#pagebreak()

#align(center + horizon)[
  = Modelagem Clássica aplicada ao Tempo
]

#pagebreak()

== Modelo linear padrão
É o modelo mais simples que podemos utilizar para modelar a dependência entre uma variável dependente $y_t$ e variáveis explicativas $x_(i t)$ ao longo do tempo. Já vimos esse modelo $n$ vezes nos semestres passados, então vou reescrever apenas os passos mais importantes
$
  y_t = beta_0 + sum_(i = 1)^P beta_i x_(i t) + epsilon_t wide epsilon_t ~ N(0, sigma^2)
$
ou, em forma matricial
$
  y = X beta + epsilon wide epsilon ~ N(0, sigma^2 I) => y ~ N(X beta, sigma^2 I)
$
onde $y in RR^T$ é o vetor das observações da variável dependente, $X in RR^(T times P)$ é a matriz de observações das variáveis explicativas, $beta in RR^P$ é o vetor de pesos atribuindo a importância de cada parâmetro para explicar $y$ e $epsilon in RR^T$ é um ruído gaussiano. Com essa estrutura, podemos obter o estimador de máxima verossimilhança de $beta$
$
  hat(beta) = (X^T X)^(-1) X^T y
$

== Balanço Viés-Variância
Vale relembrar que dentro do ramo da estatística (inclusive das séries temporais), sempre existirá o balanço *viés e variância*. O erro mais comum de se minimizar em contextos estatísticos é o erro quadrático médio
$
  EE[(y_t - hat(y)_t)^2] = "Bias"(hat(y)_t)^2 + VV[hat(y)_t]^2 + sigma^2
$

Obter modelos mais precisos na previsão de $y_t$ (com menos viés) acaba resultando em modelos com variação alta (mudanças pequenas nos dados podem impactar muito os resultado) e vice-versa

== Regularização Lasso e Ridge
Quando temos muito mais parâmetros do que amostras, o modelo pode se tornar muito instável, e isso pode ser recorrente na análise de séries temporais. Pode ocorrer de um paciente poder ser analisado por apenas 3 semanas, enquanto o modelo leva em conta 15 informações sobre o mesmo. Nesses cenários, podemos introduzir um parâmetro de regularização em nossos modelos

=== Lasso (Least Absolute Shrinkage and Selection Operator)
Em vez de minimizarmos simplesmente o erro quadrático, adicionamos um peso nos valores absolutos dos coeficientes, de forma que se eles crescem muito em módulo, a nossa função de perca não diminui como esperado
$
  sum_(t=1)^T (y_t - hat(y)_t)^2 + lambda sum_(i=1)^P |beta_i|
$
essa abordagem tente a zerar alguns coeficientes, indicando quais coeficientes realmente influenciam ou não

=== Ridge Regression
Em vez dos valores absolutos, usamos a soma dos quadrados
$
  sum_(t=1)^T (y_t - hat(y)_t)^2 + lambda sum_(i=1)^P beta_i^2
$
essa abordagem não costuma zerar os coeficientes, mas os puxa para muito próximo de $0$

== Generalized Additive Models (GAM)
Extensão dos modelos lineares, permitindo que cada variável possua uma função não-linear associada com ela. A estrutura do GAM é dada por
$
  y_t = f_1 (x_(1 t)) + ... + f_p (x_(p t)) + epsilon_t
$

Aqui, $f_j (dot)$ são funções não-lineares suaves que modelam a relação entre $y_t$ e $x_(j t)$. O exemplo mais conhecido de GAM são os modelos polinomiais

== Deep Learning (DL)
Em deep learning, expressamos a relação entre $y_t$ e suas covariáveis através de uma função complexa $f$
$
  y_t = f(x_(1 t), ..., x_(p t)) + epsilon_t
$
onde $f$ é uma função altamente flexível modelada por uma rede neural, capazes de capturar padrões complexos e não-lineares dos dados

=== Janelas, Batches e Seta do Tempo
As redes neurais, durante seu treinamento, assumem uma hipótese que muitas vezes esquecemos, mas que são MUITO importantes no nosso contexto. Os dados *podem ser trocados*, eu posso embaralhar minhas amostras *sem perca de informação*. No entanto, o conceito de séries temporais não permite essa premissa, o que podemos fazer para mitigar isso? É aí que entram as *janelas*, onde empacotamos o passado e a dependência temporal entre elas. Por exemplo, imagine que temos a seguinte sequência:
$
  {10, 12, 9, 14, 11, 13, 8, 15...}
$
para podermos alimentar essas informações em uma rede neural, vamos criar uma janela de tamanho $3$ e gerar nossos conjuntos de dados e alvo
$
  "Janela 1" -> {10, 12,  9}  ->  14    \
  "Janela 2" -> {11,  13, 8}  ->  15    \
$

perceba que eu sempre pego um conjunto de $3$ valores e digo que o valor resultante (alvo) deve ser o seguinte e assim por diante. Dessa forma, a ordem *entre janelas* passa a ser irrelevante pois a informação de passado e como ele influencia na resposta está incorporada na própria janela. No entanto, vale ressaltar que a ordem *dentro da janela* é *sagrada* e *nunca deve ser alterada*, do contrário a informação temporal entre amostras *se perde*

Como nem tudo são flores, existem alguns pontos de atenção que devemos tomar cuidado. O primeiro é quando formos separar nossos dados nos conjuntos de *treino* e *teste*. Não podemos, ao realizar a divisão, criar janelas com dados em conjuntos diferentes. Por exemplo, se temos a seguinte série, e fazemos a seguinte separação:
$
  {underbrace("10, 12, 9, 14, 11", "TREINO"), underbrace("13, 8, 15", "TESTE")...}
$
em hipótese alguma podemos, dentro das nossas janelas de treino, ter uma janela tipo ${14, 11, 13}$, pois estariamos misturando pontos de treino e teste, de forma que nosso modelo estaria vendo o futuro fora do controlado

Além disso, devemos tomar cuidado com *janelas sobrepostas*. Como falei antes, criamos as janelas para que elas possam ser independentes, no entanto, é possível criar janelas que não são independentes (ainda podemos embaralhar elas como artimanha computacional). Por exemplo, dado a série:
$
  {10, 12, 9, 14, 11, 13, 8, 15, ...}
$
as janelas ${10, 12, 9}$ e ${12, 9, 14}$ se sobrepõe, de tal forma que elas NÃO são independentes pois contém a mesma parcela do passado e como ela influencia nos valores internos. O ponto é que, para um SGD, você *pode* embaralhar essas janelas, mas isso não lhe permite tratá-las como *independentes*


#pagebreak()

#align(center + horizon)[
  = Diagnóstico Visual
]

#pagebreak()

== Introdução
Antes de testes formais, ARIMA, ACF, PACF, etc., podemos fazer um diagnóstico visual da série temporal. O objetivo é identificar padrões, tendências, sazonalidades e possíveis anomalias nos dados. Essa análise inicial nos ajuda a formular hipóteses sobre o comportamento da série e a escolher modelos apropriados para previsão. Podemos primeiro pensar na série como
$
  y_t = T_t + S_t + R_t
$

onde $T_t$ representa a tendência (nível que a série se move no médio/longo prazo), $S_t$ a sazonalidade (padrões que se repetem em intervalos fixos) e $R_t$ os resíduos (por definição, o que sobra após fixar $T_t$ e $S_t$)

#example[
  Vamos analisar a seguinte figura

  #figure(
    image("images/A1/tsr-example.png")
  )

  Visualmente conseguimos identificar cada um dos componentes da série temporal.

  *$T$*: No médio/longo prazo, a tendência é um crescimento linear, com inclinação positiva. Mesmo que existam flutuações de subida e descida, é perceptível que a cada a no o valor de $y_t$ tende a aumentar.
  *$S$*: A série mostra uma sazonalidade de subida no inicio de cada ano e descida no final, mostrando um padrão anual claro (mas de forma que a descida sempre se mantém acima do padrão anterior, gerando a tendência positiva citada anteriormente)
]

== Covariáveis
Dentro dessa estrutura, podem existir também *covariáveis explicativas* que influenciam a série temporal. Por exemplo, em uma série de vendas de um produto, fatores como campanhas de marketing, feriados ou eventos especiais podem afetar os valores observados. Incorporar essas covariáveis nos modelos pode melhorar a precisão das previsões e fornecer insights sobre os fatores que impactam a série. Ainda dentro do nosso framework visual, podemos introduzir essas covariáveis como
$
  y_t = underbrace(T_t + S_t, "Estrutura Temporal") + underbrace(x_t^T beta, "Covariáveis") + R_t
$

Na prática, $T_t$ e $S_t$ são incorporados dentro de $x_t$ e não são derivados explicitamente, mas é importante entender que eles existem e como eles caracterizam a série temporal. A análise visual pode nos ajudar a identificar quais covariáveis podem ser relevantes para o modelo e como elas se relacionam com os padrões observados na série.

== Tendência
Tendência é o movimento lento do nível da série: crescimento, queda ou platô ao longo de muitos períodos. Em dados mensais, uma média móvel com janela da ordem de um ano (por exemplo 12) alisa oscilações curtas e ajuda a ver esse nível. A média móvel aqui é ajuda visual, não um modelo formal

#figure(
  image("images/A1/tsr-trend.png", width: 100%),
  caption: "Exemplo de tendência em uma série temporal"
)

== Sazonalidade
Sazonalidade é estrutura que se repete em fases do calendário (mês do ano, dia da semana, hora do dia, ...). Distinguir sazonalidade de “subiu uma vez e nunca mais” é parte da descrição. Três gráficos olham a mesma sazonalidade, mas respondem perguntas diferentes.

*Overlay por ano*. Eixo = mês; uma linha por ano. Serve para ver *o ciclo se repetindo*: o formato do ano (pico/vale em quais meses); se o padrão é estável ou muda de ano para ano (linhas parecidas vs. um ano “fora”); a amplitude. Anos mais “altos” no gráfico ainda carregam tendência — o formato relativo é o que importa

#figure(
  image("images/A1/tsr-seasonality-overlay.png", width: 100%),
  caption: "Exemplo de sazonalidade em uma série temporal (overlay por ano)"
)

*Série sem tendência*. Plotar $y_t$ menos a média móvel (12) no calendário real. Serve para ver a *onda anual na seta do tempo*, depois de tirar o nível lento $T_t$. Dá para ver se a oscilação volta
todo ano (liga a $S_t$) e se a amplitude muda ao longo dos anos. Ainda mistura sazonalidade + ruído — não é puro.

#figure(
  image("images/A1/tsr-seasonality-detrended.png", width: 100%),
  caption: "Exemplo de sazonalidade em uma série temporal (série sem tendência)"
)

*Boxplot por mês*. Resume o nível típico de cada mês, agregando os anos. Serve para o ranking (quais meses são sistematicamente mais altos/baixos), a dispersão dentro do mês (caixa larga = aquele mês varia muito entre anos) e outliers. Não mostra a trajetória no tempo — cada mês aparece uma vez.

#figure(
  image("images/A1/tsr-seasonality-boxplot.png"),
  caption: "Exemplo de boxplot por mês"
)

Em uma frase: overlay = “como o ano se parece”; sem tendência = “a onda no tempo”; boxplot = “estatística por mês”

== Resíduos
Por definição $R_t = y_t - (T_t + S_t)$, ou seja, o que sobra após extraírmos a tendência e a sazonalidade. Tomemos por exemplo o seguinte gráfico

#figure(
  image("images/A1/tsr-not-residuals.png", width: 100%),
  caption: "Exemplo de resíduos em uma série temporal"
)

Aqui, estratificamos $T$ que é a média móvel, no entanto, o gráfico ainda contém a estrutura da *sazonalidade*. Podemos, nesse caso, interpretar a sazonalidade como a *média mensal* de $y_t - T_t$ (detalhes serão melhor compreendidos posteriormente). Removendo essa sazonalidade $S_t$, então obtemos um gráfico dos resíduos

#figure(
  image("images/A1/tsr-residuals.png", width: 100%),
  caption: "Exemplo de resíduos em uma série temporal"
)

Essa extração visual é temporária, serve no momento para termos um entendimento do que são resíduos e como eles se comportam. Posteriormente, vamos aprender a extrair $T$ e $S$ de forma formal, utilizando modelos estatísticos

== Split Temporal
Comentamos anteriormente sobre, para fazer modelos preditivos das séries temporais, para separar eles em *treino* e *teste*. Sendo mais formal, isso é feito a partir de um *split temporal*, onde, ao invés de embaralhar os dados, pegamos uma parte inicial da série para treino e uma parte final para teste a partir de uma data-fronteira.

#figure(
  image("images/A1/tsr-split.png", width: 100%),
  caption: "Exemplo de split temporal em uma série temporal"
)

#pagebreak()

#align(center + horizon)[
  = Estacionariedade e ACF
]

#pagebreak()



#pagebreak()

#align(center + horizon)[
  = Previsão e Baselines
]

#pagebreak()



#pagebreak()

#align(center + horizon)[
  = Diagnóstico de Resíduos
]

#pagebreak()



#pagebreak()

#align(center + horizon)[
  = Métricas de Avaliação
]

#pagebreak()



#pagebreak()

#align(center + horizon)[
  = Transformações
]

#pagebreak()



#pagebreak()

#align(center + horizon)[
  = Modelo AR e PACF
]

#pagebreak()



#pagebreak()

#align(center + horizon)[
  = Modelos MA e Invertibilidade
]

#pagebreak()
