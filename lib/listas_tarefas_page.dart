import 'package:app_listatarefas/database_helper.dart';
import 'package:flutter/material.dart';

class ListaTarefaPage extends StatefulWidget {
  const ListaTarefaPage({super.key});

  @override
  State<ListaTarefaPage> createState() => _ListaTarefaPageState();
}

class _ListaTarefaPageState extends State<ListaTarefaPage> {
  List<Map<String, dynamic>> tarefas = [];

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  void carregarTarefas() async {
    final dados = await DatabaseHelper.buscarTarefas();
    setState(() {
      tarefas = dados;
    });
  }

  void adicionarTarefa() {
    final novaTarefaController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nova Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: novaTarefaController,
                decoration: InputDecoration(
                  hintText: 'Digite o título...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                //Função para fechar qualquer janela/tela
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (novaTarefaController.text.isNotEmpty) {
                  await DatabaseHelper.inserirTarefa(novaTarefaController.text);
                  carregarTarefas();

                  if (!context.mounted) return;

                  Navigator.pop(context);
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 95, 127, 143),
      ),
      body: tarefas.isEmpty
          ? Center(
              child: Text('Nenhuma tarefa ainda. Toque em + para adicionar'),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                final bool situacao = tarefa['situacao'] == 1;

                return Card(
                  child: ListTile(
                    leading: Icon(
                      situacao ? Icons.check_circle : Icons.circle_outlined,
                      color: situacao ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      tarefa['titulo'],
                      style: TextStyle(
                        decoration: situacao
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(situacao ? "Concluída" : "Pendente"),
                    trailing: Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => adicionarTarefa(),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        //shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
