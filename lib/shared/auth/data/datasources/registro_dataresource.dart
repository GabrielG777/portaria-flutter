import 'package:portaria_flutter/shared/auth/domain/entities/registro_etity.dart';

abstract class RegistroDatasource {

  Future<void> enviarRegistroRetorno(Map<String, dynamic> body);

  Future<void> enviarRegistroSaida(Map<String, dynamic> body);

  Future<List<RegistroEntity>> buscarRegistros();
}
