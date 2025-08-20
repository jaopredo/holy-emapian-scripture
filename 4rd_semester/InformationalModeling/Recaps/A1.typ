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

#set text(
  size: 12pt,
)

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


// ============================ PRIMEIRA PÁGINA =============================
#align(center + top)[
  FGV EMAp

  João Pedro Jerônimo
]

#align(horizon + center)[
  #text(17pt)[
    Modelagem Informacional
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
  = Modelagem Informacional de Requisitos (MIR)
]

#pagebreak()

Muitos (incluindo eu) entraram na matéria sem ter uma noção bem do que ela se tratava (Eu perdi as primeiras aulas, então ficou ainda pior). Mas saímos da matéria de Banco de Dados, ainda mexemos com eles, mas antes, estudávamos como eles eram armazenados, o que era necessário para se ter um local estruturado para seu armazenamento. Agora, vamos estudar como eles são usados, como podemos utilizar eles de forma eficiente a responder nossas dúvidas e ser utilizados em sistemas que iremos desenvolver.

Quando estamos montando um sistema, estamos interessados, principalmente em aplicações complexas, em saber exatamente o fluxo de informações. Quando o meu usuário fizer uma ação X no meu sistema, que informações eu preciso enviar para ele? Que informações ele vai me mandar? E para onde essas informações vão? Pensando nisso, foi criado o *Diagrama de Uso*

#definition("Diagrama de Uso")[
    Um diagrama de uso descreve as expectativas do público-alvo do meu projeto e clarifica o processo de identificação de requisitos. Pode responder as perguntas:

    - O que está sendo descrito? Que sistema está sendo modelado?
    - Quem interage com meu sistema?
    - O que os *atores*(papéis) podem fazer?
]

#example[
  #figure(caption: "Exemplo de Diagrama de Uso")[
    #image("images/diagrama-de-uso-exemplo.png")
  ]
]

#definition("Ator")[
  Elementos fora do sistema que tem alguma importância no ecossistema do projeto
]

#definition("Caso de Uso")[
  Descrevem as funcionalidades esperadas de um sistema em desenvolvimento. Descrevem as expectativas da parte interessada no sistema.
]

Um ator interage com um caso de uso quando:
- Utilizam dos *casos*
- São utilizados pelos *casos*

Também podemos classificar os meus *atores*:
- *Humano*
- *Não-humano*
- *Primário*
  - Principal beneficiado da execução do *caso de uso*
- *Secundário*
  - Não recebe benefícios diretos
- *Ativo*
  - Inicia diretamente o *caso de uso*
- *Passivo*
  - Propicia funcionalidades para a execução do *caso de uso*

Podemos também classificar as formas de como os atores se relacionam com os casos de uso

#columns(2)[
  #figure(caption: [
    Necessita que *(B)* seja executado antes de *(A)*
  ])[
    #image("images/include.png")
  ]

  #colbreak()

  #figure(caption: [
    *(A)* pode executar sozinho e decide se *(B)* vai executar ou não, sendo *(B)* uma extensão (das funcionalidades) do caso *(A)*
  ])[
    #image("images/exclude.png")
  ]
]

Assim, conseguimos montar uma pequena estruturação para os Casos de Uso

- *Nome*
- *Descrição*
- *Pre-condições*: Pré-requisitos para que o caso de uso funcione corretamenteo
- *Pós-condições*: Estado esperado do sistema após a execução do caso de uso
- *Situações de erro*: Erros relevantes
- *Estado do sistema na decorrência de um erro*
- *Atores que comunicam com o caso de uso*
- *Gatilho de acionamento*: Eventos que executam o caso de uso
- *Processo Principal*
- *Processos Alternativos*: Possiveis desvios do processo principal

#definition("Informação")[
  Dado interpretado segundo um contexto
]

#definition("Processo")[
  Conjunto de atividades logicamente organizadas e condicionais, cuja execução visa alcançar um objetivo determinado
]

#definition("Comportamento")[
  Trajetória percorrida por um processo. Todo efeito observável no ambiente externo do processo
]

