#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#set page(width: 21cm, height: 29.7cm, margin: 1.5cm)
#set heading(numbering: "1.1.")

#let theorem = thmbox("theorem", "Teorema")
#let corollary = thmplain(
  "corollary",
  "Corolário",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definição", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Exemplo").with(numbering: none)
#let proof = thmproof("proof", "Prova")

#align(center + top)[
  FGV EMAp

  João Pedro Jerônimo
]

#align(horizon + center)[
  #text(17pt)[
    Algebra Linear Numérica
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

#outline(title: [Sumário])

#pagebreak()

As aulas abaixo referem-se ao livro de Trefethen sobre álgebra linear numérica

= Lecture 3 - Normas
*Aviso*: O capítulo sobre normas tem conceitos bastante abstratos, alguns deles não são muito *intuitivos*, então tente abstrair e aceitar que eles existem por enquanto, mais tarde mostraremos que são muito úteis.

== Normas de vetores

#definition("Norma")[
  Uma #text(weight: "bold")[norma] é uma função $|| dot ||: CC^m -> RR$ que satisfaz 3 propriedades:

  1. $||x|| >= 0$, e $||x|| = 0 <=> x = 0$
  2. $||x + y|| <= ||x|| + ||y||$
  3. $||alpha x|| = |alpha|||x||$
]

Normalmente vemos a norma-2, ou a *Norma Euclidiana*, que representa o *tamanho* de um vetor. Com base nisso, podemos definir uma *norma-p*.

#definition("Norma-p")[
  A *norma-p* de $x in CC^n$ (ou $||x||_p$) é definida como:

  #align(center)[$||x||_p = (sum_(i=1)^n|x_i|^p)^(1/p)$]
]

Então, podemos ter vários tipos de normas, de 1 até $infinity$, e também definimos isso!

#definition("Norma infinita")[
  A *norma infinita* de $x in CC^n$ (ou $||x||_(infinity)$) é definida como:

  #align(center)[$||x||_(infinity) = max|x_i|$]
]

Você provavelmente está se perguntando "por que eu precisaria de algo assim"? Mas acredite, será útil no futuro!
Existe um tipo de norma muito útil (de acordo com o livro), chamada *norma ponderada*.

#definition("Norma ponderada")[
  A *norma ponderada* de $x in CC^n$ é:
  
  #align(center)[$||x||_W = ||W x|| = (sum_(i=1)^n |w_(i i) x_i|^p)^(1/p)$]

  Onde $W$ é uma *matriz diagonal* e $p$ é um número arbitrário
]

== Normas de matrizes
O QUÊ?? MATRIZES TÊM NORMAS???? Sim, meu jovem Padawan! O livro diz que podemos ver uma matriz como um vetor em um espaço $m times n$, e podemos usar qualquer norma $m n$ para medi-la, mas algumas normas são mais úteis do que as já discutidas.

#definition("Norma induzida")[
  Dada $A in CC^(m times n)$, a norma induzida $||A||_(m -> n)$ é o menor inteiro para o qual a desigualdade é válida:

  #align(center)[$||A x||_m <= C||x||_n$]

  Em outras palavras:

  #align(center)[$||A||_(m -> n) = sup_(x != 0)(||A x||_m)/(||x||_n)$]
]

Essa definição pode parecer inútil e estúpida por enquanto, mas será muito útil quando falarmos sobre erros e condicionamento.

Uma norma útil que podemos mencionar é a norma $infinity$ de uma matriz.

#definition("Norma infinita de uma matriz")[
  Dada $A in CC^(m times n)$, se $a_j$ é a $j^(t h)$ linha de $A$, $||A||_(infinity)$ é definida por:

  #align(center)[$||A||_(infinity) = max_(1 <= i <= m)||a_i||_1$]
]

== Desigualdades de Cauchy-Schwarz e Hölder
Quando usamos normas, geralmente é difícil calcular normas-p com valores altos de $p$, então as gerenciamos usando desigualdades! Uma desigualdade muito útil é a de Hölder:

#definition("Desigualdade de Hölder")[
  Dados $1 <= p, q <= infinity$, e $1/p + 1/q = 1$, então, para quaisquer vetores $x, y$:

  #align(center)[$|x^*y| <= ||x||_p||y||_q$]
]

E a desigualdade de Cauchy-Schwarz é um caso especial onde $p = q = 2$.

== Limitando $||A B||$
Podemos limitar $||A B||$ como fazemos com normas de vetores.

#theorem[
  Dadas $A in CC^(l times m)$,$B in CC^(m times n)$ e $x in CC^n$, então a norma induzida de $A B$ deve satisfazer:

  #align(center)[$||A B||_(l -> n) <= ||A||_(l->m)||B||_(m->n)$]
]
#proof[
  $||A B x||_l <= ||A||_(l->m) ||B x||_m <= ||A||_(l->m) ||B||_(m->n) ||x||_n$
]

== Generalização das normas de matrizes
Vimos que uma norma segue 3 propriedades, definimos uma norma geral de matriz da mesma forma!!

#definition[
  Dadas as matrizes $A$ e $B$, uma norma $||dot||: CC^(m times n) -> RR^+$ é uma função que segue estas 3 propriedades:

  1. $||A|| >= 0$, e $||A|| = 0 <=> A = 0$
  2. $||A + A|| <= ||A|| + ||B||$
  3. $||alpha A|| = |alpha|||A||$
]

A mais importante é a *Norma de Frobenius*, definida como:

#definition[
  Dada uma matriz $A in CC^(m times n)$, sua *Norma de Frobenius* é definida como:

  #align(center)[$||A||_F = (sum_(i=1)^m sum_(j=1)^n |a_(i j)|^2)^(1/2)$ = $sqrt(\t\r(A^*A))$ = $sqrt(\t\r(A A^*))$]
]

#theorem[$||A B||_F <= ||A||_F ||B||_F$]
#proof[
  $||A B||_F = (sum_(i=1)^m sum_(j=1)^n |c_(i j)|^2)^(1/2) <= (sum_(i=1)^m sum_(j=1)^n (||a_i||_2||b_j||_2)^2)^(1/2) = (sum_(i=1)^m ||a_i||^2_2 sum_(j=1)^n ||b_j||^2_2)^(1/2) = ||A||_F||B||_F$
]

= Lectures 4 e 5 - A SVD
*Aviso rápido:* Quando começarmos a falar sobre a fatoração em si, vamos falar sobre matrizes em $CC^(m times n)$ com $m >= n$, porque é o mais comum quando falamos de problemas reais, raramente são situações com mais variáveis do que equações.

Aaaaaah, a SVD, por que ela existe? O que significa? Lembre-se que, em Álgebra Linear, quando temos uma base de um Espaço Vetorial e uma Transformação Linear, sabemos como a Transformação Linear afeta *cada* vetor naquele Espaço Vetorial? Não? Deixe-me refrescar sua memória:

#theorem[
  Dada ${a_j}$ $(1 <= j <= n)$ sendo a base de um Espaço Vetorial e $T$ uma Transformação Linear nesse espaço, se sabemos como $T$ afeta os vetores da base, sabemos como $T$ afeta *cada* vetor nesse espaço.
]
#proof[
  Sendo $v$ um vetor no Espaço Vetorial descrito, sabemos que $v$ pode ser expresso como

  #align(center)[$v = alpha_1 a_1 + ... + alpha_n a_n$]

  Aplicando $T$ em $v$

  #align(center)[$T(v) = T(alpha_1 a_1 + ... + alpha_n a_n) => T(v) = alpha_1 T(a_1) + ... + alpha_n T(a_n)$]

  Isso implica que, se conhecemos uma base do Espaço Vetorial e como $T$ a afeta, sabemos como $T$ afeta cada vetor no espaço.
]

CERTO! Memória refrescada, por que eu disse isso? Lembre-se que matrizes são transformações lineares? Então, se temos uma base ${s_j}$ de um Espaço Vetorial $S$, podemos saber o que acontece com cada combinação linear de ${s_j}$ se aplicarmos $A$ nela, certo? Certo!

Podemos resumir as operações que fazemos em vetores em duas: *esticar* e *rotacionar*, então, basicamente, quando aplicamos uma transformação linear em um vetor, estamos rotacionando-o e depois esticando-o.

Ok, mas por que estou dizendo isso? Onde diabos está a S.V.D? Bem, eu basicamente já descrevi a S.V.D para você! Quando aplicamos $A$ como uma transformação linear, se fizermos as operações descritas anteriormente, você concorda que podemos decompor $A$ como um produto de matrizes ortogonais e matrizes diagonais? O quê? Por quê? Quando? Espere, jovem Padawan! Lembre-se que eu disse que uma transformação linear pode ser resumida em esticar e rotacionar vetores? Você lembra que tipo de matrizes fazem EXATAMENTE o que eu disse? Sim, matrizes ortogonais fazem rotações e matrizes diagonais fazem alongamento.

Agora podemos introduzir aquela visualização clássica de como a S.V.D funciona, imagine uma base ortonormal em $RR^2$, veja o que acontece se aplicarmos $A$ nela:

#align(center)[
#image("images/Singular-Value-Decomposition.svg.png", width: auto, height: 6.8cm)
(Troque o M na imagem por A)
]

Com base nisso, podemos definir que, dada $A in CC^(m times n)$:

#align(center)[$A v_j = sigma_j u_j$]

Onde $v_j$ e $u_j$ são de duas bases ortonormais diferentes e $sigma_j in CC$.

== Forma reduzida
Podemos reescrever esta equação como um produto matricial!

$A V = accent(U, \u{0302}) accent(Sigma, \u{0302})$

Onde

#align(center)[$V = mat(
  |, ,|;
  v_1, ..., v_n;
  |, , |
), Sigma = mat(
  sigma_1, , ,;
  , sigma_2, , ;
  , , dots.down,;
  , , , sigma_n
), U = mat(
  |, ,|;
  u_1, ..., u_n;
  |, , |
)$]

Isso é conhecido como a fatoração SVD *reduzida*. Podemos ver que $V$ é uma matriz ortogonal quadrada (para $A v_j$ ser uma multiplicação válida, $v_j in CC^n$), então podemos reescrever $A$ como:

#align(center)[$A = accent(U, \u{0302}) accent(Sigma, \u{0302}) V^*$]

== SVD completa
Ok, se $v_j in CC^n$ e $A v_j = sigma_j u_j$, então $u_j in CC^m$! Isso significa que, além dos vetores $u$ que adicionamos em $accent(U, \u{0302})$, temos mais $m - n$ vetores ortonormais para as colunas de $accent(U, \u{0302})$, ao encontrar esses vetores, podemos construir outra matriz $U$ cujas colunas são uma base ortonormal de $CC^m$, o que significa que a nova matriz $U$ é ortogonal!

#align(center)[$V = mat(
  |, ,|;
  v_1, ..., v_n;
  |, , |
), U = mat(
  |, ,|;
  u_1, ..., u_m;
  |, , |
)$]

Legal! Mas e a matriz $accent(Sigma, \u{0302})$? Como ela muda? Bem, queremos manter $V$ e $U$ como queríamos, certo? Bem, o que fizemos foi adicionar colunas a $accent(U, \u{0302})$, então, na multiplicação, só precisamos que essas colunas desapareçam, como fazemos isso? Multiplicando por 0! Então, antes, $accent(Sigma, \u{0302})$ era uma matriz quadrada com os valores singulares na diagonal, especificamente, $n$ valores singulares. Se adicionamos $m-n$ vetores em $U$, podemos adicionar $m-n$ zeros em $accent(Sigma, \u{0302})$, então nossa nova multiplicação matricial é

#align(center)[
  $A = U Sigma V^*$
]

#align(center)[
  $mat(
  |, ,|;
  a_1, ..., a_n;
  |, , |
) = mat(
  |, ,|;
  u_1, ..., u_m;
  |, , |
)
mat(
  sigma_1, ,;
  , dots.down,;
  , , sigma_n;
  -, 0, -;
  , dots.v,;
)
mat(
  - v_1 -;
  dots.h;
  - v_n -
)$
]

== Definição formal
#definition[
  Dada $A in CC^(m times n)$ com $m >= n$, a Decomposição por Valores Singulares de $A$ é:

  #align(center)[$A = U Sigma V^*$]

  onde $U in CC^(m times m)$ é unitária, $V in CC^(n times n)$ é unitária e $Sigma in CC^(m times n)$ é diagonal. Para *conveniência*, denotamos:

  #align(center)[$sigma_1 >= sigma_2 >= sigma_3 >= ... >= sigma_n$]

  Onde $sigma_j$ é a j-ésima entrada de $Sigma$
]

Ok, vimos um método intuitivo para ver que toda matriz tem essa decomposição, mas como provamos isso matematicamente?

