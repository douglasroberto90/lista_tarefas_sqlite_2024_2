import 'package:flutter/material.dart';
import 'package:lista_tarefas_sqlite_2024_2/repositories/repositorio.dart';
import '../models/tarefa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tarefa> tarefas = [];
  TextEditingController controllerTarefa = TextEditingController();

  @override
  void initState() {
    Repositorio.recuperarTudo().then((dados) {
      setState(() {
        tarefas = dados;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de tarefas"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: controllerTarefa,
                  decoration: const InputDecoration(
                      label: Text("Nova tarefa"),
                      hintText: "Digite sua tarefa aqui"),
                )),
                IconButton(
                    onPressed: () async {
                      if (controllerTarefa.text.isNotEmpty) {
                        Tarefa tarefa = await Repositorio.adicionarTarefa(
                            Tarefa(nome: controllerTarefa.text, 
                            realizado: false));
                        setState(() {
                          tarefas.add(tarefa);
                        });
                        controllerTarefa.clear();
                      }
                      else{
                        SnackBar snack = const SnackBar(
                            content: Text("Favor inserir um nome na tarefa"),
                        duration: Duration(seconds: 5),
                        backgroundColor: Colors.deepOrangeAccent,);
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                    ))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: _construtorLista,
              itemCount: tarefas.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construtorLista(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      onDismissed: (direction) {
        Tarefa tarefaRemovida=tarefas[index];
        int indiceTarefaRemovida=index;
        tarefas.remove(tarefas[index]);
        Repositorio.deletarTarefa(tarefaRemovida);
        SnackBar snack = SnackBar(
            backgroundColor: Colors.deepOrangeAccent,
            content: Text("Tarefa ${tarefaRemovida.nome} removida"),
            action: SnackBarAction(label: "Desfazer",
              onPressed: () {
                Repositorio.adicionarTarefa(tarefaRemovida).then((task) {
                  setState(() {
                    tarefas.insert(indiceTarefaRemovida,task);
                  });
                },);
            },
            ),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snack);
      },
      background: Container(
        decoration: const BoxDecoration(color: Colors.red),
        child: const Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      child: CheckboxListTile(
        title: tarefas[index].realizado
            ? Text(
                tarefas[index].nome,
                style: const TextStyle(decoration: TextDecoration.lineThrough),
              )
            : Text(
                tarefas[index].nome,
              ),
        value: tarefas[index].realizado,
        onChanged: (checked) {
          Repositorio.atualizarTarefa(tarefas[index]);
          setState(() {
            tarefas[index].realizado = checked!;
          });
        },
        secondary: tarefas[index].realizado
            ? const Icon(
                Icons.verified,
                color: Colors.green,
              )
            : const Icon(
                Icons.error,
                color: Colors.red,
              ),
      ),
    );
  }
}