Porém esse esquema de modelagem tem alguns pontos negativos e limitações:
- Ênfase excessiva no detalhamento do comportamento sistêmico
- Falta de regra objetiva para orientar os níveis de abstração
- Insuficiente detalhamento da informação que flui entre o sistema e o ambiente 

Surge então o MIR para que possa consertar esses problemas, surgindo como uma especialização do Diagrama de Uso. Essa solução leva alguns princípios em consideração
- Focar nos objetivos
- Atribuir níveis de abstração aos objetivos
- Focar no detalhamento da informação

#definition("Objetivo Informacional")[
  Objetivos dos atores que geram eventos externos que exigem *intervenção atômica* do sistema com trocas de informação capazes de mudar o estado do ambiente, do sistema ou de ambos
]

#definition("Intervenção Atômica")[
  Se processa sem interrupções ou temporizadores. Uma vez concluída, coloca o sistema em estado de espera para o próximo evento
]

Então montamos uma tabelinha de forma que cada coluna representa um ator e cada linha um objetivo informacional associado ao ator

#example("MOBI Taxi")[
  A cooperativa MOBITAXI deseja construir um aplicativo de celular para atender seus passageiros. Todos os motoristas e clientes precisam estar cadastrados com nome, número de telefone e endereço. O passageiro pode chamar o táxi de qualquer local dentro do estado do Rio de Janeiro. A posição (GPS) do celular do cliente indicará o local aonde o motorista deverá buscá-lo. Para evitar concorrência predatória entre os colegas taxistas e diminuir o tempo de espera do cliente, o sistema deverá escolher e direcionar a corrida ao motorista mais próximo. Ao final da corrida, o valor será debitado do cartão de crédito do cliente e creditado na conta do motorista. Sabe-se de 1% de todas as corridas são da administração. O cliente ainda poderá avaliar a corrida pontuando-a entre 0-5, além de escrever um comentário. A administração da cooperativa poderá “solicitar” a saída de motoristas mal avaliados

  Estes são os requisitos do meu sistema (Banco de Dados):

  1.Manter cadastro de motoristas e colaboradores (nome, celular e endereço), um motorista pode possuir mais de um veículo, assim como pode emprestá-lo;

  2.Manter cadastro de veículos (marca, modelo, ano, placa), um veículo pode ser conduzido por mais de um motorista;
  
  3.Manter cadastro de clientes (nome, celular e endereço), um cliente pode possuir mais de um endereço;
  
  4.Manter cadastro de viagens feitas pelo cliente, que só pode avaliar um motorista por corrida;
  
  5.Manter registro de créditos da cooperativa, considerando que 1% dos créditos sustentam a administração;
  
  6.A administração da MOBITAXI pode fazer uma avaliação dos motoristas a partir da \#viagens realizadas e da pontuação dada pelos clientes. Além de poder acessar os contadores básicos: \#motoristas, \#clientes, e \#viagens por mês

  Agora que temos toda a contextualização, podemos fazer a minha tabela

  #table(
    columns: (auto, auto, auto),
    align: horizon,
    inset: 7pt,

    table.header(
      table.cell(fill: color.linear-rgb(60, 60, 60))[#text(white)[*Motorista*]],
      table.cell(fill: color.linear-rgb(60, 60, 60))[#text(white)[*Passageiro*]],
      table.cell(fill: color.linear-rgb(60, 60, 60))[#text(white)[*Administração*]]
    ),

    [(1) Ver oferta de corrida],  [(6) Pedir corrida],      [(10) Cadastrar Motorista],
    [(2) Atender corrida],        [(7) Cancelar corrida],   [(11) Cadastrar Admin],
    [(3) Recusar corrida],        [(8) Avaliar corrida],    [(12) Cadastrar Veículo],
    [(4) Fechar corrida],         [(9) Atualizar cadastro], [(13) Avaliar Motorista],
    [(5) Atualizar cadastro],     [],                       [(14) Administrar Caixa],
  )
]

Com todos os meus objetivos informacionais bem-definidos, eu vou agora especificá-los ainda mais através da criação de uma interface informacional para *cada um deles*

#definition("Interface Informacional")[
  Define os fluxos de informação que entram e saem durante o processamento do objetivo pelo sistema e divide em duas etapas:

  + Especificação dos fluxos
    - Explicito detalhadamente as informações que fluem no objetivo, seja elas sendo recebidas por ele ou sendo enviadas para outro objetivo
  + Dicionários de itens elementares
    - Detalha as propriedades das informações que estão circulando no objetivo especificado
]

