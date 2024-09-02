class Tarefa{

  Tarefa({required this.nome, required this.realizado});

  String nome;
  bool realizado;

  Map<String, dynamic> toJson (){
    return {
      "nome": nome,
      "realizado":realizado,
    };
  }
}