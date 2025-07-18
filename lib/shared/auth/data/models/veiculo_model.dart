import 'package:portaria_flutter/shared/auth/domain/entities/veiculo_entity.dart';

class VeiculoModel extends VeiculoEntity {
  VeiculoModel({
    super.id,
    required super.placa,
    required super.modelo,
    required super.status,
  });

  factory VeiculoModel.fromJson(Map<String, dynamic> json) {
    return VeiculoModel(
      id: json['id'],
      placa: json['placa'],
      modelo: json['modelo'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'placa': placa,
    'modelo': modelo,
    'status': status,
  };

  /// Usado para POST (sem o ID)
  Map<String, dynamic> toJsonPost() => {
    'placa': placa,
    'modelo': modelo,
    'status': status,
  };
}
