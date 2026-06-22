import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 

class TelaInvestimentos extends StatelessWidget {
  const TelaInvestimentos({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            isMobile
            ? Column( // NO CELULAR, O GRÁFICO FICA EM CIMA E OS CARTÕES EMBAIXO
                children: [
                  _construirAreaGrafico(isMobile),
                  const SizedBox(height: 24),
                  _construirCartoesLaterais(),
                ],
              )
            : Row( // NO PC, FICA LADO A LADO
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _construirAreaGrafico(isMobile)),
                  const SizedBox(width: 24),
                  Expanded(flex: 1, child: _construirCartoesLaterais()),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _construirAreaGrafico(bool isMobile) {
    return Card(
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
            
            SizedBox(
              height: isMobile ? 200 : 300, // Gráfico fica menor no celular para caber na tela
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => Colors.white, 
                      tooltipBorder: const BorderSide(color: Colors.black12, width: 1), 
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          const meses = ['Out', 'Nov', 'Dez', 'Jan', 'Fev', 'Mar'];
                          final mes = meses[touchedSpot.x.toInt()];
                          final valorFormatado = (touchedSpot.y * 1000).toStringAsFixed(2).replaceAll('.', ',');

                          return LineTooltipItem(
                            '$mes\n',
                            const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                            children: [
                              TextSpan(
                                text: 'Valor : R\$ $valorFormatado',
                                style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.normal, fontSize: 12),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                    getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((index) {
                        return TouchedSpotIndicatorData(
                          const FlLine(color: Color(0xFF10B981), strokeWidth: 2, dashArray: [4, 4]), 
                          FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                              radius: 5, color: const Color(0xFF10B981), strokeWidth: 3, strokeColor: Colors.white,
                            ),
                          ), 
                        );
                      }).toList();
                    },
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                  minX: 0, maxX: 5, minY: 0, maxY: 16,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 12.5), FlSpot(1, 13.2), FlSpot(2, 13.9),
                        FlSpot(3, 14.1), FlSpot(4, 15.1), FlSpot(5, 15.6),
                      ],
                      isCurved: false, color: const Color(0xFF10B981), barWidth: 3, isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 4, color: const Color(0xFF10B981), strokeWidth: 2, strokeColor: Colors.white,
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
    );
  }

  Widget _construirCartoesLaterais() {
    return Column(
      children: [
        _construirCardAtivo(
          icone: Icons.account_balance, titulo: 'Renda Fixa', subtitulo: 'Tesouro, CDBs',
          valor: 'R\$ 8.500,00', porcentagemGeral: 0.55, rendimento: '+5.2%', cor: Colors.blueAccent,
        ),
        const SizedBox(height: 16),
        _construirCardAtivo(
          icone: Icons.trending_up, titulo: 'Renda Variável', subtitulo: 'ETFs, Ações',
          valor: 'R\$ 6.900,00', porcentagemGeral: 0.45, rendimento: '+12.8%', cor: Colors.purpleAccent,
        ),
      ],
    );
  }

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