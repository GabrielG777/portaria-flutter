import 'package:flutter/material.dart';
import '../../domain/usecases/autenticar_funcionario_usecase.dart';
import '../../domain/entities/funcionario_entity.dart';

class LoginController extends ChangeNotifier {
  final AutenticarFuncionarioUsecase usecase;

  bool loading = false;
  String? error;
  FuncionarioEntity? funcionario;

  LoginController(this.usecase);

  Future<void> login(String nome, String cnh) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      funcionario = await usecase(nome, cnh);
    } catch (e) {
      error = e.toString();
      funcionario = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
