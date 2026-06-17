import 'package:flutter/material.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  bool _modoEscuroAtivo = false; // Controla o botão visualmente

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0), // Espaçamento generoso do Figma
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CABEÇALHO
            const Text(
              'Configurações da Conta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Gerencie suas preferências e configurações',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // LISTA DE CONFIGURAÇÕES
            _construirCardConfiguracao(
              icone: Icons.person_outline,
              corIcone: const Color(0xFF10B981),
              corFundoIcone: const Color(0xFFE6F8F3),
              titulo: 'Editar Perfil',
              subtitulo: 'Atualize suas informações pessoais e foto de perfil',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            _construirCardConfiguracao(
              icone: Icons.notifications_none,
              corIcone: const Color(0xFF10B981),
              corFundoIcone: const Color(0xFFE6F8F3),
              titulo: 'Notificações',
              subtitulo: 'Gerencie suas preferências de notificações',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // MODO ESCURO (Com o botão nativo Switch)
            _construirCardConfiguracao(
              icone: Icons.dark_mode_outlined,
              corIcone: Colors.deepPurpleAccent,
              corFundoIcone: Colors.deepPurple.shade50,
              titulo: 'Modo Escuro',
              subtitulo: 'Alterne entre tema claro e escuro',
              trailing: Switch(
                value: _modoEscuroAtivo,
                activeColor: Colors.deepPurpleAccent,
                onChanged: (bool valor) {
                  setState(() {
                    _modoEscuroAtivo = valor;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            _construirCardConfiguracao(
              icone: Icons.shield_outlined,
              corIcone: const Color(0xFF10B981),
              corFundoIcone: const Color(0xFFE6F8F3),
              titulo: 'Segurança',
              subtitulo: 'Altere sua senha e configure autenticação',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),

            const SizedBox(height: 60),

            // RODAPÉ (Links e Versão)
            Row(
              children: [
                const Text('Termos de Uso', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                const Text('  ·  ', style: TextStyle(color: Colors.grey)),
                const Text('Política de Privacidade', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                const Text('  ·  ', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                  child: const Text('Sair da Conta', style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Versão 1.0.0 • © 2026 Financial Goals Tracker',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para criar os cartões brancos com borda
  Widget _construirCardConfiguracao({
    required IconData icone,
    required Color corIcone,
    required Color corFundoIcone,
    required String titulo,
    required String subtitulo,
    required Widget trailing,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: corFundoIcone,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icone, color: corIcone),
          ),
          title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          subtitle: Text(subtitulo, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          trailing: trailing,
        ),
      ),
    );
  }
}