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
        SnackBar(
          content: const Text("Acesso Negado. Credenciais inválidas."),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1577106263724-2c8e03bfe9eb?q=80&w=1000&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.85),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent, width: 2),
                    ),
                    child: const Icon(Icons.security_rounded, size: 50, color: Colors.redAccent),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "ÁREA RESTRITA",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Gestão Administrativa",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _senhaController,
                    obscureText: !_senhaVisivel,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Senha Mestra",
                      labelStyle: const TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white60),
                      suffixIcon: IconButton(
                        icon: Icon(_senhaVisivel ? Icons.visibility : Icons.visibility_off, color: Colors.white60),
                        onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                      ),
                      onPressed: _carregando ? null : _validarAcesso,
                      child: _carregando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "ACESSAR SISTEMA",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Voltar para o Cardápio", style: TextStyle(color: Colors.white38)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}