#theorem[
  Toda matriz $A in CC^(m times n)$ tem uma decomposição S.V.D
]
#proof[
  Seja ${v_j}$ uma base ortonormal de $CC^n$, ${u_j}$ uma base ortonormal de $CC^m$, $A v_j = sigma_j u_j$, $U_1$ e $V_1$ matrizes unitárias de colunas ${u_j}$ e ${v_j}$ respectivamente e que, para toda matriz com menos de $m$ linhas e $n$ colunas, a fatoração é válida:

  #align(center)[$A = U_1 S V^*_1 <=> U_1^* A V_1 = S$]

  Então temos $S = mat(
    sigma_1, w^*;
    0, B;
  )$ onde $sigma_1$ é $1 times 1$, $w^*$ é $1 times (n-1)$ e $B$ é $(m-1) times (n-1)$. Beleza, mas o que é $w$? Bem, podemos chegar nesse resultado fazendo algumas manipulações com $||mat(
    sigma_1, w^*;
    0, B;
  )mat(sigma_1;w)||_2$:

  #align(center)[$||mat(
    sigma_1, w^*;
    0, B;
  )mat(sigma_1;w)||_2^2 >= sigma_1^2 + w^*w$]

  O quê? Por que isso é válido? Porque:

  #align(center)[$||M x||_2 <= ||M||_2 ||x||_2 => ||M||_2 >= (||M x||_2) / (||x||_2)$]

  Se definirmos $x = mat(sigma_1;w)$ e $M = S$, então temos:

  #align(center)[
    $M x = mat(sigma_1^2 + ||w||^2; B w)=>||M||_2 >= (|sigma_1^2 + ||w||^2|^2 + ||B w||^2)/(sigma_1^2 + ||w||^2)$
  ]

  Mas observe que o numerador é sempre maior que o denominador, então isso significa

  #align(center)[
    $(|sigma_1^2 + ||w||^2|^2 + ||B w||^2)/(sigma_1^2 + ||w||^2) >= sigma_1^2 + ||w||^2 = (sigma_1^2 + w^*w)^(1/2)||mat(sigma_1;w)||$
  ]

  Agora podemos voltar para ver o que é $w$! Bem, agora é fácil! Sabemos que $||S||_2 = ||U_1^* A V_1||_2 = ||A||_2 = sigma_1$ porque $U_1$ e $V_1$ são ortogonais. Isso significa $||S||_2 >= (sigma_1^2 + ||w||^2)^(1/2) => sigma_1 >= (sigma_1^2 + ||w||^2)^(1/2) <=> sigma_1^2 >= sigma_1^2 + ||w||^2 => w=0$.

  Pela hipótese indutiva descrita no início da prova, sabemos que $B = U_2 Sigma_2 V_2^*$, então podemos facilmente escrever $A$ como

  #align(center)[$A = U_1 mat(1, 0; 0, U_2) mat(sigma_1, 0; 0, Sigma_2) mat(1, 0; 0, V_2^*)^*V_1^*$]

  Isso é uma S.V.D de $A$, usando o caso base de $m=1$ e $n=1$, terminamos a prova da existência
]

== Mudança de base
Dado $b in CC^m$, $x in CC^n$ e $A in CC^(m times n), A = U Sigma V^*$ podemos obter as coordenadas de $b$ na base das colunas de $U$ e $x$ nas colunas de $V$. Só para lembrar:

#definition[
  Dado $w in V$ onde $V$ é um Espaço Vetorial, $exists!x_1, ..., x_n in CC$ tal que $w = v_1 x_1 + ... + v_n x_n$ onde ${v_j}$ é uma base de $V$. O vetor $mat(x_1;dots.v;x_n)$, também denotado como $[w]_v$, é o *vetor de coordenadas* de $w$ na base $v$
]

Voltando, podemos expressar $[b]_u = U^*b$ e $[x]_v = V^*x$, mas por quê?

#theorem[
  Dada uma base ortonormal ${v_k}$ de $V$ e $w in V$, então
  
  #align(center)[$([w]_v)_j = v_j^*w$]
]
#proof[
  #align(center)[
    $w = alpha_1 v_1 + ... + alpha_n v_n$

    $v_j^*w = alpha_1 v_j^*v_1 +... + alpha_n v_j^*v_n$
  ]

  Sabendo que ${v_j}$ é uma base ortonormal, o produto $alpha_i v_j^*v_i$ é igual a 0 se $j != i$ e igual a $alpha_i$ se $j = i$, ou seja:

  #align(center)[
    $v_j^*w = alpha_j$
  ]
]

Ok, agora que lembramos todas essas propriedades, podemos expressar a relação $b = A x$ em termos de $[b]_u$ e $[x]_v$, vamos ver:

#align(center)[
  $b = A x <=> U^*b = U^*A x = U^*U Sigma V^* x <=> U^*b = Sigma V^* x$

  $<=> [b]_u = Sigma [x]_v$
]

Então podemos reduzir $A$ à matriz $Sigma$ e $b$ e $x$ às suas coordenadas nas bases $u$ e $v$

== S.V.D vs Decomposição por Autovalores
Podemos fazer algo semelhante com a decomposição por autovalores. Dada $A in CC^(m times m)$ com autovetores linearmente independentes, ou seja, podemos expressar $A = S Lambda S^(-1)$ com as colunas de $S$ sendo os autovetores de $A$ e $Lambda$ sendo uma matriz diagonal com os autovalores de $A$ como entradas.

Definindo $b, x in CC^(m)$ satisfazendo $b = A x$, podemos escrever:

#align(center)[
  $[b]_(s^(-1)) = S^(-1)b$ e $[x]_(s^(-1)) = S^(-1)x$
]

Onde estou denotando $s^(-1)$ como a base expressa pelas colunas de $S^(-1)$, então a nova expressão expandida é:

#align(center)[
  $b = A x <=> S^(-1)b = S^(-1)A x = S^(-1)S Lambda S^(-1) x <=> S^(-1)b = Lambda S^(-1)x$

  $[b]_(s^(-1)) = Lambda [x]_(s^(-1))$
]

== Propriedades de matrizes com SVD
Para as próximas propriedades, seja $A in CC^(m times n)$ e $r <= min(m, n)$ o número de valores singulares não nulos

#theorem[
  rank$(A) = r$
]
#proof[
  O posto de uma matriz diagonal é o número de entradas não nulas, bem, se $A = U Sigma V^*$, sabemos que $U$ e $V$ têm posto completo, então o posto de $A$ deve ser o mesmo que o de $Sigma$, ou seja, $r$
]

#theorem[
  $C(A) = "span"{u_1, ..., u_r}$, $C(A^*) = "span"{v_1, ... v_r}, N(A) = "span"{v_(r+1), ..., v_n}, N(A^*) = "span"{u_(r+1),...,u_m}$
]
#proof[
  Vamos lembrar como cada matriz é estruturada:

  #align(center)[
    $A = mat(|,,|;u_1,...,u_m;|,,|) mat(sigma_1;,dots.down;,,sigma_r;,,,0;,,,,dots.down) mat(- v_1^* -;dots.v; - v_n^* -)$
  ]

  É fácil ver por que $C(A) = "span"{u_1, ..., u_r}$, porque as entradas de $Sigma$ só permitem abranger as primeiras $r$ colunas de $U$.
  
  Sobre $N(A) = "span"{v_(r+1), ..., v_n}$, observe como, se fizermos $A v_j space r+1 <= j <= n$, as primeiras $r$ linhas se tornarão 0 (todos os $v_k$ são ortonormais entre si) e, como as entradas diagonais após a $r$-ésima são 0, então temos $U$ vezes a matriz 0

  Para ver as propriedades de $A^*$, vamos transpor $A$

  #align(center)[
    $A^* = mat(|,,|;v_1,...,v_n;|,,|) mat(sigma_1;,dots.down;,,sigma_r;,,,0;,,,,dots.down) mat(- u_1^* -;dots.v; - u_m^* -)$
  ]

  Então, novamente, é fácil ver que $C(A^*) = "span"{v_1, ... v_r}$ e, usando o mesmo argumento mostrado antes, $N(A^*) = "span"{u_(r+1),...,u_m}$ 
]

#theorem[
  $||A||_2 = sigma_1$ e $||A||_F = sqrt(sigma_1^2 + ... + sigma_r^2)$
]
#proof[
  1. $||A||_2 = ||U Sigma V||_2 = ||Sigma||_2$, como denotamos antes, de todas as entradas, $sigma_1$ é a maior, isso significa $||A||_2 = ||Sigma||_2 = sigma_1$
  2. Sabemos que $||A||_F = sqrt(tr(A^*A)) = sqrt(tr(V Sigma^*U^* U Sigma V^*)) = sqrt(tr(V Sigma^* Sigma V^*))$. Também sabemos que $tr(A) = lambda_1 +...+ lambda_n$ com $lambda_j$ sendo os autovalores de $A$, e podemos ver claramente que os autovalores de $V Sigma^* Sigma V^*$ são $sigma_j^2$, portanto $||A||_F = sqrt(sigma_1^2 + ... + sigma_r^2)$
]

#theorem[
  $sigma_j = sqrt(lambda_j)$ com $sigma_j$ sendo os valores singulares de $A$ e $lambda_j$ os autovalores de $A^*A$
]
#proof[
  $A^*A = V Sigma^* U^* U Sigma V^* = V Sigma^* Sigma V^*$
]

#theorem[
  se $A = A^*$, então os valores singulares de $A$ são os valores absolutos dos autovalores de $A$
]
#proof[
  Pelo Teorema Espectral, sabemos que $A$ tem uma decomposição por autovalores

  #align(center)[
    $A = Q Lambda Q^*$
  ]

  Podemos reescrevê-la como

  #align(center)[
    $A = Q|Lambda|$sign$(Lambda)Q^*$
  ]

  Onde as entradas de $|Lambda|$ são $|lambda_j|$ e as entradas de sign$(Lambda)$ são sign$(lambda_j)$. Podemos mostrar que, se $Q$ é unitária, sign$(Lambda)Q$ é unitária, o que significa que $Q|Lambda|$sign$(Lambda)Q^*$ é uma SVD de $A$
]

#theorem[
  Para $A in CC^(m times m)$, $|det(A)| = product^m_(i=1)sigma_i$
]
#proof[
  $|det(A)| = |det(U Sigma V^*)| = |det(U) det(Sigma) det(V)| = |det(Sigma)|$
]

= Lecture 6 - Projetores

$P in CC^(m times n)$ é dito um #text(weight: "bold")[Projetor] se

$
  P^2 = P
$

também chamado _idempotente_. Você pode se confundir pensando apenas em projeções ortogonais, aquelas em que pegamos o vetor e o projetamos de forma a formar um ângulo de 90 graus no espaço projetado! Mas estamos falando de *todas* as projeções, incluindo as não ortogonais.

Imagine que colocamos uma luz naquele vetor, ele lançará uma sombra em algum lugar, mas você concorda comigo que podemos obter essa sombra de alguma forma, certo? Vamos ver um exemplo em 2D:

#image("images/Projector.jpg")

Como você pode ver, o vetor tracejado indica a direção em que a luz está projetando a sombra de $v$ sobre $P$. Podemos expressar essa direção como $P v - v$. É importante lembrar que, se você está deitado no chão, não terá uma sombra, certo? Ou melhor ainda, sombras não têm sombras! Traduzindo isso para o nosso contexto:

#theorem[
  Se $v in C(P)$, então $P v = v$
]
#proof[
  Todo $v in C(P)$ pode ser expresso como $v = P x$ para algum $x$, isso significa $P v = P^2x = P x = v$
]

Observe que, se aplicarmos a projeção na direção que tínhamos antes

$
  P(P v - v) = P^2v - P v = P v - P v = 0
$

Isso significa que $P v - v in $ null$(P)$. Também observe que podemos reescrever a direção como

$
  P v - v = (P - I)v = -(I - P)v
$

Veja que coisa ainda mais estranha!

$
  (I - P)^2 = I - 2P + P^2 = I - P
$

Isso significa que $I - P$ também é um projetor! Um projetor que projeta na direção da projeção de $P$.

== Projetores complementares
Se $P$ é um projetor, $I - P$ é seu projetor complementar.

#theorem[
  $I - P$ projeta sobre null$(P)$ e $P$ projeta sobre null$(I - P)$
]
#proof[
  1. $C(I - P) subset.eq N(P)$ porque $v - P v in N(P)$ e $C(I - P) supset.eq N(P)$ porque, se $P v = 0$, podemos reescrever como $(I - P)v = v$, isso significa $N(P) = C(I - P)$
  2. Se reescrevermos a expressão como $P = I - (I - P)$, então, usando o mesmo argumento de antes, temos $C(P) = N(I - P)$
]

#theorem[
  $N(I-P) inter N(P) = {0}$
]
#proof[
  $N(A) inter C(A) = {0} => N(P) inter C(P) = {0} <=> N(P) inter N(I-P) = {0}$
]

