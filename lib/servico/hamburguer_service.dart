import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../modelo/hamburguer.dart';

class HamburguerService {

  final String urlApi = 'https://mocki.io/v1/be94ad13-6c16-47c7-808e-69eaf007a721'; 

  Future<List<Hamburguer>> buscarCardapio() async {
    final response = await http.get(Uri.parse(urlApi));

    if (response.statusCode == 200) {
      List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((item) => Hamburguer.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar cardápio');
    }
  }

  Future<void> salvarUsuario(String nome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome_usuario', nome);
  }

  Future<String?> lerUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nome_usuario');
  }

  Future<void> adicionarAoCarrinho(Hamburguer item) async {
    final prefs = await SharedPreferences.getInstance();
    
    String? carrinhoJson = prefs.getString('carrinho');
    List<dynamic> listaDecodificada = [];

    if (carrinhoJson != null) {
      listaDecodificada = jsonDecode(carrinhoJson);
    }

    listaDecodificada.add(item.toJson());

    await prefs.setString('carrinho', jsonEncode(listaDecodificada));
  }

  Future<List<Hamburguer>> lerCarrinho() async {
    final prefs = await SharedPreferences.getInstance();
    String? carrinhoJson = prefs.getString('carrinho');

    if (carrinhoJson != null) {
      List<dynamic> listaDecodificada = jsonDecode(carrinhoJson);
      return listaDecodificada.map((item) => Hamburguer.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> limparCarrinho() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('carrinho');
  }
}