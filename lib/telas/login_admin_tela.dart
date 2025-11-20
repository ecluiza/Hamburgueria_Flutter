import 'package:flutter/material.dart';
import '../servico/hamburguer_service.dart';

class LoginAdminTela extends StatefulWidget {
  const LoginAdminTela({super.key});

  @override
  State<LoginAdminTela> createState() => _LoginAdminTelaState();
}

class _LoginAdminTelaState extends State<LoginAdminTela> {
  final _senhaController = TextEditingController();
  final _service = HamburguerService();
  bool _carregando = false;
  bool _senhaVisivel = false;

  void _validarAcesso() async {
    setState(() => _carregando = true);

    bool sucesso = await _service.loginAdmin(_senhaController.text);

    setState(() => _carregando = false);

    if (sucesso && mounted) {
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Acesso Negado. Verifique suas credenciais."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Acesso Restrito"),
        backgroundColor: Colors.red[800], 
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.security, size: 64, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  "Área Gerencial",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _senhaController,
                  obscureText: !_senhaVisivel,
                  decoration: InputDecoration(
                    labelText: "Senha de Administrador",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_senhaVisivel ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _carregando ? null : _validarAcesso,
                    child: _carregando 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("ACESSAR SISTEMA"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}