Isso significa que, se temos um projetor $P$ em $CC^(m times m)$, esse projetor separa $CC^m$ em dois espaços $S_1$ e $S_2$, de forma que $S_1 inter S_2 = {0}$ e $S_1 + S_2 = CC^m$.

== Projetores ortogonais
Finalmente! Os projetores que ouvimos falar o tempo todo! Eles projetam um vetor em um espaço fazendo a direção formar um ângulo de 90 graus com a projeção.

#image("images/Orthogonal_Projector.jpg")

Isso significa $(P v)^*(v - P v) = 0$

#theorem[
  $P$ é um projetor ortogonal $<=>$ $P = P^*$
]<orthogonal-projectors>
#proof[
  1. $arrow.l.double)$ Dado $x, y in CC^m$, então $x^*P^*(I - P)y = x^*(P^* - P^*P)y = x^*(P - P^2)y = x^*(P - P)y = 0$
  2. $=>)$ Seja ${q_1, ..., q_m}$ uma base ortonormal de $CC^m$ onde ${q_1,...,q_n}$ é base de $S_1$ e ${q_(n+1),...,q_m}$ é base de $S_2$. Para $j <= n$ temos $P q_j = q_j$ e para $j > n$ temos $P q_j = 0$, seja $Q$ a matriz com colunas ${q_1,...,q_m}$, temos: $ Q = mat(|,,|;q_1,...,q_m;|,,|) <=> P Q = mat(|,,|,|;q_1,...,q_n,0,...;|,,|,|;) <=> Q^*P Q = mat(1;,1;,,dots.down;,,,1;,,,,0;,,,,,dots.down)$, o que significa que encontramos uma decomposição SVD para $P$:

  $
    P = Q Sigma Q^* <=> P^* = Q Sigma^* Q^* = Q Sigma Q^* = P
  $
]

== Projeção ortogonal sobre um vetor
Vamos usar o mesmo exemplo usado anteriormente

#image("images/Orthogonal_Projector.jpg")

Seja $q$ o vetor que gera $P$, sabemos que $P v = alpha q$
$
(v - P v)^*q = 0 = (v - alpha q)^* q = 0
$
Agora procuramos o $alpha$ que torna esta equação válida
$
v^*q-alpha q^*q=0 <=> v^*q = alpha q^*q <=> alpha = (v^*q)/(q^*q)
$
$
P v = alpha q <=> P v = (v^*q)/(q^*q)q <=> P v = (q^*v)/(q^*q)q <=> P v = q (q^*v)/(q^*q) <=> P v = (q q^*)/(q^*q)v => P = (q q^*)/(q^*q)
$

== Projeção com base ortonormal
Vimos na prova de @orthogonal-projectors que alguns valores singulares de $P$ são $0$, então poderíamos remover essas linhas de $Sigma$ e reduzi-lo a $I$, também removendo as colunas e linhas de $Q$, obtendo:
$
  P = accent(Q, \u{0302})accent(Q, \u{0302})^*
$
Seja ${q_1,...,q_n}$ qualquer conjunto de vetores ortonormais em $CC^m$ e sejam eles as colunas de $accent(Q, \u{0302})$, sabemos que, para qualquer vetor $v in CC^m$:
$
  v = r + sum^n_(i=1)q_i q_i^*v
$
O quê? Quando vimos isso? Calma, deixe-me recapitular para você:

#theorem[
  Seja ${q_1,...,q_n}$ qualquer conjunto de vetores ortonormais em $CC^m$, então qualquer $v in CC^m$ pode ser expresso como
  $
    v = r + sum^n_(i=1)q_i q_i^*v
  $
  Com $r$ sendo outro vetor em $C^m$ ortogonal a ${q_1, ..., q_n}$ e, $-> n = m => r = 0$ e o conjunto de vetores escolhido é uma base para $CC^m$
]
#proof[
  Você sabe que, dada uma base de $CC^m$, qualquer vetor pode ser expresso como uma combinação linear desses vetores. Imagine a base canônica (com algumas rotações, essa lógica pode ser expandida para outras bases ortonormais), você pode imaginar que, se projetar o vetor que você tem sobre qualquer vetor da base canônica, obterá um vetor que, se somar com outro vetor $r$, obterá seu vetor original novamente! E podemos continuar esse processo até fazermos isso com $n$ vetores da base canônica, obtendo o $r$ original que, se somarmos todas as nossas projeções, obtemos o vetor original novamente, ou seja:
  $
    v = r + sum^n_(i=1)q_i q_i^*v
  $
]

Ok, sabendo que um vetor pode ser expresso assim, podemos ver que a parte da soma é a mesma que fazer:
$
accent(Q, \u{0302})accent(Q, \u{0302})^*v
$
Ou seja, $sum^n_(i=1)q_i q_i^*v$ é um projetor sobre $C(accent(Q, \u{0302}))$

#theorem[
  O complemento de um projetor ortogonal também é um projetor ortogonal
]
#proof[
  1. $(I-accent(Q, \u{0302})accent(Q, \u{0302})^*)^2 = I - 2accent(Q, \u{0302})accent(Q, \u{0302})^* + (accent(Q, \u{0302})accent(Q, \u{0302})^*)^2 = I - 2accent(Q, \u{0302})accent(Q, \u{0302})^* + accent(Q, \u{0302})accent(Q, \u{0302})^* = I - accent(Q, \u{0302})accent(Q, \u{0302})^*$
  2. $(I - accent(Q, \u{0302})accent(Q, \u{0302})^*)^* = I - (accent(Q, \u{0302})accent(Q, \u{0302})^*)^* = I - accent(Q, \u{0302})accent(Q, \u{0302})^*$
]

Um caso especial é o projetor ortogonal de posto um, que pega o vetor e obtém o componente em uma única direção $q$, que pode ser escrito:
$
  P_q = q q^*
$
E seu complemento é a matriz de posto ($m-1$)
$
  P_(tack.t q) = I - q q^*
$
Esse conceito também é válido para vetores não unitários:
$
  P_a = (a a^*)/(a^* a)
$
$
  P_(tack.t a) = I - (a a^*) / (a^* a)
$
Só para esclarecer as coisas. Se projetarmos um vetor $v$ sobre um vetor $a$, estamos restringindo $v$ na direção da projeção, então, se projetarmos no complemento de $a$, é como se pudéssemos expressar $v$ como uma combinação linear de $a$ e alguns outros vetores, e então remover a parte de $a$ nessa combinação linear, tendo apenas os outros vetores expressando um novo vetor.

== Projeção em base arbitrária
Dada uma base arbitrária ${a_j}$, deixamos os vetores dessa base serem as colunas de $A$. Dado $v$ com $P v = y in$ $C(A)$, isso significa $y - v tack.t$ $C(A)$, ou seja, $a_j^*(y-v) = 0 space forall j$. Sabemos que $y in$ $C(A)$, então vamos escrevê-lo como $A x = y$, então podemos reescrever $a_j^*(y-v) = 0 space forall j$ como:
$
A^*(A x - v) = 0 <=> A^*A x - A^*v = 0 <=> A^*A x = A^*v <=> x = (A^*A)^(-1)A^*v
$
$
A x = A(A^*A)^(-1)A^*v <=> y = A(A^*A)^(-1)A^*v
$
$
=> P = A(A^*A)^(-1)A^*
$

= Lecture 7 - Fatoração QR
A assustadora, a parte em que ninguém sabe de nada! Vamos nos acalmar e ver tudo com paciência.

Como funciona essa fatoração? Queremos expressar $A$ como:
$
A = Q R
$

Com $Q$ sendo uma matriz ortogonal e $R$ uma matriz triangular superior. Mas por que eu gostaria de fazer tal coisa? O principal motivo é resolver sistemas lineares! Vamos pegar o sistema $b = A x$, reescrevemo-lo como
$
b = Q R x <=> Q^* b = R x <=> c = R x
$
Temos um sistema equivalente, e este é um sistema *triangular*, ou seja, um sistema trivial para nós e para um computador resolverem!

== A ideia da fatoração reduzida
Seja ${a_j}$ as colunas de $A in CC^(m times n), space m >= n$. Em algumas aplicações, estamos interessados nos espaços das colunas de $A$, ou seja, os espaços sequenciais gerados pelas colunas de $A$:

#align(center)[
  span${a_1} subset.eq$ span${a_1, a_2} subset.eq$ span${a_1, a_2, a_3} subset.eq ...$
]

Por enquanto, assumiremos que $A$ tem posto completo $n$. Primeiro, queremos obter um conjunto de vetores ortonormais com a seguinte propriedade:

#align(center)[
  span${a_1, ..., a_j} =$ span${q_1, ..., q_j}$ com $j = 1,...,n$
]

Bem, acho que uma boa ideia para fazer isso é usar vetores tais que possamos expressar $a_j$ como uma combinação linear de ${q_1, ..., q_j}$. Isso significa:
$
a_1 = r_(11)q_1
$
$
a_2 = r_(12)q_1 + r_(22)q_2
$
$
dots.v
$
$
a_n = r_(1n)q_1 + r_(2n)q_2 + ... + r_(n n)q_n
$

Podemos expressar essas equações como um produto matricial!

$
mat(|,|,,|;a_1,a_2,...,a_n;|,|,,|) = mat(|,|,,|;q_1,q_2,...,q_n;|,|,,|) mat(r_(11), r_(12), ..., r_(1n);,r_(22),,dots.v;,,dots.down,dots.v;,,,r_(n n))
$

Então temos $A = accent(Q, \u{0302})accent(R, \u{0302})$, onde $Q in CC^(m times n)$ e $R in CC^(n times n)$

== Fatoração QR completa
Vai um pouco além. Sabemos que ${q_1, ..., q_n}$ é um conjunto de vetores ortonormais de $CC^m$, isso significa que temos mais $m-n$ vetores ortonormais aos que tínhamos antes, então podemos criar uma base para $CC^m$, adicionando esses vetores como colunas de $accent(Q, \u{0302})$, temos uma matriz ortogonal $Q$. Mas o que fazemos para $A$ permanecer a mesma? Podemos simplesmente adicionar linhas de 0 abaixo de $accent(R, \u{0302})$, criando $R in CC^(m times n) space (m >= n)$, obtendo

$
A = Q R
$

== Ortonormalização de Gram-Schmidt
Nossa... a assustadora... Vamos com muita calma. Vimos anteriormente uma maneira de calcular todos os $q_j$, vamos relembrar:
$
a_1 = r_(11)q_1
$
$
a_2 = r_(12)q_1 + r_(22)q_2
$
$
dots.v
$
$
a_n = r_(1n)q_1 + r_(2n)q_2 + ... + r_(n n)q_n
$
Bem, isso sugere um algoritmo para calcular o próximo $q_j$, vamos pensar, temos todos os $a_j$, e cada $q_j$ precisa dos vetores ${q_1,...,q_(j-1)}$. Bem, podemos ter alguma liberdade aqui! Vamos ver o que acontece quando tentamos calcular $q_j$:
$
a_j = r_(1j)q_1 + ... + r_(j j)q_j
$
Vamos isolar $q_j$:
$
q_j = (a_j - r_(1j)q_1 - r_(2j)q_2 - ... - r_(2(j-1))q_(j-1))/r_(j j)
$
Bem, isso sugere que $r_(j j)$ é a norma do vetor $a_j - sum^(j-1)_(k=1)r_(i j)q_i$, mas o que é $r_(i j)$? Lembra da decomposição em fatores ortogonais? Sim, aquela, $v = r + sum^n_(i=1)q_i q_i^*v$. Se trocarmos $v$ por $a_j$, temos quase a mesma coisa que definimos anteriormente!
$
a_j - sum^(j-1)_(k=1)r_(i j)q_i, space v - sum^k_(i=1)q_i q_i^*v
$
E você lembra que $r$ é ortogonal a span${q_1,...,q_k}$? Isso é exatamente o que $q_j$ é! Tudo isso que acabei de dizer sugere que posso definir $r_(i j)$ como $q_i^*a_j space (i != j)$. E nosso algoritmo está pronto! Vamos recapitular tudo aqui:

$
q_1 = (a_1)/(||a_1||_2)
$
$
q_2 = (a_2 - q_1q_1^*a_2)/(||a_2 - q_1q_1^*a_2||_2)
$
$
q_3 = (a_3 - q_1q_1^*a_3 - q_2q_2^*a_3)/(||a_3 - q_1q_1^*a_3 - q_2q_2^*a_3||_2)
$
$
dots.v
$
$
q_n = (a_n - sum^(n-1)_(i=1)q_i q_i^*a_n)/(||a_n - sum^(n-1)_(i=1)q_i q_i^*a_n||_2)
$

Escrevendo na forma de um algoritmo:

