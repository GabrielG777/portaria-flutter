import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/funcionario_datasource.dart';
import 'package:portaria_flutter/shared/auth/data/models/funcionario_model.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/impl/funcionario_datasource_impl.dart';
import 'package:portaria_flutter/shared/auth/presentation/widgets/dialog_cadastro_funcionario.dart';
import 'package:portaria_flutter/shared/auth/presentation/widgets/dialog_editar_funcionario.dart';
// import 'dart:developer' as dev;

class FuncionarioPage extends StatefulWidget {
  const FuncionarioPage({super.key});

  @override
  State<FuncionarioPage> createState() => _FuncionarioPageState();
}

class _FuncionarioPageState extends State<FuncionarioPage> {
  final dio = Dio();
  late final FuncionarioDatasource datasource;

  List<FuncionarioModel> funcionarios = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    datasource = FuncionarioDatasourceImpl(dio);
    carregarFuncionarios();
  }

  Future<void> carregarFuncionarios() async {
    try {
      final lista = await datasource.listarFuncionarios();
      setState(() {
        funcionarios = lista;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Funcionários'),
        backgroundColor: AppColors.primary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Erro: $error'))
              // dev.log()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: funcionarios.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final funcionario = funcionarios[index];
                    return ListTile(
                      trailing: IconButton(
                        icon: const Icon(Icons.delete,
                            color: AppColors.secondary),
                        onPressed: () async {
                          final confirmacao = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: const Text(
                                  'Deseja excluir este funcionário?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(color: AppColors.accent),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.accent),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Excluir',
                                    style:
                                        TextStyle(color: AppColors.background),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirmacao == true) {
                            try {
                              await datasource
                                  .deletarFuncionario(funcionario.id);
                              await carregarFuncionarios();
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Funcionário excluído com sucesso')),
                              );
                            } catch (e) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao excluir: $e')),
                              );
                            }
                          }
                        },
                      ),
                      leading:
                          const Icon(Icons.person, color: AppColors.secondary),
                      title: Text(funcionario.nome),
                      subtitle: Text(
                          'CNH: ${funcionario.cnh} - Cargo: ${funcionario.cargo}'),
                      onTap: () async {
                        final resultado = await showDialog<bool>(
                          context: context,
                          builder: (_) => DialogEditarFuncionario(
                            datasource: datasource,
                            funcionario: funcionario,
                          ),
                        );

                        if (resultado == true) {
                          await carregarFuncionarios();
                        }
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.secondary,
          child: const Icon(Icons.add),
          onPressed: () async {
            final resultado = await showDialog<bool>(
              context: context,
              builder: (_) => DialogCadastroFuncionario(
                datasource: datasource,
              ),
            );

            if (resultado == true) {
              await carregarFuncionarios();
            }
          }),
    );
  }
}
