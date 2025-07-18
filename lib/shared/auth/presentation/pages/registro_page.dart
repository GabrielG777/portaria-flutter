import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';

class RegistroPage extends StatelessWidget {
  const RegistroPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock de registros (substituir pela API real)
    final List<Map<String, String>> registros = [
      {
        'veiculo': 'ABC-1234',
        'motorista': 'João Silva',
        'data': '2025-07-18 10:30',
        'status': 'Entrada',
      },
      {
        'veiculo': 'XYZ-5678',
        'motorista': 'Maria Oliveira',
        'data': '2025-07-17 15:45',
        'status': 'Saída',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: registros.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final registro = registros[index];
            return ListTile(
              leading: Icon(
                registro['status'] == 'Entrada'
                    ? Icons.login
                    : Icons.logout,
                color: registro['status'] == 'Entrada'
                    ? Colors.green
                    : Colors.red,
              ),
              title: Text('${registro['veiculo']} - ${registro['motorista']}'),
              subtitle: Text('${registro['data']}'),
              trailing: Text(
                registro['status']!,
                style: TextStyle(
                  color: registro['status'] == 'Entrada'
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // Navegar para detalhes do registro
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
