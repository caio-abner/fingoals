import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TelaDashboard extends StatelessWidget {
  final Function(int) aoMudarAba;
  final List<Map<String, dynamic>> metas;

  const TelaDashboard({
    super.key,
    required this.aoMudarAba,
    required this.metas, 
  });

  String _formatarMoeda(double valor) {
    String str = valor.toStringAsFixed(2);
    List<String> partes = str.split('.');
    String inteiros = partes[0];
    String decimais = partes[1];
    String resultado = '';
    for (int i = 0; i < inteiros.length; i++) {
      if (i > 0 && (inteiros.length - i) % 3 == 0) resultado += '.';
      resultado += inteiros[i];
    }
    return 'R\$ $resultado,$decimais';
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bem-vindo de volta!', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 4),
            RichText(
              text: const TextSpan(
                text: 'Saldo Total: ',
                style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: 'R\$ 15.400,00', style: TextStyle(color: Color(0xFF10B981))),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

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
              color: Colors.white, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Gastos do Mês', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: const Text('R\$ 1.570,00', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('Limite', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text('R\$ 2.100,00', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 1570 / 2100,
                      backgroundColor: Colors.grey[100], color: const Color(0xFF10B981),
                      minHeight: 8, borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 8),
                    const Text('75% do orçamento mensal utilizado', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Minhas Metas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Progresso dos principais objetivos', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => aoMudarAba(1),
                  child: const Text('Ver todos ->', style: TextStyle(color: Color(0xFF10B981))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (metas.isEmpty)
              const Padding(padding: EdgeInsets.all(16.0), child: Text('Nenhuma meta cadastrada ainda.', style: TextStyle(color: Colors.grey)))
            else
              isMobile 
              ? Column(
                  children: metas.take(2).map((meta) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _construirCartaoObjetivoFigma(meta),
                    );
                  }).toList(),
                )
              : Row(
                  children: metas.take(2).map((meta) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: meta == metas.take(2).last ? 0 : 16.0),
                        child: _construirCartaoObjetivoFigma(meta),
                      ),
                    );
                  }).toList(),
                ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Meu Portfólio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Distribuição dos seus investimentos', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(onPressed: () => aoMudarAba(3), child: const Text('Ver detalhes ->', style: TextStyle(color: Color(0xFF10B981)))),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                child: isMobile 
                  ? Column( // EMPILHA NO CELULAR
                      children: [
                        _construirGraficoPizza(),
                        const SizedBox(height: 32),
                        _construirDetalhesPortfolio(),
                      ],
                    )
                  : Row( // LADO A LADO NO PC
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 4, child: _construirGraficoPizza()),
                        const SizedBox(width: 48),
                        Expanded(flex: 6, child: _construirDetalhesPortfolio()),
                      ],
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _construirGraficoPizza() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0, centerSpaceRadius: 50, startDegreeOffset: 270, 
              sections: [
                PieChartSectionData(color: const Color(0xFF3B82F6), value: 55, title: '55%', titleStyle: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold, fontSize: 16), radius: 25, titlePositionPercentageOffset: 2.0),
                PieChartSectionData(color: const Color(0xFFA855F7), value: 45, title: '45%', titleStyle: const TextStyle(color: Color(0xFFA855F7), fontWeight: FontWeight.bold, fontSize: 16), radius: 25, titlePositionPercentageOffset: 2.2),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 12, height: 12, color: const Color(0xFF3B82F6)), const SizedBox(width: 6), const Text('Renda Fixa', style: TextStyle(color: Colors.black87, fontSize: 13)),
            const SizedBox(width: 16),
            Container(width: 12, height: 12, color: const Color(0xFFA855F7)), const SizedBox(width: 6), const Text('Renda Variável', style: TextStyle(color: Colors.black87, fontSize: 13)),
          ],
        )
      ],
    );
  }

  Widget _construirDetalhesPortfolio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Valor Total Investido', style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 8),
        const Text('R\$ 15.400,00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        
        Container(
          padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(10))), const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Renda Fixa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text('Tesouro, CDBs', style: TextStyle(color: Colors.grey, fontSize: 12))]),
                ],
              ),
              Flexible(child: const Text('R\$ 8.500,00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.right)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFFAF5FF), borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFA855F7), borderRadius: BorderRadius.circular(10))), const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Renda Variável', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text('ETFs, Ações', style: TextStyle(color: Colors.grey, fontSize: 12))]),
                ],
              ),
              Flexible(child: const Text('R\$ 6.900,00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.right)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirCartaoObjetivoFigma(Map<String, dynamic> meta) {
    double progresso = meta['valorObjetivo'] > 0 ? (meta['valorAtual'] / meta['valorObjetivo']) : 0;
    int porcentagem = (progresso * 100).toInt();
    Color corTema = meta['cor'] ?? const Color(0xFF10B981);

    return Card(
      color: Colors.white, elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(radius: 16, backgroundColor: corTema.withOpacity(0.1), child: Icon(meta['icone'], size: 16, color: corTema)),
                Text('$porcentagem%', style: TextStyle(color: corTema, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text(meta['titulo'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progresso, backgroundColor: Colors.grey[100], color: corTema, minHeight: 6, borderRadius: BorderRadius.circular(10)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Valor atual', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text(_formatarMoeda(meta['valorAtual']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Meta', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text(_formatarMoeda(meta['valorObjetivo']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), overflow: TextOverflow.ellipsis),
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
}