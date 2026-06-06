// lib/providers/treino_provider.dart
import 'package:flutter/material.dart';
import '../models/treino_model.dart';
import '../models/exercicio_model.dart';

class TreinoProvider with ChangeNotifier {
  final List<TreinoModel> _treinos = [
    TreinoModel(
      id: '1',
      nome: 'Treino A',
      exercicios: [
        ExercicioModel(id: '101', nome: 'Agachamento Free'),
        ExercicioModel(id: '102', nome: 'Leg Press 45°'),
        ExercicioModel(id: '103', nome: 'Extensora'),
      ],
    ),
    TreinoModel(
      id: '2',
      nome: 'Treino B',
      exercicios: [
        ExercicioModel(id: '201', nome: 'Supino Reto'),
        ExercicioModel(id: '202', nome: 'Desenvolvimento'),
        ExercicioModel(id: '203', nome: 'Tríceps Corda'),
      ],
    ),
  ];

  List<TreinoModel> get treinos => [..._treinos];

  // Adicionar novo treino
  void adicionarTreino(String nome, List<String> nomesExercicios) {
    final novosExercicios = nomesExercicios
        .where((nome) => nome.trim().isNotEmpty)
        .map(
          (nome) => ExercicioModel(
            id: DateTime.now().microsecondsSinceEpoch.toString() + nome,
            nome: nome,
          ),
        )
        .toList();

    final novoTreino = TreinoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome,
      exercicios: novosExercicios,
    );

    _treinos.add(novoTreino);
    notifyListeners(); // Atualiza a UI
  }

  // Editar treino existente
  void editarTreino(String id, String novoNome, List<String> nomesExercicios) {
    final index = _treinos.indexWhere((t) => t.id == id);
    if (index >= 0) {
      final novosExercicios = nomesExercicios
          .where((nome) => nome.trim().isNotEmpty)
          .map(
            (nome) => ExercicioModel(
              id: DateTime.now().microsecondsSinceEpoch.toString() + nome,
              nome: nome,
            ),
          )
          .toList();

      _treinos[index].nome = novoNome;
      _treinos[index].exercicios = novosExercicios;
      notifyListeners();
    }
  }

  // Excluir Treino
  void excluirTreino(String id) {
    _treinos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // Alternar status do exercício (Check/Uncheck)
  void alternarStatusExercicio(String treinoId, String exercicioId) {
    final treino = _treinos.firstWhere((t) => t.id == treinoId);
    final exercicio = treino.exercicios.firstWhere((e) => e.id == exercicioId);

    exercicio.concluido = !exercicio.concluido;
    notifyListeners();
  }
}
