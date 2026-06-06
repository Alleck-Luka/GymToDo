import 'exercicio_model.dart';

class TreinoModel {
  String id;
  String nome;
  List<ExercicioModel> exercicios;

  TreinoModel({required this.id, required this.nome, required this.exercicios});

  factory TreinoModel.fromMap(
    String id,
    Map<String, dynamic> map,
    List<ExercicioModel> exercicios,
  ) {
    return TreinoModel(id: id, nome: map['nome'] ?? '', exercicios: exercicios);
  }

  Map<String, dynamic> toMap() {
    return {'nome': nome};
  }
}
