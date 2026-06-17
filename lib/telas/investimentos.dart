import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Importa a biblioteca de gráficos

class TelaInvestimentos extends StatelessWidget {
  const TelaInvestimentos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CABEÇALHO
            const Text(
              'Meu Portfólio',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Evolução e distribuição dos seus investimentos',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // LAYOUT DIVIDIDO: Gráfico na Esquerda, Cartões na Direita
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ÁREA DO GRÁFICO (Ocupa 2/3 da tela)
                Expanded(
                  flex: 2,
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Crescimento nos Últimos 6 Meses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          const Text('Evolução do valor total do portfólio', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 32),
                          
                          // O GRÁFICO DE LINHA DO FL_CHART
                          SizedBox(
                            height: 300, // Altura do gráfico
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false, // Tira linhas verticais do fundo
                                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                                ),
                                titlesData: FlTitlesData(
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  // Nomes dos meses embaixo
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        const meses = ['Out', 'Nov', 'Dez', 'Jan', 'Fev', 'Mar'];
                                        if (value.toInt() >= 0 && value.toInt() < meses.length) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(meses[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                  // Valores em R$ na esquerda
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 45,
                                      getTitlesWidget: (value, meta) {
                                        return Text('R\$ ${value.toInt()}k', style: const TextStyle(color: Colors.grey, fontSize: 12));
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                minX: 0,
                                maxX: 5,
                                minY: 0,
                                maxY: 16,
                                lineBarsData: [
                                  // A LINHA DO GRÁFICO
                                  LineChartBarData(
                                    spots: const [
                                      FlSpot(0, 12),
                                      FlSpot(1, 13),
                                      FlSpot(2, 13.5),
                                      FlSpot(3, 13.8),
                                      FlSpot(4, 14.5),
                                      FlSpot(5, 15.4),
                                    ],
                                    isCurved: false,
                                    color: const Color(0xFF10B981),
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                        radius: 4,
                                        color: const Color(0xFF10B981),
                                        strokeWidth: 2,
                                        strokeColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 24),
                
                // ÁREA DOS CARTÕES LATERAIS (Ocupa 1/3 da tela)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _construirCardAtivo(
                        icone: Icons.account_balance,
                        titulo: 'Renda Fixa',
                        subtitulo: 'Tesouro, CDBs',
                        valor: 'R\$ 8.500,00',
                        porcentagemGeral: 0.55,
                        rendimento: '+5.2%',
                        cor: Colors.blueAccent,
                      ),
                      const SizedBox(height: 16),
                      _construirCardAtivo(
                        icone: Icons.trending_up,
                        titulo: 'Renda Variável',
                        subtitulo: 'ETFs, Ações',
                        valor: 'R\$ 6.900,00',
                        porcentagemGeral: 0.45,
                        rendimento: '+12.8%',
                        cor: Colors.purpleAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para criar os cartões de ativos
  Widget _construirCardAtivo({
    required IconData icone, required String titulo, required String subtitulo,
    required String valor, required double porcentagemGeral, required String rendimento, required Color cor,
  }) {
    return Card(
      color: Colors.white, elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                  child: Icon(icone, color: Colors.grey.shade700),
                ),
                Text(rendimento, style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitulo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            Text(valor, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: LinearProgressIndicator(value: porcentagemGeral, backgroundColor: Colors.grey.shade200, color: cor, minHeight: 6, borderRadius: BorderRadius.circular(10))),
                const SizedBox(width: 12),
                Text('${(porcentagemGeral * 100).toInt()}%', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}