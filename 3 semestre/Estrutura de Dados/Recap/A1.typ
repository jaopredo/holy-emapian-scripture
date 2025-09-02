#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages, stroke: 1pt + luma(100))

#set page(width: 21cm, height: 30cm, margin: 1.5cm, numbering:"1")

#set figure(supplement: "Figura")

#set par(
  justify: true,
  leading: 0.65em,
)

#set text(
  size:13pt,
  font: "Atkinson Hyperlegible",
)


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
  } else {
    it
  }
}

#align(center + top)[
  FGV EMAp

  Thalis Ambrosim Falqueto
]

#align(horizon + center)[
  #text(17pt)[
    Estrutura de Dados
  ]
  
  #text(14pt)[
    Resumo
  ]
]

#align(bottom + center)[
  Rio de Janeiro

  2025
]

#pagebreak()

#outline(title: "Sumário")

#pagebreak()

= Introdução

Olá, basicamente essa é uma tentativa de explicar digitalmente um conteúdo aprendido no terceiro semestre da minha graduação, mais especificamente, o conteúdo aprendido em Estrutura de Dados. Além disso, é meu objetivo aprender a usar a ferramenta do typst. Inicialmente é esperado que você, caro telespectador, tenha algum conhecimento em `C++`.

Vamos lá!

= 1. Complexidade de algoritmos

O objetivo principal de calcular a complexidade de um algoritmo é compará-lo com outro para saber qual é o melhor, e assim, escolher o melhor algoritmo possível que resolva seu problema.

Os dois principais tipos de complexidade são:
+ Complexidade espacial: Quantidade de memória necessária para resolver o problema.
+ Complexidade temporal: Quantidade de tempo necessário para resolver o problema.

O foco dado aqui será em calcular a complexidade temporal. Você pode ter pensado que calcular essa complexidade é simples: basta contar quanto tempo um algoritmo leva para resolver um problema e compará-lo com outro algoritmo, certo? Mas isso não é o ideal, pois aí entram outras variáveis, como: 

- Especificações do computador
- Linguagem de programação
- Condiçoes de execução

Enfim, todos esses pontos influenciam diretamente no tempo do seu algoritmo, e, portanto, na sua complexidade. Por isso precisamos de algo mais genérico, e a solução para esse problema foi calcular a quantidade de operações que o algoritmo faz, ligando-o diretamente com o tamanho do problema.

== 1.1 Notação Big O

Para mensurar a quantidade de operações feita num algoritmo, é necessário introduzir a notação de Big O que permanecerá conosco até o fim desse resumo.

Em modos gerais, ela basicamente simplifica o cálculo de toda a função que determina o tempo de execução de um algoritmo pegando o termo de maior grandeza, que determina o pior caso no caso de uma quantidade grande de operações.

Exemplo:
Qual a complexidade de execução desse algoritmo?

```cpp
#include  <iostream>

float media(float arr[], int n) {    
    float total = 0;
    for(int i = 0; i < n; i++) {
        total += arr[i];
        total = total / i    
    }
    return total;
}```

Vamos contar a quantidade de operações (ignorando que a definição da função, e contando cada operação de mesmo esforço computacional):

Temos a definição da variável total, somando $1$, e, dentro do for, temos outras duas operações feitas (soma e divisão), mas elas dependem do tamanho do array(que tem tamanho n), temos então $2n$ operações ali. Ao fim, damos um return, contando mais $1$.

Logo, chamando de $T(n)$ a função que determina a complexidade de execução total do algoritmo, temos:
$T(n) = 1 + 2n + 1 =  2n + 2$

Agora, qual seria o pior caso? Aconteceria se n fosse muito grande, certo? Se n fosse muito grande(tendendo a infinito), as contantes 2 que somam e multiplicam a n não importariam o suficiente e, portanto, dizemos que esse algoritmo tem complexidade de execução $O(n).$

