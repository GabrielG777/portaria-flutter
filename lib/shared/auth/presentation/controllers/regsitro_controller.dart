import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/funcionario_datasource.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/registro_dataresource.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/veiculo_datasource.dart';
import 'package:portaria_flutter/shared/auth/data/models/funcionario_model.dart';
import 'package:portaria_flutter/shared/auth/data/models/veiculo_model.dart';
import 'package:portaria_flutter/shared/auth/domain/entities/registro_etity.dart';

class RegistroController extends ChangeNotifier {
  final RegistroDatasource _registroDatasource;
  final FuncionarioDatasource _funcionarioDatasource;
  final VeiculoDatasource _veiculoDatasource;

  RegistroController(
    this._registroDatasource,
    this._funcionarioDatasource,
    this._veiculoDatasource,
  );

  List<FuncionarioModel> _funcionarios = [];
  List<VeiculoModel> _veiculos = [];

  bool _carregando = false;
  bool _enviando = false;
  String? _erro;

  List<FuncionarioModel> get funcionarios => _funcionarios;
  List<VeiculoModel> get veiculos => _veiculos;
  bool get carregando => _carregando;
  bool get enviando => _enviando;
  String? get erro => _erro;

  bool isLoadingFuncionarios = true;

  FuncionarioModel? _funcionarioSelecionado;
  VeiculoModel? _veiculoSelecionado;
  String destino = '';
  String passageiros = '';

  List<RegistroEntity> _registros = [];

  List<RegistroEntity> get registros => _registros;

  FuncionarioModel? get funcionarioSelecionado => _funcionarioSelecionado;

  set funcionarioSelecionado(FuncionarioModel? value) {
    _funcionarioSelecionado = value;
    notifyListeners();
  }

  VeiculoModel? get veiculoSelecionado => _veiculoSelecionado;

  set veiculoSelecionado(VeiculoModel? value) {
    _veiculoSelecionado = value;
    notifyListeners();
  }

  Future<List<RegistroEntity>> carregarRegistros() async {
    _registros = await _registroDatasource.buscarRegistros();
    notifyListeners();
    return _registros;
  }

  Future<bool> registrarRetorno(String placaVeiculo) async {
    try {
      final body = {"placaVeiculo": placaVeiculo};
      await _registroDatasource.enviarRegistroRetorno(body);
      // await carregarRegistros(); <- usei o setState mesmo
      return true;
    } catch (e) {
      _erro = 'Erro ao atualizar retorno: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> carregarFuncionarios() async {
    try {
      _funcionarios = await _funcionarioDatasource.listarFuncionarios();
    } catch (e) {
      _erro = 'Erro ao carregar funcionários: $e';
    } finally {
      isLoadingFuncionarios = false;
      notifyListeners();
    }
  }

  Future<void> init() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final funcs = await _funcionarioDatasource.listarFuncionarios();
      final veics = await _veiculoDatasource.listarVeiculo();

      _funcionarios = funcs;
      _veiculos = veics;
    } catch (e) {
      _erro = 'Erro ao carregar dados: $e';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<bool> enviarRegistro() async {
    if (funcionarioSelecionado == null || veiculoSelecionado == null) {
      _erro = 'Selecione um veículo e um motorista.';
      notifyListeners();
      return false;
    }

    _enviando = true;
    _erro = null;
    notifyListeners();

    try {
      final body = {
        "placaVeiculo": veiculoSelecionado!.placa,
        "idMotorista": funcionarioSelecionado!.id,
        "destino": destino,
        "passageiros": passageiros,
      };

      await _registroDatasource.enviarRegistroSaida(body);
      resetForm();
      return true;
    } catch (e) {
      _erro = 'Erro ao enviar registro: $e';
      return false;
    } finally {
      _enviando = false;
      notifyListeners();
    }
  }

  void resetForm() {
    funcionarioSelecionado = null;
    veiculoSelecionado = null;
    destino = '';
    passageiros = '';
  }

  // dd/MM/yyyy HH:mm
  String formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$ano - $hora:$minuto';
  }
}
