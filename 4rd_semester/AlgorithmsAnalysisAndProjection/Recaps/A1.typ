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
    Projeto e Análise de Algoritmos
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
  = Notação Assintótica
]

#pagebreak()

Já vemos desde o começo do curso que um algoritmo é um conjunto de instruções feitas com o objetivo de resolver um determinado problema. Porém, certos problemas apresentam diversos tipos de solução!

#figure(
  caption: [Caminhos problema-solução],
  image("images/problem-solution-path.png")
)

Então como podemos comparar eles? Como eu sei qual que é o melhor caminho até minha solução? De primeira a gente pode pensar: "Vê quanto tempo executou!", mas isso gera um problema... Se eu executo um algoritmo em um computador de hoje em dia e o mesmo algoritmo em um computador de 1980, com certeza eles vão levar tempos diferentes para executar, correto? Isso pode afetar na medição que eu estou fazendo do meu algoritmo!

Então o que fazer? O mais comum é analisarmos o quão bem meu algoritmo consegue funcionar de acordo com o quão grande meu problema fica!

#definition("Função de Complexidade")[
  A complexidade de um algoritmo é a função $T: U^+ -> RR$ que leva do espaço do tamanho das entradas do problema até a quantidade de instruções feitas para realizá-lo
]

#example[
  ```py
  def sum(numbers: list):
    result = 0
    for number in numbers:
      result += 1
    return result
  ```
  Eu tenho que, para esse algoritmo, $T(n) = n$, pois, quanto maior é a quantidade de números na minha lista, maior é o tempo que a função vai ficar executando
]

Só que achar qual é essa função exatamente pode ser muito trabalhoso, além de que muitas funções são parecidas e podem gerar uma dificuldade na hora da análise. Então o que fazemos?

Faz sentido dizermos que, se a partir de algum ponto uma função $T_1$ cresce mais do que $T_2$, então o algoritmo $T_1$ acaba sendo pior, então criamos a definição:

#definition("Big O")[
  Dizemos que $T(n) = O(f(n))$ se $exists c, n_0 > 0$ tais que
  $
    T(n) <= c f(n), space forall n >= n_0
  $
]

Ou seja, dado algum $c$ e $n_0$ qualquer, depois de $n_0$, $f(n)$ SEMPRE cresce mais que $T(n)$

#definition([Big $Omega$])[
  Dizemos que $T(n) = Omega(f(n))$ se $exists c, n_0 > 0$ tais que
  $
    T(n) >= c f(n), space forall n >= n_0
  $
]

#definition([Big $Theta$])[
  Dizemos que $T(n) = Theta(f(n))$ se $T(n) = Omega(f(n))$ e $T(n) = O(f(n))$
]

#pagebreak()

#align(center + horizon)[
  = Recorrência
]

#pagebreak()

Alguns algoritmos são fáceis de terem suas complexidades calculadas, porém, na programação, existem casos onde uma função utiliza ela mesma dentro de sua chamada, as temidas *recursões*

```py
def fatorial(n):
  if n == 1:
    return 1
  return n*fatorial(n-1)
```

Então nós temos um $T(n)$ que chama $T(n-1)$, o que fazemos? Temos 4 métodos de resolver esse problema
- *Método da substituição*
- *Método da árvore de recursão*
- *Método da iteração*
- *Método mestre*

== Método da substituição
Vamos provar por *indução* que $T(n)$ é $O$ de uma função *pressuposta*. Só posso usar quando eu tenho uma hipótese da solução. Precisamos provar exatamente a hipótese. Pode ser usado para limites superiores e inferiores
#example[
  $
    T(n) = cases(
      theta(1) "se" n = 1,
      2 T(n/2) + n "se" n > 1
    )
  $
  Vamos pressupor que $T(n) = O(n^2)$. Queremos então provar $T(n) <= c n^2$.

  *Caso base*: $n=1 => T(1) = 1 <= c n^2$

  *Passo Indutivo*: Vamos supor que vale para $n/2$, e ver se vale para $n$. Então temos:
  $
    T(n/2) <= c n^2/4
  $
  Vamos testar para $T(n)$ então
  $
    T(n) = 2T(n/2) + n => T(n) <= 2c n^2/4 + n  \
    <=> T(n) <= (c n^2)/2 + n  \
    <=> (c n^2)/2 + n <= c n^2  \
    <=> 2n <= 2c n^2 - c n^2  \
    <=> n/2 <= c
  $
  Ou seja, conseguimos escolher um $c$ e um $n_0$ de forma que $forall n >= n_0$, $T(n) <= c n^2$, logo, $T(n) = O(n^2)$
]

