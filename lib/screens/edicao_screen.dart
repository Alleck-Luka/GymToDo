// lib/screens/edicao_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/treino_model.dart';
import '../providers/treino_provider.dart';

class EdicaoScreen extends StatefulWidget {
  final TreinoModel? treino;

  const EdicaoScreen({super.key, this.treino});

  @override
  State<EdicaoScreen> createState() => _EdicaoScreenState();
}

class _EdicaoScreenState extends State<EdicaoScreen> {
  late TextEditingController _nomeTreinoController;
  final List<TextEditingController> _exerciciosControllers = [];

  bool get isEdicao => widget.treino != null;

  @override
  void initState() {
    super.initState();
    _nomeTreinoController = TextEditingController(
      text: widget.treino?.nome ?? '',
    );

    if (isEdicao) {
      for (var exercio in widget.treino!.exercicios) {
        _exerciciosControllers.add(TextEditingController(text: exercio.nome));
      }
    } else {
      _exerciciosControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _nomeTreinoController.dispose();
    for (var controller in _exerciciosControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _adicionarCampoExercicio() {
    setState(() {
      _exerciciosControllers.add(TextEditingController());
    });
  }

  void _removerExercicio(int index) {
    setState(() {
      _exerciciosControllers[index].dispose();
      _exerciciosControllers.removeAt(index);
    });
  }

  void _salvarTreino() {
    final nomeTreino = _nomeTreinoController.text.trim();
    if (nomeTreino.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Insira o nome do treino')));
      return;
    }

    List<String> nomesExercicios = _exerciciosControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    final provider = Provider.of<TreinoProvider>(context, listen: false);

    if (isEdicao) {
      provider.editarTreino(widget.treino!.id, nomeTreino, nomesExercicios);
    } else {
      provider.adicionarTreino(nomeTreino, nomesExercicios);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Treino' : 'Novo Treino'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1E1E1E),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _nomeTreinoController,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'Nome do Treino',
                  hintText: 'Ex: Treino A',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  itemCount: _exerciciosControllers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _exerciciosControllers[index],
                            decoration: InputDecoration(
                              hintText: 'Nome do exercício',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _removerExercicio(index),
                        ),
                      ],
                    );
                  },
                ),
              ),

              OutlinedButton.icon(
                onPressed: _adicionarCampoExercicio,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar exercício'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1E1E1E),
                  side: const BorderSide(color: Color(0xFF1E1E1E)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _salvarTreino,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Concluir',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
