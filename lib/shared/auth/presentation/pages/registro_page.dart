import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:portaria_flutter/shared/auth/domain/entities/registro_etity.dart';
import 'package:portaria_flutter/shared/auth/presentation/controllers/regsitro_controller.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';
import 'package:portaria_flutter/shared/auth/presentation/widgets/registro/dialog_registro.dart';
import 'package:provider/provider.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final dio = Dio();

  late Future<List<RegistroEntity>> futureRegistros;

  late RegistroController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<RegistroController>(context, listen: false);
    futureRegistros = controller.carregarRegistros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros'),
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<List<RegistroEntity>>(
        future: futureRegistros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum registro encontrado.'));
          }

          final registros = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: registros.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final registro = registros[index];
              final possuiRetorno = registro.dataRetorno != null;
              final statusColor = possuiRetorno ? Colors.green : Colors.red;
              final statusTexto = possuiRetorno
                  ? 'Saída: ${controller.formatarData(registro.dataSaida)}\nEntrada: ${controller.formatarData(registro.dataRetorno!)}'
                  : 'Saída: ${controller.formatarData(registro.dataSaida)}';

              return ListTile(
                leading: Icon(
                  possuiRetorno ? Icons.login : Icons.logout,
                  color: statusColor,
                ),
                title: Text(
                    '${registro.placaVeiculo} - ${registro.nomeMotorista}'),
                subtitle: Text(statusTexto),
                trailing: possuiRetorno
                    ? Text(
                        'Entrada',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(AppColors.primary),
                        ),
                        child: const Text(
                          'Voltou',
                          style: TextStyle(color: AppColors.background),
                        ),
                        onPressed: () async {
                          final sucesso = await controller
                              .registrarRetorno(registro.placaVeiculo);
                          if (sucesso) {
                            setState(() { // estou bem faimlializado com o uso de setState, então optei por usar ele
                              futureRegistros = controller 
                                  .carregarRegistros();
                            });

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Registro atualizado com sucesso!'),
                                          backgroundColor: Colors.green,),
                            );
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Erro ao atualizar registro.'),
                                          backgroundColor: Colors.red,),
                            );
                          }
                        },
                      ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => DialogRegistro(
              onSuccess: () {
                setState(() {
                  futureRegistros = controller.carregarRegistros();
                });
              },
            ),
          );
        },
        child: Icon(Icons.add, color: AppColors.accent),
      ),
    );
  }
}
