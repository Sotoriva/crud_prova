// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Pessoa {
  final String? id;
  final String? nome;
  final String? sobrenome;
  final String? cpf;
  final String? email;
  final DateTime? dataNascimento;

  Pessoa({
    this.id,
    this.nome,
    this.sobrenome,
    this.cpf,
    this.email,
    this.dataNascimento,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'sobrenome': sobrenome,
      'cpf': cpf,
      'email': email,
      'dataNascimento': dataNascimento.toString(),
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['_id'] != null ? map['_id'] as String : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      sobrenome: map['sobrenome'] != null ? map['sobrenome'] as String : null,
      cpf: map['cpf'] != null ? map['cpf'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      dataNascimento: map['dataNascimento'] != null
          ? DateTime.parse(map['dataNascimento'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pessoa.fromJson(String source) =>
      Pessoa.fromMap(json.decode(source) as Map<String, dynamic>);
}
