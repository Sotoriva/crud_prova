import 'dart:convert';

import 'package:crud_prova/models/pessoa.dart';
import 'package:http/http.dart';

class ApiService {
  final String apiUrl = 'http://192.168.0.7:3000/api';

  Future<List<Pessoa>> getPessoas() async {
    Response resposne = await get(Uri.https(apiUrl, '/pessoa'));

    if (resposne.statusCode == 200) {
      List<dynamic> body = jsonDecode(resposne.body);
      List<Pessoa> pessoas = body.map((item) => Pessoa.fromJson(item)).toList();
      return pessoas;
    } else {
      throw "Falha ao buscar lista de pessoas.";
    }
  }

  Future<Pessoa> getPessoaPorId(String id) async {
    final response = await get(Uri.https(apiUrl, '/pessoa/$id'));

    if (response.statusCode == 200) {
      return Pessoa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao buscar pessoa.');
    }
  }

  Future<Pessoa> criarPessoa(Pessoa pessoa) async {
    Map data = {
      'nome': pessoa.nome,
      'sobrenome': pessoa.sobrenome,
      'cpf': pessoa.cpf,
      'dataNascimento': pessoa.dataNascimento,
      'email': pessoa.email,
    };

    final Response response = await post(
      Uri.https(apiUrl, '/pessoa'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return Pessoa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha para enviar pessoa.');
    }
  }

  Future<Pessoa> updateCases(String id, Pessoa pessoa) async {
    Map data = {
      'nome': pessoa.nome,
      'sobrenome': pessoa.sobrenome,
      'cpf': pessoa.cpf,
      'dataNascimento': pessoa.dataNascimento,
      'email': pessoa.email,
    };

    final Response response = await put(
      Uri.https(apiUrl, '/pessoa/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return Pessoa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha para atualizar pessoa.');
    }
  }

  Future<void> deleteCase(String id) async {
    Response res = await delete(Uri.https(apiUrl, '/pessoa/$id'));

    if (res.statusCode == 200) {
      print("Pessoa removida");
    } else {
      throw "Falha para deletar a pessoa.";
    }
  }
}