#pseudocode-list[
  + *para* $j = 1$ *até* $n$
    + $v_j = a_j$
    + *para* $i = 1$ *até* $j-1$
      + $r_(i j) = q_i^*a_j$
      + $v_j = v_j - r_(i j)q_i$
    + $r_(j j) = ||v_j||_2$
    + $q_j = v_j/r_(j j)$
]

== Existência e unicidade
#theorem[
  Toda $A in CC^(m times n), space (m >= n)$ tem uma fatoração QR completa, portanto também uma fatoração QR reduzida
]
#proof[
  Se rank$(A) = n$, podemos construir a fatoração reduzida usando Gram-Schmidt como fizemos antes. O único problema aqui é se, em algum momento, $v_j = a_j - sum^(j-1)_(k=1)q_k q_k^*a_j = 0$ e, portanto, não pode ser normalizado. Se isso acontecer, significa que $A$ não tem posto completo, o que significa que posso escolher qualquer vetor ortogonal que quiser para continuar o processo.
]

#theorem[
  Cada $A in CC^(m times n) space (m >= n)$ de posto completo tem uma fatoração QR reduzida única $A = accent(Q, \u{0302})accent(R, \u{0302})$ com $r_(j j) > 0$
]
#proof[
  Sabemos que, se $A$ é de posto completo $=> r_(j j) != 0$ e, portanto, em cada passo sucessivo $j$, as fórmulas mostradas anteriormente determinam $r_(i j)$ e $q_j$ completamente, o único problema é o sinal de $r_(j j)$, uma vez que dizemos $r_(j j) > 0$, esse problema é resolvido
]

= Lecture 8 - Ortonormalização de Gram-Schmidt
Podemos descrever o algoritmo de Gram-Schmidt usando projetores, mas por que quereríamos isso? Na verdade, isso é uma introdução para outro algoritmo que veremos mais tarde. Quando falamos de algoritmos, queremos que eles sejam estáveis, no sentido de que, se inserirmos uma entrada no computador, ele nos retornará uma resposta próxima da correta (computadores não resolvem problemas contínuos exatamente), e o processo de Gram-Schmidt não é estável (falaremos sobre isso nas próximas aulas).

Lembre-se que eu disse que, se você tem um vetor $v$ e o decompõe como
$
v = r + sum^(n)_(k=1)q_k q_k^* v
$
A parte $sum^(n)_(k=1)q_k q_k^*$ é um projetor que projeta na matriz $accent(Q, \u{0302})accent(Q, \u{0302})^*$ ($accent(Q, \u{0302})$ tem colunas ${q_1, ..., q_n}$)? Bem, acontece que podemos expressar os passos do algoritmo de Gram-Schmidt da mesma forma! Vamos relembrar. No $j$-ésimo passo, temos:
$
q_j = (a_j - sum^(j-1)_(i=1)q_i q_i^* a_j)/(||a_j - sum^(j-1)_(i=1)q_i q_i^* a_j||_2)
$
Isso significa que podemos reescrever isso como
$
q_j = ((I - accent(Q, \u{0302})_(j-1) accent(Q, \u{0302})_(j-1)^*)a_j)/(||(I - accent(Q, \u{0302})_(j-1) accent(Q, \u{0302})_(j-1)^*)a_j||_2)
$
Onde $accent(Q, \u{0302})_(j-1) = mat(|,,|;q_1,,q_(j-1);|,,|)$. Vamos definir, para simplificação, o projetor $P_j$ como:
$
  P_j = I - accent(Q, \u{0302})_(j-1) accent(Q, \u{0302})_(j-1)^*
$

== Algoritmo de Gram-Schmidt Modificado
Usando as definições anteriores, vamos reescrever o Algoritmo de Gram-Schmidt.

Para cada valor de $j$, o algoritmo de Gram-Schmidt original calcula uma única projeção ortogonal de posto $m - (j - 1)$. Estou apenas traduzindo para a linguagem usando projetores, ele faz isso:
$
v_j = P_j a_j = (I - accent(Q, \u{0302})_(j-1) accent(Q, \u{0302})_(j-1)^*)a_j
$
Se você voltar ao que eu disse antes, obterá a fórmula original, estou apenas trocando aquele monte de somas e vetores por um produto matricial. O algoritmo original faz esse cálculo usando um único projetor, mas o que veremos faz isso por uma sequência de $j-1$ projetores de posto $m - 1$. Pela definição de $P_j$, podemos afirmar que:

#theorem[
$
P_j = P_(perp q_(j-1))...P_(perp q_2)P_(perp q_1)
$
]
#proof[
  Lembre-se que $P_(perp q_k) = I - q_k q_k^*$, e o que isso faz? Ele projeta um vetor $v$ no subespaço ortogonal a ${q_1,...,q_(k-1)}$, ou seja, removendo os componentes ${q_1, ..., q_(k-1)}$ de $v$. O projetor $P_j$ faz exatamente a mesma coisa, certo? Então, você pode pensar que, se eu projeto no complemento de $q_1$, depois no complemento de $q_2$ e assim por diante, no $j$-ésimo passo, terei um vetor que é ortogonal aos anteriores, o que significa que removo todos os componentes anteriores, deixando o vetor projetado como uma combinação linear de ${q_k, ...}$
]

Ok! Se definirmos $P_1 = I$, podemos reescrever $v_j = P_j a_j$ como:

$
  v_j = P_(perp q_(j-1))...P_(perp q_2)P_(perp q_1)a_j
$

O novo algoritmo modificado é baseado nesta nova equação. Podemos obter o mesmo resultado declarado na versão anterior do algoritmo como:

$
  v_j^((1)) = a_j
$
$
  v_j^((2)) = P_(perp q_1)v_j^((1))
$
$
  v_j^((3)) = P_(perp q_2)v_j^((2))
$
$
  v_j = v_j^((j)) = P_(perp q_(j-1))v_j^((j-1))
$

Podemos reescrevê-lo na forma de pseudocódigo:

#pseudocode-list[
  + *para* $i = 1$ *até* $n$
    + $v_i = a_i$
  + *para* $i = 1$ *até* $n$
    + $r_(i i) = ||v_i||$
    + $q_i = v_i / r_(i i)$
    + *para* $j = i + 1$ *até* $n$
      + $r_(i j) = q_i^* v_j$
      + $v_j = v_j - r_(i j)q_i$
]

== Gram-Schmidt como Ortonormalização Triangular
Podemos interpretar cada passo do algoritmo de Gram-Schmidt como uma multiplicação à direita por uma matriz triangular superior quadrada. Espere, o quê? Por quê? Pegue a matriz $R$:
$
mat(
  r_11, r_12, ..., r_(1n);
  , r_22, , dots.v;
  ,,dots.down,dots.v;
  ,,,r_(n n)
)
$

Você pode separá-la como:
$
mat(
  r_11, r_12, ..., r_(1n);
  , 1, , dots.v;
  , , dots.down, dots.v;
  , , , 1
)
mat(
  1, 0, ..., 0;
  , r_22, , dots.v;
  , , dots.down, dots.v;
  , , , 1
)...
$

Então, podemos ver facilmente que, para a $j$-ésima matriz, a inversa dela é:

$
mat(
  dots.down,;
  , 1;
  , ,r_(j j), r_(j (j+1)),...;
  ,,,dots.down;
)^(-1)
=
mat(
  dots.down,;
  , 1;
  , ,1/r_(j j), -r_(j (j+1))/r_(j j),...;
  ,,,dots.down;
)
$

Isso significa que podemos entender o algoritmo de Gram-Schmidt como uma ortonormalização por matrizes triangulares

$
A R_1R_2...R_n = accent(Q, \u{0302})
$
$
R_1R_2...R_n = R^(-1)
$

= Lecture 10 - Triangularização de Householder
NÃOOOO, HOUSEHOLDER NÃOOOOO! Espere, espere, espere, vamos entrar nisso passo a passo! Vimos no último capítulo que o algoritmo de Gram-Schmidt pode ser escrito como uma série de multiplicações por matrizes triangulares superiores, certo? Bem, o algoritmo de triangularização de Householder é muito semelhante, mas, como o nome sugere, em vez de obtermos uma matriz ortogonal no final, terminamos com uma matriz triangular superior
$
Q_1Q_2...Q_n A = R
$
É fácil ver que $Q_n^*...Q_2^*Q_1^*$ é uma matriz unitária, o que significa que $A = Q_n^*...Q_2^*Q_1^*R$ é uma fatoração QR completa de $A$

== Triangularização por Introdução de Zeros
No coração do algoritmo de Householder, temos a ideia de aplicar uma matriz ortogonal que introduz zeros abaixo da diagonal principal! Assim (neste exemplo, $x$ significa uma entrada não nula, *$x$* significa uma entrada que mudou desde a última aplicação ortogonal e nada significa 0)

$
mat(
  x, x, x;
  x, x, x;
  x, x, x;
  x, x, x;
  x, x, x;
)_A
-> Q_1 A ->
mat(
  bold(x), bold(x), bold(x);
  , bold(x), bold(x);
  , bold(x), bold(x);
  , bold(x), bold(x);
  , bold(x), bold(x);
)_(Q_1 A)
-> Q_2 Q_1 A ->
mat(
  x, x, x;
  , bold(x), bold(x);
  , , bold(x);
  , , bold(x);
  , , bold(x);
)_(Q_2 Q_1 A)
-> Q_3Q_2Q_1 A ->
mat(
  x, x, x;
  , x, x;
  , , bold(x);
  , , ;
  , , ;
)_(Q_3 Q_2 Q_1 A)
$

== Refletores de Householder
Ok, entendemos como o algoritmo vai funcionar, mas que tipo de matrizes pode fazer tal coisa? É aqui que entram em cena os *refletores de Householder*! Cada $Q_k$ terá esta estrutura:
$
Q_k = mat(I,0;0,F)
$
Onde $I$ é a matriz identidade de tamanho $k-1 times k-1$ e $F$ é uma matriz unitária $m-k+1 times m-k+1$. Mas por que essa estrutura, onde vimos isso? Bem, lembre-se que, como vimos antes, quando multiplicamos $Q_(k-1)...Q_1 A$ por $Q_k$, queremos manter as linhas $1$ a $k-1$ intocadas, então, para fazer isso, criamos uma matriz bloco $k-1 times k-1$ da identidade para manter essas linhas intocadas.

E por que $F$ é uma matriz unitária? Bem, sabemos que, por causa dos zeros abaixo de $I$ e acima de $F$, as colunas de $F$ serão ortogonais às colunas de $I$ independentemente do que eu colocar ali, mas queremos que $Q_k$ seja ortogonal, então, se as colunas de $I$ já são ortonormais, só precisamos que as colunas de $F$ também sejam ortonormais, ou seja, $F$ deve ser ortogonal.

Ok, mas agora a parte mais difícil, precisamos que, quando multiplicarmos por $F$, ela introduza zeros abaixo da $k$-ésima entrada da diagonal e ainda seja ortogonal. Vamos fazer $F$ estar em $CC^(m - k + 1 times m - k +1)$ e afetar vetores de $CC^(m - k + 1)$ (podemos ver as linhas abaixo das $k$-ésimas entradas de vetores desse espaço), então queremos que a primeira entrada dos vetores seja diferente de 0 e o resto seja 0, sabendo que matrizes ortogonais são rotações em um espaço, podemos fazer $F$ fazer isso:

$
x = mat(x;x;x;dots.v;x) -> F x = mat(||x||;0;0;dots.v;0) = ||x||e_1
$

Como mostrado nesta figura:
#image("images/Householder_Reflector.jpg")

Observe que projetar $v$ para obter $||v||e_1$ não nos dará uma projeção ortogonal, mas podemos projetá-lo na linha azul, que é a bissetriz do ângulo entre $v$ e $||v||e_1$. Essa bissetriz forma um ângulo de 90 graus com $||v||e_1 - v$. Este é um plano 2D, então é a bissetriz do ângulo, mas em um espaço de dimensão maior, será um hiperplano ortogonal a $||v||e_1 - v$. Vamos definir $w = ||v||e_1 - v$, então, se $H$ é o hiperplano ortogonal a $w$, podemos projetar $v$ sobre $H$ fazendo:

$
  P v = I - (w w^*)/(w^* w)v
$

Mas, como podemos ver, se projetarmos $v$ sobre $H$, para chegar a $||v||e_1$, precisamos percorrer duas vezes a distância que acabamos de percorrer, então, a equação final para o refletor de Householder é:

$
  F = I - 2(w w^*)/(w^* w)
$

== O Melhor de Dois Refletores
Na verdade, podemos ter muitos refletores de Householder, por exemplo, no caso complexo, podemos projetar $v$ em qualquer vetor $z||v||e_1$ com $|z|=1$. No caso real, temos duas alternativas:

#image("images/Householder_Reflector_2.jpg")