Existem outras análises, que calculam o melhor caso, caso médio, etc. Não vamos entrar nesse assunto no momento, e sim na próxima matéria,PAA.

Por fim, a definição formal da notação big O para encontrar o pior caso é: Dizemos que a função $f(n) = O(g(n))$ se existir uma constante $c$ e um valor $n_0$ tal que $f(n) ≤ c g(n).$


= 2. Tipos Abstratos de Dados

TAD é um modelo conceitual de uma estrutura de dados que define um conjunto de operações sem especificar como elas são implementadas. Diferente dos tipos primitivos, que possuem uma representação direta na memória, um TAD é definido em termos de comportamento e operações permitidas, sem impor detalhes sobre sua implementação. Como exemplo temos listas, tuplas, conjuntos, dicionários, filas, pilhas, árvores, etc.

Na prática, para criar um TAD, utilizamos estruturas de dados concretas, como arrays e ponteiros, e definimos funções que respeitam a interface do TAD.

A importância de estudarmos essas Estrutura de Dados é que, basicamente, cada TAD é melhor em resolver um problema específico. Então, de acordo com cada problema, escolhemos o TAD que melhor o soluciona e fazemos uso dele.

Basicamente, temos 3 operações principais: inserir, remover e buscar. Vamos ver alguns TADs e seus desempenhos em cada uma dessas.  

== 2.1 Pilhas

Uma pilha é uma Estrutura de Dados que segue a política LIFO(Last in, First Out), ou seja, o último elemento adicionado da pilha é o primeiro a ser removido. 

Algumas aplicações:
+ Controle de chamadas de funções;
+ Fazer/Desfazer (ctrl y/ctrl z);
+ Navegação;

Enfim, vamos analisar a estrutura de dados desse TAD:
```cpp
struct Stack {
    int * data;
    int maxSize;
    int top;
};
```

Temos um ponteiro que aponta para a pilha,
um inteiro que guarda o tamanho máximo da pilha e um inteiro 
e outro inteiro que aponta para o topo(a quantidade de elementos na pilha atualmente).

Além disso, aqui vai algumas funções básicas dessa Estrutura:

- Inicialização da Pilha - apenas declaramos uma nova pilha, apontamos cada elemento da lista para seu respectivo elemento e a retornamos:

```cpp
Stack* initializationStack(int maxSize) {
    Stack * s = new Stack();
    s->data = new int[maxSize];
    s->maxSize = maxSize;
    s->top = -1;
    return s;
}```

- Push de um elemento - Se a pilha não estiver cheia, incrementamos a contagem do topo e acessamos o próximo elemento após o topo e colocamos o value lá:

```cpp
int pushStack(Stack *s, int value) {
    if (s->top == s->maxSize - 1) {
        return 0; // Full stack
    }
    s->top += 1;
    s->data[s->top] = value;
    return 1;
}```

- Remoção de um elemento - Caso a pilha não esteja vazia, acessamos o ponteiro value usando o último elemento da pilha e decrementamos da contagem de topo:

```cpp
int popStack(Stack *s, int *value) {
    if (s->top == -1) {
        return 0; // Empty stack
    }
    *value = s->data[s->top];
    s->top -= 1;
    return 1;
}```

- Busca de um elemento - Se a pilha não estiver vazia, apenas retornamos o último elemento colocado da lista:
```cpp
int peekStack(const Stack *s, int *value) {
    if (s->top == -1){
        return 0; // Empty stack
    }
    *value = s->data[s->top];
    return 1;
}
```

- Destruição da pilha - Deleta o array e a pilha:

```cpp
void destroyStack(Stack* s) {
    delete[] s->data;
    delete s;
}
```

O básico é isso, terão coisas mais legais nos exercícios.

== 2.2 Filas

Uma fila é um tipo de Estrutura de Dados que segue a política FIFO(First IN, First Out), ou seja, o primeiro alemento a ser adicionado na fila é também o primeiro a ser removido.

Algumas aplicações:

