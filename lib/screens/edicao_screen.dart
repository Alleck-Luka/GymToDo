// lib/screens/edicao_screen.dart
import 'package:flutter/material.dart';

class EdicaoScreen extends StatefulWidget {
  final String? nomeTreinoOriginal; // Se for nulo, funciona como "Add"

  const EdicaoScreen({super.key, this.nomeTreinoOriginal});

  @override
  State<EdicaoScreen> createState() => _EdicaoScreenState();
}

class _EdicaoScreenState extends State<EdicaoScreen> {
  late TextEditingController _nomeTreinoController;
  final List<TextEditingController> _exerciciosControllers = [];

  bool get isEdicao => widget.nomeTreinoOriginal != null;

  @override
  void initState() {
    super.initState();
    _nomeTreinoController = TextEditingController(
      text: widget.nomeTreinoOriginal ?? '',
    );

    // Se for edição, popula com dados padrão
    if (isEdicao) {
      _exerciciosControllers.addAll([
        TextEditingController(text: 'Exercício 1'),
        TextEditingController(text: 'Exercício 2'),
        TextEditingController(text: 'Exercício 3'),
        TextEditingController(text: 'Exercício 4'),
      ]);
    } else {
      // Se for inserção, começa com um campo em branco
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
              // Banner decorativo padrão (Substituindo a área cinza com lápis)
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

              // Input Nome do Treino
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

              // Lista Dinâmica de Inputs de Exercícios
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

              // Botão Adicionar Exercício
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

              // Botão Concluir
              ElevatedButton(
                onPressed: () {
                  // Aqui salvará as alterações no State / Firebase futuramente
                  Navigator.pop(context);
                },
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