#example("MOBI Taxi")[
  Ainda utilizando da tabela que montamos anteriormente, vamos fazer as interfaces informacionais dos objetivos (1) e (2).

  #align(center, block(
    width: 100%,
    fill: rgb("#0E94B3"),
    radius: 10pt,
  )[
    #block(inset: 5pt, text(white, size: 13pt)[
      *Ator: Motorista | Objetivo 1: Ver oferta de Corrida*
    ])
    
    #block(
      width: 100%,
      fill: rgb("#C5EAF2"),
      inset: 10pt,
      spacing: 0pt,
      radius: (bottom-left: 10pt, bottom-right: 10pt),
      align(left, text(size: 12pt)[
        $<-$ *`oferta_corrida = id_cliente + nome_cliente + avaliação_cliente + ponto_partida_gps + dt_hr_pedido`*

        - Descrição: Informações de um passageiro pedindo uma corrida.
        - Propósito: Dar ao motorista a opção de aceitar ou não a corrida.
        - Frequência: 100/dia
      ])
    )
  ])

  #align(center, block(
    width: 100%,
    fill: rgb("#0E94B3"),
    radius: 10pt,
  )[
    #block(inset: 5pt, text(white, size: 13pt)[
      *Ator: Motorista | Objetivo 2: Atender Corrida*
    ])
    
    #block(
      width: 100%,
      fill: rgb("#C5EAF2"),
      inset: 10pt,
      spacing: 0pt,
      radius: (bottom-left: 10pt, bottom-right: 10pt),
      align(left, text(size: 12pt)[
        $->$ *`aceite_corrida = id_motorista + nome_motorista + localização_gps + dt_hr_aceite`*

        - Descrição: Uma vez que o motorista aceitou a corrida, o tempo começa a contar até chegar ao passageiro e nenhum outro motorista pode pegar a mesma corrida.
        - Propósito: Informar ao sistema a posição, as informações do motorista e a previsão de chegada ao passageiro.
        - Frequência: 100/dia
      ])
    )
  ])

  A seta $->$ apontando para dentro do texto significa que a informação está sendo *enviada para o sistema*, enquanto a seta $<-$ apontando para fora do texto quer dizer que a informação está sendo *recebida* pelo ator. Com as interfaces criadas, podemos agora fazer os dicionários elementares de cada interface. Farei apenas da interface informacional (1)

  #align(center)[
    #tablex(
      columns: (auto, auto, auto, auto),
      align: horizon,
      inset: 7pt,

      colspanx(4, fill: rgb("#0E94B3"), text(white)[ *Ator: Motorista | Objetivo 1: Ver Oferta de Corrida* ]),
  
      cellx(fill: rgb("#E3EEF0"))[*Nome*],
      cellx(fill: rgb("#E3EEF0"))[*Descrição*],
      cellx(fill: rgb("#E3EEF0"))[*Tipo*],
      cellx(fill: rgb("#E3EEF0"))[*Domínio*],

      [`Id_cliente`],[Id do cliente],[`Num. Sequencial natural`],[Gerado automaticamente],
      [`Nome_cliente`],[Nome do cliente],[`Str`],[],
      [`Avaliação_cliente`],[Média de avaliação do cliente por outros motoristas],[`Num. Natural`],[${1..5}$],
      [`Ponto_partida_gps`],[Posição geográfica (Lat/Long) do passageiro pedindo corrida],[`Float`],[Coordenadas WGS 84],
      [`Dt_hr_pedido`],[Data e hora em que o passageiro fez o pedido],[`Timestamp`],[]

    )
  ]
]

