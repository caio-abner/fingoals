import 'package:flutter/material.dart';

class TelaMetas extends StatelessWidget {
  const TelaMetas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Minhas Metas', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // GridView.count divide a tela em colunas (neste caso, 2)
      body: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          // Chamamos a nossa função auxiliar para gerar as caixinhas rapidamente
          _construirCaixinhaMeta(
            titulo: 'Intercâmbio',
            valorAtual: 2000,
            valorObjetivo: 10000,
            icone: Icons.flight_takeoff,
            corDestaque: Colors.blueAccent,
          ),
          _construirCaixinhaMeta(
            titulo: 'MacBook Pro',
            valorAtual: 3500,
            valorObjetivo: 14000,
            icone: Icons.laptop_mac,
            corDestaque: Colors.purpleAccent,
          ),
          _construirCaixinhaMeta(
            titulo: 'Reserva',
            valorAtual: 5000,
            valorObjetivo: 5000,
            icone: Icons.shield,
            corDestaque: const Color(0xFF10B981),
          ),
        ],
      ),
      // BOTÃO FLUTUANTE PARA NOVA META
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Futura lógica para criar nova meta
        },
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  // --- FUNÇÃO AUXILIAR: CONSTRUTOR DE CAIXINHAS ---
  // Isso mantém o código limpo e reutilizável
  Widget _construirCaixinhaMeta({
    required String titulo,
    required double valorAtual,
    required double valorObjetivo,
    required IconData icone,
    required Color corDestaque,
  }) {
    // Calcula a porcentagem automaticamente (ex: 2000 / 10000 = 0.2)
    double progresso = valorAtual / valorObjetivo;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 36, color: corDestaque),
            const SizedBox(height: 12),
            Text(
              titulo, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Barrinha de preenchimento da meta
            LinearProgressIndicator(
              value: progresso,
              backgroundColor: Colors.grey[200],
              color: corDestaque,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Text(
              // Transforma os números em formato "k" (ex: 2.0k / 10.0k) para caber na caixinha
              'R\$ ${(valorAtual / 1000).toStringAsFixed(1)}k / ${(valorObjetivo / 1000).toStringAsFixed(1)}k',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}