import 'package:portaria_flutter/shared/auth/data/models/veiculo_model.dart';

abstract class VeiculoDatasource {
  Future<List<VeiculoModel>> listarVeiculo();
  Future<List<VeiculoModel>> listarVeiculoPlaca(int id);
  Future<List<VeiculoModel>> listarVeiculoViagem(String emViagem);
  Future<List<VeiculoModel>> listarVeiculoPatio(String noPatio);

  Future<void> criarVeiculo(VeiculoModel veiculo); 

  Future<void> deletarVeiculo(int id);

  Future<void> editarVeiculo(VeiculoModel veiculo);

  Future<void> editarVeiculoCustom(int id, Map<String, dynamic> dadosAtualizados);

}
