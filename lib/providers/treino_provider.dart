// lib/providers/treino_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/treino_model.dart';
import '../models/exercicio_model.dart';

class TreinoProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<TreinoModel> _treinos = [];
  String? _userId;

  List<TreinoModel> get treinos => [..._treinos];

  void atualizarUsuario(String? novoUserId) {
    _userId = novoUserId;
    if (_userId != null) {
      escutarTreinos();
    } else {
      _treinos = [];
      notifyListeners();
    }
  }

  CollectionReference get _treinosRef {
    if (_userId == null) throw Exception("Usuário não autenticado");
    return _db.collection('usuarios').doc(_userId).collection('treinos');
  }

  void escutarTreinos() {
    _treinosRef.snapshots().listen((treinosSnapshot) async {
      List<TreinoModel> listaTemporaria = [];

      for (var doc in treinosSnapshot.docs) {
        final dadosTreino = doc.data() as Map<String, dynamic>;

        final exerciciosSnapshot = await doc.reference
            .collection('exercicios')
            .get();

        List<ExercicioModel> listaExercicios = exerciciosSnapshot.docs.map((
          expDoc,
        ) {
          return ExercicioModel.fromMap(expDoc.id, expDoc.data());
        }).toList();

        listaTemporaria.add(
          TreinoModel.fromMap(doc.id, dadosTreino, listaExercicios),
        );
      }

      _treinos = listaTemporaria;
      notifyListeners();
    });
  }

  Future<void> adicionarTreino(
    String nome,
    List<String> nomesExercicios,
  ) async {
    DocumentReference treinoDoc = await _treinosRef.add({'nome': nome});

    for (var nomeExercicio in nomesExercicios) {
      if (nomeExercicio.trim().isNotEmpty) {
        await treinoDoc.collection('exercicios').add({
          'nome': nomeExercicio,
          'concluido': false,
        });
      }
    }
  }

  Future<void> editarTreino(
    String id,
    String novoNome,
    List<String> nomesExercicios,
  ) async {
    try {
      final index = _treinos.indexWhere((t) => t.id == id);
      if (index != -1) {
        List<ExercicioModel> exerciciosLocais = nomesExercicios
            .where((nome) => nome.trim().isNotEmpty)
            .map(
              (nome) => ExercicioModel(
                id: DateTime.now().toString(),
                nome: nome,
                concluido: false,
              ),
            )
            .toList();

        _treinos[index].nome = novoNome;
        _treinos[index].exercicios = exerciciosLocais;

        notifyListeners();
      }

      DocumentReference treinoDoc = _treinosRef.doc(id);
      await treinoDoc.update({'nome': novoNome});

      final exerciciosAntigos = await treinoDoc.collection('exercicios').get();
      for (var doc in exerciciosAntigos.docs) {
        await doc.reference.delete();
      }

      for (var nomeExercicio in nomesExercicios) {
        if (nomeExercicio.trim().isNotEmpty) {
          await treinoDoc.collection('exercicios').add({
            'nome': nomeExercicio,
            'concluido': false,
          });
        }
      }
    } catch (e) {
      print("Erro ao editar treino: $e");
    }
  }

  Future<void> excluirTreino(String id) async {
    await _treinosRef.doc(id).delete();
  }

  void alternarStatusExercicio(
    String treinoId,
    String exercicioId,
    bool statusAtual,
  ) {
    try {
      final treino = _treinos.firstWhere((t) => t.id == treinoId);
      final exercicio = treino.exercicios.firstWhere(
        (e) => e.id == exercicioId,
      );

      exercicio.concluido = !statusAtual;

      notifyListeners();

      _treinosRef
          .doc(treinoId)
          .collection('exercicios')
          .doc(exercicioId)
          .update({'concluido': exercicio.concluido})
          .catchError((error) {
            print("Erro ao sincronizar com o Firebase: $error");
            exercicio.concluido = statusAtual;
            notifyListeners();
          });
    } catch (e) {
      print("Erro ao atualizar o estado do exercício localmente: $e");
    }
  }
}
