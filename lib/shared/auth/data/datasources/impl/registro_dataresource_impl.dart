// lib/features/registro/data/datasources/registro_datasource_impl.dart

import 'package:dio/dio.dart';
import 'package:portaria_flutter/core/ulr/ulr_config.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/registro_dataresource.dart';
import 'package:portaria_flutter/shared/auth/data/models/registro_model.dart';
import 'package:portaria_flutter/shared/auth/domain/entities/registro_etity.dart';

class RegistroDatasourceImpl implements RegistroDatasource {
  final Dio dio;

  RegistroDatasourceImpl(this.dio);

  @override
  Future<void> enviarRegistroRetorno(Map<String, dynamic> body) async {
    final response =
        await dio.post('${UrlConfig.ipconfig}/registro/retorno', data: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao registrar retorno');
    }
  }

  @override
  Future<List<RegistroEntity>> buscarRegistros() async {
    final response = await dio.get('${UrlConfig.ipconfig}/registro/busca');

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((e) => RegistroModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar registros');
    }
  }

  @override
  Future<void> enviarRegistroSaida(Map<String, dynamic> body) async {
    final response =
        await dio.post('${UrlConfig.ipconfig}/registro/saida', data: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao enviar registro: ${response.statusCode}');
    }
  }
}
