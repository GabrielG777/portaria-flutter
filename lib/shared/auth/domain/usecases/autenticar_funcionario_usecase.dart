import 'package:portaria_flutter/shared/auth/domain/entities/funcionario_entity.dart';
import 'package:portaria_flutter/shared/auth/domain/repositories/auth_repository.dart';

class AutenticarFuncionarioUsecase {
  final AuthRepository repository;

  AutenticarFuncionarioUsecase(this.repository);

  Future<FuncionarioEntity> call(String nome, String cnh) {
    return repository.autenticarFuncionario(nome, cnh);
  }
}
