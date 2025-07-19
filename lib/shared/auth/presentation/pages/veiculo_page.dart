import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/impl/veiculo_datasource_impl.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/veiculo_datasource.dart';
import 'package:portaria_flutter/shared/auth/presentation/controllers/veiculo_controller.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';
import 'package:portaria_flutter/shared/auth/presentation/widgets/veiculo/dialog_cadastro_veiculo.dart';
import 'package:portaria_flutter/shared/auth/presentation/widgets/veiculo/dialog_editar_veiculo.dart';

class VeiculoPage extends StatefulWidget {
  const VeiculoPage({super.key});

  @override
  State<VeiculoPage> createState() => _VeiculoPageState();
}

class _VeiculoPageState extends State<VeiculoPage> {
  final dio = Dio();
  late final VeiculoDatasource datasource;
  late final VeiculoController controller;

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    datasource = VeiculoDatasourceImpl(dio);
    controller = VeiculoController();
    carregarVeiculos();

    controller.addListener(() {
      setState(() {});
    });
  }

  Future<void> carregarVeiculos() async {
    try {
      final lista = await datasource.listarVeiculo();
      controller.setVeiculos(lista);
      setState(() {
        isLoading = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final veiculosExibidos = controller.veiculosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Veículos'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por placa',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) => controller.setBuscaPlaca(text),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilterButton(
                label: 'No Pátio',
                isSelected: controller.statusFiltro == 'NO_PATIO',
                onTap: () => controller.setStatusFiltro('NO_PATIO'),
              ),
              const SizedBox(width: 8),
              FilterButton(
                label: 'Em Viagem',
                isSelected: controller.statusFiltro == 'EM_VIAGEM',
                onTap: () => controller.setStatusFiltro('EM_VIAGEM'),
              ),
              const SizedBox(width: 8),
              FilterButton(
                label: 'Todos',
                isSelected: controller.statusFiltro == 'TODOS',
                onTap: () => controller.setStatusFiltro('TODOS'),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(child: Text('Erro: \$error'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: veiculosExibidos.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final veiculo = veiculosExibidos[index];
                          return ListTile(
                            trailing: IconButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Deseja realmente excluir o veículo de placa ${veiculo.placa}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await datasource.deletarVeiculo(veiculo.id!);
                                  carregarVeiculos();
                                }
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: AppColors.secondary,
                              ),
                            ),
                            leading: const Icon(Icons.local_shipping,
                                color: AppColors.secondary),
                            title: Text('Placa: ${veiculo.placa}'),
                            subtitle: Text(
                                'Modelo: ${veiculo.modelo} - Status: ${controller.formatarStatus(veiculo.status)}'),
                            onTap: () async {
                              final atualizado = await showDialog<bool>(
                                context: context,
                                builder: (context) => DialogEditarVeiculo(
                                  veiculo: veiculo,
                                  datasource: datasource,
                                ),
                              );
                              if (atualizado == true) {
                                carregarVeiculos();
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
        onPressed: () async {
          final criado = await showDialog<bool>(
            context: context,
            builder: (context) => DialogCadastroVeiculo(datasource: datasource),
          );
          if (criado == true) {
            carregarVeiculos();
          }
        },
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.secondary : Colors.transparent,
        foregroundColor: isSelected ? Colors.white : AppColors.secondary,
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}
