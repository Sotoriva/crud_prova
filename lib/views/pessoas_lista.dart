import 'package:crud_prova/models/pessoa.dart';
import 'package:crud_prova/services/api_service.dart';
import 'package:crud_prova/views/pessoa_detalhe.dart';
import 'package:flutter/material.dart';

class PessoasLista extends StatefulWidget {
  const PessoasLista({super.key});

  @override
  State<PessoasLista> createState() => _PessoasListaState();
}

class _PessoasListaState extends State<PessoasLista> {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de pessoas')),
      body: FutureBuilder(
        future: _carregaLista(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Falha ao carregar pessoas');
          } else if (snapshot.hasData) {
            return snapshot.data!.isNotEmpty
                ? ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PessoaDetalhe(
                                id: snapshot.data![index].id,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          '${snapshot.data![index].nome!} ${snapshot.data![index].sobrenome!}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              snapshot.data![index].dataNascimento!.toString(),
                            ),
                            Text(snapshot.data![index].cpf!),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(child: Text('Nenhuma pessoa cadastrada!'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarPessoa(context),
        tooltip: 'Nova pessoa',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Pessoa>> _carregaLista() {
    final futureCases = api.getPessoas();
    return futureCases;
  }

  _adicionarPessoa(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PessoaDetalhe()),
    );
  }
}
