import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/data/models/veiculo_model.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/veiculo_datasource.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';

class DialogEditarVeiculo extends StatefulWidget {
  final VeiculoDatasource datasource;
  final VeiculoModel veiculo;

  const DialogEditarVeiculo({
    required this.datasource,
    required this.veiculo,
    super.key,
  });

  @override
  State<DialogEditarVeiculo> createState() => _DialogEditarVeiculoState();
}

class _DialogEditarVeiculoState extends State<DialogEditarVeiculo> {
  late TextEditingController _placaController;
  late TextEditingController _modeloController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _placaController = TextEditingController(text: widget.veiculo.placa);
    _modeloController = TextEditingController(text: widget.veiculo.modelo);
    _statusController = TextEditingController(text: widget.veiculo.status);
  }

  @override
  void dispose() {
    _placaController.dispose();
    _modeloController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Veículo'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _placaController,
              decoration: const InputDecoration(labelText: 'Placa'),
            ),
            TextField(
              controller: _modeloController,
              decoration: const InputDecoration(labelText: 'Modelo'),
            ),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar',
              style: TextStyle(color: AppColors.secondary)),
        ),
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> dadosParaAtualizar = {
              'placa': _placaController.text,
              'modelo': _modeloController.text,
            };

            if (_statusController.text.isNotEmpty &&
                _statusController.text != widget.veiculo.status) {
              dadosParaAtualizar['status'] = _statusController.text;
            }

            try {
              await widget.datasource
                  .editarVeiculoCustom(widget.veiculo.id!, dadosParaAtualizar);
              // ignore: use_build_context_synchronously
              Navigator.pop(context, true);
            } catch (e) {
              // ignore: use_build_context_synchronously
              Navigator.pop(context, false);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao editar veículo: $e')),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Salvar',
              style: TextStyle(color: AppColors.secondary)),
        ),
      ],
    );
  }
}
