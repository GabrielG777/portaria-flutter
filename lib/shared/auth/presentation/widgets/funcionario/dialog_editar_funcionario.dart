import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/funcionario_datasource.dart';
import 'package:portaria_flutter/shared/auth/data/models/funcionario_model.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';

class DialogEditarFuncionario extends StatefulWidget {
  final FuncionarioDatasource datasource;
  final FuncionarioModel funcionario;

  const DialogEditarFuncionario({
    required this.datasource,
    required this.funcionario,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DialogEditarFuncionarioState createState() =>
      _DialogEditarFuncionarioState();
}

class _DialogEditarFuncionarioState extends State<DialogEditarFuncionario> {
  late TextEditingController _nomeController;
  late TextEditingController _cargoController;
  late TextEditingController _cnhController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.funcionario.nome);
    _cargoController = TextEditingController(text: widget.funcionario.cargo);
    _cnhController = TextEditingController(text: widget.funcionario.cnh);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cargoController.dispose();
    _cnhController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Funcionário'),
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
            final funcionarioEditado = FuncionarioModel(
              id: widget.funcionario.id,
              nome: _nomeController.text,
              cargo: _cargoController.text,
              cnh: _cnhController.text,
            );

            try {
              await widget.datasource.editarFuncionario(funcionarioEditado);
              // ignore: use_build_context_synchronously
              Navigator.pop(context, true);
            } catch (e) {
              // Trate erro se quiser
              // ignore: use_build_context_synchronously
              Navigator.pop(context, false);
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