+ Assistir mais tarde (YouTube);
+ Gerenciamento de entrada em eventos;
+ Sistema de atendimento de Bancos;

Enfim, vamos analisar a estrutura desse TAD:

```cpp
struct Queue {
    int* data;
    int maxSize;
    int size;
};
```
Análogo a pilha, a estrutura contém um ponteiro para o array, um inteiro que guarda o tamanho máximo pilha e outro inteiro que guarda o tamanho atual da pilha.

Ok, vamos para as funções básicas dessa estrutura:

- Inicialização da fila - Apenas inicia uma nova fila e declara cada variável com seu respectivo valor, e, por fim, retorna a fila.

```cpp
Queue * initializationQueue(int maxSize) {
    Queue * q = new Queue();
    q->data = new int[maxSize];
    q->maxSize = maxSize;
    q->size = 0;
    return q;
}```

- Push de um elemento - Se a fila estiver cheia, não há nada mais a fazer, caso contrário, adicionamos no fim da fila o valor value e incrementamos a quantidade de elementos na lista.
```cpp
int pushQueue(Queue *q, int value){
    if (q->size == q->maxSize) {
        return 0; // Full queue
    }
    q->data[q->size] = value;
    q->size += 1;
    return 1;
}```

Remoção de um elemento - Caso a fila não esteja vazia, salva o primeiro valor adicionado na fila atual, e depois abrimos um for para mover cada item da fila um elemento atrás. Por fim, decrementa o tamanho da fila.
```cpp
int popQueue(Queue *q, int *value) {
    if (q->size == 0) {
        return 0; // Empty queue
    }

    *value = q->data[0];
    for (int i = 1; i < q->size; i++) {
        q->data[i - 1] = q->data[i];
    }
    q->size -= 1;
    return 1;
}
```

- Busca de um elemento - Caso a fila não esteja vazia, apenas seleciona o primeiro elemento adicionado a fila atual e o aloca na variável value.
```cpp
int peekQueue(const Queue *q, int *value) {
    if (q->size == 0) {
        return 0; // Empty queue
    } 
    *value = q->data[0];
    return 1;
}
```

- Destruição da fila - Destrói o array e depois a fila.
```cpp
void destroy(Queue* q) {
    delete[] q->data;
    delete q;
}

```

== 2.3 Fila circular

Analisando a função popQueue da fila comum, notamos que existe um for para a realocação dos elementos da fila. Isso causa um problema de uma complexidade de execução de $O(n)$. Para contornar isso, uma boa ideia é a implementação de uma fila circular, com head(cabeça/ponta) e tail(cauda/fim).

As aplicações são as mesmas, portanto, vamos para a estrutura desse TAD:

```cpp
struct CircularQueue {
    int *data;
    int maxSize;
    int size;
    int head;
    int tail;
};```

A estrutura é semelhante à fila, a menos de que, agora, temos dois novos inteiros que marcam os índices do head e do tail da fila.

Vamos analisar o que mudam as funções básicas da fila circular:

- Inicialização da fila circular - Análogo a fila, apenas declara as outras variáveis adicionadas na estrutura.

```cpp
CircularQueue * initializationCircularQueue(int maxSize) {
    CircularQueue * cq = new CircularQueue();
    cq->data = new int[maxSize];
    cq->head = 0;
    cq->tail = -1;
    cq->size = 0;
}
```

- Push de um elemento - Aqui a diferença é que temos que atualizar o tail da fila. Para isso, incrementamos o tail, pois adicionamos algo ao final da fila, e tiramos o módulo em relação ao tamanho da lista, para que o tail "resete" quando o array da fila circular chega ao fim.

```cpp
int pushCircularQueue(CircularQueue *cq, int value) {
    if (cq->size == cq->maxSize) {
        return 0; // Full circular queue
    }
    cq->tail = (cq->tail + 1) % cq->maxSize;
    cq->data[cq->tail] = value;
    cq->size++;
    return 1;
}
```