Então, o que devo escolher? Qual vetor é melhor para meu algoritmo? Todos serão a mesma coisa? Na verdade, há uma melhor opção que você pode escolher! Matematicamente, todos são a mesma coisa, mas para estabilidade numérica (insensibilidade a erros de arredondamento), escolheremos o $z||v||e_1$ que não está muito próximo de $v$, para alcançar isso, projetaremos em $-"sign"(v_1)||v||e_1$ onde $v_1$ é a primeira entrada de $v$, isso significa:

$
w = -"sign"(v_1)||v||e_1 - v or w = "sign"(v_1)||v||e_1 + v
$

E podemos definir que:

$
"sign"(0) = 1
$

Só para esclarecer por que fizemos essa escolha, imagine que o ângulo entre $v$ e $||v||e_1$ é MUITO PEQUENO, isso significa que, quando fazemos $||v||e_1 - v$, estamos subtraindo quantidades próximas, dependendo de quais quantidades, isso poderia nos levar a cálculos imprecisos, levando a grandes erros

== O Algoritmo
Agora podemos reescrevê-lo como um algoritmo, mas antes disso:

#definition[
  Dada a matriz $A$, $A_(i:i', j:j')$ é a submatriz $(i' - i + 1) times (j' - j + 1)$ de $A$ com o elemento do canto superior esquerdo igual a $(A)_(i j)$ e o elemento do canto inferior direito igual a $(A)_(i' j')$. Se a submatriz for um vetor linha ou coluna, podemos escrevê-lo como $A_(i,j:j')$ ou $A_(i:i',j)$
]

Dada essa definição, vamos reescrever o algoritmo

#pseudocode-list[
  + *para* $k = 1$ *até* $n$
    + $x = A_(k:m,k)$
    + $v_k = "sign"(x_1)||x||e_1 + x$
    + $v_k = v_k / (||v_k||)$
    + $A_(k:m,k:n) = A_(k:m,k:n) - 2v_k (v_k^*A_(k:m,k:n))$
]

== Aplicando na formação de Q
Observe que não construímos a matriz $Q$ inteira no algoritmo, apenas aplicamos:
$
Q^* = Q_n...Q_1 <=> Q = Q_1...Q_n
$
(Não há asteriscos faltando, porque cada $Q_j$ é hermitiana!)

Fazemos isso porque construir $Q$ requer trabalho extra, então trabalhamos diretamente com $Q_j$. Por exemplo, lembra que podemos reescrever $b = A x$ como $Q^*b = R x$? Bem, podemos fazer isso como no algoritmo anterior:

#pseudocode-list[
  + *para* $k=1$ *até* $n$
    + $b_(k:m) = b_(k:m) - 2 v_k (v^*_k b_(k:m))$
]

Observe que fizemos o mesmo processo que fizemos com $A$, só não explicitei as partes onde defini $v_k$ e o normalizei.

= Lecture 11 - Problemas de Mínimos Quadrados
Qual é o problema que estamos tentando analisar aqui? Bem, temos um conjunto de $m$ equações com $n$ variáveis, e temos mais equações do que variáveis $(m >= n)$, e queremos encontrar uma solução para esse sistema! Mas você concorda comigo, se fizermos a fatoração $Q R$ de $A$, a maioria dessas equações não terá solução, certo? Porque as entradas abaixo da $n$-ésima linha de $R$ serão iguais a $0$, então, para o vetor $Q^*b$ ter todas as entradas iguais a zero abaixo da $n$-ésima linha, apenas algumas escolhas específicas de $b$ satisfarão isso!
$
A = Q R => A x = b <=> R x = Q^* b
$
Então, o que podemos fazer com esse sistema? Ignorá-lo? Bem, de forma alguma! Sabemos que $b$ terá uma solução apenas se estiver em $C(A)$, isso significa que, se $b in.not C(A)$, temos:
$
  b - A x = r space (r != 0)
$
Então, poderíamos encontrar uma maneira de tornar $r$ o menor possível, então nosso novo objetivo é *minimizar* $b - A x$. Para medir quão pequeno é $r$, podemos escolher qualquer norma, mas a norma 2 é uma boa escolha e tem algumas propriedades boas para trabalhar.

#align(center)[
  Dado $A in CC^(m times n)$, $m >= n$ e $b in CC^m$

  encontrar $x in CC^n$ tal que $||b - A x||_2$ seja minimizado
]

Então, como resolvemos isso? Existe uma maneira fixa para resolver esse problema? O que fazemos? Na verdade, existe uma maneira fixa para resolvê-lo, e ela gira em torno da *projeção ortogonal*

== Projeções Ortogonais e as Equações Normais
Faz sentido que a solução seja obtida por uma projeção de $b$ em $C(A)$, mas que tipo de projeção? Você pode imaginar um plano 3D, se visualizar $A$ como um plano, faz sentido que o $A x$ que minimiza $||b - A x||_2$, veja a imagem na próxima página:

#image("images/Projection_Min_Squared.jpg", width: 14cm)

Ok, parece correto, e podemos pensar nisso intuitivamente, mas está matematicamente correto?

#theorem[
  Seja $A in CC^(m times n) space (m >= n)$, $b in CC^m$.
  #align(center)[
    $x$ minimiza $||b - A x||_2 <=> b - A x perp C(A)$
  ]
]
#proof[
  Primeiro, defina como $P$ um projetor ortogonal que projeta sobre $C(A)$ e $c = P b$

  Bem, sabemos que $c perp b - A x$ (veja a imagem anterior), então, como $c$ está em $C(A)$, podemos expressar $c = A y$ para algum $y in CC^n != 0$. Vamos escrever tudo:
  $
    c^*(b - A x) = 0 <=> y^*A^*(b - A x) = 0
  $
  Sabemos que $y != 0$, isso significa $A^*(b - A x) = 0$
  $
    A^*(b - A x) = 0 <=> A^*b - A^*A x = 0 <=> A^*b = A^*A x
  $
  Queremos $x$ que satisfaça esta equação, se $A^*A$ é inversível, então
  $
    x = (A^*A)^(-1)A^* b
  $
  E observe que, se aplicarmos $A$ em $x$, isso me dá a fórmula exata da projeção ortogonal de $b$ sobre $A$:
  $
    A x = A(A^*A)^(-1)A^*b
  $
]

A equação $A^*b = A^*A x$ é conhecida como "equação normal", e usá-la nos permite obter alguns algoritmos diferentes para calcular a solução de mínimos quadrados!

=== Padrão
Se $A$ tem posto completo, isso significa que $A^*A$ é um sistema de equações quadrado, hermitiano e definido positivo com dimensão $n$. Então, podemos fazer a Fatoração de Cholesky de $A^*A$, obtendo $R^*R$ onde $R$ é triangular superior, então podemos fazer a redução:
$
  A^*b = A^*A x <=> A^* b = R^*R x
$
Então, podemos fazer o algoritmo:
1. Formar a matriz $A^*A$ e $A^*b$
2. Calcular a Fatoração de Cholesky de $A^*A$, $R^*R$
3. Resolver o sistema triangular inferior $R^* w = A^* b$ para $w$
4. Resolver o sistema triangular superior $R x = w$ para $x$

=== Fatoração $Q R$
Um método "moderno" usa a fatoração $Q R$ reduzida. Usando o algoritmo de Householder, calculamos $A = accent(Q, \u{0302}) accent(R, \u{0302})$ (Lembre-se que $accent(R, \u{0302})$ é quadrada e $accent(Q, \u{0302})$ é $m times n$). Podemos então reescrever o projetor ortogonal $P = (A^*A)^(-1)A$ como $P = accent(Q, \u{0302})accent(Q, \u{0302})^*$, porque $C(A) = C(Q)$.
$
  accent(Q, \u{0302}) accent(R, \u{0302}) x = accent(Q, \u{0302}) accent(Q, \u{0302})^* b <=> accent(R, \u{0302}) x = accent(Q, \u{0302})^* b
$
E se $R$ tem inversa, podemos multiplicá-lo por $R^(-1)$ e ter $A^+ = accent(R, \u{0302}) accent(Q, \u{0302})^*$
1. Calcular a fatoração $Q R$ reduzida $A = accent(Q, \u{0302}) accent(R, \u{0302})$
2. Calcular o vetor $accent(Q, \u{0302})^*b$
3. Resolver o sistema triangular superior $accent(R, \u{0302}) x = accent(Q, \u{0302})^* b$ para $x$

=== S.V.D
Se obtivermos $A = accent(U, \u{0302}) accent(Sigma, \u{0302}) V^*$ (Fatoração S.V.D reduzida), podemos reescrever $P$ como $P = accent(U, \u{0302})accent(U, \u{0302})^*$, porque $accent(U, \u{0302})$ é retangular com colunas ortonormais e $C(A) = C(accent(U, \u{0302}))$, então projetar ortogonalmente sobre $C(A)$ é o mesmo que projetar ortogonalmente sobre $C(accent(U, \u{0302}))$, análogo ao método $Q R$, temos:
$
  accent(U, \u{0302}) accent(Sigma, \u{0302}) V^* x = accent(U, \u{0302})accent(U, \u{0302})^* b <=> accent(Sigma, \u{0302}) V^* x = accent(U, \u{0302})^* b
$
Observe que podemos obter uma nova fórmula para $A^+$, que é $A^+ = V accent(Sigma, \u{0302})^(-1) accent(U, \u{0302})^*$
1. Calcular a S.V.D reduzida $A = accent(U, \u{0302}) accent(Sigma, \u{0302}) V^*$
2. Calcular o vetor $accent(U, \u{0302})^* b$
3. Resolver o sistema diagonal $accent(Sigma, \u{0302})w = accent(U, \u{0302})^* b$ para $w$
4. Definir $x = V w$


= Lecture 12 - Condicionamento e Números de Condição
Esta é a parte em que as coisas começam a ficar confusas, então precisaremos passar por isso com muita calma!

== Condicionamento de um Problema
Primeiro, o que é um problema?

#definition[
  Um _problema_ $f: X -> Y$ é uma função de um espaço vetorial normado $X$ de *dados* para um espaço vetorial normado $Y$ de *soluções*
]

Por que defini um problema assim? Porque, nas próximas aulas, queremos identificar e medir o que acontece quando fornecemos dados ligeiramente diferentes para esse problema. Dado que temos certos dados e os passamos para o problema, e ele nos dá uma solução, a solução difere muito? Apenas um pouco? É a mesma solução?

#definition[
  Um problema *bem-condicionado* é aquele em que todas as pequenas perturbações de $x in X$ geram pequenas diferenças em $f(x) in Y$, ou seja, se fizermos perturbações em $x$, as soluções do problema não mudarão muito
]

#definition[
  Um problema *mal-condicionado* é aquele em que uma pequena perturbação de $x in X$ gera uma grande diferença nas soluções $f(x) in Y$, ou seja, alterar os dados, mesmo que ligeiramente, me dará respostas completamente diferentes para o problema
]

O significado de *pequeno* e *grande* depende do contexto que estou analisando. E como posso medir esse tipo de mudanças? Como quantifico essas mudanças "*pequenas*" e "*grandes*"? Vou defini-lo aqui e mostrar como poderíamos visualizá-lo

#definition("Número de Condição Absoluto")[
  Seja $Delta x$ uma pequena perturbação de $x$ e escreva $Delta f = f(x + Delta x) - f(x)$. O *número de condição absoluto* do problema $f$ é definido como
  $
    accent(kappa, \u{0302}) = lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||Delta f||)/(||Delta x||))
  $

  Para melhor entendimento, podemos reescrevê-lo como $accent(kappa, \u{0302}) = sup_(Delta x)(||Delta f||)/(||Delta x||)$, ou seja, o supremo sobre todas as perturbações infinitesimais em $x$ (entendendo que $Delta x$ e $Delta f$ são infinitesimais)
]

Nossa, não entendi NADA! Calma, vamos tentar desenhar aqui:

#align(center)[
  #image("images/Problem.jpg", width: 14cm)
]

Primeiro, tenho os espaços normados $X$ e $Y$ e como o problema $f$ aplica uma transformação em $x$. Agora, vamos fazer um pequeno ajuste em $x$, tendo $Delta x$, esse novo vetor é uma perturbação infinitesimal em $x$, quase a mesma coisa, agora vamos dar uma olhada em como $f$ afeta $Delta x$:

#align(center)[
  #image("images/Condition-Problem.jpg", width: 14cm)
]

NOSSA, observe como uma ligeira perturbação em $x$ mudou a solução MUITO? Isso significa que este é um problema _mal-condicionado_, e o *maior* dessas perturbações é o *número de condição absoluto* de $f$

