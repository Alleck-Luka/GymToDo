import 'package:flutter/material.dart';
import 'package:gym_to_do/providers/treino_provider.dart';
import 'package:gym_to_do/screens/edicao_screen.dart';
import 'package:gym_to_do/screens/treino_screen.dart';
import 'package:provider/provider.dart';

class ListaTreinosWidget extends StatefulWidget {
  const ListaTreinosWidget({super.key});

  @override
  State<ListaTreinosWidget> createState() => _ListaTreinosWidgetState();
}

class _ListaTreinosWidgetState extends State<ListaTreinosWidget> {
  @override
  Widget build(BuildContext context) {
    final treinoProvider = Provider.of<TreinoProvider>(context);

    return ListView.separated(
      itemCount: treinoProvider.treinos.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final treino = treinoProvider.treinos[index];
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            title: Text(
              treino.nome,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, color: Color(0xFF1E1E1E)),
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EdicaoScreen(treino: treino),
                    ),
                  );
                } else if (value == 'delete') {
                  treinoProvider.excluirTreino(treino.id);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('Excluir', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TreinoScreen(treinoId: treino.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
