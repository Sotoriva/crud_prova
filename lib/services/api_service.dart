import 'dart:convert';

import 'package:crud_prova/models/pessoa.dart';
import 'package:http/http.dart';

class ApiService {
  final String apiUrl =
      'https://crudcrud.com/api/1e1b3dbd14d3435bb71e8c19fdf09ee1';

  Future<List<Pessoa>> getPessoas() async {
    final response = await get(Uri.parse('$apiUrl/pessoa'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Pessoa> pessoas = body.map((item) => Pessoa.fromMap(item)).toList();
      return pessoas;
    } else {
      throw Exception("Falha ao buscar lista de pessoas.");
    }
  }

  Future<Pessoa> getPessoaPorId(String id) async {
    final response = await get(Uri.parse('$apiUrl/pessoa/$id'));

    if (response.statusCode == 200) {
      final data = Pessoa.fromMap(json.decode(response.body));
      return data;
    } else {
      throw Exception('Falha ao buscar pessoa.');
    }
  }

  Future<bool> criarPessoa(Pessoa pessoa) async {
    final data = pessoa.toJson();

    final response = await post(
      Uri.parse('$apiUrl/pessoa'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data,
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Falha para cadastrar pessoa!');
    }
  }

  Future<bool> updatePessoa(String id, Pessoa pessoa) async {
    final data = pessoa.toJson();

    final Response response = await put(
      Uri.parse('$apiUrl/pessoa/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha para atualizar pessoa.');
    }
  }

  Future<bool> deletePessoa(String id) async {
    final response = await delete(Uri.parse('$apiUrl/pessoa/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Falha para deletar a pessoa.");
    }
  }
}
