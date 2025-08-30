#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#import "@preview/wrap-it:0.1.1"
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
    Ciência de Redes
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
  = Grafos
]

#pagebreak()

De antemão valhe ressaltar que essa matéria, por mais que seja chamada de *Ciência de Redes*, o termo *rede* se refere a um grafo, não ao tipo específico de grafo que se é visto em *Fluxo em Redes* quando estudamos matemática discreta. Então que já fique esclarecido de antemão que, ao citarmos redes, estamos nos referindo a um grafo no geral, desde que o contrário seja explicitado

Essa sessão será apenas algumas definições que não foram passadas no curso de Matemática Discreta, então conceitos que forem citados sobre grafos e não houver definição nesse resumo, a mesma estará no recap de Matemática Discreta. Aqui segue algumas notações sobre grafos para que não fique confuso:

- $G(V, E) :=$ Grafo com conjunto de vértices $V$ e de arestas $E$ (edges)
- $N(v) :=$ Vizinhança do vértice $v$ (Neighbourhood)
- $delta(v) :=$ Grau do vértice $v$
- $K_n :=$ Grafo completo com $n$ vértices
- $K_(m,n) :=$ Grafo completo bipartido com $m$ vértices no primeiro conjunto e $n$ vértices no segundo
- $Chi(G) :=$ Número cromático de $G$
- $Chi'(G) :=$ Número cromático por arestas de $G$

#definition("Grau Médio")[
  Dado um grafo não-dirigido $G(V,E)$, o grau médio de $G$ é:
  $
    delta_"med" (G) := 1/(|V|) sum_(v_i in V) delta(v_i)
  $
  Se G é dirigido, podemos definir os graus médios de entrada e saída
  $
    delta_"med"^"in" (G) := 1/(|V|) sum_(v_i in V) delta^"in" (v_i) space space space "Entrada"
  $
  $
    delta_"med"^"out" (G) := 1/(|V|) sum_(v_i in V) delta^"out" (v_i) space space space "Saída"
  $
]

#definition("Distribuição do Grau")[
  A distribuição do grau de um Grafo $G(V,E)$ é a distribuição da variável aleatória $X$, sendo $X$ o grau do vértice que eu escolho ao acaso
]

*Para os teoremas a seguir e daqui em diante, consideremos a matriz de incidência de forma que $A_(i j) = 1$ se a aresta $j$ se conecta no vértice $i$ e, 0 do contrário (-1 se $G$ for dirigido).*

#theorem[
  Dado um grafo $G(V,E)$ e sua matriz de incidência $A$, temos que:
  $
    "nº de ciclos" = |E| - "posto"(A)
  $
]
#proof[
  $
    "posto(A)" + dim(N(A)) = |E| \
    <=> |E| - "posto(A)" = dim(N(A))
  $

  Porém, a dimensão do núcleo de $A$ é a quantidade de ciclos no grafo, então eu tenho que:

  $
    "nº de ciclos" = |E| - "posto"(A)
  $
]

#definition("Coeficiente de Clustering")[
  Dado um grafo $G(V,E)$, o coeficiente de clustering de um nó $v in V$ é:
  $
    C(v) := (2 E_v) / (delta(v) ( delta(v)-1 ))
  $
  onde $E_v$ é a quantidade de arestas ligadas aos nós vizinhos
]

#pagebreak()

#align(center + horizon)[
  = Medidas de Centralidade
]

#pagebreak()

Quando estamos vendo aplicações reais de grafos, é muito comum querermos ver o "quão importante" um nó é no contexto que estamos analisando. Por exemplo, se nosso grafo representa as conexões entre servidores que um pacote pode percorrer, faz muito sentido querermos ver qual o servidor que quase todos os pactes percorrem

#image("images/graph.png")

Imagine que esse é o grafo que estávamos falando (Não importa o que ele representa de verdade, só finge que é o caso que falamos), então o nó azul tem uma importância MUITO grande, mas como podemos medir isso? Nem sempre o grafo vai ta arrumadinho assim pra gente. Daí que surgem as medidas de Centralidade.

#definition("Farness/'Lonjura'")[
  Dado um grafo $G(V,E)$, a farness de um vértice $v_i$ é dada por
  $
    L(v_i) := sum_(v_i != v_j in V) d(v_i, v_j)
  $
  onde $d(v_i, v_j)$ é o tamanho do menor caminho entre $v_i$ e $v_j$
]

Essa medida mede o quão longe o nó está dos outros, de forma que, quanto maior essa medida é, menos importante o meu nó é (Depende do contexto analisado)

