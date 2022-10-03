import 'package:crud_prova/models/pessoa.dart';
import 'package:crud_prova/views/pessoas_lista.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';

class PessoaDetalhe extends StatefulWidget {
  const PessoaDetalhe({super.key, this.id});

  final String? id;

  @override
  State<PessoaDetalhe> createState() => _PessoaDetalheState();
}

class _PessoaDetalheState extends State<PessoaDetalhe> {
  final ApiService api = ApiService();

  final nomeController = TextEditingController();
  final sobrenomeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final dataNascimentoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pessoa'), actions: [
        IconButton(
          onPressed: () async {
            await api.deletePessoa(widget.id!).then((value) async {
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Pessoa removida com sucesso!',
                    ),
                  ),
                );
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const PessoasLista(),
                  ),
                );
              }
            }).catchError((onError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(onError)),
              );
            });
          },
          icon: const Icon(Icons.delete),
        ),
      ]),
      body: FutureBuilder(
        future: widget.id != null ? api.getPessoaPorId(widget.id!) : null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            nomeController.text = snapshot.data!.nome!;
            sobrenomeController.text = snapshot.data!.sobrenome!;
            cpfController.text = snapshot.data!.cpf!;
            emailController.text = snapshot.data!.email!;
            dataNascimentoController.text =
                snapshot.data!.dataNascimento!.toString();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(label: Text('Nome')),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: sobrenomeController,
                    decoration: const InputDecoration(label: Text('Sobrenome')),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: cpfController,
                    decoration: const InputDecoration(label: Text('CPF')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo não pode ser vázio!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(label: Text('Email')),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: dataNascimentoController,
                    decoration: const InputDecoration(
                      label: Text('Data Nascimento'),
                      hintText: '2022-01-31',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final pessoaData = Pessoa(
                          nome: nomeController.text,
                          sobrenome: sobrenomeController.text,
                          cpf: cpfController.text,
                          email: emailController.text,
                          dataNascimento:
                              DateTime.parse(dataNascimentoController.text),
                        );

                        if (widget.id != null) {
                          await api
                              .updatePessoa(widget.id!, pessoaData)
                              .then((data) async {
                            if (data) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Cadastrado atualizado com sucesso!',
                                  ),
                                ),
                              );
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const PessoasLista(),
                                ),
                              );
                            }
                          }).catchError((onError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(onError)),
                            );
                          });
                        } else {
                          await api.criarPessoa(pessoaData).then((data) async {
                            if (data) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cadastrado com sucesso!'),
                                ),
                              );
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const PessoasLista(),
                                ),
                              );
                            }
                          }).catchError((onError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(onError)),
                            );
                          });
                        }
                      }
                    },
                    child: const Text('Finalizar'),
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
