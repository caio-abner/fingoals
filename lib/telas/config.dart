import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaConfiguracoes extends StatefulWidget {
  // A tela recebe os dados da mãe perfeitamente!
  final String nome;
  final String email;
  final String? fotoBase64;
  final Function(String, String, String?) onAtualizarPerfil;

  const TelaConfiguracoes({
    super.key,
    required this.nome,
    required this.email,
    this.fotoBase64,
    required this.onAtualizarPerfil,
  });

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  bool _modoEscuroAtivo = false; 

  // --- LÓGICA 1: Formulário de Edição de Perfil ---
  void _abrirModalEdicaoPerfil(BuildContext context) {
    final TextEditingController nomeController = TextEditingController(text: widget.nome);
    final TextEditingController emailController = TextEditingController(text: widget.email);
    String? novaFotoBase64 = widget.fotoBase64;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            
            Future<void> selecionarFoto() async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              
              if (image != null) {
                final bytes = await image.readAsBytes();
                setModalState(() {
                  novaFotoBase64 = base64Encode(bytes);
                });
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24, right: 24, top: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Editar Perfil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  GestureDetector(
                    onTap: selecionarFoto,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: novaFotoBase64 != null ? MemoryImage(base64Decode(novaFotoBase64!)) : null,
                          child: novaFotoBase64 == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Seu Nome', prefixIcon: Icon(Icons.person_outline)),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Endereço de E-mail', prefixIcon: Icon(Icons.email_outlined)),
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        if (nomeController.text.isNotEmpty && emailController.text.isNotEmpty) {
                          widget.onAtualizarPerfil(nomeController.text, emailController.text, novaFotoBase64);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Salvar Alterações', style: TextStyle(fontWeight: FontWeight.bold)),
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

  // --- LÓGICA 2: Simulação de Exportação de Dados ---
  void _simularExportacao(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: Color(0xFF10B981)),
              SizedBox(width: 24),
              Expanded(child: Text('A compilar os seus dados num ficheiro CSV...', style: TextStyle(fontWeight: FontWeight.w500))),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Relatório exportado e guardado nas suas Transferências!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(24),
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

  // --- POP-UPS: Logout, Termos e Privacidade ---
  void _confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Sair da Conta', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Tem certeza que deseja sair? Você precisará fazer login novamente para acessar seu dashboard.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
            TextButton(
              onPressed: () async {
                // A MÁGICA DO LOGOUT: Avisamos o banco que a sessão acabou!
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('is_logged_in', false);

                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LandingPage()), 
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: const Text('Sair', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarTermos(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Termos de Uso', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const SingleChildScrollView(
          child: Text('Bem-vindo ao FinGoals!\n\nEstes Termos de Uso regulamentam o acesso e a utilização do nosso aplicativo. Ao utilizar o FinGoals, você concorda que o app é uma ferramenta de auxílio para gestão financeira pessoal.\n\nNão somos uma instituição financeira e não nos responsabilizamos por investimentos ou decisões tomadas com base nos dados aqui inseridos. Use com responsabilidade e alcance seus objetivos financeiros!', style: TextStyle(height: 1.4)),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)))],
      ),
    );
  }

  void _mostrarPrivacidade(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Política de Privacidade', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const SingleChildScrollView(
          child: Text('Sua privacidade é nossa prioridade.\n\nO FinGoals foi desenvolvido com foco na total segurança dos seus dados. Para garantir sua privacidade, todas as informações de metas, orçamento e perfil são salvas exclusivamente de forma local no seu próprio dispositivo.\n\nNós não coletamos, não processamos em servidores externos e não compartilhamos suas informações financeiras com terceiros.', style: TextStyle(height: 1.4)),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)))],
      ),
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
            const Text('Configurações da Conta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Gerencie suas preferências e configurações', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 40),

            // BOTÃO EDITAR PERFIL
            InkWell(
              onTap: () => _abrirModalEdicaoPerfil(context),
              borderRadius: BorderRadius.circular(12),
              child: _construirCardConfiguracao(
                icone: Icons.person_outline, corIcone: const Color(0xFF10B981), corFundoIcone: const Color(0xFFE6F8F3),
                titulo: 'Editar Perfil', subtitulo: 'Atualize suas informações pessoais e foto de perfil', trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            
            _construirCardConfiguracao(
              icone: Icons.notifications_none, corIcone: const Color(0xFF10B981), corFundoIcone: const Color(0xFFE6F8F3),
              titulo: 'Notificações', subtitulo: 'Gerencie suas preferências de notificações', trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            _construirCardConfiguracao(
              icone: Icons.dark_mode_outlined, corIcone: Colors.deepPurpleAccent, corFundoIcone: Colors.deepPurple.shade50,
              titulo: 'Modo Escuro', subtitulo: 'Alterne entre tema claro e escuro',
              trailing: Switch(
                value: _modoEscuroAtivo,
                activeColor: Colors.deepPurpleAccent,
                onChanged: (bool valor) {
                  setState(() { _modoEscuroAtivo = valor; });
                },
              ),
            ),
            const SizedBox(height: 16),

            _construirCardConfiguracao(
              icone: Icons.shield_outlined, corIcone: const Color(0xFF10B981), corFundoIcone: const Color(0xFFE6F8F3),
              titulo: 'Segurança', subtitulo: 'Altere sua senha e configure autenticação', trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // BOTÃO EXPORTAR DADOS
            InkWell(
              onTap: () => _simularExportacao(context),
              borderRadius: BorderRadius.circular(12),
              child: _construirCardConfiguracao(
                icone: Icons.file_download_outlined, corIcone: Colors.blueAccent, corFundoIcone: Colors.blue.shade50,
                titulo: 'Exportar Dados', subtitulo: 'Descarregue o seu histórico em formato CSV', trailing: const Icon(Icons.download, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 60),

            Row(
              children: [
                TextButton(
                  onPressed: () => _mostrarTermos(context),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                  child: const Text('Termos de Uso', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
                const Text('  ·  ', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () => _mostrarPrivacidade(context),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                  child: const Text('Política de Privacidade', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
                const Text('  ·  ', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () => _confirmarLogout(context), 
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                  child: const Text('Sair da Conta', style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Versão 1.0.0 • © 2026 Financial Goals Tracker', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _construirCardConfiguracao({
    required IconData icone, required Color corIcone, required Color corFundoIcone,
    required String titulo, required String subtitulo, required Widget trailing,
  }) {
    return Card(
      color: Colors.white, elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: corFundoIcone, borderRadius: BorderRadius.circular(10)),
            child: Icon(icone, color: corIcone),
          ),
          title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          subtitle: Text(subtitulo, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          trailing: trailing,
        ),
      ),
    );
  }
}