#definition("Closeness/Proximidade")[
  Dado um grafo $G(V,E)$, a proximidade/closeness do vértice $v_i in V$ é dada por:
  $
    C(v_i) := (|V|)/L(v_i)
  $
  Por convenção, se $v_i$ e $v_j$ estão em componentes conexas separadas em $G$, então $d(v_i, v_j) = infinity$, o que torna a definição de antes inútil, então podemos redefinir como:
  $
    C(v_i) := 1/(|V|) sum_(v_i != v_j in V) 1/d(v_i,v_j)
  $
]

#definition("Betweeness/Intermediação")[
  Dado um grafo $G(V,E)$ e $P(v_i,v_j)$ o conjunto de todos os menores caminhos possíveis entre $v_i$ e $v_j$, então a intermediação de $v_i$ é:
  $
    B(v_i) := sum_(v_s, v_t in V)( |c in P(v_s,v_t) ; v_i in c| ) / (| P(v_s,v_t) |)
  $
]

Saindo um pouco dessas definições, vamos tentar pensar em alguma medida mais básica e intuitiva. Uma medida bem padrão que podemos pensar logo de cara é simplesmente o grau do vértice, já que, quanto mais vértices ele se ligar, mais importante ele é! Em muitas literaturas sobre redes o grau do vértice é chamado de *Centralidade de Grau*.

Um outro pensamento que pode surgir a partir desse é: "Poxa, meu vértice tem um grau alto, então ele é importante, mas eu quero valorizar aqueles vértices que se conectam com ele, afinal, se ele é importante, os vértices que estão diretamente ligados nele também são, não é?", e esse pensamento não está errado! É dessa ideia que surge a centralidade por autovetor. Funciona assim: Vamos inicialmente assumir que todos os nossos vértices $v_i$ tem importância $x^((0))_i = 1$, o que não me é muito útil agora, porém, vamos tentar fazer uma nova estimativa baseada nos vizinhos, que tal a nova centralidade do vértice $v_i$ ser a soma da centralidade dos vizinhos? Isso faz com que a importância do $v_i$ se baseie no quão importante são seus vizinhos! Eu posso expressar isso com uma fórmula:
$
  x^((1))_i = sum_(j)A_(i j)x^((0))_j
$
Onde $A$ é minha matriz de adjacência. Se meu nó $v_i$ não é vizinho de $v_j$, então $A_(i j) = 0$ o que faz com que minha centralidade $x^((0))_j$ não seja somada. Posso reformular isso de forma matricial:
$
  x^((1)) = A x^((0))
$
onde $x^((k))$ é o vetor com entradas $x_i^((k))$. Se fizermos esse processo várias vezes, depois de $k$ passos, vamos ter algo do tipo:
$
  x^((k)) = A^k x^((0))
$
Tomemos a liberdade, então, de escrever $x^((0))$ como uma combinação linear dos autovetores $w_j$ de $A$ de forma que
$
  x^((0)) = sum_(j=1)^n c_j w_j
$
Para alguma escolha apropriada de $c_j$. Então temos:
$
  x^((k)) = A^k sum_(j=1)^n c_j w_j = sum^n_(j=1) c_j lambda_j v_j = lambda_1^k sum_(j=1)^n c_j (lambda_j/lambda_1)^k w_j
$

De forma que $lambda_j$ são os autovalores de $A$ e $lambda_1$ pode ser, sem perca de generalização, o maior de todos em módulo. Como $lambda_i\/lambda_1 < 1 space forall lambda_i "com" i!=j$, então:
$
  lim_(k->infinity) sum_(j=1)^n c_j lambda_j^k w_j = c_1 lambda_1 w_1
$

Ou seja, o vetor de centralidades que limita as centralidades que eu fiz antes é proporcional ao autovetor associado ao maior autovalor de $A$, que é equivalente a dizer que o vetor de centralidades $x$ satisfaz:
$
  A x = lambda_1 x
$

#definition("Centralidade Autovalor")[
  Seja $r$ um vetor com as centralidades dos vértices $v_i$ de uma rede $G$ de forma que $r_i = "centralidade de" v_i$, então:
  $
    A r = lambda_1 r
  $
  onde $lambda_1$ é o maior autovalor de $A$
]

