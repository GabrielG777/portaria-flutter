import 'package:portaria_flutter/shared/auth/domain/entities/funcionario_entity.dart';

abstract class AuthRepository {
  Future<FuncionarioEntity> autenticarFuncionario(String nome, String cnh);
}