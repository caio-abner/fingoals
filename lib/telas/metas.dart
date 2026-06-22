import 'package:flutter/material.dart';

class TelaMetas extends StatefulWidget {
  final List<Map<String, dynamic>> metas;
  final Function(Map<String, dynamic>) onAdicionar;
  final Function(int) onRemover;
  final Function(int, Map<String, dynamic>) onEditar; 

  const TelaMetas({
    super.key, 
    required this.metas, 
    required this.onAdicionar, 
    required this.onRemover,
    required this.onEditar,
  });

  @override
  State<TelaMetas> createState() => _TelaMetasState();
}

class _TelaMetasState extends State<TelaMetas> {
  final List<IconData> opcoesIcones = [
    Icons.star, Icons.flight_takeoff, Icons.directions_car, 
    Icons.home, Icons.laptop_mac, Icons.school, 
    Icons.favorite, Icons.fitness_center, Icons.videogame_asset,
  ];

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

  void _abrirFormularioNovaMeta(BuildContext context) {
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController valorObjetivoController = TextEditingController();
    IconData iconeSelecionado = opcoesIcones[0]; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nova Meta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Qual o seu objetivo? (Ex: Carro Novo)')),
                  const SizedBox(height: 16),
                  TextField(controller: valorObjetivoController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Valor da Meta (R\$)')),
                  const SizedBox(height: 24),
                  const Text('Escolha um ícone:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12, runSpacing: 12,
                    children: opcoesIcones.map((icone) {
                      bool isSelected = iconeSelecionado == icone;
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setModalState(() => iconeSelecionado = icone),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF10B981).withOpacity(0.2) : Colors.grey.shade100,
                            border: Border.all(color: isSelected ? const Color(0xFF10B981) : Colors.transparent, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icone, color: isSelected ? const Color(0xFF10B981) : Colors.grey.shade600),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: () {
                        if (tituloController.text.isNotEmpty && valorObjetivoController.text.isNotEmpty) {
                          widget.onAdicionar({'titulo': tituloController.text, 'valorAtual': 0.0, 'valorObjetivo': double.tryParse(valorObjetivoController.text.replaceAll(',', '.')) ?? 1000.0, 'icone': iconeSelecionado, 'cor': const Color(0xFF10B981)});
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Salvar Meta', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _abrirFormularioEditarMeta(BuildContext context, int index, Map<String, dynamic> metaAtual) {
    final TextEditingController tituloController = TextEditingController(text: metaAtual['titulo']);
    final TextEditingController valorObjetivoController = TextEditingController(text: metaAtual['valorObjetivo'].toStringAsFixed(2).replaceAll('.', ','));
    final TextEditingController valorAtualController = TextEditingController(text: metaAtual['valorAtual'].toStringAsFixed(2).replaceAll('.', ','));
    IconData iconeSelecionado = metaAtual['icone']; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Editar Meta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Qual o seu objetivo?')),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: valorAtualController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Já guardado (R\$)'))),
                      const SizedBox(width: 16),
                      Expanded(child: TextField(controller: valorObjetivoController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Valor Total (R\$)'))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Escolha um ícone:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12, runSpacing: 12,
                    children: opcoesIcones.map((icone) {
                      bool isSelected = iconeSelecionado == icone;
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setModalState(() => iconeSelecionado = icone),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF10B981).withOpacity(0.2) : Colors.grey.shade100,
                            border: Border.all(color: isSelected ? const Color(0xFF10B981) : Colors.transparent, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icone, color: isSelected ? const Color(0xFF10B981) : Colors.grey.shade600),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: () {
                        if (tituloController.text.isNotEmpty && valorObjetivoController.text.isNotEmpty) {
                          widget.onEditar(index, {'titulo': tituloController.text, 'valorAtual': double.tryParse(valorAtualController.text.replaceAll(',', '.')) ?? metaAtual['valorAtual'], 'valorObjetivo': double.tryParse(valorObjetivoController.text.replaceAll(',', '.')) ?? metaAtual['valorObjetivo'], 'icone': iconeSelecionado, 'cor': metaAtual['cor']});
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Salvar Alterações', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmarRemocao(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Excluir Meta?', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Tem certeza que deseja excluir esta meta? Essa ação não pode ser desfeita.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
            TextButton(onPressed: () { widget.onRemover(index); Navigator.of(context).pop(); }, child: const Text('Excluir', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
          ],
        );
      },
    );
  }

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
            const Text('Minhas Metas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Acompanhe o progresso dos seus objetivos financeiros', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 40),

            if (widget.metas.isEmpty) // CORRIGIDO AQUI
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Nenhuma meta cadastrada ainda.', style: TextStyle(color: Colors.grey)),
              )
            else
              isMobile
              ? ListView.builder( 
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.metas.length, // CORRIGIDO AQUI
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _construirCaixinhaMeta(context: context, index: index, meta: widget.metas[index]), // CORRIGIDO AQUI
                    );
                  },
                )
              : GridView.builder( 
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 24, 
                    mainAxisSpacing: 24, 
                    childAspectRatio: 1.4
                  ),
                  itemCount: widget.metas.length, // CORRIGIDO AQUI
                  itemBuilder: (context, index) {
                    return _construirCaixinhaMeta(context: context, index: index, meta: widget.metas[index]); // CORRIGIDO AQUI
                  },
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormularioNovaMeta(context),
        backgroundColor: const Color(0xFF10B981), elevation: 2, child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _construirCaixinhaMeta({required BuildContext context, required int index, required Map<String, dynamic> meta}) {
    String titulo = meta['titulo'];
    double valorAtual = meta['valorAtual'];
    double valorObjetivo = meta['valorObjetivo'];
    IconData icone = meta['icone'];
    Color corDestaque = meta['cor'];
    
    double progresso = valorObjetivo > 0 ? (valorAtual / valorObjetivo) : 0;

    return Card(
      color: Colors.white, elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: corDestaque.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icone, size: 28, color: corDestaque)),
                const SizedBox(height: 16),
                Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                LinearProgressIndicator(value: progresso, backgroundColor: Colors.grey[100], color: corDestaque, minHeight: 8, borderRadius: BorderRadius.circular(10)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(_formatarMoeda(valorAtual), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_formatarMoeda(valorObjetivo), style: const TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.right, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(top: 8, right: 40, child: IconButton(icon: const Icon(Icons.edit, color: Colors.grey, size: 18), onPressed: () => _abrirFormularioEditarMeta(context, index, meta), tooltip: 'Editar Meta')),
          Positioned(top: 8, right: 8, child: IconButton(icon: const Icon(Icons.close, color: Colors.grey, size: 18), onPressed: () => _confirmarRemocao(context, index), tooltip: 'Excluir Meta')),
        ],
      ),
    );
  }
}