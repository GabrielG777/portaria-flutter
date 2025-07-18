import 'package:dio/dio.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/funcionario_datasource.dart';
import 'package:portaria_flutter/shared/auth/data/models/funcionario_model.dart';
import 'dart:developer' as dev;

class FuncionarioDatasourceImpl implements FuncionarioDatasource {
  final Dio dio;

  FuncionarioDatasourceImpl(this.dio);

  @override
  Future<List<FuncionarioModel>> listarFuncionarios() async {
    final response =
        await dio.get('http://192.168.5.16:8080/funcionarios/listar');

    dev.log("response: ${response.statusCode}");
    dev.log("aquiiiiii");

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => FuncionarioModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar funcionários');
    }
  }

  @override
  Future<void> criarFuncionario(FuncionarioModel funcionario) async {
    final jsonData = funcionario.toJsonPost();
    dev.log("JSON enviado: $jsonData");
    dev.log("aquiiiiiiiiiii");

    final response = await dio.post(
      'http://192.168.5.16:8080/funcionarios/criar',
      data: funcionario.toJsonPost(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // dev.log("$response.data");
    if (response.statusCode == 201) {
      throw Exception('Erro ao adicionar funcionario novo');
    }

      dev.log('Funcionário adicionado com sucesso');
  }
  
  @override
  Future<void> deletarFuncionario(int id) async {
    final response = await dio.delete(
      'http://192.168.5.16:8080/funcionarios/deletar/$id',
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar funcionario");
    }
  }

  @override
  Future<void> editarFuncionario(FuncionarioModel funcionario) async {
  final response = await dio.put(
    'http://192.168.5.16:8080/funcionarios/atualizar/${funcionario.id}',
    data: funcionario.toJson(),
  );

  if (response.statusCode != 200) {
    throw Exception('Erro ao atualizar funcionário');
  }
}

}
