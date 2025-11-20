import 'package:flutter/material.dart';
import 'telas/login_tela.dart';
import 'telas/cardapio_tela.dart';
import 'telas/carrinho_tela.dart';
import 'telas/admin_tela.dart';
import 'telas/login_admin_tela.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hamburgueria Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginTela(),
        '/cardapio': (context) => const CardapioTela(),
        '/carrinho': (context) => const CarrinhoTela(),
        '/admin': (context) => const AdminTela(),
        '/login-admin': (context) => const LoginAdminTela(),
      },
    );
  }
}