- Remoção de um elemento - Agora, não precisamos mais do for, e após salvar o valor no ponteiro de value, atualizamos a cabeça da cauda. Como queremos tirar(não tiramos, já que não deletamos o valor) o primeiro valor da fila, apenas incrementamos o head(usando o mesmo argumento do módulo no push), passando assim a apontar a head para o próximo valor imediatamente após o head antigo.

```cpp
int popCircularQueue(CircularQueue *cq, int *value) {
    if (cq->size == 0) {
        return 0; // Empty circular queue
    }
    *value = cq->data[cq->head];
    cq->head = (cq->head + 1) % cq->maxSize;
    cq->size--;
    return 1;
}
```

- Busca de um elemento - Nada para mudar aqui. 

```cpp
int peekCicularQueue(CircularQueue *cq, int *value) {
    if (cq->size == 0) {
        return 0; // Empty circular queue
    }
    *value = cq->data[cq->head];
    return 1; 
}
```
- Destruição da fila - Nada para mudar aqui.

```cpp
void destroyCircularQueue(CircularQueue *cq) {
    delete[] cq->data;
    delete cq;
}```

#pagebreak()

== 2.4 Comparação entre TADs

Para cada propósito ao qual cada TAD é designado, quase todas as principais operações são $O(1)$. Veja: 

#set table(
  stroke: none,
  gutter: 0.2em,
  fill: (x, y) =>
    if x == 0 or y == 0 { gray },
  inset: (right: 1.5em),
)

#align(
    center,
    table(
  columns: 4,
  [Operação], [Pilha], [Fila com array], [Fila com array circular],

  [inserir], [$O(1)$], [$O(1)$], [$O(1)$],
  [Remover], [$O(1)$], [$O(n)$], [$O(1)$],
  [Buscar],  [$O(1)$], [$O(1)$], [$O(1)$],
)
)

Mas, até agora, todas as estruturas de dados que aprendemos têm em geral, um problema: Todas elas são baseadas num array de tamanho fixo, passado na inicialização do TAD. Isso é um problema por dois dois motivos:
+ Excesso de espaço dependendo do caso;
+ Falta de espaço dependendo do caso.
Como solucionar esse problema?

== 2.5 Lista (simplesmente) encadeada

Uma lista encadeada é uma lista que usa ponteiros que indicam o próximo elemento da lista, sem depender uma estrutura de dados pronta que define o tamanho da lista na inicialização.

Algumas aplicações:

+ As mesmas de filas e pilhas(podem ser feitas com listas encadeadas);
+ Tabelas Hash;

Vamos pra estrutura!

```cpp
struct Node {
    Node* next;  
    int value; 
};

struct SingleLinkedList {
    Node* head;
    int size;
};
```

Note que agora são necessárias duas estruturas, uma para o nó, onde temos um inteiro que armazena o valor do nó(tal qual um elemento de um array) e o ponteiro para o próximo elemento, e outra para administrar a lista em si, que controla o ponteiro inicial, e um inteiro que informa o tamanho da lista.

Agora que você já está mais familiarizado com a aparência das funções(verificações básicas, interações com ponteiros), vou deixar de comentar algumas parte do código, já que são mais simples e, além disso, as funções acabam ficando maiores. Vamos as funções básicas:

- Inicialização da lista encadeada - Pela primeira vez, vemos uma atribuição de nullptr, que, como diz o próprio nome, aponta para um ponteiro nulo(todos os nullptr do mesmo código apontam para o mesmo local).

```cpp
SingleLinkedList* InitializationSLList() {
    SingleLinkedList* list = new SingleLinkedList;
    list->head = nullptr;
    list->size = 0;
    return list;
}```

- Push de um elemento:
  - Front - Como queremos adicionar na frente, apenas declaramos um novo nó e fazemos ele apontar para o head da lista, após isso atualizamos o head para ser o novo nó e incrementamos o tamanho.
  - End -  Agora o next do novo nó será vazio, e se a lista não for vazia, criamos um nó temporário que serve para andar pela lista, começando pelo head. Enquanto next do nó temporário não for nullptr, significa que não chegamos ao final, e portanto, a lista não chegou ao fim. Quando chegamos ao ponteiro no fim da lista, então colocamos o next dessa lista como o nó criado

