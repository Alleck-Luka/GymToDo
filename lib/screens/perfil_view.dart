// lib/screens/perfil_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usuario_provider.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final _nomeController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _editando = false;

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    if (!_editando) {
      _nomeController.text = usuarioProvider.nome;
      _senhaController.text = usuarioProvider.senha;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.red[700],
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
        ),
        const SizedBox(height: 24),

        TextField(
          controller: _nomeController,
          enabled: _editando,
          decoration: const InputDecoration(
            labelText: 'Nome',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _senhaController,
          enabled: _editando,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Senha',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_editando) {
                usuarioProvider.atualizarPerfil(
                  _nomeController.text,
                  _senhaController.text,
                );
              }
              _editando = !_editando;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _editando
                ? Colors.green[700]
                : const Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(_editando ? 'Salvar Alterações' : 'Editar Perfil'),
        ),
      ],
    );
  }
}