== Método da árvore de recursão
O método da árvore de recursão consiste em construir uma árvore definindo em cada nível os sub-problemas gerados pela iteração do nível anterior. A forma geral é encontrada ao somar o custo de todos os nós
- Cada nó representa um subproblema.
- Os filhos de cada nó representam as suas chamadas recursivas.
- O valor do nó representa o custo computacional do respectivo problema.

Esse método é útil para analisar algoritmos de divisão e conquista.

#example[
  $
    T(n) = cases(
      theta(1) "se" n = 1,
      2 T(n/2) + n "se" n > 1
    )
  $

  #figure(
    caption: [Árvore de $T(n)$],
    image("images/tree-example.png")
  )

  Temos então que:
  $
    T(n) = sum_(k=0)^(log(n)) 2^k n/(2^k) = n log(n) + n
  $
  Então temos que $T(n) = O(n log(n))$
]

== Método da Recorrência
O método da iteração consiste em expandir a relação de recorrência até o $n$-ésimo termo, de forma que seja possível compreender a sua forma geral

#example[
  $
    T(n) = cases(
      theta(1) "se" n = 1,
      2 T(n-1) + n "se" n > 1
    )
  $

  Expandindo, temos:
  $
    T(n) = 2 T(n-1) + n   \
    T(n) = 2( 2 T(n-2) + n ) + n    \
    dots.v    \
    T(n) = 2^k T(n-k) + (2^k - 1)n - sum^(k-1)_(j=1)2^j j
  $
  Para chegar na última iteração, temos que $k = n-1$
  $
    T(n) = 2^(n-1) + (2^(n-1) - 1)n - sum^(n-2)_(j=1)2^j j
  $
  Temos que: $sum^(n-2)_(j=1)2^j j = 1/2 (2^n n - 3 dot 2^n + 4)$, então podemos fazer:
  $
    T(n) = 2^(n-1) + 2^(n-1)n - n - 2^(n-1) n + 3 dot 2^(n-1) - 2   \
    <=> T(n) = 2^(n-1) - n + 3 dot 2^(n-1) - 2    \
    <=> T(n) = 4 dot 2^(n-1) - n - 2  = 2^(n+1) - n - 2   \
    <=> T(n) = Theta(2^n)
  $
]

== Método mestre
Esse teorema é uma decoreba. Ele te dá um caso geral e vários casos de resultado dependendo dos valores na estrutura de $T(n)$

#theorem("Teorema Mestre")[
  Dada uma recorrência da forma
  $
    T(n) = a T(n/b) + f(n)
  $
  Considerando $a >= 1$, $b > 1$ e $f(n)$ assintoticamente positiva
  - Se $f(n) = O(n^( log_b (a) - epsilon ))$ para alguma constante $epsilon > 0$, então *$T(n) = Theta(n^( log_b (a) ))$*
  - Se $f(n) = Theta( n^( log_b (a) ) )$, então *$T(n) = Theta(f(n) log(n))$*
  - Se $f(n) = Omega( n^( log_b (a) + epsilon ) )$ para alguma constante $epsilon > 0$ e atender a uma condição de regularidade $a f(n/b) <= c f(n)$ para alguma constante positiva $c < 1$ e para todo $n$ suficientemente grande, então *$T(n) = Theta(f(n))$*
]

#example("Primeiro caso")[
  $
    T(n) = 9 T(n/3) + n
  $
  Então $a = 9$, $b = 3$ e $f(n)=n$, calculamos então:
  $
    n^( log_b (a) ) = n^( log_3 (9) ) = n^2
  $
  Ou seja, conseguimos escolher $epsilon = 1$ de forma que
  $
    f(n) = O(n^(2 - 1)) = O(n)
  $
  Ou seja, $T(n) = Theta(n^2)$
]

#example("Segundo caso")[
  $
    T(n) = T( (2n)/3 ) + 1
  $
  Então $a = 1$, $b = 3/2$ e $f(n)=1$, calculamos então:
  $
    n^( log_b (a) ) = n^( log_(3/2) (1) ) = 1
  $
  Ou seja, $f(n) = Theta(n^( log_b (a) ))$, e isso quer dizer que $T(n) = Theta(n^( log_(3/2) (1) log(n) )) = Theta(log(n))$
]

#example("Terceiro caso")[
  $
    T(n) = 3 T(n/4) + n log(n)
  $
  Então $a = 3$, $b = 4$ e $f(n)= n log(n)$, calculamos então:
  $
    n^( log_b (a) ) = n^( log_(4) 3 ) approx n^(0.79)
  $
  Temos então que $f(n) = Omega(n^( log_4 3 + epsilon ))$ para um $epsilon approx 0.2$. Então agora vamos analisar a condição de regularidade:
  $
    a f(n/b) <= c f(n)    \
    3 ( n/4 log(n/4) ) <= c n log(n) => c >= 3/4
  $
  Ou seja, $T(n) = Theta(n log(n))$
]