```cpp
void pushFrontSLList(SingleLinkedList* list, int value) {
    Node* newNode = new Node;
    newNode->value = value;
    newNode->next = list->head;    
    list->head = newNode;
    list->size++;
}

void pushEndSLList(SingleLinkedList* list, int value) {
    Node* newNode = new Node;
    newNode->value = value;
    newNode->next = nullptr;
    if (list->head == nullptr) {
        list->head = newNode;
    } else {
        Node* temp = list->head;
        while(temp->next != nullptr) {
            temp = temp->next;
        }
        temp->next = newNode;
    }
    list->size++;
}
```

- Remoção de um elemento:
  - Front - Nesse caso, sequer precisamos saber o valor a ser deletado, já que será o elemento do início da lista. Salvamos o primeiro elemento da lista, e dizemos que agora a head da lista é o próximo elemento depois do head, e agora podemos deletar o elemento antes salvo.
  - Middle/end - Agora precisamos do valor a ser deletado, e após salvarmos o ponteiro atual da lista, fazemos um while que deve encontrar o valor exato, e, para isso, devemos verificar se o next do ponteiro é nulo e se o valor do ponteiro é exatamente o valor procurado. Se entrarno próximo if, significa que parou na primeira condição do while e, portanto, o ponteiro é nulo. Caso contrário, é porque encontramos o nó de valor desejado, portanto salvamos o ponteiro, atualizamos o current e deletamos o nó do valor.
```cpp
void popFrontSLList(SingleLinkedList* list) {
    if (list->head == nullptr) {
        return -1; // Empty queue
    }
    Node* temp = list->head;
    list->head = list->head->next;
    delete temp;
    list->size--;
}

void popEndSLList(SingleLinkedList* list, int value) {
    if (list->head == nullptr) {
        return;
    }
    Node* current = list->head;
    while (current->next != nullptr && current->next->value != value) {
        current = current->next;
    }
    if (current->next == nullptr) {
        return;
    }
    Node* temp = current->next;
    current->next = current->next->next;
    delete temp;
    list->size--;
}
```

Note que aqui temos o popEnd seria análago ao popMiddle, já que, de qualquer forma, teríamos que percorrer a lista inteira para encontrar o elemento, dado que provavelmente não sabemos onde ele está.

- Busca de um elemento - Percorre toda a lista usando um ponteiro auxiliar até achar o valor, retornando true. Caso não achar, retorna false.
```cpp
bool searchSLList(SingleLinkedList* list, int value) {
    Node* current = list->head;
    while (current != nullptr) {
        if (current->value == value) {
            return true;
        }
        current = current->next;
    }
    return false;
}
```

- Destruição da lista - Em geral isso não é muito útil, já que precisamos passar elemento a elemento para deletar, e que essa lista não usa uma estrutura pronta como array.

```cpp
void deleteSLList(SingleLinkedList* list) {
    Node* current = list->head;
    while (current != nullptr) {
        Node* temp = current;
        current = current->next;
        delete temp;
    }
    delete list;
}
```

== 2.6 Lista encadeada circular

Nesse caso, basta colocar um ponteiro tail na struct SingleLinkedList apontando para a cauda (tail), e atualizar nas funções mostradas anteriormente. Como a lista não tem um tamanho pré-fixado, também não é necessário tratar casos com o módulo da lista, etc. Fica a cargo do leitor.

- *Obs.1:*

Uma limitação da lista encadeada simples é que ela só vê o próximo elemento, o que é problemático em situações como remoção de um nó ou verificação do elemento anterior numa lista. Para solucionar esse problema, basta adicionarmos um ponteiro tail em cada um dos nós da lista! 

