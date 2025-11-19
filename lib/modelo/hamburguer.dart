class Hamburguer {
  final int id;
  final String nome;
  final double preco;
  final String imagem;

  Hamburguer({
    required this.id,
    required this.nome,
    required this.preco,
    required this.imagem,
  });

  factory Hamburguer.fromJson(Map<String, dynamic> json) {
    return Hamburguer(
      id: json['id'],
      nome: json['nome'],
      preco: (json['preco'] as num).toDouble(),
      imagem: json['imagem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'imagem': imagem,
    };
  }
}