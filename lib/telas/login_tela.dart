import 'package:flutter/material.dart';
import '../servico/hamburguer_service.dart';

class LoginTela extends StatefulWidget {
  const LoginTela({super.key});

  @override
  State<LoginTela> createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {
  final _controller = TextEditingController();
  final _service = HamburguerService();

  void _entrar() async {
    if (_controller.text.isNotEmpty) {
      await _service.salvarUsuario(_controller.text);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/cardapio');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fastfood, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              "Bem-vindo à Hamburgueria",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Digite seu nome",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _entrar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "ENTRAR",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login-admin');
              },
              child: const Text(
                "Acesso Administrativo",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