Estamos falando de problemas em espaços *normados*, portanto, em sua essência, poderíamos dizer que os problemas são funções de subespaços de $CC^m$ para $CC^n$, o que significa que, se um problema $f$ é _diferenciável_ (é uma função, então pode ou não ser diferenciável), ele tem uma _Jacobiana_. Há uma afirmação que diz, _"Se $f: X -> Y$ é diferenciável, então $f(x + Delta x) approx f(x) + J(x)Delta x$ quando $Delta x -> 0$"_, bem, estamos trabalhando com $Delta x -> 0$, então o que acontece se substituirmos $f(x + Delta x)$ por $f(x) + J(x)Delta x$:

$
  accent(kappa, \u{0302}) = lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||Delta f||)/(||Delta x||)) = lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||f(x + Delta x) - f(x)||)/(||Delta x||)) = lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||f(x) + J(x) Delta x - f(x)||)/(||Delta x||))
$
$
lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||J(x) Delta x||)/(||Delta x||)) <= lim_(Delta -> 0)sup_(||Delta x|| < Delta)((||J(x)|| ||Delta x||)/(||Delta x||)) = ||J(x)||
$

Isso significa que o valor supremo sobre todas as variações infinitesimais de $x$ será $||J(x)||$, ou seja

$
  accent(kappa, \u{0302}) = ||J(x)||
$

#definition("Número de Condição Relativo")[
  Seja $Delta x$ uma pequena perturbação de $x$ e escreva $Delta f = f(x + Delta x) - f(x)$. O *número de condição relativo* do problema $f$ é definido como

  $
    kappa = lim_(Delta -> 0) sup_(||Delta x|| <= Delta) ((||Delta f(x)||)/(||f(x)||)) / ((||Delta x||)/(||x||))
  $
]<relative_condition_number>

Por que definimos um número de condição "relativo"? Porque estou tentando medi-lo relativamente.

Nossa! Você só repetiu a mesma coisa... Calma. Imagine que um engenheiro está construindo um foguete de 1000m, e ele mede um erro de 1m, é um pequeno erro, certo? Mas e se o foguete tiver 2m? É um erro COLOSSAL, certo? Esse é o ponto, estamos tentando medir o erro causado por $Delta x$ com base no tamanho de $x$ e sua solução $f(x)$

Bem, lembre-se que podemos representar o número de condição absoluto como
$
accent(kappa, \u{0302}) = ||J(x)||
$

Podemos fazer algo semelhante com $kappa$, vamos ver:

$
kappa = lim_(Delta -> 0) sup_(||Delta x|| <= Delta) ((||Delta f(x)||)/(||f(x)||)) / ((||Delta x||)/(||x||)) = lim_(Delta -> 0) sup_(||Delta x|| <= Delta) (||Delta f(x)||)/(||f(x)||) (||x||)/(||Delta x||) = lim_(Delta -> 0) sup_(||Delta x|| <= Delta) (||Delta f(x)||)/(||Delta x||) (||x||)/(||f(x)||) = ||J(x)||(||x||)/(||f(x)||)
$

== Condicionamento de Matrizes e Vetores
Agora, um conceito importante para estabilidade e condicionamento é como a multiplicação de vetores e matrizes é condicionada, as multiplicações de vetores são _bem-condicionadas_? _mal-condicionadas_? Como as matrizes são condicionadas? Vamos ver

=== Condição da Multiplicação Matriz-Vetor

#theorem[
  Dado $A in CC^(m times n)$ fixo, o problema de calcular $A x$ com $x$ no espaço normado de dados, o número de condição do problema da matriz é

  $
    kappa = ||A|| (||x||)/(||A x||)
  $

  Se $A$ é quadrada e inversível:

  $
    kappa <= ||A|| ||A^(-1)||
  $
]<condition_number_matrix_vector_multiplication>
#proof[
  Fixe $A in CC^(m times n)$ e o problema de calcular $A x$, com $x$ sendo os dados, ou seja, calcularemos a condição desse problema com base em perturbações de $x$, não de $A$, $A$ será fixo o tempo todo.
  $
    kappa = sup_(Delta x)((||f(x + Delta x) - f(x)||)/(||f(x)||) (||x||)/(||Delta x||)) = sup_(Delta x)((||A(x + Delta x) - A x||)/(||A x||) (||x||)/(||Delta x||)) = sup_(Delta x)((||A Delta x||)/(||A x||) (||x||)/(||Delta x||))
  $
  $
    kappa <= sup_(Delta x)((||A|| ||Delta x||)/(||A x||) (||x||)/(||Delta x||)) = ||A||(||x||)/(||A x||)
  $

  Se $A$ é quadrada e inversível, podemos usar o fato de que $(||x||)/(||A x||) <= ||A^(-1)||$ (prová-lo-emos depois), para expressar $kappa$ como:

  $
    kappa <= ||A|| ||A^(-1)|| or kappa = alpha ||A|| ||A^(-1)||
  $
]

#corollary[
  Seja $A in CC^(m times n)$ não singular e considere a equação $A x = b$. O problema de calcular $b$ dado $x$ tem número de condição
  $
    kappa = ||A||(||x||)/(||b||)
  $
]

#theorem[
  $
    (||x||)/(||A x||) <= ||A^(-1)||
  $
]
#proof[
  Escreva $x$ como $x = A^(-1)(A x)$, isso significa
  $
    ||x|| = ||A^(-1) A x|| <= ||A^(-1)|| ||A x|| <=> (||x||)/(||A x||) <= ||A^(-1)||
  $
]

=== Número de Condição de uma Matriz
O quê? Por que podemos dar um número de condição a uma matriz? Porque elas são *funções*! Por quê? Lembre-se que podemos representar toda *transformação linear* como uma *multiplicação matricial*? Isso implica que, se uma matriz $A$ está em $CC^(m times n)$, então ela pode ser representada como $A: CC^n -> CC^m$! Agora que entendemos por que elas podem ter um número de condição, vamos defini-lo

#definition[
  Dado $A in CC^(m times m)$ não singular, o número de condição de $A$, denotado como $kappa(A)$, é:
  $
    kappa(A) = ||A|| ||A^(-1)||
  $
  Se $A$ é singular
  $
    kappa(A) = infinity
  $
  Se $A$ é retangular
  $
    kappa(A) = ||A|| ||A^(+)||, space (A^(+) = (A^*A)^(-1)A)
  $
]

=== Condição de Sistemas de Equações
#theorem[
  Dado um sistema $A x = b$, vamos manter $b$ fixo e considerar o problema $A  |-> x = A^(-1)b$, o número de condição desse problema é:
  $
    kappa(A)
  $
]
#proof[
  Se perturbarmos $A$ e $x$, fazemos:
  $
    (A + Delta A)(x + Delta x) = b
  $
  $
    <=> A x + A (Delta x) + (Delta A) x + (Delta A)(Delta x) = b
  $
  $
    <=> b + A (Delta x) + (Delta A) x + (Delta A)(Delta x) = b
  $
  $
    <=> A (Delta x) + (Delta A) x + (Delta A)(Delta x) = 0
  $

  Sabemos que $(Delta A)(Delta x)$ é duplamente infinitesimal e ambos estão indo para 0, então podemos descartá-lo, e obtemos

  $
    A (Delta x) + (Delta A)x = 0 <=> Delta x = -A^(-1)(Delta A)x
  $
  Esta equação implica que
  $
    ||Delta x|| <= ||A^(-1)|| ||Delta A|| ||x|| <=> ||Delta x|| ||A|| <= ||A^(-1)|| ||A|| ||Delta A|| ||x||
  $
  $
    (||Delta x||)/(||x||) (||A||)/(||Delta A||) <= ||A^(-1)|| ||A||
  $

  Se fizermos $Delta x -> 0$ e $Delta A -> 0$, temos
  $
    kappa = ||A|| ||A^(-1)|| = kappa(A)
  $
]


= Lecture 13 - Aritmética de Ponto Flutuante
Quando estamos analisando algoritmos e computadores, temos um problema *realmente* grande. Computadores são máquinas discretas, o que significa que, quando falamos de números reais, eles não podem representar *todos* eles, há uma quantidade finita de números que podem representar, dependendo de como esses computadores são construídos. A maioria dos computadores usa um sistema binário para representar números reais, mas eles poderiam usar outros sistemas. Existem dois grandes problemas na representação de números reais:
1. *Underflow & Overflow*: Como eu disse, um computador pode representar um número finito de números reais, isso significa que há um máximo e um mínimo nesse conjunto. Se eu tentar representar um número maior que esse máximo, terei um erro de *overflow*, portanto, tentar representar um número menor, terei um erro de *underflow*. Hoje em dia, isso não é um grande problema, a maioria dos computadores é capaz de armazenar números muito grandes e muito pequenos, suficientes para os problemas com os quais vamos trabalhar
2. *Gap*: Quando tentamos representar números reais, há um problema, porque entre dois números reais, existem infinitos outros números reais, o que nos leva ao problema do *gap*, porque, se o conjunto de números que o computador pode representar é finito, podemos contá-los, e se podemos contá-los, podemos obter uma infinidade de outros números reais entre eles. O problema do *gap* não é realmente um *PROBLEMA*, mas quando estamos criando algoritmos, queremos que eles sejam o mais precisos possível, porque um algoritmo instável pode nos levar a grandes erros de arredondamento

== Conjunto de Ponto Flutuante
O conjunto de números que um computador pode entender e representar é chamado de *Conjunto de Ponto Flutuante*. O livro nos dá uma definição bem complicada, então vou te dar uma mais simples e, depois, entender a definição do livro:

#definition("Definição Simples")[
  Um *Conjunto de Ponto Flutuante* é definido como:
  $
    F = {plus.minus 0,d_1d_2...d_t*beta^e \/ e in ZZ}
  $
  Onde $0,d_1...d_t$ é a *mantissa*, $t in NN^*$ é a *precisão* da mantissa, $beta in NN (beta >= 2)$ é a base, $d_j (0 <= d_j < beta)$ são os dígitos da mantissa e $e in ZZ$ é o *expoente*. Em computadores, *nós* definimos um intervalo para $t$, $e$ e uma base específica $beta$
]

Vamos analisar tudo. Primeiro, definimos tudo, mas o que e por que defini essas coisas?

=== Mantissa
É o núcleo de um número, um número nesse conjunto tem apenas uma mantissa, mas uma mantissa pode estar associada a vários números, por exemplo, podemos representar $1$ no sistema decimal como $0,1*10$ e podemos representar 10 como $0,1*10^2$, isso significa que a mesma mantissa pode representar muitos números. É importante dizer que a mantissa é sempre escrita na base $beta$, veremos o que isso significa agora

=== Base e Precisão
#definition[
  Se temos $x in RR$, escrever $x$ na base $beta$ significa escolher coeficientes $..., alpha_(-1), alpha_0, alpha_1, ...$ com $0 <= alpha_j < beta$ e $alpha_j$ são inteiros tais que:
  $
    x = ... + alpha_2 beta^(2) + alpha_1 beta^1 + alpha_0 beta^0 + alpha_(-1) beta^(-1) + alpha_(-2) beta^(-2) + ...
  $
  Então escrevemos $x$ na base $beta$ como $...alpha_(2)alpha_1alpha_0,alpha_(-1)alpha_(-2)..._beta$, onde cada $alpha_j$ é um dígito
]

Essa é uma maneira de representar cada número real, mas o computador é limitado a uma certa quantidade de $alpha_j$, ele não pode armazenar, por exemplo, 1 bilhão de $alpha_j$, é aí que entra a precisão, ela diz ao computador quantos dígitos a mantissa pode representar!

Espere... mas vimos que a mantissa só armazena números após a _","_, então como o conjunto representa números maiores que 1? É aí que entra o *expoente*

=== Expoente
O expoente indica a ordem do nosso número, por exemplo, com uma mantissa $0,d_1d_2d_3$, podemos representar 4 números diferentes: $0,d_1d_2d_3$, $d_1,d_2d_3$, $d_1d_2,d_3$, $d_1d_2d_3$, eles têm expoentes $0, 1, 2$ e $3$, respectivamente. Mas, se eu tenho uma mantissa $0,d_1...d_t$, por que multiplicá-la por $beta^e$ move a vírgula por $e$ dígitos? (Só para fazer um paralelo, é exatamente assim que nosso sistema decimal funciona, se você tem $0,1$, multiplicá-lo por 10 dá $1$)

#theorem[
  Se você tem $x$ escrito na base $beta$, multiplicá-lo por $beta^e$ moverá a vírgula, na notação da base $beta$, $e$ dígitos para a direita
]
#proof[
  $
    x = ... + alpha_2 beta^(2) + alpha_1 beta^1 + alpha_0 beta^0 + alpha_(-1) beta^(-1) + alpha_(-2) beta^(-2) + ...
  $
  $
    <=> beta^e x = (... + alpha_2 beta^(2) + alpha_1 beta^1 + alpha_0 beta^0 + alpha_(-1) beta^(-1) + alpha_(-2) beta^(-2) + ...) beta^e
  $
  $
    <=> beta^e x = ... + alpha_2 beta^(2) beta^e + alpha_1 beta^1 beta^e + alpha_0 beta^0 beta^e + alpha_(-1) beta^(-1) beta^e + alpha_(-2) beta^(-2) beta^e + ...
  $
  $
    <=> beta^e x = ... + alpha_2 beta^(e+2) + alpha_1 beta^(e+1) + alpha_0 beta^e + alpha_(-1) beta^(e-1) + alpha_(-2) beta^(e-2) + ...
  $
  Observe como todos os $alpha_j$ moveram $e$ dígitos para a esquerda, isso significa que a vírgula move $e$ dígitos para a direita
]

