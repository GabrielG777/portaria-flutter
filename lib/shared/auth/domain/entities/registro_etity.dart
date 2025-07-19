class RegistroEntity {
  final String placaVeiculo;
  final String nomeMotorista;
  final String destino;
  final DateTime dataSaida;
  final DateTime? dataRetorno;

  RegistroEntity({
    required this.placaVeiculo,
    required this.nomeMotorista,
    required this.destino,
    required this.dataSaida,
    this.dataRetorno,
  });

  String get status => dataRetorno == null ? 'Saída' : 'Entrada';

  String get dataSaidaFormatted =>
      dataSaida.toString().replaceFirst('T', ' ').split('.').first;

  String get dataRetornoFormatted =>
      dataRetorno?.toString().replaceFirst('T', ' ').split('.').first ?? '';
}