Agora temos outro problema. Quando temos um grafo dirigido, essa medida de centralidade autovalor já não funciona, já que se um nó não tem nenhuma aresta apontando para ele (Apenas saem arestas dele), ele não terá sequer uma centralidade, e isso afeta não só esse vértice como os vértices que ele aponta, que não terão nenhuma "pontuação" adicionada por serem apontados por esse vértice, e isso não pode ocorrer, já que não faz muito sentido na maioria das aplicações práticas. O que podemos fazer para contornar isso? Então entra a solução a seguir:
$
  x_i = alpha sum_j A_(i j)x_j + beta
$

Onde $alpha$ e $beta$ são constantes positivas. O primeiro termo é a centralidade autovetor que vimos antes, porém o termo $beta$ garante que os nós que comentei anteriormente (Sem grau de entrada) possuam uma pontuação e possam contribuir para a pontuação dos nós que eles apontam. Essa medida é interessante por conta do termo $alpha$ que balanceia o termo constante e a medida de centralidade autovetor. Podemos expressar isso de forma matricial:
$
  x = alpha A x + beta bold(1)
$

Onde $1 = (1, ..., 1)$. Se rearranjarmos para $x$, obtemos:
$
  x = beta(I - alpha A)^(-1) bold(1)
$

Normalmente colocamos $beta = 1$ pois não estamos interessados em saber o valor exato das centralidades, mas saber quais vértices são ou não mais ou menos centrais.
$
  x = -alpha (A - 1/alpha I)^(-1)
$
Perceba que eu quero que $A - 1/alpha I$ seja invertível, e isso acontece quando $1/alpha != lambda_j$ onde $lambda_j$ são os autovalores de $A$. Ou seja, o meu $alpha$ não é completamente arbitrário, eu vou ter que analisar o contexto da minha aplicação. Porém, muito comumente, se é utilizado $alpha = 1/lambda_1$ com $lambda_1$ sendo o maior autovalor

#definition("Centralidade de Katz")[
  Dado uma rede $G(V,E)$ e duas contantes $alpha, beta > 0$, o vetor de centralidades de katz de todos os nós em $V$ é:
  $
    K(V) = beta (I - alpha A)^(-1) bb(1)
  $
  Onde $A$ é a matriz de adjacência de $G$. ($K(V) in RR^(|V|)$)
]

Um outro tipo de medida surge quando queremos responder a questão: "Se eu estou navegando entre meus nós, ao longo prazo, qual é o nó que eu mais vou percorrer/parar nele?". Um exemplo são páginas na internet que referenciam entre si, daí surge o nome da medida: *PageRank*. O que fazemos essencialmente é transformar a rede em uma cadeia de markov. Por exemplo:

#figure(
  caption: [Grafo de Exemplo 1],
  image("images/example-network.png")
)

Vamos supor que estamos no nó 4 e queremos escolher aleatoriamente entre os nós 3 e 1 para irmos, como podemos ver na distribuição dos pesos (Nesse exemplo, isso indica que a página 4 tem 2 links referenciando a página 1 e apenas 1 link referenciando a página 3), então teríamos:
$
  PP(4->3) = 1/3 \
  PP(4->1) = 2/3
$

E fazemos isso definindo uma matriz estocástica $H$ de tal forma que:
$
  H_(i j) = A_(i j)/( sum_k^n A_(i k) )
$

Com $A$ sendo a matriz de adjacência. De forma que a soma de todos os elementos de uma coluna dê $1$. Agora que vem o truque interessante. Dado um vetor $p in RR^n$ de forma que cada entrada de $p_i$ representa a chance de eu ir do nó que eu estou para o nó $v_i$ (Ou seja, $p$ tem que ser alguma coluna de $H$), ao fazer a operação:
$
  H p
$
Eu estou ponderando as probabilidades de $p$ com os seus respectivos nós, ou seja, $(H p)_k$ representa a probabilidade esperada de que, ao sair do nó $v_i$, eu vá para o nó $v_k$. Se isso é verdade e, como eu defini antes, eu quero saber qual nó é mais visitado conforme se passa o tempo, faz sentido eu refazer esse processo inúmeras vezes, então eu tenho uma centralidade do vértice $v_i$:
$
  r = lim_(t -> infinity) H^t p
$

Com $p$ sendo a $i$-ésima coluna de $H$. Porém isso ainda nos trás um problema, veja essa outra rede:

#figure(
  caption: [Grafo de Exemplo 2],
  image("images/example-network-2.png")
)

Veja que, por conta do nó 6, eu não posso transformar meu esquema em uma cadeia de markov, pois eu teria uma coluna de 0, e no caso dos nós 7 e 8 eu teria um problema por conta que eles sempre vão um para o outro. Como podemos resolver isso? O PageRank vem para resolver isso. Vamos pensar no caso da internet, você navegador aleatório, uma hora, pode se cansar de estar onde estar, e visitar uma página aleatoriamente dentro da sua rede, e é nessa ideia que trabalhamos em cima.

