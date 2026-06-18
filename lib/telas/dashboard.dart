import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TelaDashboard extends StatelessWidget {
  final Function(int) aoMudarAba;
  final List<Map<String, dynamic>> metas;

  const TelaDashboard({
    super.key,
    required this.aoMudarAba,
    required this.metas, // A lista oficial recebida do main.dart
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CABEÇALHO
            const Text(
              'Bem-vindo de volta!',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4),
            RichText(
              text: const TextSpan(
                text: 'Saldo Total: ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'R\$ 15.400,00',
                    style: TextStyle(color: Color(0xFF10B981)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // 2. RESUMO DO ORÇAMENTO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Resumo do Orçamento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => aoMudarAba(2),
                  child: const Text('Ver detalhes ->', style: TextStyle(color: Color(0xFF10B981))),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Gastos do Mês', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('R\$ 1.570,00', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Limite', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text('R\$ 2.100,00', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 1570 / 2100,
                      backgroundColor: Colors.grey[100],
                      color: const Color(0xFF10B981),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 8),
                    const Text('75% do orçamento mensal utilizado', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 3. MINHAS METAS (100% DINÂMICO AGORA!)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Minhas Metas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Progresso dos seus principais objetivos', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                TextButton(
                  onPressed: () => aoMudarAba(1),
                  child: const Text('Ver todos ->', style: TextStyle(color: Color(0xFF10B981))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Loop dinâmico que lê a lista e desenha no máximo os 2 primeiros cartões
            if (metas.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Nenhuma meta cadastrada ainda.', style: TextStyle(color: Colors.grey)),
              )
            else
              Row(
                children: metas.take(2).map((meta) {
                  return Expanded(
                    child: Padding(
                      // Adiciona um espaço à direita do primeiro cartão, mas não do último
                      padding: EdgeInsets.only(right: meta == metas.take(2).last ? 0 : 16.0),
                      child: _construirCartaoObjetivoFigma(meta),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 32),

            // 4. MEU PORTFÓLIO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Meu Portfólio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Distribuição dos seus investimentos', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                TextButton(
                  onPressed: () => aoMudarAba(3),
                  child: const Text('Ver detalhes ->', style: TextStyle(color: Color(0xFF10B981))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 150, width: 150,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 0, centerSpaceRadius: 40,
                              sections: [
                                PieChartSectionData(color: Colors.blueAccent, value: 55, title: '', radius: 30),
                                PieChartSectionData(color: Colors.purpleAccent, value: 45, title: '', radius: 30),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('100%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                Text('Total', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Valor Total Investido', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const Text('R\$ 15.400,00', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(width: 16, height: 16, decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(4))),
                                    const SizedBox(width: 12),
                                    const Text('Renda Fixa', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const Text('R\$ 8.500,00', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(width: 16, height: 16, decoration: BoxDecoration(color: Colors.purpleAccent, borderRadius: BorderRadius.circular(4))),
                                    const SizedBox(width: 12),
                                    const Text('Renda Variável', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const Text('R\$ 6.900,00', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // A função que desenha o cartão agora extrai as cores e ícones dinamicamente do objeto "meta"
  Widget _construirCartaoObjetivoFigma(Map<String, dynamic> meta) {
    double progresso = meta['valorObjetivo'] > 0 ? (meta['valorAtual'] / meta['valorObjetivo']) : 0;
    int porcentagem = (progresso * 100).toInt();

    // Extrai a cor do mapa de forma segura
    Color corTema = meta['cor'] ?? const Color(0xFF10B981);

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: corTema.withOpacity(0.1),
                  // Renderizando o ícone dinâmico escolhido pelo usuário!
                  child: Icon(meta['icone'], size: 16, color: corTema),
                ),
                Text('$porcentagem%', style: TextStyle(color: corTema, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              meta['titulo'], // Título dinâmico
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progresso,
              backgroundColor: Colors.grey[100],
              color: corTema,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Valor atual', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    Text('R\$ ${meta['valorAtual'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Meta', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    Text('R\$ ${meta['valorObjetivo'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}