import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaOrcamento extends StatefulWidget {
  const TelaOrcamento({super.key});

  @override
  State<TelaOrcamento> createState() => _TelaOrcamentoState();
}

class _TelaOrcamentoState extends State<TelaOrcamento> {
  bool _carregando = true;
  double _orcamentoTotal = 3000.0;
  List<Map<String, dynamic>> _categorias = [];

  final List<IconData> _opcoesIcones = [
    Icons.restaurant, Icons.directions_car, Icons.shopping_cart, 
    Icons.local_hospital, Icons.movie, Icons.receipt, 
    Icons.fitness_center, Icons.pets, Icons.school, Icons.home,
  ];

  final List<Color> _opcoesCores = [
    Colors.redAccent, Colors.blueAccent, Colors.orange, 
    Colors.purpleAccent, Colors.teal, Colors.pinkAccent,
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('perfil_email') ?? 'default';
    
    _orcamentoTotal = prefs.getDouble('orcamento_total_$email') ?? 3000.0;
    String? categoriasJson = prefs.getString('orcamento_cat_$email');

    if (categoriasJson != null) {
      List<dynamic> decodificado = jsonDecode(categoriasJson);
      _categorias = decodificado.map((item) => {
        'titulo': item['titulo'],
        'icone': _opcoesIcones.firstWhere(
          (iconeConstante) => iconeConstante.codePoint == (item['icone'] as int),
          orElse: () => Icons.restaurant,
        ),
        'cor': Color(item['cor'] as int),
        'gasto': item['gasto'],
        'limite': item['limite'],
      }).toList();
    } else {
      _categorias = [
        {'titulo': 'Alimentação', 'icone': Icons.restaurant, 'cor': Colors.redAccent, 'gasto': 600.0, 'limite': 800.0},
        {'titulo': 'Transporte', 'icone': Icons.directions_car, 'cor': Colors.blueAccent, 'gasto': 200.0, 'limite': 400.0},
      ];
      _salvarDados();
    }
    setState(() => _carregando = false);
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('perfil_email') ?? 'default';
    
    await prefs.setDouble('orcamento_total_$email', _orcamentoTotal);
    
    List<Map<String, dynamic>> paraSalvar = _categorias.map((item) => {
      'titulo': item['titulo'],
      'icone': item['icone'].codePoint,
      'cor': item['cor'].value,
      'gasto': item['gasto'],
      'limite': item['limite'],
    }).toList();
    
    await prefs.setString('orcamento_cat_$email', jsonEncode(paraSalvar));
  }