Definimos um $alpha in (0, 1)$, onde podemos interpretar $alpha$ como a chance do meu navegador permanecer no meu nó. Definimos então nossa nova matriz de chances da seguinte forma:
$
  GG = alpha H + (1 - alpha)C
$
De forma que $C$ é uma matriz $n times n$ com todas as entradas iguais a $1\/n$ para representar um dirigido onde todos os nós apontam para todos os outros nós (Representando a ideia de que eu posso ir para o nó que eu quiser). Porém, há uma propriedade que, se eu tenho uma combinação convexa entre duas matrizes estocásticas/markovianas, então o resultado é uma matriz markoviana. Ou seja, eu ainda posso aplicar a mesma ideia de antes do vetor $p_0$ inicial e aplicar o limite, assim, eu vou obter meu vetor de centralidades $r$, de tal forma que
$
  lim_(t -> infinity) GG^t p_0 = r
$

#definition("PageRank")[
  Sejam a matriz $GG$ como definida anteriormente e o vetor inicial $p_i$ sendo a $i$-ésima coluna de $GG$, então o vetor de centralidades PageRank $r$ onde a $k$-ésima entrada é a centralidade de $v_k$, então:
  $
    r = lim_(t -> infinity) GG^t p_0
  $
]


#pagebreak()

#align(center + horizon)[
  = Redes Aleatórias
]

#pagebreak()

== Ideia Inicial
Também chamadas de *Redes Erdös-Renyi* ou *Redes de Poisson*, são tipos de redes que vão se montando aleatoriamente. Por exemplo, imagine que você está em uma festa e o anfitrião está fornecendo um vinho da melhor qualidade, mas ele não avisou ninguém. Um convidado curioso, por acidente, provou desse vinho e *adorou*, então ele vai contar para as pessoas da festa. A pergunta é, para quem ele vai falar? Ele vai falar para todos? Vai sobrar vinho para você?

Em cima disso conseguimos montar as redes aleatórias, onde cada par de nós (Aresta) é formado de acordo com uma *probabilidade*

#definition("Rede Aleatória")[
  Uma rede aleatória é um grafo $G(V,E)$ de $|V| = N$ nós onde cada par de nós é conectado por uma probabilidade *$p$*
]

Como cada aresta tem uma probabilidade $p$ de aparecer, podemos interpretar ela como ela aparecer ou não sendo uma variável indicadora, de forma que o número total de arestas segue uma distribuição binomial. Ou seja, a probabilidade a quantidade de arestas ser $L=l$ é:
$
  PP(L=l) =  mat(mat(N;2);l) p^l (1-p)^(N(N-1)/2 l)
$
Podemos aplicar a mesma ideia para o grau de um vértice também:
$
  PP(delta(v) = k) = mat(N-1;k) p^k (1-p)^(N-1-k)
$
Já que meu vértice pode se ligar a $N-1$ vértices com probabilidade $k$, então isso vira a soma das variáveis indicadores que são $1$ quando o meu vértice se liga com outro vértice, de forma que eu tenho a soma de $N-1$ variáveis de bernoulli

Com isso, nós temos:
$
  delta_"med" (G) = (N-1)p
$

E podemos obter também a variância dos graus
$
  VV(delta(v)) = (N-1)p(1-p)
$

Então, apenas para resumir, temo que:
$
  "Número de arestas" L ~ "Bin"(mat(N;2), p)    \
  "Grau do vértice" delta(v) ~ "Bin"(N-1, p)
$

Porém, em redes reais, elas são *esparsas*, ou seja, eu tenho *muitos* nós e graus pequenos. E lembra qual é a distribuição que é a binomial com $n$ muito grande? Exato, a *Poisson*! Essas redes aleatórias também são chamadas de *redes de poisson*
$
  PP(delta(v)=k) = e^(-delta_"med" (G)) ( delta_"med" (G)^k )/k!
$
Ou seja, para $N$ muito grande e $k$ pequeno com relação a $N$, podemos estimar de forma que:
$
  "Grau do vértice" delta(v) ~ "Poisson"(delta_"med" (G))
$

== Evolução das Redes Aleatórias
Conforme iniciamos um grafo com um grau médio $0$ e vamos aumentando ele aos poucos, nós percebemos que a partir de um ponto chave, os nós começam a se agrupar em algo que chamamos de *componente gigante*, que seria a maior componente conexa da rede.