E para finalizar, temos os objetivos organizacionais

#definition("Objetivo Organizacional")[
  Uma sequência admissível de objetivos informacionais, representando uma linha de trabalho/objetivo de negócio relevante no domínio da aplicação para um ou mais atores
]

#definition[
  Sequências admissíveis de objetivos informacionais:

  #image("images/dependencia-temporal.png", width: 50%)
  Sequência de Objetivos Informacionais em relação de dependência temporal (*dt*). Isso significa que o objetivo *b* só poderá ser executando quando *a* terminar de executar

  #image("images/dependencia-incompatibilidade.png", width: 53%)
  Sequencia de objetivos informacionais em relação de incompatibilidade (*ic*). Isso significa que o evento *a* não ocorre se *b* ocorrer e vice-versa

  #image("images/dependencia-incompatibilidade-direcional.png", width: 71%)
  Sequencia de objetivos informacionais em relação de incompatibilidade *ic* em apenas um sentido. Isso significa que, se *a* acontecer, *b* não pode ocorrer, porém o contrário não vale
]

#example("MOBI Taxi")[
  *Atender Passageiro*
  #figure(caption: [Exemplo de Objetivo Organizacional], image("images/exemplo-mir.png"))

  - (6) $->$ (1): O motorista só pode ver a oferta após o passageiro pedir a corrida
  - (6) o---o (1): Não é possível recusar uma corrida sem que ela seja feita e um motorista não consegue recusar a corrida diretamente sem sequer a vê-la
  - (8) ---o (4): Não posso avaliar uma corrida que ainda não foi concluída, porém, mas o motorista pode fechar corridas independentemente do passageiro avaliá-la ou não
]

#pagebreak()

#align(center + horizon)[
  = Data Warehouses
]

#pagebreak()

Antes de adentrar no conceito de um Data Warehouse, vamos ter algumas definições antes

#definition("Dado Operacional")[
  Informações com pouco tempo de vida, utilizados essencialmente para o dia a dia e funcionamento do sistema, tem alta frequência e vão se atualizando conforme o tempo passa. Usado por diversos funcionários em setores diferentes e é orientado à aplicação
]

#definition("Dado Analítico")[
  Informações duradouras, que não se atualizam frequentemente e nem tem alta frequência de acesso. Redundância não é um problema, utilizado por um grupo ninchado de pessoas. Orientado ao assunto/contexto
]

A definição pode não ser muito clara, mas podemos imaginar um comparativo. Pense nos dados operacionais como um registro de diário, enquanto os dados analíticos são um livro de história. Os dados operacionais são frequentes, e não representam uma importância a longo prazo, por exemplo, o preço de um produto que está sendo passado no caixa, enquanto os dados analíticos representam um marco da empresa, como por exemplo, o lucro total da empresa na semana $x$.

Vamos também definir melhor:

#definition("Orientado à Aplicação/Application Oriented")[
  Dados projetados para suportar processos do dia a dia da organização. Estrutura de dados otimizada para inserções, atualizações e consultas rápidas de informações atuais com foco em transações (OLTP – Online Transaction Processing).
]
#example[
  Sistema bancário para processar depósitos/saques, sistema hospitalar para registrar consultas.
]

#definition("Orientado ao Assunto/Subject Oriented")[
  Dados projetados para analisar informações de um assunto de negócio específico (clientes, vendas, faturamento, estoque, etc.). Dados integrados e organizados de forma a responder perguntas estratégicas. Foco em análise histórica e tendências (OLAP – Online Analytical Processing). Normalmente são read-only (só leitura, não ficam sendo atualizados a todo instante).
]
#example[
  DW que reúne anos de dados de vendas para gerar relatórios, dashboards ou prever demanda.
]

