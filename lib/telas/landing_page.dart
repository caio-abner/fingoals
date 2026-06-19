import 'package:flutter/material.dart';
import 'login.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. NAVBAR (Barra de Navegação no Topo)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.track_changes, color: Color(0xFF10B981), size: 32),
                      SizedBox(width: 12),
                      Text('FinGoals', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _fazerLogin(context),
                    child: const Text('Entrar', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 60),

            // 2. HERO SECTION (Seção Principal de Chamada)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              constraints: const BoxConstraints(maxWidth: 800), // Limita a largura para telas muito grandes (Web)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Etiqueta (Badge)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F8F3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'A sua nova vida financeira começa aqui',
                      style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Título Gigante
                  const Text(
                    'Controle seus gastos, defina metas e invista com inteligência.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, height: 1.2, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  
                  // Subtítulo
                  const Text(
                    'O FinGoals reúne tudo que você precisa para alcançar sua independência financeira em um único dashboard intuitivo e multiplataforma.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 48),
                  
                  // Botão Principal (Call to Action)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () => _fazerLogin(context),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Acessar meu Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // 3. IMAGEM/MOCKUP DO APLICATIVO
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 15))
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.dashboard_rounded, size: 80, color: Color(0xFF10B981)),
                        const SizedBox(height: 16),
                        Text('Dashboard do FinGoals', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 24)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // Função que faz o redirecionamento seguro para a área logada
  void _fazerLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaLogin()),
    );
  }
}