Vamos analisar um exemplo para entender melhor:

#example[
  Criei uma máquina que representa meus números por um conjunto de ponto flutuante $F$ com base decimal ($beta = 10$), precisão $3$ e $e in [-5, 5]$, responda estas perguntas:
  1. Qual é o menor número positivo que $F$ pode representar?

    Bem, se $F$ tem precisão 3, minha mantissa é assim:
    $
      0,d_1d_2d_3_beta
    $
    Então, se queremos o mínimo, precisamos tornar $d_j$ o menor possível, mas ainda diferente de $0$, isso significa que fazemos o último dígito ($d_3$) igual a 1 e o resto igual a $0$, isso significa que a menor mantissa que podemos ter é:
    $
      0,001
    $
    Mas ainda podemos representar um número maior usando o expoente, o menor expoente que temos é $-5$, isso significa que o menor número positivo que esse conjunto pode representar é
    $
      0,001*10^(-5) = 0,00000001
    $
  
  2. Qual é o maior número positivo que $F$ pode representar?

    Seguindo a mesma lógica, a maior mantissa que podemos ter é:
    $
      0,999
    $
    Usando o maior expoente possível, o maior número que nosso conjunto pode representar é:
    $
      0,999 * 10^5 = 99900
    $

  3. O número -3921 está no conjunto?

    Vamos testar, se o decompusermos:
    $
      -3921 = -0,3921 * 10^4
    $
    O expoente está no intervalo $[-5, 5]$, mas a mantissa tem precisão $4$, isso significa que $-3921$ *NÃO ESTÁ NO CONJUNTO $F$*

  4. O número 738000000 está no conjunto?

    Decompondo, temos: $738000000 = 0,738 * 10^9$, como podemos ver, a mantissa tem a precisão desejada, mas o expoente é maior que o intervalo dado, isso significa que 738000000 *NÃO ESTÁ NO CONJUNTO $F$*
]

Agora que entendemos essa definição de conjunto de ponto flutuante, vamos ver a definição do livro:

#definition("Definição do Livro")[
  Sendo $F subset RR$, definimos como:
  $
    F = {plus.minus (m/(beta^t))beta^e}
  $
  Onde $t$, $e$ e $beta$ significam a mesma coisa com as mesmas restrições da definição anterior
]

Qual é a diferença e por que o livro define assim? Há apenas uma grande diferença aqui: Por que ele está definindo a *mantissa* como $m/(beta^t)$? Lembre-se de quando provamos que, se escrevemos $x$ na base $beta$ e multiplicamos $x$ por $beta^e$, a vírgula move $e$ dígitos para a direita? O mesmo se aplica se $e < 0$, mas a vírgula vai para a esquerda, e por que estou dizendo isso? Porque, o que o livro não nos diz, é que escrevemos $m$ *NA BASE $beta$*, e essa divisão por $beta^t$ faz com que obtenhamos apenas os primeiros $t$ dígitos do número, significando que obtemos apenas os dígitos que desejamos, SÓ ISSO (Sim, o livro explica isso mal)

== Números não em $F$
Quando tentamos representar um número que não está em $F$, o computador pode fazer 2 coisas:
1. *Arredondar*: Obtemos $t+1$ dígitos do número, e verificamos se o $(t+1)$-ésimo dígito é maior ou igual a $ceil(beta/2)$, se for, excluímos o $(t+1)$-ésimo dígito e somamos 1 ao $t$-ésimo dígito. Se o $(t+1)$-ésimo dígito for menor que $ceil(beta/2)$, então apenas excluímos o $(t+1)$-ésimo dígito
  #example[
    Arredonde 10324 sabendo que $F$ tem precisão $4$ e $e in [-infinity, +infinity]$ e $beta = 10$.

    Convertendo para a notação de mantissa e expoente: $10324 = 0,10324 * 10^5$, temos 5 dígitos, então vamos ver o $5$-ésimo. $4 >= ceil(10/2) <=> 4 >= 5$? Não, então o número arredondado será $0,1032*10^5$
  ]
2. *Truncar*: Se a mantissa do número passar de $t$ dígitos, removemos todos os dígitos após o $t$-ésimo

Sabendo disso, podemos finalmente entender o que é $epsilon_("machine")$

== Épsilon Máquina
Vamos ver a primeira definição do livro, que é:
$
  epsilon_("machine") = 1/2 beta^(1 - t)
$
Mas o que isso significa? Por que ele definiu assim? Primeiro, $epsilon_("machine")$ é o número que, se fizermos essa operação em $F$, será válida
$
  1 + epsilon_("machine") > 1
$
Isso significa que, se somarmos 1 com um número menor que $epsilon_("machine")$, mesmo que por uma diferença infinitesimal, o número retornado será arredondado ou truncado para $1$ em $F$. O livro diz que essa definição é a distância entre 2 números representáveis em $F$, mas por que isso?

#theorem[
  A distância entre 2 números representáveis em $F$ é $beta^(1-t)$
]
#proof[
  Se temos $x$ escrito na notação da base $beta$ com precisão $t$, escrevemo-lo como:
  $
    x = 0,d_1d_2...d_t_beta
  $
  Se queremos incrementar algo nesse número, mas sem fazer com que ele saia da precisão possível e fazendo o menor incremento possível, podemos adicionar $1$ a $d_t$. Então vamos fazer isso e ver o que acontece, escrevendo $x$:
  $
    x = d_1beta^(-1) + d_2beta^(-2) + ... + d_t beta^(1-t)
  $
  Se somarmos $1$ a $d_t$:
  $
    alpha = d_1beta^(-1) + d_2beta^(-2) + ... + (d_t+1) beta^(1-t)
  $
  $
    <=> alpha = d_1beta^(-1) + d_2beta^(-2) + ... + d_t beta^(1-t) + beta^(1-t)
  $
  Mas observe como podemos reescrever isso como
  $
    alpha = x + beta^(1-t)
  $
  Isso significa que $alpha$ (o próximo número representável), é $x + bold(beta^(1-t))$, ou seja, a distância entre eles
]

Agora podemos visualizá-lo como uma linha, onde temos os números representáveis e, se tentarmos representar um número que está no intervalo entre eles, o computador o arredondará com base em $epsilon_("machine")$

#align(center)[
  #image("images/Epsilon_Machine.jpg", width: 13.5cm)
]

Os pontos azul-ciano representam números reais que não podem ser representados inteiramente por $F$, e as setas mostram para onde o computador os arredonda. Mudaremos essa definição mais tarde, e você entenderá por que depois.

O livro nos mostra uma desigualdade que todo $epsilon_("machine")$ deve satisfazer, mas essa desigualdade pode ser reescrita:

#definition[
  Seja $F$ um conjunto de ponto flutuante. $"fl": RR -> F$ é uma função que retorna a aproximação arredondada da entrada $x$ no conjunto $F$
]

#theorem("Conversão de Ponto Flutuante")[
  $forall x in RR$, existe $epsilon$ com $|epsilon| <= epsilon_("machine")$ tal que:
  $
    "fl"(x) = x(1+epsilon)
  $
]<floating_point_conversion>

O que isso significa? Significa que, sempre que arredondamos um número real para ajustá-lo em $F$, o número arredondado é equivalente a multiplicar $x$ por $1+$ um número muito pequeno, você pode visualizá-lo olhando para a representação em linha de $F$ que mostrei antes

== Aritmética de Ponto Flutuante
Precisamos fazer operações com números, certo? Mas temos o mesmo problema, os computadores precisam arredondar porque não conseguem entender todos os números em um intervalo, então como podemos tornar as operações o mais precisas possível? Construímos um computador baseado neste princípio (alguns computadores podem ter mais princípios em seu núcleo, então algumas operações podem ser ainda mais precisas, mas vamos focar apenas neste):

#definition("Axioma Fundamental da Aritmética de Ponto Flutuante")[
  Dado que $+$, $-$, $times$ e $div$ representam operações em $RR$, considere $plus.circle$, $minus.circle$, $times.circle$ e $div.circle$ sendo operações em $F$. Seja $ast.circle$ definir qualquer uma das operações anteriores em $F$, então definimos um computador que realiza a operação $x ast.circle y$ como
  $
    x ast.circle y = "fl"(x ast y) = (x ast y)
  $
  Isso significa que construímos um computador tal que $forall x, y in F$, existe $epsilon$ com $|epsilon| <= epsilon_("machine")$ tal que
  $
    x ast.circle y = (x ast y)(1 + epsilon)
  $
]<fundamental_axiom_of_floating_point_arithmetic>

Em outras palavras, toda operação em $F$ tem um erro com tamanho *no máximo* $epsilon_("machine")$

== Mais sobre Épsilon Máquina
Agora podemos redefinir $epsilon_"machine"$! Mas por quê? Bem, queremos torná-lo o menor possível, e às vezes aumentar a precisão não é uma opção:

#definition[
  $epsilon_"machine"$ é o menor valor tal que @floating_point_conversion e @fundamental_axiom_of_floating_point_arithmetic são válidos
]

Isso implica que, para alguns computadores, $epsilon_"machine"$ pode ser ainda menor que $1/2 beta^(1-t)$, o que é uma coisa *muito* boa!


= Lecture 14 e 15 - Estabilidade
Quando falamos de *estabilidade*, estamos tentando verificar se um algoritmo tem fidelidade no computador! Isso significa, se os arredondamentos que o computador faz nas entradas e saídas não mudarão o resultado para algo muito diferente do original. Mas primeiro, precisamos definir matematicamente o que é um algoritmo!

#definition[
  Seja um problema $f: X -> Y$ e um computador com sistema de ponto flutuante que satisfaz @fundamental_axiom_of_floating_point_arithmetic fixado. O algoritmo de $f$, $accent(f, ~): X->F^n subset Y$, é uma função que representa uma série de passos e suas implementações no computador dado com o objetivo de resolver o problema $f$

  *Nota:* $F^n subset Y$ apenas representa que tenho um vetor de números que podem ser representados por $F$ e esse vetor está em $Y$
]

Bem, sabemos que, se passarmos $x in X$ para esse algoritmo, o resultado $accent(f, ~)(x)$ pode ser afetado por erros de arredondamento! Na maioria dos casos, $accent(f, ~)$ não é uma função contínua, mas o algoritmo precisa aproximar $f(x)$ da melhor forma possível.

Vamos fazer uma definição para um algoritmo *estável* também! Primeiro, vamos definir a *precisão* de um algoritmo

#definition("Precisão do Algoritmo")[
  Um algoritmo $accent(f, ~)$ é preciso se:
  $
    (||accent(f, ~)(x) - f(x)||)/(||f(x)||) = O(epsilon_"machine")
  $
]

O QUÊ? O QUE DIABOS $O(epsilon_"machine")$ SIGNIFICA??? Calma, calma, farei uma definição formal mais tarde, por agora, você pode entender que um algoritmo é preciso se o erro entre a saída do algoritmo e a saída original não ultrapassa $epsilon_"machine"$

Em algoritmos mal-condicionados, a igualdade mostrada na definição é muito ambiciosa, porque erros de arredondamento são inevitáveis, nesse tipo de algoritmos, esse arredondamento pode causar grandes erros, ultrapassando os erros desejados que queríamos

Agora podemos definir um algoritmo *estável*

#definition("Algoritmo Estável")[
  Um algoritmo $accent(f, ~)$ para um problema $f$ é estável se
  $
    forall x "é válido que" (||accent(f, ~)(x) - f(accent(x, ~))||)/(||f(accent(x, ~))||) = O(epsilon_"machine")
  $
  $
    "para um" accent(x, ~) "com" (||accent(x, ~) - x||)/(||x||) = O(epsilon_"machine")
  $
]<stable_algorithm>

Espere, o quê? O que essa definição significa?

Significa que, todos os dados semelhantes aos meus dados originais passados para o meu algoritmo retornarão saídas muito semelhantes às soluções corretas (isso é mostrado com $epsilon_"machine"$, ou seja, a diferença entre as soluções dadas pelo algoritmo e as soluções reais não ultrapassará $epsilon_"machine"$)

Existe outro tipo de *estabilidade*, muito poderoso:

