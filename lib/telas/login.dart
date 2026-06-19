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
      usuarios = {'caio@gmail.com': {'nome': 'Caio', 'senha': '123'}};
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
                const Icon(Icons.track_changes, color: Color(0xFF10B981), size: 64),
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
                const SizedBox(height: 32),
                
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