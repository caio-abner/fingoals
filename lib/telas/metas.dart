import 'package:flutter/material.dart';

class TelaMetas extends StatefulWidget {
  final List<Map<String, dynamic>> metas;
  final Function(Map<String, dynamic>) onAdicionar;
  final Function(int) onRemover;

  const TelaMetas({
    super.key, 
    required this.metas, 
    required this.onAdicionar, 
    required this.onRemover,
  });

  @override
  State<TelaMetas> createState() => _TelaMetasState();
}

class _TelaMetasState extends State<TelaMetas> {
  // A lista _metas sumiu daqui! Agora usamos widget.metas

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _valorObjetivoController = TextEditingController();

  void _abrirFormularioNovaMeta(BuildContext context) {
    final List<IconData> opcoesIcones = [
      Icons.star, Icons.flight_takeoff, Icons.directions_car, 
      Icons.home, Icons.laptop_mac, Icons.school, 
      Icons.favorite, Icons.fitness_center, Icons.videogame_asset,
    ];
    
    IconData iconeSelecionado = opcoesIcones[0]; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        // 2. StatefulBuilder permite que o modal mude visualmente ao clicarmos nos ícones
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24, right: 24, top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nova Meta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _tituloController,
                    decoration: const InputDecoration(labelText: 'Qual o seu objetivo? (Ex: Carro Novo)'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _valorObjetivoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Valor da Meta (R\$)'),
                  ),
                  const SizedBox(height: 24),
                  
                  // 3. A GALERIA DE ÍCONES
                  const Text('Escolha um ícone:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Wrap( // O Wrap quebra a linha automaticamente se faltar espaço
                    spacing: 12,
                    runSpacing: 12,
                    children: opcoesIcones.map((icone) {
                      bool isSelected = iconeSelecionado == icone;
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // setModalState atualiza a tela do formulário para piscar a nova cor
                          setModalState(() {
                            iconeSelecionado = icone;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF10B981).withOpacity(0.2) : Colors.grey.shade100,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icone, 
                            color: isSelected ? const Color(0xFF10B981) : Colors.grey.shade600,
                          ),
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
                        if (_tituloController.text.isNotEmpty && _valorObjetivoController.text.isNotEmpty) {
                          // A MUDANÇA É AQUI: Chamamos widget.onAdicionar!
                          widget.onAdicionar({
                            'titulo': _tituloController.text,
                            'valorAtual': 0.0,
                            'valorObjetivo': double.tryParse(_valorObjetivoController.text) ?? 1000.0,
                            'icone': iconeSelecionado,
                            'cor': const Color(0xFF10B981), // Mantendo verdinho padrão, ou a cor que preferir
                          });
                          _tituloController.clear();
                          _valorObjetivoController.clear();
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
          content: const Text('Tem certeza que deseja remover esta meta? Essa ação não pode ser desfeita.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                // AQUI ESTÁ A CORREÇÃO! Usamos a função que veio do main.dart
                widget.onRemover(index); 
                Navigator.of(context).pop();
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Minhas Metas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Acompanhe o progresso dos seus objetivos financeiros', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 40),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 24, mainAxisSpacing: 24, childAspectRatio: 1.4,
              ),
              // Lemos a lista que veio por parâmetro!
              itemCount: widget.metas.length, 
              itemBuilder: (context, index) {
                final meta = widget.metas[index]; // Lemos da widget.metas
                return _construirCaixinhaMeta(
                  context: context,
                  index: index, 
                  titulo: meta['titulo'],
                  valorAtual: meta['valorAtual'],
                  valorObjetivo: meta['valorObjetivo'],
                  icone: meta['icone'],
                  corDestaque: meta['cor'],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormularioNovaMeta(context),
        backgroundColor: const Color(0xFF10B981),
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _construirCaixinhaMeta({
    required BuildContext context, required int index, required String titulo, 
    required double valorAtual, required double valorObjetivo, 
    required IconData icone, required Color corDestaque,
  }) {
    double progresso = valorObjetivo > 0 ? (valorAtual / valorObjetivo) : 0;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: corDestaque.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icone, size: 28, color: corDestaque),
                ),
                const SizedBox(height: 16),
                Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                LinearProgressIndicator(value: progresso, backgroundColor: Colors.grey[100], color: corDestaque, minHeight: 8, borderRadius: BorderRadius.circular(10)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('R\$ ${(valorAtual / 1000).toStringAsFixed(1)}k', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('R\$ ${(valorObjetivo / 1000).toStringAsFixed(1)}k', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          
          Positioned(
            top: 8, right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey, size: 18),
              onPressed: () => _confirmarRemocao(context, index),
              tooltip: 'Remover Meta',
            ),
          ),
        ],
      ),
    );
  }
}