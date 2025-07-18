import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/data/models/veiculo_model.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/veiculo_datasource.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';
import 'dart:developer' as dev;

class DialogCadastroVeiculo extends StatefulWidget {
  final VeiculoDatasource datasource;

  const DialogCadastroVeiculo({super.key, required this.datasource});

  @override
  State<DialogCadastroVeiculo> createState() => _DialogCadastroVeiculoState();
}

class _DialogCadastroVeiculoState extends State<DialogCadastroVeiculo> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _modeloController = TextEditingController();

  bool isLoading = false;

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final novoVeiculo = VeiculoModel(
      placa: _placaController.text.trim().toUpperCase(),
      modelo: _modeloController.text.trim(),
      status: 'NO_PATIO',  
    );

    try {
      await widget.datasource.criarVeiculo(novoVeiculo);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true); 
    } catch (e) {
      setState(() => isLoading = false);
      // ignore: use_build_context_synchronously
      dev.log("erro: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar veículo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cadastrar Veículo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _placaController,
              decoration: const InputDecoration(labelText: 'Placa'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Informe a placa' : null,
            ),
            TextFormField(
              controller: _modeloController,
              decoration: const InputDecoration(labelText: 'Modelo'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Informe o modelo' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          onPressed: isLoading ? null : _salvar,
          child: isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(
                  'Salvar',
                  style: TextStyle(color: AppColors.background),
                ),
        ),
      ],
    );
  }
}
