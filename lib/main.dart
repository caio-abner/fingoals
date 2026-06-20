import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'telas/dashboard.dart';
import 'telas/metas.dart';
import 'telas/orcamento.dart';
import 'telas/investimentos.dart';
import 'telas/config.dart';
import 'telas/landing_page.dart';

void main() {
  runApp(const FinGoalsApp());
}

class FinGoalsApp extends StatelessWidget {
  const FinGoalsApp({super.key});

  // Função que verifica no banco se o usuário já fez login antes
  Future<bool> _verificarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinGoalsApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981)),
        useMaterial3: true,
      ),
      // O FutureBuilder decide qual tela mostrar baseado no banco de dados!
      home: FutureBuilder<bool>(
        future: _verificarSessao(),
        builder: (context, snapshot) {
          // Enquanto está lendo o banco, mostra um loading verde
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF10B981))));
          }
          // Se estiver logado, vai direto pro Dashboard!
          if (snapshot.data == true) {
            return const NavegacaoPrincipal();
          }
          // Se não estiver logado, vai para a Landing Page
          return const LandingPage();
        },
      ),
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
  
  // --- NOVAS VARIÁVEIS DO PERFIL ---
  String _nomeUsuario = 'Caio';
  String _emailUsuario = 'caio@gmail.com';
  String? _fotoPerfilBase64;

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

  Future<void> _carregarDoBancoDeDados() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. CARREGA O PERFIL
    _nomeUsuario = prefs.getString('perfil_nome') ?? 'Caio';
    _emailUsuario = prefs.getString('perfil_email') ?? 'caio@gmail.com';
    _fotoPerfilBase64 = prefs.getString('perfil_foto');

    // 2. CARREGA AS METAS (Seu código intacto)
    final String? metasSalvas = prefs.getString('banco_metas');
    if (metasSalvas != null) {
      List<dynamic> decodificado = jsonDecode(metasSalvas);
      setState(() {
        _metasGlobais = decodificado.map((item) => {
          'titulo': item['titulo'],
          'valorAtual': item['valorAtual'],
          'valorObjetivo': item['valorObjetivo'],
          'icone': _iconesDisponiveis.firstWhere(
            (iconeConstante) => iconeConstante.codePoint == (item['icone'] as int),
            orElse: () => Icons.star,
          ),
          'cor': Color(item['cor'] as int),
        }).toList();
        _carregandoBanco = false;
      });
    } else {
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
    List<Map<String, dynamic>> paraSalvar = _metasGlobais.map((item) => {
      'titulo': item['titulo'],
      'valorAtual': item['valorAtual'],
      'valorObjetivo': item['valorObjetivo'],
      'icone': item['icone'].codePoint, 
      'cor': item['cor'].value,         
    }).toList();
    await prefs.setString('banco_metas', jsonEncode(paraSalvar));
  }

  // --- NOVA FUNÇÃO QUE A TELA DE CONFIGURAÇÕES VAI CHAMAR ---
  Future<void> _atualizarPerfil(String nome, String email, String? fotoBase64) async {
    setState(() {
      _nomeUsuario = nome;
      _emailUsuario = email;
      _fotoPerfilBase64 = fotoBase64;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('perfil_nome', nome);
    await prefs.setString('perfil_email', email);
    if (fotoBase64 != null) {
      await prefs.setString('perfil_foto', fotoBase64);
    }
  }

  void _adicionarMeta(Map<String, dynamic> novaMeta) {
    setState(() { _metasGlobais.add(novaMeta); });
    _salvarNoBancoDeDados(); 
  }

  void _removerMeta(int index) {
    setState(() { _metasGlobais.removeAt(index); });
    _salvarNoBancoDeDados(); 
  }

  void _editarMeta(int index, Map<String, dynamic> metaAtualizada) {
    setState(() { _metasGlobais[index] = metaAtualizada; });
    _salvarNoBancoDeDados();
  }

  void _aoClicarNaAba(int index) {
    setState(() { _abaSelecionada = index; });
  }

  Widget _obterTela() {
    if (_carregandoBanco) return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));

    switch (_abaSelecionada) {
      case 0: return TelaDashboard(aoMudarAba: _aoClicarNaAba, metas: _metasGlobais);
      case 1: return TelaMetas(metas: _metasGlobais, onAdicionar: _adicionarMeta, onRemover: _removerMeta, onEditar: _editarMeta);
      case 2: return const TelaOrcamento();
      case 3: return const TelaInvestimentos();
      case 4: 
        // Passando as informações do perfil para a tela de configurações
        return TelaConfiguracoes(
          nome: _nomeUsuario, 
          email: _emailUsuario, 
          fotoBase64: _fotoPerfilBase64, 
          onAtualizarPerfil: _atualizarPerfil,
        );
      default: return TelaDashboard(aoMudarAba: _aoClicarNaAba, metas: _metasGlobais);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pegando as duas primeiras letras do nome para caso não tenha foto
    String iniciais = _nomeUsuario.isNotEmpty 
      ? (_nomeUsuario.length > 1 ? _nomeUsuario.substring(0, 2).toUpperCase() : _nomeUsuario.toUpperCase()) 
      : 'US';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: Colors.grey.shade200, width: 1))),
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
                
                // --- O MENU LATERAL AGORA É DINÂMICO ---
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 18,
                        // Se tiver foto no banco, mostra a foto. Senão, mostra nulo e desenha as letras.
                        backgroundImage: _fotoPerfilBase64 != null ? MemoryImage(base64Decode(_fotoPerfilBase64!)) : null,
                        child: _fotoPerfilBase64 == null 
                            ? Text(iniciais, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)) 
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_nomeUsuario, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(_emailUsuario, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(child: Container(color: const Color(0xFFF9FAFB), child: _obterTela())),
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