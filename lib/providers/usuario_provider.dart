import 'package:flutter/material.dart';

class UsuarioProvider with ChangeNotifier {
  String _nome = 'Usuário Padrão';
  String _senha = '123456';

  String get nome => _nome;
  String get senha => _senha;

  void atualizarPerfil(String novoNome, String novaSenha) {
    if (novoNome.trim().isNotEmpty) _nome = novoNome;
    if (novaSenha.trim().isNotEmpty) _senha = novaSenha;
    notifyListeners();
  }
}
