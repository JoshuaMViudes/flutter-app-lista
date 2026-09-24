import 'package:app_listatarefas/database_helper.dart';
import 'package:app_listatarefas/sobre_app_page.dart';
import 'package:flutter/material.dart';

class ListaTarefaPage extends StatefulWidget {
  const ListaTarefaPage({super.key});

  @override
  State<ListaTarefaPage> createState() => _ListaTarefaPageState();
}

class _ListaTarefaPageState extends State<ListaTarefaPage> {
  List<Map<String, dynamic>> tarefas = [];

  String? filtroAtual;

  static const categorias = ['Pessoal', 'Trabalho', 'Estudo', 'Compras'];

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  void carregarTarefas() async {
    final dados = await DatabaseHelper.buscarTarefas(filtro: filtroAtual);
    setState(() {
      tarefas = dados;
    });
  }

  void aplicarFiltro(String? novoFiltro) {
    filtroAtual = novoFiltro;
    Navigator.pop(context);
    carregarTarefas();
  }

  // Marcar ou desmarcar a tarefa como concluída
  Future<void> marcarSituacao(int index) async {
    final tarefa = tarefas[index];

    final novoValor = tarefa['situacao'] == 1 ? 0 : 1;

    await DatabaseHelper.atualizarTarefa(
      tarefa['id'],
      novoValor,
    );

    carregarTarefas();
  }

  // Deletar uma tarefa
  Future<void> deletarTarefa(int index) async {
    final tarefa = tarefas[index];

    await DatabaseHelper.deletarTarefa(
      tarefa['id'],
    );

    carregarTarefas();
  }

  void adicionarTarefa() {
    final novaTarefaController = TextEditingController();
    String categoriaEscolhida = categorias.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
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
                  SizedBox(
                    height: 12,
                  ),
                  DropdownButton<String>(
                    value: categoriaEscolhida,
                    isExpanded: true,
                    items: categorias.map((categoria) {
                      return DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      );
                    }).toList(),
                    onChanged: (novaCategoria) {
                      setStateDialog(() {
                        categoriaEscolhida = novaCategoria!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Função para fechar qualquer janela/tela
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (novaTarefaController.text.isNotEmpty) {
                      await DatabaseHelper.inserirTarefa(
                        novaTarefaController.text,
                        categoriaEscolhida,
                      );

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

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                "Minhas Tarefas",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Todas as Tarefas"),
              selected: filtroAtual == null,
              onTap: () => aplicarFiltro(null),
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text("Concluídas"),
              selected: filtroAtual == 'concluidas',
              onTap: () => aplicarFiltro('concluidas'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text("Pendentes"),
              selected: filtroAtual == 'pendentes',
              onTap: () => aplicarFiltro('pendentes'),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Sobre o App"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SobreAppPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: tarefas.isEmpty
          ? Center(
              child: Text(
                'Nenhuma tarefa ainda. Toque em + para adicionar',
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                final bool situacao = tarefa['situacao'] == 1;
                final String categoria = tarefa['categoria'] ?? 'Sem Categoria';

                return Card(
                  child: ListTile(
                    // Botão para marcar/desmarcar
                    leading: GestureDetector(
                      onTap: () => marcarSituacao(index),
                      child: Icon(
                        situacao ? Icons.check_circle : Icons.circle_outlined,
                        color: situacao ? Colors.green : Colors.grey,
                      ),
                    ),

                    // Título da tarefa
                    title: Text(
                      tarefa['titulo'],
                      style: TextStyle(
                        decoration: situacao
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),

                    // Situação da tarefa
                    subtitle: Text(
                      '${situacao ? "Concluída" : "Pendente"} - $categoria',
                    ),

                    // Botão para deletar
                    trailing: GestureDetector(
                      onTap: () => deletarTarefa(index),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => adicionarTarefa(),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        // shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