#figure(
  caption: [Gráfico que mostra a fração de nós dentro de uma grande componente conexa em função do grau médio],
  image("images/mean-degree-and-big-component-fraction.png")
)

Quanto $delta_"med" (G) < 1$, então a quantidade de nós na componente gigante é desprezível em relação à quantidade de nós na rede, porém, a partir de $delta_"med" (G) = 1$, isso indica que temos, pelo menos, $n/2$ componentes conexas, o que já começa a fazer uma diferença no gráfico.

Dado uma rede $G(V,E)$, vamos definir a fração de nós que *não está* na componente gigante como:
$
  u = 1 - N_G / (|V|)
$

De forma que $N_G$ é a quantidade de nós dentro dessa componente gigante, vamos definir essa componente como $Psi subset.eq V$. Se um nó $v_i in Psi$, então ele deve estar interligado com outro nó $v_j$, que também deve satisfazer $v_j in Psi$. Por isso, se $v_i in.not Psi$, então isso pode ocorrer por duas razões:

- ${v_i, v_j} in.not E$. A probabilidade de isso acontecer é $1-p$
- ${v_i, v_j} in E$, porém $v_j in.not Psi$. A probabilidade de isso acontecer é $p u$

Então temos:
$
  PP(v_i in.not Psi) = 1 - p + p u
$

Então a probabilidade de que $v_i$ não esteja linkado a $Psi$ por qualquer nó é de $(1 - p + p u)^(|V| - 1)$, já que temos outros $|V|-1$ nós que poderiam fazer com que $v_i$ se interligasse a componente gigante.

Sabemos que $u$ é a fração de nós que não está em $Psi$, para qualquer $p$ e $|V|$, a solução da equação
$
$
$
  u = (1 - p + p u)^(|V| - 1)
$

nos dá o tamanho da componente gigante por meio de $N_G = |V|(1-u)$. Usando $p = (delta_"med" (G)) / (|V|-1)$ e tirando $log$ de ambos os lados, para $delta_"med" (G) << |V|$ (Grau médio *muito* menor que $|V|$), obtemos:
$
  ln(u) approx (|V|-1) ln[ 1 - (delta_"med" (G)) / (|V|-1) (1 - u) ]    \

  "Tiramos exponencial e obtemos:"    \

  u approx exp { - ( delta_"med" (G) ) / (1-u) }
$

Se denotarmos $S = N_G / |V|$, obtemos que:
$
  S = 1 - e^(-delta_"med" (G) dot S)
$

== Distribuição de tamanhos de Cluster
Queremos também ter uma noção da probabilidade de um nó $v_i$ qualquer estar em um cluster (Grupo de nós na rede) de tamanho $s$. No livro do Newman, ele nos mostra que essa probabilidade é:
$
  PP(v_i in Psi_(|Psi|=s)) = e^( - delta_"med" (G) dot s ) (delta_"med" (G) dot s)^(s-1) / s!
$

== Mundos pequenos
Mundos pequenos (Small worlds) são grafos em que, independente da quantidade de vértices, a distância entre dois nós aleatórios costuma ser muito pequeno. Um exemplo é um modelo que cada nó representa todas as pessoas do mundo e as arestas indicam se elas já interagiram e se conhecem ou não (Impressionantemente), tanto que existe a teoria dos 6 graus de distância entre as pessoas

#link("https://youtu.be/TcxZSmzPw8k?si=jXPDJE_SWwNys4YM")[_Vídeo sobre o assunto (Clique aqui)_]

E se quisermos ter uma noção de o quão *não-relacionadas* duas pessoas são em uma rede social? Podemos calcular sua distância, obviamente, mas alguns algoritmos ficam computacionalmente inviáveis. Podemos então estimar uma distância média entre dois nós selecionados aleatoriamente no grafo

#wrap-it.wrap-content(
  figure(
    caption: [Grafo Árvore],
    image("images/tree-shaped-graph.png", width: 60%)
  ),
  [
    Redes aleatórias costumam ter uma topologia de árvore com praticamente um número constante de graus. Perceba então que eu posso escrever a quantidade de nós $|V|$ como:
    $
      |V| &= 1 + delta_"med" (G) +... + delta_"med" (G)^(d_"max")   \

      &= (delta_"med" (G)^(d_"max") - 1) / ( delta_"med" (G) - 1 ) 
    $
    Então vamos ter que:
    $
      d_"max" approx (log |V|) / (log (delta_"med" (G)))
    $
  ]
)
