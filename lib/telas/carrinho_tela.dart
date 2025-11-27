import 'package:flutter/material.dart';
import '../modelo/hamburguer.dart';
import '../servico/hamburguer_service.dart';

class CarrinhoTela extends StatefulWidget {
  const CarrinhoTela({super.key});

  @override
  State<CarrinhoTela> createState() => _CarrinhoTelaState();
}

class _CarrinhoTelaState extends State<CarrinhoTela> {
  final _service = HamburguerService();
  List<Hamburguer> _itens = [];

  @override
  void initState() {
    super.initState();
    _carregarCarrinho();
  }

  void _carregarCarrinho() async {
    var lista = await _service.lerCarrinho();
    setState(() {
      _itens = lista;
    });
  }

  void _finalizarPedido() async {
    await _service.limparCarrinho();
    setState(() {
      _itens = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Pedido enviado para a cozinha!"),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = _itens.fold(0, (soma, item) => soma + item.preco);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Seu Pedido", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _itens.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text("Seu carrinho está vazio", style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _itens.length,
                    itemBuilder: (context, index) {
                      final item = _itens[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.imagem,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, obj, trace) => Container(
                                width: 60, height: 60, color: Colors.grey[200],
                                child: const Icon(Icons.fastfood, color: Colors.grey),
                              ),
                            ),
                          ),
                          title: Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: const Text("Ingredientes extras..."),
                          trailing: Text(
                            "R\$ ${item.preco.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 15),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_itens.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total do Pedido", style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text("R\$ ${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _finalizarPedido,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text("FINALIZAR COMPRA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}