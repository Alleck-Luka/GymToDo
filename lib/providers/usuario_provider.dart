import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _usuarioAtual;

  UsuarioProvider() {
    _auth.authStateChanges().listen((User? user) {
      _usuarioAtual = user;
      notifyListeners();
    });
  }

  User? get usuario => _usuarioAtual;
  bool get estaLogado => _usuarioAtual != null;
  String get nome => _usuarioAtual?.displayName ?? 'Usuário';
  String get email => _usuarioAtual?.email ?? '';

  Future<void> login(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  Future<void> cadastrar(String email, String senha, String nome) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
    await credential.user?.updateDisplayName(nome);
    await credential.user?.reload();
    _usuarioAtual = _auth.currentUser;
    notifyListeners();
  }

  Future<void> atualizarSenha(String novaSenha) async {
    if (_usuarioAtual != null && novaSenha.trim().isNotEmpty) {
      await _usuarioAtual!.updatePassword(novaSenha.trim());
    }
  }

  Future<void> atualizarNome(String novoNome) async {
    if (_usuarioAtual != null && novoNome.trim().isNotEmpty) {
      await _usuarioAtual!.updateDisplayName(novoNome.trim());
      await _usuarioAtual!.reload();
      _usuarioAtual = _auth.currentUser;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
