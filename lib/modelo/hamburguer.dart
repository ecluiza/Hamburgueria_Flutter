class Hamburguer {
  final int id; 
  final String nome;
  final double preco;
  final String imagem;
  String categoria;

  Hamburguer({
    required this.id,
    required this.nome,
    required this.preco,
    required this.imagem,
    required this.categoria,
  });

  factory Hamburguer.fromJson(Map<String, dynamic> json) {
    return Hamburguer(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nome: json['nome'] ?? 'Sem nome',
      preco: double.tryParse(json['preco'].toString()) ?? 0.0,
      imagem: json['imagem'] ?? '',
      categoria: json['categoria'] ?? 'lanche',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'nome': nome,
      'preco': preco,
      'imagem': imagem,
      'categoria': categoria,
    };
  }
}