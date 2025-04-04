// Lembrar que não estamos usando o latex, ou seja, não devemos usar "\" para comandos e não devemos deixar letras juntas com comandos, como em "\mathbb{R}^m" que deve ser escrito como "RR^m".

// #set heading(numbering: "1.")

#let int = $integral$
#let supp = "supp"
#let cl = "cl"
#let qed = align(right, text(12pt)[$square$])
#let dx = $d x$
#let dif = $d/dx$
#let cdot = $dot.c$

#set page(numbering: "1")

#align(right, text(12pt)[
  FGV - EMAP
])


#align(center, text(17pt)[
  A1 2020 Pobrebilidade - To aprendendo typst

  #datetime.today().display("[day]/[month]/[year]")
])

= Exercício 1
== #rect(width: 100%, height: auto)[A probabilidade de uma pessoa que fuma ter câncer de pulmão é 20 vezes maior doque as que não fumam. Em uma certa população, 10% das pessoas fumam. Se uma pessoa escolhida ao acaso nessa população tem câncer de pulmão, qual é a probabilidade de que ela seja fumante?]

== Solução

Queremos $P(F|C)$, onde C é o evento no qual a pessoa tem câncer de pulmão e F o evento na qual ela fuma, sabemos que vale $P(C|F) = 20 P(C|F^c)$, logo façamos:

$
  P(C|F) + P(C|F^c) = 20 P(C|F^c) + P(C|F^c)\ = P(C) = 21P(C|F^c),
$

E pelo Teorema de Bayes:

$
  P(F|C) = (P(C|F)P(F)) / P(C)  = (20 P(C|F^c) 1/10) / (21 P(C|F^c)) = 2/21.
$


= Exercício 2
== #rect(width: auto, height: auto)[2. As amigas Ana, Beatriz, Cláudia e Diana têm uma bola cada uma. Quando toca um sinal, cada menina escolhe, ao acaso, uma de suas três amigas para jogar sua bola.

a) Qual é a probabilidade de que Ana receba exatamente uma bola? E de que 
receba duas bolas? [Sugestão: qual é a distribuição do número de bolas recebidas
por Ana?]

b) Qual é a probabilidade de que Ana receba exatamente uma bola e Bruna não
receba nenhuma?

c) Seja X o número de meninas que recebem exatamente uma bola. Calcule EX.]

== Solução
=== a)

Com $X$ = Quantidade de bolas recebidas por ana, de fato $X ~ B(3, 1/3)$, onde B é a distribuição binomial com parâmetros 3 (quantidade de experimentos realizados) e 1/3 (a probabilidae de sucesso de cada um), então estamos interessados em calcular:

$
  P(X = 1) = binom(3, 1) (1/3)^1 (2/3)^(3-1) = 3 (1/3) (4/9) = 4/9.\ P(X = 2) = binom(3, 2) (1/3)^2 (2/3)^(3-2) = 3 (1/9) (2/3) = 6/27 = 2/9.
$ 

=== b)

Queremos o caso $X = 1$ e $Y = 0$, onde $Y$ é a quantidade de bolas recebidas por Bruna, que em particular também segue a distribuição binomial, e de fato os 2 eventos são indepententes, pois todos os lançamentos são feitos ao acaso, logo $P(X = 1 inter Y = 0) = P(X = 1) inter P(Y = 0)$, logo:

$
  P(X = 1) = 4/9,\
  P(Y = 0) = binom(3, 0) (1/3)^0 (2/3)^(3-0) = 1 (1) (8/27) = 8/27,\
  P(X = 1 inter Y = 0) = (4/9) (8/27) = 32/243.
$

=== c)

Com X sendo o número de meninas que recebem exatamente uma bola, X segue a distribuição binomial com parâmetros 4 (quantidade de experimentos realizados) e 1/3 (a probabilidae de sucesso de cada um), então temos:

$
  EE(X) = sum_(phi in RR)phi P(X = phi) = sum_(phi in RR)phi binom(4, phi) (1/3)^phi (2/3)^(4-phi) = 4/3.
$

= Exercício 3

== #rect(width: auto, height: auto)[3. Uma caixa possui 4 bolas brancas e 6 pretas, idênticas a menos da cor. As bolas são retiradas da caixa uma a uma, sem reposição.

a) Qual é a probabilidade de que saiam 2 bolas brancas nas primeiras 4 retiradas?

b) Dado que sairam 2 bolas brancas nas primeiras 4 bolas retiradas, qual é a probabilidade de que a décima bola retirada seja branca?

c) Dado que sairam 2 bolas brancas nas primeiras 4 bolas retiradas, qual é a probabilidade de que a primeira bola retirada tenha sido branca?]

== Solução

=== a) 

Sendo $X$ a quantidade de bolas brancas retiradas, de fato $X ~ B(4, 4/10)$, então:

$
  P(X = 2) = binom(4,2) (4/10)^2 (6/10)^(4-2).
$

=== b)

Se saíram 2 brancas nas 4 primeiras retiradas, então saíram 2 pretas nesse mesmo experimento. Como 4 bolas já foram retiradas, faltam 6 para a décima, temos 2 brancas e 4 pretas num subespaço $Omega_2 subset Omega$, a décima bola (última bola que tiraremos) é branca se e somente se tivermos apenas 1 bola branca retirada nos primeiros 5 experimentos (assim o sexto $arrow$ décima bola total será branca).

Seja então $Y$ o número de bolas brancas retiradas a partir da quarta bola (evento descrito acima), de fato $Y ~B(6, 2/4)$, e estamos interessados em:

$
  P(Y = 1) = binom(6,1) (2/4)^1 (2/4)^(6-1).
$.

=== c)

Se saíram 2 bolas brancas nas primeiras 4 retiradas, então saíram 2 pretas também, e os possíveis casos são:

$
  B P B P , B B P P , ... , P P B B
$

Basta contar em quantos desses casos a primeira entrada é um $B$. (trivial)

= Exercício 4
== #rect(width: auto, height: auto)[Um monitor atende aos 20 alunos de uma turma. Em cada dia, cada aluno tem
probabilidade 0,1 de procurar o monitor, independentemente dos demais alunos e do
que ocorre nos demais dias. O monitor tem tempo para atender a no máximo 2
alunos por dia; se um número maior de alunos procura o monitor, os últimos a fazê-
lo não são atendidos. A função de distribuição acumulada da variável aleatória X
que representa o número de alunos a procurarem o monitor em um dado dia é dada
parcialmente na tabela abaixo.

a) Qual é a probabilidade de que, em um dado dia, haja algum aluno que procure o monitor mas não seja atendido?

b) Qual é a probabilidade de que o primeiro atendimento feito pelo monitor ocorra no terceiro dia de atendimento?

c)Qual é o valor esperado do número de alunos que, emum determinado dia, procuram o monitor, mas não conseguem ser atendidos?

]



