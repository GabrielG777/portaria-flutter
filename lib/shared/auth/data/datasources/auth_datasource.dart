
import 'package:portaria_flutter/shared/auth/data/models/funcionario_model.dart';

abstract class AuthDatasource {
  Future<FuncionarioModel> autenticarFuncionario(String nome, String cnh);
}
