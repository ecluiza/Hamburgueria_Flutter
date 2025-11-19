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
      const SnackBar(content: Text("Pedido enviado com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = _itens.fold(0, (soma, item) => soma + item.preco);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seu Carrinho"),
        backgroundColor: Colors.orange,
      ),
      body: _itens.isEmpty
          ? const Center(child: Text("Carrinho vazio :("))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _itens.length,
                    itemBuilder: (context, index) {
                      final item = _itens[index];
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(item.imagem)),
                        title: Text(item.nome),
                        trailing: Text("R\$ ${item.preco.toStringAsFixed(2)}"),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.orange[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: R\$ ${total.toStringAsFixed(2)}", 
                           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: _finalizarPedido,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text("Finalizar", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}