  void _abrirModalEditarOrcamento(BuildContext context) {
    final TextEditingController valorController = TextEditingController(text: _orcamentoTotal.toStringAsFixed(2).replaceAll('.', ','));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Orçamento do Mês', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Defina o valor total disponível que você tem para gastar este mês.', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 16),
              TextField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Valor Total (R\$)', prefixIcon: const Icon(Icons.attach_money), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
              onPressed: () {
                double? novoValor = double.tryParse(valorController.text.replaceAll(',', '.'));
                if (novoValor != null && novoValor > 0) {
                  setState(() => _orcamentoTotal = novoValor);
                  _salvarDados();
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }
    );
  }

  void _abrirModalNovaCategoria(BuildContext context) {
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController limiteController = TextEditingController();
    IconData iconeSelecionado = _opcoesIcones[0];

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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nova Categoria', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Nome da Categoria (ex: Saúde)')),
                  const SizedBox(height: 16),
                  TextField(controller: limiteController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Limite Mensal (R\$)')),
                  const SizedBox(height: 24),
                  const Text('Escolha um ícone:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12, runSpacing: 12,
                    children: _opcoesIcones.map((icone) {
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
                        if (tituloController.text.isNotEmpty && limiteController.text.isNotEmpty) {
                          double? limite = double.tryParse(limiteController.text.replaceAll(',', '.'));
                          if (limite != null && limite > 0) {
                            setState(() {
                              _categorias.add({
                                'titulo': tituloController.text,
                                'icone': iconeSelecionado,
                                'cor': _opcoesCores[_categorias.length % _opcoesCores.length],
                                'gasto': 0.0,
                                'limite': limite,
                              });
                            });
                            _salvarDados();
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('Criar Categoria', style: TextStyle(fontWeight: FontWeight.bold)),
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

  // --- NOVA LÓGICA: EDITAR / EXCLUIR CATEGORIA ---
  void _abrirModalEditarCategoria(BuildContext context, int index) {
    final categoria = _categorias[index];
    final TextEditingController tituloController = TextEditingController(text: categoria['titulo']);
    final TextEditingController limiteController = TextEditingController(text: categoria['limite'].toStringAsFixed(2).replaceAll('.', ','));
    IconData iconeSelecionado = categoria['icone'];

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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Editar Categoria', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          setState(() { _categorias.removeAt(index); });
                          _salvarDados();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Categoria excluída!'), backgroundColor: Colors.redAccent));
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Nome da Categoria')),
                  const SizedBox(height: 16),
                  TextField(controller: limiteController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Limite Mensal (R\$)')),
                  const SizedBox(height: 24),
                  const Text('Escolha um ícone:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12, runSpacing: 12,
                    children: _opcoesIcones.map((icone) {
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
                        if (tituloController.text.isNotEmpty && limiteController.text.isNotEmpty) {
                          double? limite = double.tryParse(limiteController.text.replaceAll(',', '.'));
                          if (limite != null && limite > 0) {
                            setState(() {
                              _categorias[index]['titulo'] = tituloController.text;
                              _categorias[index]['icone'] = iconeSelecionado;
                              _categorias[index]['limite'] = limite;
                            });
                            _salvarDados();
                            Navigator.pop(context);
                          }
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

  void _abrirModalNovoGasto(BuildContext context) {
    if (_categorias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Crie uma categoria primeiro!'), backgroundColor: Colors.redAccent));
      return;
    }

    final TextEditingController valorController = TextEditingController();
    String categoriaSelecionada = _categorias[0]['titulo'];
    String mensagemErro = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Adicionar Gasto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  if (mensagemErro.isNotEmpty) ...[
                    Text(mensagemErro, style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                  ],

                  const Text('Categoria', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(12)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: categoriaSelecionada,
                        isExpanded: true,
                        items: _categorias.map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat['titulo'],
                            child: Row(children: [Icon(cat['icone'], color: cat['cor'], size: 20), const SizedBox(width: 12), Text(cat['titulo'])]),
                          );
                        }).toList(),
                        onChanged: (String? novoValor) {
                          if (novoValor != null) setModalState(() => categoriaSelecionada = novoValor);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: valorController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Valor do Gasto (R\$)', prefixIcon: const Icon(Icons.attach_money), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        double? valorDigitado = double.tryParse(valorController.text.replaceAll(',', '.'));
                        if (valorDigitado == null || valorDigitado <= 0) {
                          setModalState(() => mensagemErro = 'Digite um valor válido.');
                          return;
                        }

                        setState(() {
                          int index = _categorias.indexWhere((c) => c['titulo'] == categoriaSelecionada);
                          if (index != -1) _categorias[index]['gasto'] += valorDigitado;
                        });

                        _salvarDados();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gasto registrado com sucesso!'), backgroundColor: Color(0xFF10B981)));
                      },
                      child: const Text('Registrar Gasto', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));

    double gastoTotal = _categorias.fold(0, (soma, item) => soma + item['gasto']);
    double disponivel = _orcamentoTotal - gastoTotal;
    double progressoGeral = _orcamentoTotal > 0 ? (gastoTotal / _orcamentoTotal) : 0;

    const meses = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
    String mesAtual = meses[DateTime.now().month - 1];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Orçamento', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Acompanhe seus limites e controle seus gastos', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 40),

            Card(
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
                        Text('Resumo de $mesAtual', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                          onPressed: () => _abrirModalEditarOrcamento(context),
                          tooltip: 'Editar Orçamento Total',
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Disponível para gastar', style: TextStyle(color: Colors.grey)),
                    Text(
                      disponivel >= 0 ? 'R\$ ${disponivel.toStringAsFixed(2)}' : '- R\$ ${disponivel.abs().toStringAsFixed(2)}', 
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: disponivel >= 0 ? const Color(0xFF10B981) : Colors.redAccent)
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: progressoGeral > 1.0 ? 1.0 : progressoGeral,
                      backgroundColor: Colors.grey[100],
                      color: progressoGeral >= 1.0 ? Colors.redAccent : const Color(0xFF10B981),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gasto: R\$ ${gastoTotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Orçamento: R\$ ${_orcamentoTotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Categorias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => _abrirModalNovaCategoria(context),
                  child: const Text('+ Nova Categoria', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Agora passamos o índice (index) para cada categoria
            ..._categorias.asMap().entries.map((entry) {
              int index = entry.key;
              var categoria = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _construirCategoria(
                  index: index,
                  icone: categoria['icone'],
                  corOriginal: categoria['cor'],
                  titulo: categoria['titulo'],
                  gasto: categoria['gasto'],
                  limite: categoria['limite'],
                ),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirModalNovoGasto(context),
        backgroundColor: const Color(0xFF10B981),
        elevation: 2,
        tooltip: 'Adicionar Gasto',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _construirCategoria({
    required int index, required IconData icone, required Color corOriginal, 
    required String titulo, required double gasto, required double limite
  }) {
    double progresso = limite > 0 ? (gasto / limite) : 0;
    int porcentagem = (progresso * 100).toInt();
    Color corBarra = progresso >= 1.0 ? Colors.redAccent : corOriginal;

    // A mágica: Envolvemos o Card em um InkWell para deixá-lo clicável!
    return InkWell(
      onTap: () => _abrirModalEditarCategoria(context, index),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: Colors.white, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 0),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: corOriginal.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icone, color: corOriginal),
              ),
              title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('R\$ ${gasto.toStringAsFixed(2)} / R\$ ${limite.toStringAsFixed(2)}'),
              trailing: Text('$porcentagem%', style: TextStyle(fontWeight: FontWeight.bold, color: corBarra, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 8),
              child: LinearProgressIndicator(
                value: progresso > 1.0 ? 1.0 : progresso,
                backgroundColor: Colors.grey.shade100,
                color: corBarra,
                minHeight: 4,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }
}