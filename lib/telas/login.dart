import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'cadastro.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _carregando = false;

  Future<void> _realizarLogin() async {
    setState(() => _carregando = true);
    final prefs = await SharedPreferences.getInstance();
    
    // Puxa os usuários do banco (se não existir, injetamos a sua conta Caio por padrão!)
    String? usersJson = prefs.getString('auth_users');
    Map<String, dynamic> usuarios = {};
    
    if (usersJson != null) {
      usuarios = jsonDecode(usersJson);
    } else {
      usuarios = {'caio_abner@usp.br': {'nome': 'Caio', 'senha': '1234'}};
      await prefs.setString('auth_users', jsonEncode(usuarios));
    }

    String email = _emailController.text.trim();
    String senha = _senhaController.text;

    // LÓGICA DE VALIDAÇÃO
    if (usuarios.containsKey(email) && usuarios[email]['senha'] == senha) {
      // Deu certo! Salvamos a sessão
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('perfil_email', email);
      await prefs.setString('perfil_nome', usuarios[email]['nome']);
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NavegacaoPrincipal()),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      // Errou a senha ou email
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail ou senha incorretos!'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  // --- LÓGICA: ESQUECI A SENHA COM FALSO 2FA ---
  void _abrirEsqueciSenha(BuildContext context) {
    final TextEditingController emailRecuperacaoController = TextEditingController();
    final TextEditingController codigoController = TextEditingController();
    final TextEditingController novaSenhaController = TextEditingController();
    
    int etapa = 0; // 0 = Pede E-mail | 1 = Pede Código 2FA | 2 = Pede Nova Senha
    String mensagemErro = '';
    String emailSalvo = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Recuperar Senha', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (mensagemErro.isNotEmpty) ...[
                      Text(mensagemErro, style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                    ],

                    // ETAPA 0: Pedir o E-mail
                    if (etapa == 0) ...[
                      const Text('Digite o seu e-mail para recuperar a conta.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailRecuperacaoController,
                        decoration: InputDecoration(labelText: 'E-mail', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ],

                    // ETAPA 1: O Falso 2FA (Código SMS) - TEXTO EM PT-BR!
                    if (etapa == 1) ...[
                      const Text('Como você tem a Autenticação 2FA ativa, enviamos um código para o seu celular. (Dica: digite qualquer código de 4 dígitos)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: codigoController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(labelText: 'Código de 4 dígitos', prefixIcon: const Icon(Icons.message_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ],

                    // ETAPA 2: Redefinir a Senha
                    if (etapa == 2) ...[
                      const Text('Código validado! Crie a sua nova senha abaixo.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: novaSenhaController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Nova Senha', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                  onPressed: () async {
                    setStateDialog(() => mensagemErro = '');
                    final prefs = await SharedPreferences.getInstance();
                    
                    // A CORREÇÃO ESTÁ AQUI: Injetamos o banco antes de checar o e-mail!
                    String? usersJson = prefs.getString('auth_users');
                    Map<String, dynamic> usuarios = {};
                    
                    if (usersJson != null) {
                      usuarios = jsonDecode(usersJson);
                    } else {
                      usuarios = {'caio_abner@usp.br': {'nome': 'Caio', 'senha': '1234'}};
                      await prefs.setString('auth_users', jsonEncode(usuarios));
                    }

                    // AÇÃO DA ETAPA 0
                    if (etapa == 0) {
                      emailSalvo = emailRecuperacaoController.text.trim();
                      if (emailSalvo.isEmpty) {
                        setStateDialog(() => mensagemErro = 'Preencha o e-mail.');
                        return;
                      }
                      if (usuarios.containsKey(emailSalvo)) {
                        // Verifica se tem 2FA ativo (se tem número guardado)
                        if (usuarios[emailSalvo].containsKey('telefone')) {
                          setStateDialog(() => etapa = 1); // Tem 2FA, vai pedir o código!
                        } else {
                          // Não tem 2FA, simula o envio de e-mail e fecha
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Um link de recuperação foi enviado para o seu e-mail!'), backgroundColor: Color(0xFF10B981)));
                        }
                      } else {
                        setStateDialog(() => mensagemErro = 'E-mail não encontrado.');
                      }
                    }
                    
                    // AÇÃO DA ETAPA 1
                    else if (etapa == 1) {
                      if (codigoController.text.length == 4) {
                        setStateDialog(() => etapa = 2); // Código aceito!
                      } else {
                        setStateDialog(() => mensagemErro = 'O código deve ter 4 dígitos.');
                      }
                    }

                    // AÇÃO DA ETAPA 2
                    else if (etapa == 2) {
                      if (novaSenhaController.text.isNotEmpty) {
                        usuarios[emailSalvo]['senha'] = novaSenhaController.text;
                        await prefs.setString('auth_users', jsonEncode(usuarios));
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha redefinida com sucesso! Você já pode entrar.'), backgroundColor: Color(0xFF10B981)));
                        }
                      } else {
                        setStateDialog(() => mensagemErro = 'Digite uma senha válida.');
                      }
                    }
                  },
                  child: Text(etapa == 2 ? 'Salvar Senha' : 'Continuar', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black87)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.gps_fixed, color: Color(0xFF10B981), size: 64),
                const SizedBox(height: 24),
                const Text('Bem-vindo de volta!', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Acesse sua conta para continuar', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 48),
                
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'E-mail', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Senha', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                
                // O NOSSO NOVO BOTÃO DE ESQUECI A SENHA
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _abrirEsqueciSenha(context),
                    child: const Text('Esqueci a minha senha', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                  ),
                ),
                
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _carregando ? null : _realizarLogin,
                  child: _carregando 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
                
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaCadastro())),
                  child: const Text('Ainda não tem conta? Cadastre-se', style: TextStyle(color: Color(0xFF10B981))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}