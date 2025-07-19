import 'package:portaria_flutter/shared/auth/domain/entities/registro_etity.dart';

class RegistroModel extends RegistroEntity {
  RegistroModel({
    required super.placaVeiculo,
    required super.nomeMotorista,
    required super.destino,
    required super.dataSaida,
    super.dataRetorno,
  });

  factory RegistroModel.fromJson(Map<String, dynamic> json) {
    return RegistroModel(
      placaVeiculo: json['placaVeiculo'],
      nomeMotorista: json['nomeMotorista'],
      destino: json['destino'],
      dataSaida: DateTime.parse(json['dataSaida']),
      dataRetorno:
          json['dataRetorno'] != null ? DateTime.parse(json['dataRetorno']) : null,
    );
  }
}
