import 'package:flutter/material.dart';
import '../modelo/hamburguer.dart';
import '../servico/hamburguer_service.dart';

class AdminTela extends StatefulWidget {
  const AdminTela({super.key});

  @override
  State<AdminTela> createState() => _AdminTelaState();
}

class _AdminTelaState extends State<AdminTela> {
  final _service = HamburguerService();
  
  List<Hamburguer> _listaAtual = [];
  bool _carregando = true;

  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _imgController = TextEditingController();
  
  // 1. Variável para guardar a categoria selecionada (padrão 'lanche')
  String _categoriaSelecionada = 'lanche'; 

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    setState(() => _carregando = true);
    final dados = await _service.buscarCardapio();
    setState(() {
      _listaAtual = dados;
      _carregando = false;
    });
  }

  void _abrirFormulario({Hamburguer? item}) {
    if (item != null) {
      _nomeController.text = item.nome;
      _precoController.text = item.preco.toString();
      _imgController.text = item.imagem;
      _categoriaSelecionada = item.categoria; 
    } else {
      _nomeController.clear();
      _precoController.clear();
      _imgController.clear();
      _categoriaSelecionada = 'lanche';
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder( 
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(item == null ? "Novo Item" : "Editar Item", style: const TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: "Nome do Prato",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _categoriaSelecionada,
                    decoration: InputDecoration(
                      labelText: "Categoria",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    items: const [
                      DropdownMenuItem(value: 'lanche', child: Text("Lanche")),
                      DropdownMenuItem(value: 'bebida', child: Text("Bebida")),
                      DropdownMenuItem(value: 'acompanhamento', child: Text("Acompanhamento")),
                    ],
                    onChanged: (valor) {
                      setStateDialog(() {
                        _categoriaSelecionada = valor!;
                      });
                    },
                  ),
                  // ----------------------------------------------
                  const SizedBox(height: 10),
                  TextField(
                    controller: _precoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Preço (R\$)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _imgController,
                    decoration: InputDecoration(
                      labelText: "URL da Imagem",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[100],
                      helperText: "Cole o link direto da imagem"
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() => _carregando = true); 

                  final novoItem = Hamburguer(
                    id: item?.id ?? 0, 
                    nome: _nomeController.text,
                    preco: double.tryParse(_precoController.text) ?? 0.0,
                    imagem: _imgController.text,
                    categoria: _categoriaSelecionada, 
                  );

                  bool sucesso;
                  if (item == null) {
                    sucesso = await _service.cadastrarHamburguer(novoItem);
                  } else {
                    sucesso = await _service.atualizarHamburguer(novoItem);
                  }

                  if (mounted) {
                    if (sucesso) {
                      _carregarDados(); 
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(item == null ? "Cadastrado com sucesso!" : "Atualizado com sucesso!")),
                      );
                    } else {
                      setState(() => _carregando = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Erro ao salvar! Verifique os dados.")),
                      );
                    }
                  }
                },
                child: const Text("Salvar", style: TextStyle(color: Colors.white)),
              )
            ],
          );
        }
      ),
    );
  }

  void _confirmarDelecao(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Exclusão"),
        content: const Text("Tem certeza que deseja remover este item?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _carregando = true);

              bool sucesso = await _service.removerHamburguer(id);
              
              if (mounted) {
                if (sucesso) {
                  _carregarDados();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Item removido.")),
                  );
                } else {
                  setState(() => _carregando = false);
                }
              }
            },
            child: const Text("EXCLUIR", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Gerenciar Cardápio", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black87,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Novo Item", style: TextStyle(color: Colors.white)),
        onPressed: () => _abrirFormulario(),
      ),
      body: _carregando 
        ? const Center(child: CircularProgressIndicator(color: Colors.black87))
        : _listaAtual.isEmpty 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text("Cardápio Vazio", style: TextStyle(color: Colors.grey[500], fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _listaAtual.length,
            itemBuilder: (context, index) {
              final item = _listaAtual[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.imagem, 
                          width: 80, 
                          height: 80, 
                          fit: BoxFit.cover, 
                          errorBuilder: (_,__,___) => Container(
                            width: 80, height: 80, color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          )
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              item.categoria.toUpperCase(), 
                              style: TextStyle(fontSize: 10, color: Colors.grey[600], letterSpacing: 1),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "R\$ ${item.preco.toStringAsFixed(2)}", 
                              style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                            onPressed: () => _abrirFormulario(item: item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _confirmarDelecao(item.id),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}