== 2.7 Lista duplamente encadeada

Sabendo que você provavelmente já entendeu o conceito, vamos às aplicações:

+ Todas as outras anteriores;
+ Botões de "avançar" e "voltar" num site;
+ Músicas/filmes de uma playlist.

Legal, vamos para sua estrutura:

```cpp
struct Node {
    int value;
    Node* next;
    Node* prev;
};

struct DoubleLinkedList {
    Node* head;
    Node* tail;
    int size;
};
```

Bastante semelhante a lista simplesmente encadeada, a menos do ponteiro representando o anterior no nó(chamado de prev) e na lista(chamado de tail).

- Inicialização da lista duplamente encadeada - Análogo a simplesmente encadeada, a menos do tail.

```cpp
DoubleLinkedList* InitializationDLList() {
    DoubleLinkedList* list = new DoubleLinkedList;
    list->head = nullptr;
    list->tail = nullptr;
    list->size = 0;
    return list;
}
```

- Push de um elemento:
 - Front - Aqui, quando verificamos se a lista não é vazia, como queremos atualizar na frente, apontamos o previous do head para  o nó a ser adicionado, e depois atualizamos o head da lista como o novo nó. Depois verificamos se ela está vazia e, se estiver, após adicionar o nó como head, colocamos o nó como tail e incrementamos o size.
 - End - Criamos o novo nó, verificamos se a lista é nula e, caso for, colocamos ele como o head. Após isso, verificamos se o tail não é nulo, ou seja, se a lista não é vazia. Caso não seja, então o tail da lista aponta para o nó adicionado. Atualizamos o tail após isso e incrementamos o size.
```cpp
void pushFrontDLList(DoubleLinkedList* list, int value) {
    Node* newNode = new Node{};
    newNode->value = value;
    newNode->next = list->head;
    newNode->prev = nullptr;
    if (list->head != nullptr) {
        list->head->prev = newNode;
    }
    list->head = newNode;
    if (list->tail == nullptr) {
        list->tail = newNode;
    }
    list->size++;
}

void pushEndDLList(DoubleLinkedList* list, int value) {
    Node* newNode = new Node{};
    newNode->value = value;
    newNode->next = nullptr;
    newNode->prev = list->tail;

    if (list->head == nullptr) {
        list->head = newNode;
    }
    if (list->tail != nullptr) {
        list->tail->next = newNode;
    }
    list->tail = newNode;
    list->size++;
}```

- Remoção de um elemento:
 - Front - Após verificarmos se a lista não esta vazia, criamos um ponteiro temporário que salvará o ponteiro a ser deletado, logo após atualizamos o head da lista, e com ela atualizada, verificamos se o head atual não é nulo, pois caso ele não seja, devemos atualizar também o prev da nova head. Caso ele seja nulo, então o tail também deve ser atualizado como nulo. Deletamos o ponteiro antigo e decrementamos o size.
 - End - Fazemos literalmente a mesma coisa, só que olhando para o tail. Note como a estrutura é parecida


```cpp
void popFrontDLList(DoubleLinkedList* list) {
    if (list->head == nullptr) {
        return;
    }
    Node* temp = list->head;
    list->head = list->head->next;
    if (list->head != nullptr) {
        list->head->prev = nullptr;
    } else {
        list->tail = nullptr;
    }
    delete temp;
    list->size--;
}

void popEndDLList(DoubleLinkedList* list) {
    if (list->tail == nullptr) {
        return;
    }

    Node* temp = list->tail;
    list->tail = list->tail->prev;
    if (list->tail != nullptr) {
        list->tail->next = nullptr;
    } else {
        list->head = nullptr;
    }
    delete temp;
    list->size--;
}
```

Note que não colocamos as funções de push e pop no meio da lista, já que isso quebraria a ideia dessas operações serem $O(1)$, pois teríamos que percorrer toda a lista até encontrar o elemento do meio, se fosse o caso.
Além disso, um push no meio não faz sentido, seria algo como furar fila, enquanto o pop no meio de uma fila pode realmente acontecer, como uma desistência. Aqui vai o código do pop no meio da lista:

