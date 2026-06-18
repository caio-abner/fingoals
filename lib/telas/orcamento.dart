import 'package:flutter/material.dart';

class TelaOrcamento extends StatelessWidget {
  const TelaOrcamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Fundo padronizado
      // Mudamos para SingleChildScrollView para permitir o cabeçalho fora da lista
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0), // Espaçamento padronizado
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CABEÇALHO PADRÃO
            const Text(
              'Orçamento',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Acompanhe seus limites e controle seus gastos',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // CARTÃO DE RESUMO DO MÊS
            Card(
              color: Colors.white,
              elevation: 0, // Sem sombra
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200), // Borda sutil
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Resumo de Junho', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    const Text('Disponível para gastar', style: TextStyle(color: Colors.grey)),
                    const Text(
                      'R\$ 1.800,00', 
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF10B981))
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.4,
                      backgroundColor: Colors.grey[100],
                      color: const Color(0xFF10B981),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gasto: R\$ 1.200,00', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Total: R\$ 3.000,00', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            const Text('Categorias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // LISTA DE CATEGORIAS
            _construirCategoria(
              icone: Icons.restaurant,
              corIcone: Colors.redAccent,
              corFundo: const Color(0xFFFFE4E6),
              titulo: 'Alimentação',
              gasto: 600,
              limite: 800,
            ),
            const SizedBox(height: 12),
            _construirCategoria(
              icone: Icons.directions_car,
              corIcone: Colors.blueAccent,
              corFundo: const Color(0xFFE0F2FE),
              titulo: 'Transporte',
              gasto: 200,
              limite: 400,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF10B981),
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Função para padronizar as listagens de categorias sem repetir código
  Widget _construirCategoria({
    required IconData icone, required Color corIcone, required Color corFundo, 
    required String titulo, required double gasto, required double limite
  }) {
    double progresso = gasto / limite;
    int porcentagem = (progresso * 100).toInt();

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: corFundo, borderRadius: BorderRadius.circular(10)),
          child: Icon(icone, color: corIcone),
        ),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('R\$ ${gasto.toStringAsFixed(2)} / R\$ ${limite.toStringAsFixed(2)}'),
        trailing: Text('$porcentagem%', style: TextStyle(fontWeight: FontWeight.bold, color: corIcone, fontSize: 16)),
      ),
    );
  }
}