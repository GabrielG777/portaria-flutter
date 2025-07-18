import 'package:portaria_flutter/shared/auth/data/models/funcionario_model.dart';

abstract class FuncionarioDatasource {
  Future<List<FuncionarioModel>> listarFuncionarios();

  Future<void> criarFuncionario(FuncionarioModel funcionario); 

  Future<void> deletarFuncionario(int id);

  Future<void> editarFuncionario(FuncionarioModel funcionario);
}
