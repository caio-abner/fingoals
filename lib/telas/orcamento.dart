import 'package:flutter/material.dart';

class TelaOrcamento extends StatelessWidget {
  const TelaOrcamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Orçamento', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // ListView é ótimo aqui pois já permite rolagem automática e empilha os itens
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // CARTÃO DE RESUMO DO MÊS
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                    value: 0.4, // 40% gasto
                    backgroundColor: Colors.grey[200],
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
          
          const SizedBox(height: 24),
          const Text('Categorias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // CATEGORIA 1: ALIMENTAÇÃO
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFE4E6), // Fundo vermelho claro
              child: Icon(Icons.restaurant, color: Colors.redAccent),
            ),
            title: const Text('Alimentação', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('R\$ 600 / R\$ 800'),
            trailing: const Text('75%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
          ),
          
          const SizedBox(height: 8),

          // CATEGORIA 2: TRANSPORTE
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE0F2FE), // Fundo azul claro
              child: Icon(Icons.directions_car, color: Colors.blueAccent),
            ),
            title: const Text('Transporte', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('R\$ 200 / R\$ 400'),
            trailing: const Text('50%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          ),
        ],
      ),
      // BOTÃO FLUTUANTE PARA ADICIONAR GASTO
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aqui entrará a lógica de abrir o formulário depois
        },
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}