Imagine que você está fazendo o sistema, você sabe que seus dados precisam ser bem estruturados, o foco do seu sistema é ser duradouro e bem manutenível além de promover uma segurança boa, então seus dados vão ser *application-oriented*, de forma que você faz questão de deixar tudo muito bem-estruturado e separado. Porém imagine que o foco do seu sistema é responder perguntas de negócio de forma rápida e eficiente, por exemplo: "Quanto minha empresa faturou nos últimos 3 meses?", dificilmente você vai se importar que as informações do banco que você está consultando estejam todas na norma 3, ou separadas direitinho com as chaves-estrangeiras bem definidas e organizadas, o importante é você responder a pergunta de forma rápida e eficiente, então você vai estruturar esse banco de forma a atingir esse objetivo, então seus dados são *subject-oriented*

Com isso em mente, agora podemos entender o que são Data Warehouses

#definition("Data Warehouse")[
  Um Data Warehouse é um *repositório estruturado* de dados *integrados*, *orientados ao assunto*, *com informações sobre toda a empresa*, *históricos* e *variantes com o tempo*. O propósito de um Data Warehouse é a extração de *dados analíticos*. Pode armazenar dados detalhados e/ou resumidos
]

De forma resumida, um Data Warehouse também é um banco de dados, porém, estruturado e com um objetivo totalmente diferente dos bancos convencionais que estudamos na disciplina de *banco de dados*. Mas o que compõe um Data Warehouse? No núcleo, ele em si é apenas esse banco de dados diferenciado, porém, como funciona o sistema? Como é estruturado um projeto/sistema em que um Data Warehouse é incluído?

#figure(
  caption: [ Ecossistema Data Warehouse ],
  image("images/data-warehouse-ecosystem.png")
)

Todas as definições abaixo são referentes a elementos apresentados na imagem como componentes de um ecossistema de Data Warehouse

#definition("Sistemas de Origem")[
  Sob o contexto de DW, os sistemas de origem são bases de dados operacionais e outros repositórios de dados (qualquer conjunto de dados usado para proposta operacional) que provê informação analítica útil para assuntos de análise. Cada unidade de armazenamento de dados operacionais que é usada como sistema de origem tem duas finalidades:
    - A própria finalidade operacional
    - Ser a fonte do DW
  Sistemas de origem podem incluir fontes internas e externas
]

#definition("Infraestrutura de ETL")[
  Facilita a leitura dos dados dos sistemas de origem para o Data Warehouse. O ETL (Extract, Transform, Load) tem as seguintes tarefas:
  - Extrair dados analiticamente úteis das origens operacionais
  - Transformar tais dados de forma aderente a estrutura de “orientação-ao-assunto” do modelo do DW (ao mesmo tempo que assegura a qualidade dessa transformação)
  - Carregar os dados transformados e com qualidade assegurada para o destino “target” data warehouse
]

#definition("Data Warehouse")[
  As vezes referenciado como "target system". Um DW típico lê as informações analiticamente úteis dos sistemas de origem de forma periódica ou contínua ,provendo sempre dados atualizados para análise
]

#definition("Aplicações Front-end")[
  De forma similar aos bancos operacionais, as aplicações “front-end” permitem o acesso indireto dos usuários aos dados
]

Como vimos, um data warehouse tem informações sobre *toda* uma empresa, podendo gerar análises sobre todos os seus departamentos. Mas e se isso for um comportamento indesejado? Eu quero ter uma análise detalhada, mas focar apenas no meu departamento e evitar que os outros vejam informações que não deveriam ou informações que possam atrapalhar nas suas análises, então aí entram os Data Marts

#definition("Data Mart")[
  Os Data Marts Seguem os mesmos princípios de um DW ,mas possuem um escopo mais limitado, geralmente ligado a um uso mais departamental, e não de forma abrangente à empresa conforme um DW.
  - *Data Mart independente*: Lobo solitário, criado como se fosse um DW. Um DM independente tem os próprios sistemas de origem e infraestrutura de ETL
  - *Data Mart dependente*: Não possui os próprios sistemas de origem. Os dados são lidos de um DW
]
