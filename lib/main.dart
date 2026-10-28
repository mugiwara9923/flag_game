import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/paises.dart';

void main() {
  runApp(const FlagGameApp());
}

class FlagGameApp extends StatelessWidget {
  const FlagGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flag Game',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F6FC),
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int tempoSelecionado = 60;
  int recorde = 0;

  @override
  void initState() {
    super.initState();
    carregarRecorde();
  }

  Future<void> carregarRecorde() async {
    final preferencias = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      recorde = preferencias.getInt('recorde_flag_game') ?? 0;
    });
  }

  Future<void> abrirConfiguracoes() async {
    final resultado = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TimeSettingsScreen(tempoInicial: tempoSelecionado),
      ),
    );

    if (resultado != null && mounted) {
      setState(() {
        tempoSelecionado = resultado;
      });
    }
  }

  void iniciarJogo({String? continente}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          duracao: tempoSelecionado,
          continente: continente,
        ),
      ),
    );
  }

  Widget menuButton({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required Color cor,
    required VoidCallback onPressed,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: cor, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172554),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitulo,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 17),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.public,
                    size: 80,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'FLAG GAME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Color(0xFF172554),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Teste seus conhecimentos sobre as bandeiras do mundo!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: const Icon(
                        Icons.emoji_events,
                        color: Color(0xFFF59E0B),
                        size: 32,
                      ),
                      title: const Text(
                        'Seu recorde',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '$recorde pontos',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  menuButton(
                    icon: Icons.map,
                    titulo: 'Jogar por continente',
                    subtitulo: 'Escolha uma região do mundo',
                    cor: const Color(0xFF2563EB),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContinentsScreen(
                            aoEscolher: (continente) {
                              iniciarJogo(continente: continente);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  menuButton(
                    icon: Icons.shuffle,
                    titulo: 'Jogo aleatório',
                    subtitulo: 'Bandeiras de todo o mundo',
                    cor: const Color(0xFF059669),
                    onPressed: () => iniciarJogo(),
                  ),
                  const SizedBox(height: 16),
                  menuButton(
                    icon: Icons.timer_outlined,
                    titulo: 'Configurar tempo',
                    subtitulo: 'Tempo atual: ${textoTempo(tempoSelecionado)}',
                    cor: const Color(0xFF9333EA),
                    onPressed: abrirConfiguracoes,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'APRENDA • JOGUE • CONQUISTE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String textoTempo(int segundos) {
  if (segundos < 60) return '$segundos segundos';
  if (segundos == 60) return '60 segundos';
  return '${segundos ~/ 60} minutos';
}

class ContinentsScreen extends StatelessWidget {
  final ValueChanged<String> aoEscolher;

  const ContinentsScreen({
    super.key,
    required this.aoEscolher,
  });

  final List<String> continentes = const [
    'África',
    'América',
    'Ásia',
    'Europa',
    'Oceania',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha o continente')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: continentes.length,
        itemBuilder: (context, index) {
          final continente = continentes[index];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.public,
                color: Color(0xFF2563EB),
                size: 30,
              ),
              title: Text(
                continente,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
                aoEscolher(continente);
              },
            ),
          );
        },
      ),
    );
  }
}

class TimeSettingsScreen extends StatefulWidget {
  final int tempoInicial;

  const TimeSettingsScreen({
    super.key,
    required this.tempoInicial,
  });

  @override
  State<TimeSettingsScreen> createState() => _TimeSettingsScreenState();
}

class _TimeSettingsScreenState extends State<TimeSettingsScreen> {
  late int tempoSelecionado;

  final Map<int, String> tempos = {
    30: '30 segundos',
    60: '60 segundos',
    180: '3 minutos',
    300: '5 minutos',
  };

