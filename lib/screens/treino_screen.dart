// lib/screens/treino_screen.dart
import 'package:flutter/material.dart';

class TreinoScreen extends StatefulWidget {
  final String nomeTreino;
  const TreinoScreen({super.key, required this.nomeTreino});

  @override
  State<TreinoScreen> createState() => _TreinoScreenState();
}

class _TreinoScreenState extends State<TreinoScreen> {
  final List<Map<String, dynamic>> exercicios = [
    {'nome': 'Exercício 1', 'concluido': false},
    {'nome': 'Exercício 2', 'concluido': false},
    {'nome': 'Exercício 3', 'concluido': false},
    {'nome': 'Exercício 4', 'concluido': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[700]!, Colors.red[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.fitness_center, color: Colors.white, size: 36),
                    SizedBox(height: 12),
                    Text(
                      'Foco e Consistência',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Complete todos os exercícios de hoje.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.nomeTreino,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E1E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: const Text('Concluir'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  itemCount: exercicios.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = exercicios[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          item['concluido'] = !item['concluido'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: item['concluido']
                              ? Colors.red[50]
                              : const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: item['concluido']
                                ? Colors.red[200]!
                                : Colors.transparent,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['nome'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: item['concluido']
                                    ? Colors.red[900]
                                    : const Color(0xFF1E1E1E),
                                decoration: item['concluido']
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            Icon(
                              item['concluido']
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: item['concluido']
                                  ? Colors.red[700]
                                  : const Color(0xFF888888),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
