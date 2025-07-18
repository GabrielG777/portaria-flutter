
import 'package:portaria_flutter/shared/auth/data/datasources/auth_datasource.dart';
import 'package:portaria_flutter/shared/auth/data/models/funcionario_model.dart';

class AuthDatasourceImplTest implements AuthDatasource {
  @override
  Future<FuncionarioModel> autenticarFuncionario(String nome, String cnh) async {
    await Future.delayed(Duration(seconds: 1)); // simula tempo de rede

    if (nome == 'João Silva' && cnh == '12345678900') {
      return FuncionarioModel(id: 1, nome: nome, cnh: cnh, cargo: '');
    } else {
      throw Exception('Funcionário não encontrado ou CNH inválida');
    }
  }
}
