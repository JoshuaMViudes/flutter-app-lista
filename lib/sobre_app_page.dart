import 'package:flutter/material.dart';

class SobreAppPage extends StatelessWidget {
  const SobreAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre o APP"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo.png',
                width: 130,
                height: 130,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Nosso aplicativo de gestão de tarefas ajuda você a organizar suas atividades do dia a dia, permitindo adicionar, visualizar, concluir e excluir tarefas. Com uma interface fácil de usar, você pode manter tudo organizado e acompanhar seu progresso de maneira rápida e eficiente.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Versão 1.0.0',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
