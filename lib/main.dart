import 'package:flutter/material.dart';
import 'telas/dashboard.dart';
import 'telas/metas.dart';
import 'telas/orcamento.dart';
import 'telas/config.dart';
import 'telas/investimentos.dart';

void main() {
  runApp(const FinGoalsApp());
}

// 1. CONFIGURAÇÃO PRINCIPAL DO APP
class FinGoalsApp extends StatelessWidget {
  const FinGoalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinGoalsApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Aqui definimos o nosso verde esmeralda como cor principal
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981)),
        useMaterial3: true,
      ),
      home: const NavegacaoPrincipal(),
    );
  }
}

// 2. O GERENCIADOR DO MENU LATERAL (SIDEBAR)
class NavegacaoPrincipal extends StatefulWidget {
  const NavegacaoPrincipal({super.key});

  @override
  State<NavegacaoPrincipal> createState() => _NavegacaoPrincipalState();
}

class _NavegacaoPrincipalState extends State<NavegacaoPrincipal> {
  int _abaSelecionada = 0;

  void _aoClicarNaAba(int index) {
    setState(() {
      _abaSelecionada = index;
    });
  }

  // NOVA FORMA DE CHAMAR AS TELAS (Permite passar funções para dentro delas)
  Widget _obterTela() {
    switch (_abaSelecionada) {
      case 0:
        // Passamos a função _aoClicarNaAba como um "controle remoto" para o Dashboard
        return TelaDashboard(aoMudarAba: _aoClicarNaAba);
      case 1:
        return const TelaMetas();
      case 2:
        return const TelaOrcamento();
      case 3:
        return const TelaInvestimentos();
      case 4:
        return const TelaConfiguracoes();
      default:
        return TelaDashboard(aoMudarAba: _aoClicarNaAba);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // MENU LATERAL (SIDEBAR) - Continua igualzinho
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
          
          // ÁREA DO CONTEÚDO
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAFB),
              // Aqui nós chamamos a função em vez de usar a lista
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