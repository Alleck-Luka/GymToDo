// lib/screens/perfil_view.dart
import 'package:flutter/material.dart';
import 'package:gym_to_do/screens/login_screen.dart';
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
      _senhaController.text = '••••••••';
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
          onPressed: () async {
            try {
              if (_editando) {
                await usuarioProvider.atualizarNome(_nomeController.text);

                if (_senhaController.text != '••••••••' &&
                    _senhaController.text.isNotEmpty) {
                  await usuarioProvider.atualizarSenha(_senhaController.text);
                }

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perfil atualizado com sucesso!'),
                    ),
                  );
                }
              }
              setState(() {
                _editando = !_editando;
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao atualizar: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
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
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () async {
            await usuarioProvider.logout();
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text(
            'Sair da Conta',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
