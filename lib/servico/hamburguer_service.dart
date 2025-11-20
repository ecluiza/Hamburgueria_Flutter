import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../modelo/hamburguer.dart';

class HamburguerService {
  
  final String urlApi = 'https://691e52f3bb52a1db22bd9491.mockapi.io/hamburgueres'; 


  Future<bool> loginAdmin(String senha) async {
    
    await Future.delayed(const Duration(seconds: 1));

   
    if (senha == "admin123") {
      return true;
    }
    return false;
  }

 
  Future<List<Hamburguer>> buscarCardapio() async {
    final response = await http.get(Uri.parse(urlApi));

    if (response.statusCode == 200) {
      List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((item) => Hamburguer.fromJson(item)).toList();
    } else {
      return []; 
    }
  }


  Future<bool> cadastrarHamburguer(Hamburguer hamburguer) async {
    final mapaSemId = hamburguer.toJson();
    mapaSemId.remove('id'); 

    final response = await http.post(
      Uri.parse(urlApi),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mapaSemId),
    );

    return response.statusCode == 201; 
  }


  Future<bool> atualizarHamburguer(Hamburguer hamburguer) async {
    final urlEdicao = '$urlApi/${hamburguer.id}'; 

    final response = await http.put(
      Uri.parse(urlEdicao),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(hamburguer.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> removerHamburguer(int id) async {
    final urlDelecao = '$urlApi/$id';

    final response = await http.delete(Uri.parse(urlDelecao));

    return response.statusCode == 200;
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