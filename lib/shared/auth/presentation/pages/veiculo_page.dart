import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';

class VeiculoPage extends StatelessWidget {
  const VeiculoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock de veículos (até conectar ao backend)
    final List<Map<String, String>> veiculos = [
      {'placa': 'ABC-1234', 'modelo': 'Caminhão Mercedes'},
      {'placa': 'XYZ-5678', 'modelo': 'Carreta Volvo'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Veículos'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Ação para adicionar novo veículo
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: veiculos.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final veiculo = veiculos[index];
            return ListTile(
              leading: const Icon(Icons.local_shipping, color: AppColors.secondary),
              title: Text('Placa: ${veiculo['placa']}'),
              subtitle: Text('Modelo: ${veiculo['modelo']}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navegar para detalhes ou edição
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
