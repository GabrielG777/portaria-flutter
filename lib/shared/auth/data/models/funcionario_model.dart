
import 'package:portaria_flutter/shared/auth/domain/entities/funcionario_entity.dart';

class FuncionarioModel extends FuncionarioEntity {
  FuncionarioModel({
    required super.id,
    required super.cargo,
    required super.nome,
    required super.cnh,
  });

  factory FuncionarioModel.fromJson(Map<String, dynamic> json) {
    return FuncionarioModel(
      id: json['id'],
      cargo: json['cargo'],
      nome: json['nome'],
      cnh: json['cnh'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'cargo': cargo,
    'nome': nome,
    'cnh': cnh,
  };
  Map<String, dynamic> toJsonPost() => {
    // 'id': id,
    'nome': nome,
    'cargo': cargo,
    'cnh': cnh,
  };
}
