import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/data/models/funcionario_model.dart';
import 'package:portaria_flutter/shared/auth/data/models/veiculo_model.dart';
import 'package:portaria_flutter/shared/auth/presentation/controllers/regsitro_controller.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';
import 'package:provider/provider.dart';

class DialogRegistro extends StatefulWidget {
  final Function() onSuccess;

  const DialogRegistro({super.key, required this.onSuccess});

  @override
  State<DialogRegistro> createState() => _DialogRegistroState();
}

class _DialogRegistroState extends State<DialogRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _destinoController = TextEditingController();
  final _passageirosController = TextEditingController();

  late RegistroController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<RegistroController>();
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegistroController>(
      builder: (context, controller, _) {
        if (controller.carregando) {
          return const AlertDialog(
            content: SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return AlertDialog(
          title: const Text('Novo Registro de Saída'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<VeiculoModel>(
                    decoration: const InputDecoration(labelText: 'Veículo'),
                    items: controller.veiculos
                        .where((v) => v.status == 'NO_PATIO')
                        .map((v) => DropdownMenuItem(
                              value: v,
                              child: Text('${v.placa} (${v.modelo})'),
                            ))
                        .toList(),
                    value: controller.veiculoSelecionado,
                    onChanged: (v) => controller.veiculoSelecionado = v,
                    validator: (value) =>
                        value == null ? 'Selecione um veículo' : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<FuncionarioModel>(
                    decoration: const InputDecoration(labelText: 'Motorista'),
                    items: controller.funcionarios.map((f) {
                      return DropdownMenuItem(
                        value: f,
                        child: Text(f.nome),
                      );
                    }).toList(),
                    value: controller.funcionarioSelecionado,
                    onChanged: (f) => controller.funcionarioSelecionado = f,
                    validator: (value) =>
                        value == null ? 'Selecione um motorista' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _destinoController,
                    decoration: const InputDecoration(labelText: 'Destino'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe o destino'
                        : null,
                    onChanged: (value) => controller.destino = value,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passageirosController,
                    decoration: const InputDecoration(labelText: 'Passageiros'),
                    onChanged: (value) => controller.passageiros = value,
                  ),
                  if (controller.erro != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      controller.erro!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ]
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: controller.enviando
                  ? null
                  : () => Navigator.of(context).pop(),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.error),),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.primary),
              ),
              onPressed: controller.enviando
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        final sucesso = await controller.enviarRegistro();
                        if (sucesso && context.mounted) {
                          widget.onSuccess();
                          Navigator.of(context).pop();
                        }
                      }
                    },
              child: controller.enviando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Enviar',
                      style: TextStyle(color: AppColors.background),
                    ),
            ),
          ],
        );
      },
    );
  }
}