#definition("Estabilidade Retroativa")[
  Um algoritmo $accent(f, ~)$ para $f$ é *estável retroativamente* se:
  $
    forall x in X "é válido que" exists accent(x, ~) "com" (||accent(x, ~) - x||)/(||x||) = O(epsilon_"machine") "tal que" accent(f, ~)(x) = f(accent(x, ~))
  $
]

Isso significa que, se eu passar os dados para o algoritmo, posso encontrar uma perturbação muito pequena $accent(x, ~)$ tal que a solução do problema se eu passar essa perturbação é a *mesma* que se eu passar os dados originais para o algoritmo!

#example[
  Dado o dado $x in CC$, verifique se o algoritmo $x plus.circle x$ para calcular o problema de somar dois números iguais (solução é $2 x$) é estável retroativamente:

  Temos que
  $
    f(x) = x + x e accent(f, ~)(x) = x plus.circle x
  $
  Isso significa
  $
    accent(f, ~)(x) = (2 x)(1+epsilon)
  $
  Vamos verificar se esse algoritmo é *estável*. Primeiro, defina $accent(x, ~) = x(1+epsilon)$, sabemos que $epsilon = O(epsilon_"machine")$, vamos verificar se o erro relativo entre $x$ e $accent(x, ~)$ é $O(epsilon_"machine")$:
  $
    (||accent(x, ~) - x||)/(||x||) = (||x(1+epsilon) - x||)/(||x||) = (||x(1+epsilon - 1)||)/(||x||) = |epsilon| = O(epsilon_"machine")
  $
  Então $x(1+epsilon)$ é uma definição *válida* para $accent(x, ~)$, deixando isso claro, vamos verificar se $accent(f, ~)$ é estável
  $
    (||accent(f, ~)(x) - f(accent(x, ~))||)/(||f(accent(x, ~))||) = (||2 x (1+epsilon) - 2 x (1+epsilon)||)/(||f(accent(x, ~))||) = 0 = O(epsilon_"machine")
  $
  Isso significa que $accent(f, ~)$ é estável, mas é *estável retroativamente*? Precisamos de uma definição de $accent(x, ~)$ que ainda satisfaça a condição de $x$ definida em @stable_algorithm. Vamos verificar se nossa definição satisfaz, já verificamos que a condição é válida, mas ela satisfaz $f(accent(x, ~)) = accent(f, ~)(x)$?
  $
    accent(f, ~)(x) = 2 x (1 + epsilon)
  $
  $
    f(accent(x, ~)) = 2 x (1 + epsilon)
  $
  Isso significa que esse algoritmo *É* de fato *estável retroativamente*
]

== Definição Formal de $O(epsilon_"machine")$
Vou escrever a definição aqui e explicar o que significa logo depois

#definition[
  Dadas as funções $phi(t)$ e $psi(t)$, a sentença
  $
    phi(t) = O(psi(t))
  $
  significa que $exists C > 0$ tal que $forall t$ suficientemente próximo de um limite conhecido (por exemplo, $t -> 0$, $t -> infinity$), é válido que:
  $
    phi(t) <= C psi(t)
  $
]

O que isso significa? Significa que, se escrevemos $phi(t) = O(psi(t))$, e sabemos para onde $t$ está indo, existe $C > 0$ tal que os valores de $phi(t)$ nunca serão maiores que $C psi(t)$. Na maioria das vezes, eu nem me importo com o que é $C$, só me importo com sua existência!

Falando sobre como estamos tratando $epsilon_"machine"$, o limite implícito aqui é $epsilon_"machine" -> 0$, e escrever que $phi(t) = O(epsilon_"machine")$ significa que temos uma constante que limita o erro a uma quantidade de $epsilon_"machine"$, ou seja, o erro nunca será maior que, por exemplo, $3$ vezes $epsilon_"machine"$, $2$ e meio vezes $epsilon_"machine"$.

Podemos fazer uma definição formal mais forte (mas mais confusa) para a notação $O$

#definition[
  Dado $phi(s, t)$, temos que:
  $
    phi(s, t) = O(psi(t)) "uniformemente em" s
  $
  garante que $exists ! C > 0$ tal que:
  $
    phi(s, t) <= C psi(t)
  $
  e isso é válido para qualquer $s$ que eu escolher
]

É uma definição semelhante, estou apenas adicionando uma variável que posso escolher e que não mudará nada.

Em computadores reais, $epsilon_"machine"$ é um número fixo, então quando estamos trabalhando com o limite implícito $epsilon_"machine" -> 0$, estamos selecionando uma família *ideal* de computadores!

== Dependência de $m$ e $n$
Na prática, quando falamos de erros de arredondamento, a estabilidade de algoritmos envolvendo uma matriz $A$ não depende da própria $A$, mas de $m$ e $n$ (suas dimensões). Podemos ver isso analisando o seguinte problema:

Suponha que eu tenha um algoritmo para resolver um sistema não singular $m times m$ $A x = b$ para $x$ e garantimos que a solução $accent(x, ~)$ dada pelo algoritmo satisfaz
$
  (||accent(x, ~) - x||)/(||x||) = O(kappa(A)epsilon_"machine")
$
Isso significa que existe uma constante $C$ que satisfaz
$
  ||accent(x, ~) - x|| <= C kappa(A) epsilon_"machine" ||x||
$
Isso mostra que, mesmo $C$ não dependendo nem de $A$ nem de $b$, acaba dependendo das dimensões de $A$ porque, se mudarmos $m$ ou $n$, os dados passados para o problema mudam, o que significa que teremos um *novo* problema porque estamos mudando seu domínio e $kappa(A)$ também mudará se alterarmos suas dimensões!

== Independência da Norma
Você pode ter notado que, quando estamos definindo coisas em estabilidade com normas, denotamos $||dot||$ como *qualquer* tipo de norma, mas, se escolhermos uma certa norma, a definição pode não ser válida, certo? Como, pode ser válida para $||dot||_2$, mas não para $||dot||_3$, certo? Na verdade, errado! Podemos mostrar que *precisão*, *estabilidade* e *estabilidade retroativa* mantêm suas propriedades para *qualquer* tipo de norma! Isso significa que, quando escolhemos uma norma, podemos escolher uma que facilite os cálculos!

#theorem[
  Para problemas $f$ e seus algoritmos $accent(f, ~)$ em espaços normados de dimensão finita $X$ e $Y$, as propriedades de *precisão*, *estabilidade* e *estabilidade retroativa* são válidas ou não independentemente de qual norma eu escolher para fazer a análise
]
#proof[
  Se provarmos que, se $||dot||$ e $||dot||'$ são duas normas em $X$ e $Y$, então $exists c_1, c_2$ tais que:
  $
    c_1||x|| <= ||x||' <= c_2||x||
  $
  então o teorema mostrado antes é válido, porque isso mostra:
  1. Se uma sequência converge ou é muito pequena em uma norma, ela será em todas as outras normas também
  2. Pequenos erros em uma norma serão pequenos em todas as outras normas também

  Mas precisamos provar a afirmação anterior, certo? Vamos fazer isso! (O livro apenas diz que é fácil, lol)

  Primeiro, vamos reduzir o problema a uma esfera unitária das normas, vamos definir:
  $
    S = { x in CC^(n) \/ ||x|| = 1 }
  $
  esse conjunto é *fechado* porque a norma é *contínua* e é *limitado* (uma esfera, lol). Agora vamos definir a função $f(x) = ||x||'$, porque $f(x)$ é contínua em $CC^n$ e $S$ é fechado e limitado, podemos encontrar o *máximo* e o *mínimo* valor de $f$ em $S$, vamos definir:
  1. $m = min_(x in S)||x||'$
  2. $M = max_(x in S)||x||'$
  $m > 0$ porque $0 in.not S$. Agora, vamos tentar generalizar em $CC^n$. Se queremos generalizar para todo $x != 0 in CC^n$, vamos escrever:
  $
    x = ||x||(x/(||x||))
  $
  Você pode ver claramente que $x/(||x||) in S$ porque $||x/(||x||)|| = 1$. Então, vamos ver o que acontece se tomarmos $||x||'$:
  $
    ||x||' = || ||x||(x/(||x||)) ||' = ||x|| ||x/(||x||)||'
  $
  Se você olhar de perto, $x/(||x||)$ é um vetor em $S$, isso significa que $||x/(||x||)||' in [m, M]$ e, por causa de $||x||$ (número escalar positivo), podemos ver que
  $
    ||x|| ||x/(||x||)||' in [ ||x||m, ||x||M ]
  $
  Podemos reescrever isso como
  $
    m||x|| <= ||x||' <= M||x||
  $
  Isso significa que essas duas constantes existem e provam o teorema estabelecido antes
]

== Estabilidade da Aritmética de Ponto Flutuante
#theorem[
  As operações $plus.circle$, $minus.circle$, $times.circle$ e $div.circle$ são *estáveis retroativamente*
]
#proof[
  Defina $ast.circle$ como qualquer uma das 4 operações mostradas antes. Dado um problema $f: X -> Y$ que está calculando $x_1 ast x_2$, o algoritmo $accent(f, ~)$ para resolver esse problema é $accent(f, ~)(x) = "fl"(x_1) ast.circle "fl"(x_2)$ onde $x = mat(x_1;x_2)$.

  Temos que:
  $
    accent(f, ~)(x) = "fl"(x_1) ast.circle "fl"(x_2)
  $
  $
    = ("fl"(x_1) ast "fl"(x_2))(1 + epsilon_3)
  $
  $
    = (x_1(1 + epsilon_1) ast x_2(1 + epsilon_2))(1 + epsilon_3)
  $
  $
    = x_1(1+epsilon_1)(1+epsilon_3) ast x_2(1+epsilon_2)(1+epsilon_3)
  $
  $
    = x_1(1+epsilon_4) ast x_2(1+epsilon_5)
  $

  Onde $epsilon_4 = O(epsilon_"machine")$ e $epsilon_5 = O(epsilon_"machine")$. Calculamos $accent(f, ~)(x)$, agora vamos ver $f(accent(x, ~))$. Primeiro, vamos definir:
  $
    accent(x, ~) = mat(x_1(1+epsilon_4);x_2(1+epsilon_5))
  $

  Se definirmos $accent(x, ~)$ assim, podemos ver claramente que
  $
    f(accent(x, ~)) = x_1(1+epsilon_4) + x_2(1+epsilon_5) = accent(f, ~)(x)
  $

  Mas a condição $(||accent(x, ~) - x||)/(||x||) = O(epsilon_"machine")$ é satisfeita?
  $
    (||accent(x, ~) - x||)/(||x||) = (||mat(x_1(1+epsilon_4);x_2(1+epsilon_5)) - mat(x_1;x_2)||)/(||mat(x_1;x_2)||) = (||mat(x_1 epsilon_4;x_2 epsilon_5)||)/(||mat(x_1;x_2)||)
  $
  Usando a norma 1
  $
    (x_1 epsilon_4 + x_2 epsilon_5)/(x_1 + x_2) = (x_1 O(epsilon_"machine") + x_2 O(epsilon_"machine"))/(x_1 + x_2) = ((x_1 + x_2)O(epsilon_"machine"))/(x_1 + x_2) = O(epsilon_"machine")
  $

  Isso mostra que $plus.circle$, $minus.circle$, $times.circle$ e $div.circle$ são *estáveis retroativamente*
]

== Precisão de um Algoritmo Estável Retroativamente
Falamos de números de condição antes da estabilidade, vamos tentar associar ambos!

#theorem[
  Suponha que um algoritmo estável retroativamente $accent(f, ~)$ é aplicado para um problema $f: X -> Y$ com número de condição $kappa$ em um computador que satisfaz @floating_point_conversion e @fundamental_axiom_of_floating_point_arithmetic, então, o erro relativo satisfaz:
  $
    (||accent(f, ~)(x) - f(accent(x, ~))||)/(||f(accent(x, ~))||) = O(kappa(x)epsilon_"machine")
  $
]
#proof[
  Por definição, temos $accent(f, ~)(x) = f(x + delta x)$ com $(||delta x||)/(||x||) = O(epsilon_"machine")$. Usando @relative_condition_number (Número de Condição Relativo), temos que:
  $
    kappa(x) = lim_(delta x -> 0) ((||f(x + delta x) - f(x)||)/(||f(x)||)) ((||x||)/(||delta x||))
  $
  $
    kappa(x) = lim_(delta x -> 0)((||accent(f, ~)(x) - f(x)||)/(||f(x)||)(||x||)/(||delta x||))
  $

  Usando algumas definições formais (nem eu entendo, então se tentar explicar aqui, só perderei tempo, lol), podemos reescrever isso como:
  $
    (||accent(f, ~)(x) - f(x)||)/(||f(x)||) <= (kappa(x) + o(1))(||delta x||)/(||x||)
  $

  Onde $o(1) -> 0$ quando $epsilon_"machine" -> 0$
]