import 'package:flutter/material.dart';

class ListaTarefaPage extends StatelessWidget {
  const ListaTarefaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tarefas = [
      {"titulo": "Fazer compra", "situacao": false},
      {"titulo": "Pagar Conta de Luz", "situacao": true},
      {"titulo": "Revisar aula de TI", "situacao": true},
      {"titulo": "Fazer fatura do Inter", "situacao": false},
      {"titulo": "Levar carro na manutençã", "situacao": false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 95, 127, 143),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          final bool situacao = tarefa['situacao'];

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
        onPressed: () {},
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        //shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
