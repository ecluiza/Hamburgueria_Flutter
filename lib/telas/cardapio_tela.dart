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

  Widget _construirGrid(List<Hamburguer> lista) {
    if (lista.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
            const Text("Nenhum item nesta categoria"),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, 
        childAspectRatio: 0.9, 
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final item = lista[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    item.imagem,
                    fit: BoxFit.cover,
                    errorBuilder: (_,__,___) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            item.nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "R\$ ${item.preco.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green[700], 
                              fontWeight: FontWeight.w800,
                              fontSize: 13
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _service.adicionarAoCarrinho(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${item.nome} add!"),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: const Text("Comprar", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Olá,", style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text(_nomeUsuario, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.orange),
                onPressed: () => Navigator.pushNamed(context, '/carrinho'),
              ),
            )
          ],
          bottom: const TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: "Lanches", icon: Icon(Icons.lunch_dining)),
              Tab(text: "Bebidas", icon: Icon(Icons.local_drink)),
              Tab(text: "Extras", icon: Icon(Icons.fastfood)),
            ],
          ),
        ),
        body: FutureBuilder<List<Hamburguer>>(
          future: _cardapioFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.orange));
            } else if (snapshot.hasError) {
              return Center(child: Text("Erro: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Cardápio Vazio"));
            }

            final todosItens = snapshot.data!;

            final lanches = todosItens.where((i) => i.categoria == 'lanche').toList();
            final bebidas = todosItens.where((i) => i.categoria == 'bebida').toList();
            final extras = todosItens.where((i) => i.categoria == 'acompanhamento').toList();


            if (lanches.isEmpty && bebidas.isEmpty && extras.isEmpty) {
                lanches.addAll(todosItens); 
            }

            return TabBarView(
              children: [
                _construirGrid(lanches), 
                _construirGrid(bebidas), 
                _construirGrid(extras),  
              ],
            );
          },
        ),
      ),
    );
  }
}