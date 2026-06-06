class ExercicioModel {
  String id;
  String nome;
  bool concluido;

  ExercicioModel({
    required this.id,
    required this.nome,
    this.concluido = false,
  });

  factory ExercicioModel.fromMap(String id, Map<String, dynamic> map) {
    return ExercicioModel(
      id: id,
      nome: map['nome'] ?? '',
      concluido: map['concluido'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'concluido': concluido};
  }
}
