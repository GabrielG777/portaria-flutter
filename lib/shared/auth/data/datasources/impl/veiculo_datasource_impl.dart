import 'package:dio/dio.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/veiculo_datasource.dart';
import 'package:portaria_flutter/shared/auth/data/models/veiculo_model.dart';
import 'dart:developer' as dev;

class VeiculoDatasourceImpl implements VeiculoDatasource {
  final Dio dio;

  VeiculoDatasourceImpl(this.dio);

  @override
  Future<void> criarVeiculo(VeiculoModel veiculo) async {
    final data = {
      'placa': veiculo.placa,
      'modelo': veiculo.modelo,
      'status': 'NO_PATIO',
    };

    dev.log("json: $data");
    final response = await dio.post(
      'http://192.168.5.16:8080/veiculos',
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
      }),
    );
    dev.log("error cod: ${response.statusCode}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao cadastrar veículo');
    }

    if (response.statusCode == 209) {
      throw Exception('Erro: placa já existente');
    }
  }

  @override
  Future<void> deletarVeiculo(int id) async {
    try {
      final response = await dio.delete(
        'http://192.168.5.16:8080/veiculos/deletar/$id',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao deletar veículo');
      }
    } catch (e) {
      throw Exception('Erro na requisição de exclusão: $e');
    }
  }

  @override
  Future<void> editarVeiculo(VeiculoModel veiculo) async {
    final jsonData = veiculo.toJsonPost();

    dev.log("json: $jsonData");
    final response = await dio.put(
      'http://192.168.5.16:8080/veiculos/atualizar/${veiculo.id}',
      data: jsonData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dev.log("codigo: ${response.statusCode}");
    if (response.statusCode != 200) {
      throw Exception('Erro ao editar veículo');
    }
  }

  @override
  Future<void> editarVeiculoCustom(
      int id, Map<String, dynamic> dadosAtualizados) async {
    final response = await dio.put(
      'http://192.168.5.16:8080/veiculos/atualizar/$id',
      data: dadosAtualizados,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar veículo');
    }
  }

  @override
  Future<List<VeiculoModel>> listarVeiculo() async {
    final response = await dio.get('http://localhost:8080/veiculos');

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => VeiculoModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar veículos');
    }
  }

  @override
  Future<List<VeiculoModel>> listarVeiculoPatio(String noPatio) {
    throw UnimplementedError();
  }

  @override
  Future<List<VeiculoModel>> listarVeiculoPlaca(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<VeiculoModel>> listarVeiculoViagem(String emViagem) {
    throw UnimplementedError();
  }
}
