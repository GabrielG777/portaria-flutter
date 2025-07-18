import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/data/models/funcionario_model.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/funcionario_datasource.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';
// import 'dart:developer' as dev;

class DialogCadastroFuncionario extends StatelessWidget {
  final FuncionarioDatasource datasource;
  // final Future<void> Function() onSucesso;

  DialogCadastroFuncionario({
    required this.datasource,
    // required this.onSucesso,
    super.key,
  });

  final _nomeController = TextEditingController();
  final _cargoController = TextEditingController();
  final _cnhController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
      title: const Text('Cadastrar Funcionário'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _cargoController,
              decoration: const InputDecoration(labelText: 'Cargo'),
            ),
            TextField(
              controller: _cnhController,
              decoration: const InputDecoration(labelText: 'CNH'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar',
              style: TextStyle(color: AppColors.secondary)),
        ),
        ElevatedButton(
          onPressed: () async {
            final funcionario = FuncionarioModel(
              nome: _nomeController.text,
              cargo: _cargoController.text,
              cnh: _cnhController.text,
              id: 0,
            );

            try {
              await datasource.criarFuncionario(funcionario);

              if (context.mounted) {
                Navigator.pop(context, true);
              }
            } catch (e) {
              if (context.mounted) {
                Navigator.pop(context, false);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao cadastrar: $e')),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text(
            'Salvar',
            style: TextStyle(color: AppColors.secondary),
          ),
        ),
      ],
    );
  }
}
