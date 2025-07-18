

import 'package:portaria_flutter/shared/auth/data/datasources/auth_datasource.dart';
import 'package:portaria_flutter/shared/auth/domain/entities/funcionario_entity.dart';
import 'package:portaria_flutter/shared/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<FuncionarioEntity> autenticarFuncionario(String nome, String cnh) async {
    final model = await datasource.autenticarFuncionario(nome, cnh);
    return model;
  }
}