```cpp
void popMiddleDLList(DoubleLinkedList* list, int value) {
    if (list->head == nullptr) {
        return;
    }
    Node* current = list->head;
    while (current != nullptr && current->value != value) {
        current = current->next;
    }
    if (current == nullptr) {
        return;
    }
    current->prev->next = current->next;
    if (current->next != nullptr) {
        current->next->prev = current->prev;
    }
    delete current;
    list->size--;
}
```
- Busca de um elemento - Análogo a lista simplesmente encadeada.
```cpp
bool searchDLList(DoubleLinkedList* list, int value) {
    Node* current = list->head;
    while (current != nullptr) {
        if (current->value == value) {
            return true;
        }
        current = current->next;
    }
    return false;
}
```

- Destruição da lista - Análogo a lista simplesmente encadeada.

```cpp
void deleteDLList(DoubleLinkedList* list) {
    Node* current = list->head;
    while (current != nullptr) {
        Node* temp = current;
        current = current->next;
        delete temp;
    }
    delete list;
}
```

== 2.8 Comparação entre arrays e listas encadeadas

Após todo esse código, podemos fazer uma breve comparação entre listas encadeadas e arrays:

 - Arrays são uma boa escolha quando há uma estimativa da quantidade de elementos a serem inseridos e permitem acesso rápido a qualquer elemento via índice, mas inserções e remoções no meio são custosas, pois exigem deslocamento de elementos .
- Listas encadeadas são boa escolha quando a quantidade de elementos pode variar significativamente e inserções e remoções são eficientes, pois não exigem deslocamento de elementos, porém, acesso a elementos individuais é mais lento, pois requerem percorrer a lista.

Além disso, embora listas encadeadas sejam flexíveis e eficientes para inserção e remoção, elas possuem algumas desvantagens:

+ Maior uso de memória por elemento (devido aos ponteiros adicionais);
+ Não é possivel acessar uma posição aleatória da lista de forma eficiente;

Uma ideia que possibilita o acesso a uma posição aleatória de forma eficiente e melhora a busca linear é ordenar a lista. Mas como fazer isso?

#pagebreak()

= 3. Ordenação

Como introduzido, por vezes gostaríamos que nossa Estrutura de Dados estivesse ordenada,
pois a ordem dos elementos pode ser mais importante que a inserção ou remoção. Por exemplo, num
sistema de e-commerce, onde os produtos são identificados por preço, ou até num hospital, onde gostaríamos de ordenar por prioridade.

Ordenar os dados é essencial, pois:

+ permite buscas mais eficientes;
+ define uma ordem de prioridade;
+ facilita a análise estatística(Ex: mediana);

== 3.1 - Características relevantes:

A utilidade dos algoritmos de ordenação que vamos ver podem ser medidos através de:

- Complexidade de tempo de execução;
- Complexidade de espaço utilizado:  quantidade de espaço adicional de memória necessária (além do array de entrada);
- Estabilidade: se mantém a ordem relativa dos elementos iguais na entrada;
    - Exemplo: No caso do exemplo do hospital, se cada elemento(pessoa) tem uma prioridade, é esperado que pessoas de mesma prioridade continuem na mesma ordem que chegaram. Portanto, ao ordenar pela prioridade, o algoritmo é estável se cada elemento de mesma prioridade se mantém na mesma ordem antes de ordenar.
- In-place vs Out-of-place:
    - In-place: Não requer memória extra significativa.
    - Out-of-place: Requer uma estrutura auxiliar para armazenar os elementos ordenados;
- Performance em diferentes tamanhos de entrada: Alguns algoritmos podem ser melhores que outros para quantidades pequenas ou grandes de dados.

Existem outros tipos de características relevantes, como adaptabilidade e paralelização, mas não serão abordados aqui. Legal, vamos para os algoritmos!

