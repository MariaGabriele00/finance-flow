# Finance Flow

Sistema de gestão financeira pessoal desenvolvido com Flutter e Dart, com interface moderna, responsiva e adaptada para diferentes plataformas.

O projeto foi desenvolvido com foco em organização de código, separação de responsabilidades, reutilização de componentes, experiência do usuário e aplicação de boas práticas de desenvolvimento.

## Telas

### Dashboard

<div align="center">
  <img src="./assets/image-desktop.png" width="850">
</div>

### Fluxo Financeiro

<div align="center">
  <img src="./assets/image-desktop1.png" width="850">
</div>

### Transações

<div align="center">
  <img src="./assets/image-desktop3.png" width="850">
</div>

### Dashboard Mobile

<div align="center">
  <img src="./assets/image.png" width="280">
</div>

### Nova Transação

<div align="center">
  <img src="./assets/image-1.png" width="280">
</div>

### Transações Mobile

<div align="center">
  <img src="./assets/image-3.png" width="280">
</div>

## Funcionalidades

- Dashboard financeiro
- Controle de entradas e saídas
- Visualização do saldo atual
- Resumo financeiro
- Gráficos financeiros com animações
- Fluxo financeiro dos últimos meses
- Visualização de receitas e despesas
- Controle e cadastro de transações (inclusão e exclusão)
- Categorias financeiras e seleção de datas
- Formatação de valores em moeda brasileira
- Interface responsiva com layouts específicos para desktop e mobile
- Componentes reutilizáveis
- Tema baseado no Material 3

## Arquitetura

O projeto utiliza **Clean Architecture** para separar as responsabilidades da aplicação e facilitar sua manutenção, evolução e testabilidade.

```text
lib/
├── core/
│   └── theme/
│
├── data/
│   ├── datasources/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── presentation/
│   ├── bloc/
│   ├── pages/
│   └── widgets/
│
└── main.dart
```

### Fluxo da aplicação

```text
 Presentation
      |
      v
    BLoC
      |
      v
  Use Cases
      |
      v
  Repository
      |
      v
 Data Source
```

- **Core:** Responsável pelos recursos compartilhados da aplicação, como tema e configurações utilizadas por diferentes partes do sistema.
- **Data:** Responsável pela implementação dos repositórios e pelo acesso aos dados.
- **Domain:** Contém as regras de negócio da aplicação, entidades, contratos dos repositórios e casos de uso.
- **Presentation:** Responsável pela interface do usuário, gerenciamento de estado e componentes visuais.

## Tecnologias

- Flutter
- Dart
- Clean Architecture & Clean Code
- BLoC (Gerenciamento de Estado)
- fl_chart (Gráficos)
- Material 3
- Intl (Formatação de moeda e datas)
- Equatable

## Interface e Experiência

- **Gráficos:** O dashboard utiliza gráficos animados para facilitar a visualização da movimentação financeira, tornando a apresentação dos dados mais dinâmica e proporcionando uma experiência fluida. A visualização permite acompanhar entradas e saídas ao longo dos meses.
- **Design Responsivo:** A interface foi desenvolvida considerando diferentes tamanhos de tela (Smartphones, Tablets, Monitores, Notebooks e Desktops). A navegação e a distribuição dos componentes são adaptadas de acordo com o espaço disponível.

## Plataformas Suportadas

O projeto foi estruturado para funcionar de forma nativa e adaptada nas seguintes plataformas:

- Android & iOS
- Windows, macOS & Linux
- Web

## Como Executar

Clone o repositório:

```bash
git clone [https://github.com/MariaGabriele00/finance-flow.git](https://github.com/MariaGabriele00/finance-flow.git)
```

Acesse a pasta do projeto:

```bash
cd finance-flow
```

Instale as dependências:

```bash
flutter pub get
```

Execute o projeto de acordo com a plataforma desejada:

```bash
# Execução padrão
flutter run

# Execução no Windows
flutter run -d windows

# Execução na Web
flutter run -d chrome

# Execução no Android
flutter run -d android

# Execução no iOS
flutter run -d ios
```

## Dados e Gerenciamento

- **Persistência de dados:** O datasource atual utiliza armazenamento local em memória. A camada de dados está isolada através da abstração de repositórios, permitindo substituir posteriormente a implementação por uma solução persistente (SQLite, Isar, Firebase, API REST) sem alterar as regras de negócio da aplicação.
- **Estrutura de dados:** O domínio utiliza entidades próprias para representar as informações financeiras. A comunicação entre as camadas ocorre através de contratos, mantendo as regras de negócio desacopladas.
- **Gerenciamento de estado:** Realizado utilizando BLoC. A camada de apresentação comunica as intenções do usuário ao BLoC, que executa os casos de uso necessários e atualiza o estado da interface.

## Próximos Passos

- [ ] Persistência local de dados
- [ ] Autenticação de usuários e Sincronização em nuvem
- [ ] Múltiplas contas bancárias e Cartões de crédito
- [ ] Orçamentos e Metas financeiras
- [ ] Relatórios financeiros e Filtros avançados
- [ ] Busca de transações
- [ ] Notificações
- [ ] Testes unitários e Testes de BLoC
- [ ] Integração com API REST

## Objetivo do Projeto

O Finance Flow foi desenvolvido como um projeto de estudo e portfólio, com o objetivo de aplicar conceitos avançados de desenvolvimento de aplicações Flutter utilizando uma arquitetura organizada, componentes reutilizáveis, gerenciamento reativo de estado e uma interface altamente responsiva.

## Licença

Este projeto está disponível para fins de estudo e portfólio.
