import 'dart:convert'; // Usado para converter dados para o banco
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // O Banco de Dados

// IMPORTANDO SEUS ARQUIVOS REAIS MODULARIZADOS
import 'telas/dashboard.dart';
import 'telas/metas.dart';
import 'telas/orcamento.dart';
import 'telas/investimentos.dart';
import 'telas/config.dart';

void main() {
  runApp(const FinGoalsApp());
}

class FinGoalsApp extends StatelessWidget {
  const FinGoalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinGoalsApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981)),
        useMaterial3: true,
      ),
      home: const NavegacaoPrincipal(),
    );
  }
}

class NavegacaoPrincipal extends StatefulWidget {
  const NavegacaoPrincipal({super.key});

  @override
  State<NavegacaoPrincipal> createState() => _NavegacaoPrincipalState();
}

class _NavegacaoPrincipalState extends State<NavegacaoPrincipal> {
  int _abaSelecionada = 0;
  bool _carregandoBanco = true; 

  List<Map<String, dynamic>> _metasGlobais = [];

  // 1. LISTA SEGURA DE CONSTANTES (Para o Tree Shaking do Flutter não reclamar)
  final List<IconData> _iconesDisponiveis = [
    Icons.star, Icons.flight_takeoff, Icons.directions_car, 
    Icons.home, Icons.laptop_mac, Icons.school, 
    Icons.favorite, Icons.fitness_center, Icons.videogame_asset,
    Icons.shield,
  ];

  @override
  void initState() {
    super.initState();
    _carregarDoBancoDeDados(); 
  }

  // --- LÓGICA DA BASE DE DADOS LOCAL ---
  Future<void> _carregarDoBancoDeDados() async {
    final prefs = await SharedPreferences.getInstance();
    final String? metasSalvas = prefs.getString('banco_metas');

    if (metasSalvas != null) {
      List<dynamic> decodificado = jsonDecode(metasSalvas);
      setState(() {
        _metasGlobais = decodificado.map((item) => {
          'titulo': item['titulo'],
          'valorAtual': item['valorAtual'],
          'valorObjetivo': item['valorObjetivo'],
          
          // 2. A MÁGICA: Pescamos o ícone constante da nossa lista segura em vez de criar um dinâmico!
          'icone': _iconesDisponiveis.firstWhere(
            (iconeConstante) => iconeConstante.codePoint == (item['icone'] as int),
            orElse: () => Icons.star, // Segurança caso não encontre
          ),
          
          'cor': Color(item['cor'] as int),
        }).toList();
        _carregandoBanco = false;
      });
    } else {
      // Se for a primeira vez abrindo a aplicação...
      setState(() {
        _metasGlobais = [
          {'titulo': 'Intercâmbio', 'valorAtual': 2000.0, 'valorObjetivo': 10000.0, 'icone': Icons.flight_takeoff, 'cor': Colors.blueAccent},
          {'titulo': 'MacBook Pro', 'valorAtual': 3500.0, 'valorObjetivo': 14000.0, 'icone': Icons.laptop_mac, 'cor': Colors.purpleAccent},
        ];
        _carregandoBanco = false;
      });
      _salvarNoBancoDeDados(); 
    }
  }

  Future<void> _salvarNoBancoDeDados() async {
    final prefs = await SharedPreferences.getInstance();
    // Converte nossos ícones e cores para formato de texto (JSON) que o celular entenda
    List<Map<String, dynamic>> paraSalvar = _metasGlobais.map((item) => {
      'titulo': item['titulo'],
      'valorAtual': item['valorAtual'],
      'valorObjetivo': item['valorObjetivo'],
      'icone': item['icone'].codePoint, // Pega o código numérico do ícone
      'cor': item['cor'].value,         // Pega o código hexadecimal da cor
    }).toList();

    await prefs.setString('banco_metas', jsonEncode(paraSalvar));
  }

  // --- FUNÇÕES DE COMUNICAÇÃO (CONTROLE REMOTO DAS TELAS) ---
  void _adicionarMeta(Map<String, dynamic> novaMeta) {
    setState(() {
      _metasGlobais.add(novaMeta);
    });
    _salvarNoBancoDeDados(); // Salva no banco sempre que uma meta nasce
  }

  void _removerMeta(int index) {
    setState(() {
      _metasGlobais.removeAt(index);
    });
    _salvarNoBancoDeDados(); // Atualiza o banco sempre que apagamos
  }

  void _aoClicarNaAba(int index) {
    setState(() {
      _abaSelecionada = index;
    });
  }

  Widget _obterTela() {
    // Se o banco ainda estiver carregando, mostra só um fundo limpo
    if (_carregandoBanco) return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));

    switch (_abaSelecionada) {
      case 0:
        return TelaDashboard(aoMudarAba: _aoClicarNaAba, metas: _metasGlobais);
      case 1:
        return TelaMetas(metas: _metasGlobais, onAdicionar: _adicionarMeta, onRemover: _removerMeta);
      case 2:
        return const TelaOrcamento();
      case 3:
        return const TelaInvestimentos();
      case 4:
        return const TelaConfiguracoes();
      default:
        return TelaDashboard(aoMudarAba: _aoClicarNaAba, metas: _metasGlobais);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // MENU LATERAL (SIDEBAR)
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey.shade200, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: const [
                      Icon(Icons.track_changes, color: Color(0xFF10B981), size: 28),
                      SizedBox(width: 12),
                      Text('FinGoals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                _construirItemMenu(icone: Icons.dashboard_rounded, titulo: 'Dashboard', index: 0),
                _construirItemMenu(icone: Icons.flag_rounded, titulo: 'Minhas Metas', index: 1),
                _construirItemMenu(icone: Icons.account_balance_wallet_rounded, titulo: 'Orçamento', index: 2),
                _construirItemMenu(icone: Icons.trending_up_rounded, titulo: 'Investimentos', index: 3),
                _construirItemMenu(icone: Icons.settings_rounded, titulo: 'Configurações', index: 4),

                const Spacer(),

                Divider(height: 1, color: Colors.grey.shade200),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 18,
                        child: const Text('CA', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Caio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('caio@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAFB),
              child: _obterTela(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirItemMenu({required IconData icone, required String titulo, required int index}) {
    bool selecionado = _abaSelecionada == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: InkWell(
        onTap: () => _aoClicarNaAba(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(color: selecionado ? const Color(0xFFE6F8F3) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icone, color: selecionado ? const Color(0xFF10B981) : Colors.grey, size: 20),
              const SizedBox(width: 16),
              Text(titulo, style: TextStyle(color: selecionado ? const Color(0xFF10B981) : Colors.grey[700], fontWeight: selecionado ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }
}