== 3.2 Selection Sort

- *Ideia*
 - Percorre a lista até encontrar o menor elemento;
 - Troca esse elemento com o primeiro da lista;
 - Repete a ideia para os próximos elementos.

== img

Note que precisamos de dois inteiros, um para salvar o índice do menor elemento, e outro para fazer a troca de elementos. O primeiro for passará por toda a lista, e o segundo for comparará os elementos subjacentes ao indíce i, pois antes desse índice os elementos já foram ordenados. Fazemos a comparação do valor do índice i com todos os posteriores, e atualizamos o índice j. Após cada comparação, salvamos o valor do menor elemento, atualizamos o valor do índice do menor elemento como o elemento do índice i, e por fim atualizamos o valor do índice i como o menor elemento.  
```cpp
void selectionSort(int arr[], int n) {      // Custo  | Vezes
    int minIndex, temp;                     // 2      | 1
    for (int i = 0; i < n - 1; i++) {       // 2      | n-1
        minIndex = i;                       // 1      | n-1
        for (int j = i + 1; j < n; j++) {   // 2      | n-i+1 -> n-1, 
            if (arr[j] < arr[minIndex]) {   // 1      | n-i+1 -> n-1,
                minIndex = j;               // 1      | n-i+1 -> n-1, 
            }
        }
        temp = arr[minIdx];                 // 1      | n-1
        arr[minIdx] = arr[i];               // 1      | n-1
        arr[i] = temp;                      // 1      | n-1
    }
} 
```

- *Características:*
    - Complexidade de tempo de execução: $O(n^2)$ para o pior caso, dado dois fors que iteram praticamente até $n$;
    - Complexidade de espaço: $O(1)$, pois não precisamos criar nada; 
    - Estabilidade: não é estável, trocas alteram a ordem de elementos iguais.

== 3.3 Insertion Sort

- *ideia*
    - Considera o primeiro elemento como ordenado;
    - Insere o próximo elemento na posição correta na parte ordenada;
    - Repete o processo para o restante dos elementos.

=== img

Pense em uma separação da mesma lista em duas, uma ordenada e a outra não. Olhando para o código
começamos com a declaração do valor elemento que salvaremos, após isso abrimos um for para passar por toda a lista, salvamos o 
current como o elemento i e iniciamos o j como o índice do elemento antes de i. Então,
se antes do elemento i está ordenado, basta achar o lugar certo para o elemento i. 

É isso que fazemos com o while, olhamos enquanto não chegamos no índice j = 0(início da lista) e enquanto o elemento do array
no índice j é maior que o item a direita dele. 
Quando ele não for, significa que é a posição ordenada, e atualizamos a posição fora do while.

Note que quando entramos no while mas não saímos, significa que ainda não encontramos o local exato do elemento, e para manter a
 estrutura da lista, atualizamos o array no indice j+1 como sendo o valor do elemento anterior.
```cpp
void insertionSort(int arr[], int n) {          // Custo  | Vezes
    int current;                                // 3      | 1
    for (int i = 1; i < n; i++) {               // 2      | n 
        current = arr[i];                       // 1      | n-1
        int j = i - 1;                          // 1      | n-1
        while (j >= 0 && arr[j] > current) {    // 3      | i-1 -> 0 -> n-2
            arr[j+1] = arr[j];                  // 1      | i-1 -> 0 -> n-2
            j = j - 1;                          // 1      | i-1 -> 0 -> n-2
        }
        arr[j+1] = current;                     // 1      | n-1
    }
}
```

- *Características:*
    - Complexidade de tempo de execução: $O(n^2)$ para o pior caso, dado o for e o while que iteram em função de n;
    - Complexidade de espaço: $O(1)$, pois usamos a mesma lista; 
    - Estabilidade: é estável, trocas não alteram a ordem de elementos iguais já que fazemos a troca apenas quando o elemento é maior(>), e não maior igual(>=).

== 3.4 Bubble Sort