#example("Exemplo que não funciona")[
  $
    T(n) = 2 T(n/2) + n log(n)
  $
  Para agilizar, isso se encaixa no caso em que $f(n) = Omega(n^( log_b (a) + epsilon ))$. Vamos então checar a regularidade:
  $
    a f(n/b) <= c f(n)              \
    2 n/2 log(n/2) <= c n log(n)    \
    <=> c >= 1 - 1/log(n)
  $
  *Impossível!* Já que $c < 1$
]

Esse método pode ser simplificado para uma categoria específica de funções

#theorem("Teorema mestre simplificado")[
  Dada uma recorrência do tipo:
  $
    T(n) = a T(n/b) + Theta(n^k)
  $
  Considerando $a >= 1$, $b > 1$ e $k >= 0$:
  - Se $a > b^k$, então *$T(n) = Theta(n^( log_b a ))$*
  - Se $a = b^k$, então *$T(n) = Theta(n^k log n)$*
  - Se $a < b^k$, então *$T(n) = Theta(n^k)$*
]


#pagebreak()

#align(center + horizon)[
  = Algoritmos de busca
]

#pagebreak()

Vamos apresentar algoritmos de busca e suas complexidades

== Busca em um vetor ordenado
Dado um vetor ordenado de inteiros:
```cpp
int* v = { 2, 5, 9, 18, 23, 27, 32, 33, 37, 41, 43, 45 };
```

Queremos escrever um algoritmo que recebe o vetor $v$, um número $x$ e retorna o índice de $x$ no vetor $v$ se $x in v$. Temos dois algorimtos principais para esse problema

#codly(
  header: [*BUSCA LINEAR*],
  header-cell-args: (align: center),
  inset: 0.25em
)
```cpp
int linear_search(const int v[], int size, int x) {
  for (int i = 0; i < size; i++) {
    if (v[i] == x) {
      return i;
    }
  }
  return -1;
}
```

No pior caso, esse algoritmo tem complexidade $Theta(n^2)$

Porém, se considerarmos uma lista ordenada, podemos fazer algo mais inteligente. Comparamos do meio do vetor e dependendo se o valor atual é maior ou menor comparado ao avaliado, então eu ignoro uma parte do vetor. O algoritmo consiste em avaliar se o elemento buscado ($x$) é o elemento no meio do vetor ($m$), e caso não seja executar a mesma operação sucessivamente para a metade superior (caso $x > m$) ou inferior (caso $x < m$).

#codly(
  header: [*BUSCA BINÁRIA*],
  header-cell-args: (align: center),
  inset: 0.25em
)
```cpp
int search(int v[], int leftInx, int rightInx, int x) {
  int midInx = (leftInx + rightInx) / 2;
  int midValue = v[midInx];
  if (midValue == x) {
    return midInx;
  }
  if (leftInx >= rightInx) {
    return -1;
  }
  if (x > midValue) {
    return search(v, midInx + 1, rightInx, x);
  } else {
    return search(v, leftInx, midInx - 1, x);
  }
}
```

Podemos escrever a complexidade da função como:
$
  T(n) = T(n/2) + c
$
Fazendo os cálculos, obtemos que $T(n) = Theta(log(n))$

== Árvores
Uma árvore binária consiste em uma estrutura de dados capaz de armazenar um conjunto de nós.
- Todo nó possui uma chave
- Opcionalmente um valor (dependendo da aplicação).
- Cada nó possui referências para dois filhos
- Sub-árvores da direita e da esquerda.
- Toda sub-árvore também é uma árvore.

#figure(
  caption: [Exemplo de árvore],
  image("images/tree-example.png", width: 70%)
)

Um nó sem pai é uma *raíz*, enquanto um nó sem filhos é um nó *folha*

#definition("Altura do nó")[
  Distância entre um nó e a folha mais afastada. A altura de uma árvore é a algura do nó raíz
]

#figure(
  caption: [Exemplificação de altura],
  image("images/node-height-example.png", width: 50%)
)

#theorem[
  Dada uma árvore de altura $h$, a quantidade máxima de nós $n_"max"$ e mínima $n_"min"$ são:
  $
    n_"min" = h + 1   \
    n_"max" = 2^(h+1) - 1
  $
]

#definition[
  Uma árvore está *balanceada* quando a altura das subárvores de um nó apresentem uma diferença de, no máximo, $1$
]

#theorem[
  Dada uma árvore com $n$ nós e balanceada, a sua altura $h$ será, no máximo:
  $
    h = log(n)
  $
]

Para códigos posteriores, considere a seguinte estrutura:

```cpp
class Node {
  public:
    Node(int key, char data)
      : m_key(key)
      , m_data(data)
      , m_leftNode(nullptr)
      , m_rightNode(nullptr)
      , m_parentNode(nullptr) {}
    Node & leftNode() const { return * m_leftNode; }
    void setLeftNode(Node * node) { m_leftNode = node; }

    Node & rightNode() const { return * m_rightNode; }
    void setRightNode(Node * node) { m_rightNode = node; }

    Node & parentNode() const { return * m_parentNode; }
    void setParentNode(Node * node) { m_parentNode = node; }

  private:
    int m_key;
    char m_data;
    Node * m_leftNode;
    Node * m_rightNode;
    Node * m_parentNode;
};
```

Temos alguns tipos de problemas para trabalhar em cima das árvores e suas soluções:

*Problema*: Dada uma árvore binária A com n nós encontre a sua altura
```cpp
int nodeHeight(Node * node) {
  if (node == nullptr) {
    return -1;
  }

  int leftHeight = nodeHeight(node->leftNode());
  int rightHeight = nodeHeight(node->rightNode());

  if (leftHeight < rightHeight) {
    return rightHeight + 1;
  } else {
    return leftHeight + 1;
  }
}
```
A complexidade dessa solução é $Theta(n)$

*Problema*: Dada uma árvore binária $A$ imprima a chave de todos os nós através da busca em profundidade. Desenvolva o algoritmo para os 3 casos: Em ordem, pré-ordem, pós-ordem

#codly(
  header: [*EM ORDEM*],
  header-cell-args: (align: center),
  inset: 0.25em
)
```cpp
void printTreeDFSInorder(class Node * node) {
  if (node == nullptr) {
    return;
  }
  printTreeDFSInorder(node->leftNode());
  cout << node->key() << " ";
  printTreeDFSInorder(node->rightNode());
}
```

#codly(
  header: [*PRÉ-ORDEM*],
  header-cell-args: (align: center),
  inset: 0.25em
)
```cpp
void printTreeDFSPreorder(class Node * node) {
  if (node == nullptr) {
    return;
  }
  cout << node->key() << " ";
  printTreeDFSPreorder(node->leftNode());
  printTreeDFSPreorder(node->rightNode());
}
```

#codly(
  header: [*PÓS-ORDEM*],
  header-cell-args: (align: center),
  inset: 0.25em
)
```cpp
void printTreeDFSPostorder(class Node * node) {
  if (node == nullptr) {
    return;
  }
  printTreeDFSPostorder(node->leftNode());
  printTreeDFSPostorder(node->rightNode());
  cout << node->key() << " ";
}
```

*Problema*: dada uma árvore binária $A$ imprima a chave de todos os nós através da busca em largura.

```cpp
void printTreeBFSWithQueue(Node * root) {
  if (root == nullptr) {
    return;
  }
  queue<Node*> queue;
  queue.push(root);
  while (!queue.empty()) {
    Node * node = queue.front();
    cout << node->key() << " ";
    queue.pop();
    Node * childNode = node->leftNode();
    if (childNode) {
      queue.push(childNode);
    }
    childNode = node->rightNode();
    if (childNode) {
      queue.push(childNode);
    }
  }
}
```

== Árvores Binárias de Busca
#definition("Árvores de busca")[
  São uma classe específica de árvores que seguem algumas características:
  - A chave de cada nó é maior ou igual a chave da raiz da sub-árvore esquerda.
  - A chave de cada nó é menor ou igual a chave da raiz da sub-árvore direita
  `left.key <= key <= right.key`
]

#figure(
  caption: [Exemplo de árvore binária],
  image("images/binary-tree-example.png", width: 60%)
)

Então queremos utilizar essa árvore para poder procurar valores. Na verdade ela é bem parecida com o caso de aplicar uma busca binária em um vetor ordenado.

*Problema*: dada uma árvore binária de busca $A$ com altura $h$ encontre o nó cuja chave seja $k$.

#codly(
  header: [*BUSCA EM ÁRVORE BINÁRIA (RECURSÃO)*],
  header-cell-args: (align: center),
  inset: 0.25em
)
```cpp
Node * binaryTreeSearchRecursive(Node * node, int key) {
  if (node == nullptr || node->key() == key) {
    return node;
  }
  if (node->key() > key) {
    return binaryTreeSearchRecursive(node->leftNode(), key);
  } else {
    return binaryTreeSearchRecursive(node->rightNode(), key);
  }
}
```
Esse algoritmo tem complexidade $Theta(h)$

#codly(
  header: [*BUSCA EM ÁRVORE BINÁRIA (ITERATIVO)*],
  header-cell-args: (align: center),
  inset: 0.25em
)
```cpp
Node * binaryTreeSearchIterative(Node * node, int key) {
  while (node != nullptr && node->key() != key) {
    if (node->key() > key) {
      node = node->leftNode();
    } else {
      node = node->rightNode();
    }
  }
  return node;
}
```
