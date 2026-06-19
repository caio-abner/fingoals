import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _carregando = false;

  Future<void> _realizarCadastro() async {
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty || _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos!'), backgroundColor: Colors.redAccent));
      return;
    }

    setState(() => _carregando = true);
    final prefs = await SharedPreferences.getInstance();
    
    String? usersJson = prefs.getString('auth_users');
    Map<String, dynamic> usuarios = usersJson != null ? jsonDecode(usersJson) : {};
    
    String email = _emailController.text.trim();

    // Verifica se o e-mail já existe
    if (usuarios.containsKey(email)) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Este e-mail já está em uso!'), backgroundColor: Colors.redAccent));
      }
      return;
    }

    // Salva o novo usuário no banco
    usuarios[email] = {
      'nome': _nomeController.text.trim(),
      'senha': _senhaController.text,
    };
    await prefs.setString('auth_users', jsonEncode(usuarios));

    // Loga automaticamente o usuário recém-criado
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('perfil_email', email);
    await prefs.setString('perfil_nome', _nomeController.text.trim());

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavegacaoPrincipal()),
        (Route<dynamic> route) => false,
      );
    }
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
                const Text('Criar Conta', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Comece a controlar suas finanças hoje', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 48),
                
                TextField(controller: _nomeController, decoration: InputDecoration(labelText: 'Seu Nome', prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                const SizedBox(height: 16),
                
                TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'E-mail', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                const SizedBox(height: 16),
                
                TextField(controller: _senhaController, obscureText: true, decoration: InputDecoration(labelText: 'Senha', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                const SizedBox(height: 32),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _carregando ? null : _realizarCadastro,
                  child: _carregando 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Cadastrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}