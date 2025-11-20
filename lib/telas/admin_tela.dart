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
    } else {
      _nomeController.clear();
      _precoController.clear();
      _imgController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? "Novo Prato" : "Editar Prato"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nomeController, decoration: const InputDecoration(labelText: "Nome")),
            TextField(controller: _precoController, decoration: const InputDecoration(labelText: "Preço"), keyboardType: TextInputType.number),
            TextField(controller: _imgController, decoration: const InputDecoration(labelText: "URL da Imagem")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _carregando = true); 

              final novoItem = Hamburguer(
                id: item?.id ?? 0, 
                nome: _nomeController.text,
                preco: double.tryParse(_precoController.text) ?? 0.0,
                imagem: _imgController.text,
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
                    const SnackBar(content: Text("Salvo com sucesso!")),
                  );
                } else {
                  setState(() => _carregando = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Erro ao salvar!")),
                  );
                }
              }
            },
            child: const Text("Salvar"),
          )
        ],
      ),
    );
  }

  void _confirmarDelecao(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir"),
        content: const Text("Tem certeza? Isso apagará do servidor."),
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
                    const SnackBar(content: Text("Item removido de verdade!")),
                  );
                } else {
                  setState(() => _carregando = false);
                }
              }
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestão"), backgroundColor: Colors.redAccent),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: _carregando 
        ? const Center(child: CircularProgressIndicator())
        : _listaAtual.isEmpty 
          ? const Center(child: Text("Nenhum item cadastrado."))
          : ListView.builder(
            itemCount: _listaAtual.length,
            itemBuilder: (context, index) {
              final item = _listaAtual[index];
              return ListTile(
                leading: Image.network(
                  item.imagem, 
                  width: 50, 
                  height: 50, 
                  fit: BoxFit.cover, 
                  errorBuilder: (_,__,___) => const Icon(Icons.fastfood)
                ),
                title: Text(item.nome),
                subtitle: Text("R\$ ${item.preco.toStringAsFixed(2)}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _abrirFormulario(item: item)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmarDelecao(item.id)),
                  ],
                ),
              );
            },
          ),
    );
  }
}