import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/treino_model.dart';
import '../models/exercicio_model.dart';

class TreinoProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<TreinoModel> _treinos = [];
  String? _userId;

  List<TreinoModel> get treinos => [..._treinos];

  // Sempre que o usuário logar ou deslogar, atualizamos o ID aqui para carregar os treinos certos
  void atualizarUsuario(String? novoUserId) {
    _userId = novoUserId;
    if (_userId != null) {
      escutarTreinos();
    } else {
      _treinos = [];
      notifyListeners();
    }
  }

  // Atalho para pegar a referência da coleção de treinos do usuário atual
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
  }

  Future<void> excluirTreino(String id) async {
    await _treinosRef.doc(id).delete();
  }

  Future<void> alternarStatusExercicio(
    String treinoId,
    String exercicioId,
    bool statusAtual,
  ) async {
    await _treinosRef
        .doc(treinoId)
        .collection('exercicios')
        .doc(exercicioId)
        .update({'concluido': !statusAtual});
  }
}
