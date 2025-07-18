import 'package:flutter/foundation.dart';
import 'package:portaria_flutter/shared/auth/data/models/veiculo_model.dart';

class VeiculoController extends ChangeNotifier {
  List<VeiculoModel> _todosVeiculos = [];
  List<VeiculoModel> veiculosFiltrados = [];

  String statusFiltro = 'TODOS'; // 'TODOS', 'NO_PATIO', 'EM_VIAGEM'
  String buscaPlaca = '';

  String formatarStatus(String status) {
  switch (status) {
    case 'NO_PATIO':
      return 'No pátio';
    case 'EM_VIAGEM':
      return 'Em viagem';
    default:
      return status;
  }
}


  void setVeiculos(List<VeiculoModel> veiculos) {
    _todosVeiculos = veiculos;
    filtrar();
  }

  void setStatusFiltro(String status) {
    statusFiltro = status;
    filtrar();
  }

  void setBuscaPlaca(String placa) {
    buscaPlaca = placa.toLowerCase();
    filtrar();
  }

  void filtrar() {
    List<VeiculoModel> lista = _todosVeiculos;

    if (statusFiltro != 'TODOS') {
      lista = lista.where((v) => v.status == statusFiltro).toList();
    }

    if (buscaPlaca.isNotEmpty) {
      lista = lista
          .where((v) => v.placa.toLowerCase().contains(buscaPlaca))
          .toList();
    }

    veiculosFiltrados = lista;
    notifyListeners();
  }
}
