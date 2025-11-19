import 'package:flutter/material.dart';
import '../modelo/hamburguer.dart';
import '../servico/hamburguer_service.dart';

class CardapioTela extends StatefulWidget {
  const CardapioTela({super.key});

  @override
  State<CardapioTela> createState() => _CardapioTelaState();
}

class _CardapioTelaState extends State<CardapioTela> {
  final _service = HamburguerService();
  late Future<List<Hamburguer>> _cardapioFuture;
  String _nomeUsuario = "";

  @override
  void initState() {
    super.initState();
    _cardapioFuture = _service.buscarCardapio();
    _carregarUsuario();
  }

  void _carregarUsuario() async {
    String? nome = await _service.lerUsuario();
    setState(() {
      _nomeUsuario = nome ?? "Cliente";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá, $_nomeUsuario"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/carrinho');
            },
          )
        ],
      ),
      body: FutureBuilder<List<Hamburguer>>(
        future: _cardapioFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum item no cardápio"));
          }

          final lista = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];
              return Card(
                elevation: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        item.imagem,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        // Tratamento de erro de imagem
                        errorBuilder: (ctx, obj, trace) => const Icon(Icons.image_not_supported),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text("R\$ ${item.preco.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green)),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () async {
                              await _service.adicionarAoCarrinho(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${item.nome} adicionado!")),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: const Text("Comprar", style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}