  @override
  void initState() {
    super.initState();
    tempoSelecionado = widget.tempoInicial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar tempo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.timer,
              size: 70,
              color: Color(0xFF9333EA),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quanto tempo você quer jogar?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            RadioGroup<int>(
              groupValue: tempoSelecionado,
              onChanged: (valor) {
                if (valor != null) {
                  setState(() {
                    tempoSelecionado = valor;
                  });
                }
              },
              child: Column(
                children: tempos.entries.map((entrada) {
                  return Card(
                    color: Colors.white,
                    child: RadioListTile<int>(
                      title: Text(entrada.value),
                      value: entrada.key,
                    ),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, tempoSelecionado);
              },
              child: const Text('Salvar configuração'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final int duracao;
  final String? continente;

  const GameScreen({
    super.key,
    required this.duracao,
    this.continente,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random random = Random();

  late List<Pais> banco;
  late List<Pais> paisesDisponiveis;
  late int tempoRestante;

  List<Pais> opcoes = [];
  Pais? perguntaAtual;
  int pontuacao = 0;
  int respondidas = 0;
  int? respostaSelecionada;

  Timer? cronometro;
  bool bloqueado = false;
  bool finalizado = false;

  @override
  void initState() {
    super.initState();

    banco = widget.continente == null
        ? List<Pais>.from(paises)
        : paises
            .where((pais) => pais.continente == widget.continente)
            .toList();

    tempoRestante = widget.duracao;
    paisesDisponiveis = List<Pais>.from(banco)..shuffle(random);
    gerarPergunta();

    cronometro = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted || finalizado) {
          timer.cancel();
          return;
        }

        if (tempoRestante <= 1) {
          setState(() {
            tempoRestante = 0;
          });
          encerrarJogo();
        } else {
          setState(() {
            tempoRestante--;
          });
        }
      },
    );
  }

  void gerarPergunta() {
  if (paisesDisponiveis.isEmpty) {
    perguntaAtual = null;
    opcoes = [];
    return;
  }

  perguntaAtual = paisesDisponiveis.removeAt(0);

  final outrasOpcoes = List<Pais>.from(banco)
    ..removeWhere((pais) => pais.nome == perguntaAtual!.nome)
    ..shuffle(random);

  opcoes = [
    perguntaAtual!,
    ...outrasOpcoes.take(3),
  ];

  opcoes.shuffle(random);
  respostaSelecionada = null;
  bloqueado = false;
}

  Future<void> responder(Pais pais) async {
    if (bloqueado || finalizado || perguntaAtual == null) return;

    setState(() {
      bloqueado = true;
      respostaSelecionada = opcoes.indexOf(pais);
      respondidas++;

      if (pais.nome == perguntaAtual!.nome) {
        pontuacao++;
      }
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted || finalizado) return;

    if (tempoRestante <= 0 || paisesDisponiveis.isEmpty) {
  encerrarJogo();
  return;
}

setState(() {
  gerarPergunta();
    });
  }

  Future<void> encerrarJogo() async {
    if (finalizado) return;

    finalizado = true;
    cronometro?.cancel();

    final preferencias = await SharedPreferences.getInstance();
    final recordeAnterior =
        preferencias.getInt('recorde_flag_game') ?? 0;

    final bateuRecorde = pontuacao > recordeAnterior;
    final recordeAtual =
        bateuRecorde ? pontuacao : recordeAnterior;

    if (bateuRecorde) {
      await preferencias.setInt('recorde_flag_game', pontuacao);
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          respondidas: respondidas,
          acertos: pontuacao,
          recorde: recordeAtual,
          bateuRecorde: bateuRecorde,
        ),
      ),
    );
  }

  @override
  void dispose() {
    cronometro?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pais = perguntaAtual;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.continente ?? 'Modo aleatório'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Encerrar partida',
            onPressed: encerrarJogo,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.timer, size: 18),
                        label: Text(
                          '${tempoRestante ~/ 60}:'
                          '${(tempoRestante % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Chip(
                        avatar: const Icon(Icons.star, size: 18),
                        label: Text('Pontos: $pontuacao'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'A qual país pertence esta bandeira?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pais?.bandeira ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...opcoes.asMap().entries.map((entrada) {
                    final indice = entrada.key;
                    final opcao = entrada.value;

                    Color cor = Colors.white;

                    if (bloqueado) {
                      if (opcao.nome == perguntaAtual?.nome) {
                        cor = const Color(0xFFC8F7D2);
                      } else if (indice == respostaSelecionada) {
                        cor = const Color(0xFFFFD6D6);
                      }
                    }

                    return Card(
                      color: cor,
                      child: ListTile(
                        title: Text(
                          opcao.nome,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: bloqueado ? null : () => responder(opcao),
                      ),
                    );
                  }),
                  if (bloqueado) ...[
                    const SizedBox(height: 12),
                    Text(
                      opcoes[respostaSelecionada!].nome ==
                              perguntaAtual?.nome
                          ? 'Resposta correta!'
                          : 'Resposta errada! A bandeira era de '
                              '${perguntaAtual?.nome}.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: opcoes[respostaSelecionada!].nome ==
                                perguntaAtual?.nome
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final int respondidas;
  final int acertos;
  final int recorde;
  final bool bateuRecorde;

  const ResultsScreen({
    super.key,
    required this.respondidas,
    required this.acertos,
    required this.recorde,
    required this.bateuRecorde,
  });

  @override
  Widget build(BuildContext context) {
    final erros = respondidas - acertos;
    final percentual =
        respondidas == 0 ? 0.0 : acertos / respondidas * 100;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 100,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'FIM DE JOGO!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172554),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Confira seu desempenho',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  if (bateuRecorde) ...[
                    const SizedBox(height: 20),
                    const Card(
                      color: Color(0xFFFFF3CD),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: Color(0xFFF59E0B),
                              size: 32,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Novo recorde! Parabéns!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  resultadoCard(
                    'Recorde pessoal',
                    '$recorde pontos',
                    Icons.emoji_events,
                  ),
                  const SizedBox(height: 16),
                  resultadoCard(
                    'Perguntas respondidas',
                    '$respondidas',
                    Icons.quiz,
                  ),
                  resultadoCard(
                    'Acertos',
                    '$acertos',
                    Icons.check_circle,
                  ),
                  resultadoCard(
                    'Erros',
                    '$erros',
                    Icons.cancel,
                  ),
                  resultadoCard(
                    'Percentual de acertos',
                    '${percentual.toStringAsFixed(1)}%',
                    Icons.bar_chart,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (rota) => rota.isFirst,
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Voltar ao menu principal'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget resultadoCard(String titulo, String valor, IconData icone) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          icone,
          color: const Color(0xFF2563EB),
          size: 28,
        ),
        title: Text(titulo),
        trailing: Text(
          valor,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}