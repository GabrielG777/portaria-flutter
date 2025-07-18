import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:portaria_flutter/shared/auth/data/models/funcionario_model.dart';
import 'auth_datasource.dart';
import 'dart:developer' as dev;

class AuthDatasourceImpl implements AuthDatasource {
  final Dio dio;

  AuthDatasourceImpl(this.dio);

  @override
  Future<FuncionarioModel> autenticarFuncionario(
      String nome, String cnh) async {
    try {
      final response = await dio.post(
        'http://192.168.5.16:8080/auth/login',
        data: {
          'nome': nome,
          'cnh': cnh,
        },
      );
      dev.log('Response status: ${response.statusCode}');
      dev.log('Response data: ${response.data}');
      // print("data: ${response.data}");
      // print("aquiiiiii");

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final payload = JwtDecoder.decode(token);

        dev.log("id: ${payload['id']}");
        dev.log("nome: ${payload['nome']}");
        dev.log("cnh: ${payload['cnh']}");

        return FuncionarioModel.fromJson(payload);
      } else {
        throw Exception('Erro na autenticação: ${response.statusCode}');
      }
    } catch (e, stack) {
      dev.log('Erro ao conectar com API: $e');
      dev.log('Stack: $stack');
      rethrow;
    }
  }
}
