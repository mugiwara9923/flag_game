# 🏳️ Flag Game — Jogo de Bandeiras

## 📌 Sobre o projeto

O **Flag Game** é um jogo de perguntas e respostas desenvolvido em Flutter, no qual o jogador precisa identificar os países por meio de suas bandeiras.

O projeto foi desenvolvido como atividade acadêmica, com o objetivo de praticar o desenvolvimento de aplicações utilizando Flutter e Dart.

## 🎮 Funcionalidades

- **Modo por continente:** permite jogar com países de diferentes continentes.
- **Modo aleatório:** apresenta países de forma aleatória.
- **Seleção de tempo:** permite escolher entre 30 segundos, 60 segundos, 3 minutos e 5 minutos.
- **Perguntas com alternativas:** cada pergunta apresenta uma bandeira e quatro opções de resposta.
- **Cronômetro:** controla o tempo disponível para a partida.
- **Pontuação:** contabiliza as respostas corretas e incorretas.
- **Sem repetição de países:** evita que o mesmo país apareça novamente durante a mesma partida.
- **Tela de resultados:** apresenta a quantidade de perguntas respondidas, acertos, erros e percentual de aproveitamento.
- **Recorde salvo localmente:** utiliza o armazenamento local para manter o recorde do jogador.

## 🛠️ Tecnologias utilizadas

- **Flutter:** framework utilizado para desenvolver a interface e a aplicação.
- **Dart:** linguagem de programação utilizada no projeto.
- **Shared Preferences:** biblioteca utilizada para armazenar informações localmente no dispositivo.

## 📋 Pré-requisitos

Para executar o projeto, é necessário ter instalado:

- Flutter SDK.
- Dart SDK, incluído na instalação do Flutter.
- Visual Studio Code ou outra IDE compatível.
- Google Chrome ou um dispositivo compatível para executar a aplicação.

## 🚀 Como executar o projeto

### 1. Clonar o repositório

```bash
git clone URL_DO_SEU_REPOSITORIO
```

Substitua `URL_DO_SEU_REPOSITORIO` pelo endereço do repositório do projeto no GitHub.

### 2. Entrar na pasta do projeto

```bash
cd flag_game
```

### 3. Instalar as dependências

```bash
flutter pub get
```

### 4. Executar a aplicação

Para executar no Google Chrome:

```bash
flutter run -d chrome
```

## 📂 Estrutura do projeto

```text
flag_game/
├── lib/
│   ├── main.dart
│   └── paises.dart
├── test/
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

- **main.dart:** contém a estrutura principal do aplicativo, as telas e a lógica do jogo.
- **paises.dart:** contém os dados dos países, suas bandeiras e seus continentes.
- **pubspec.yaml:** define as dependências e as configurações do projeto.
- **test/:** diretório destinado aos testes da aplicação.

## 🎯 Objetivo

O objetivo do Flag Game é proporcionar uma maneira interativa e divertida de aprender e testar conhecimentos sobre bandeiras e países do mundo, combinando aprendizado, agilidade e competição por pontuação.

## 👨‍💻 Desenvolvimento

Projeto acadêmico desenvolvido como atividade prática de programação com Flutter e Dart.
