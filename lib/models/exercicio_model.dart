class ExercicioModel {
  String id;
  String nome;
  bool concluido;

  ExercicioModel({
    required this.id,
    required this.nome,
    this.concluido = false,
  });
}
