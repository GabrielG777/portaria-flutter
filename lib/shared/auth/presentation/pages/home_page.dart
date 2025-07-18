import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/presentation/pages/login_page.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';
import 'package:portaria_flutter/shared/auth/presentation/widgets/func_disponiveis_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Olá, seja bem vindo!',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(
                              'agroterenas_logo.png',
                              // width: 80,
                              // height: 80,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'AGT - PATIO',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.home,
                        color: AppColors.secondary,
                      ),
                      title: const Text('Início'),
                      onTap: () {
                        Navigator.pop(context); // fecha o drawer
                        // ação para o menu "Início"
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.people_alt,
                        color: AppColors.secondary,
                      ),
                      title: const Text("Funcionarios"),
                      onTap: () {
                        Navigator.of(context)
                                  .pushNamed('/funcionario');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.car_crash_outlined,
                        color: AppColors.secondary,
                      ),
                      title: const Text("Veiculos"),
                      onTap: () {
                        Navigator.of(context)
                                  .pushNamed('/veiculo');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.folder_copy_outlined,
                        color: AppColors.secondary,
                      ),
                      title: const Text("Registro"),
                      onTap: () {
                        Navigator.of(context)
                                  .pushNamed('/registro');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings,
                          color: AppColors.secondary),
                      title: const Text('Configurações'),
                      onTap: () {
                        Navigator.pop(context);
                        // ação para configurações
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading:
                    const Icon(Icons.exit_to_app, color: AppColors.secondary),
                title: const Text('Sair'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                  // ação para logout
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  '/agroterenas_logo.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sistema de Controle de Pátio - AGT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Esse aplicativo tem como objetivo auxiliar no controle de veículos no pátio da empresa, registrando entradas, saídas e viagens realizadas pelos motoristas - funcionários.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Funcionalidades disponíveis:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: const [
                    FuncDisponiveisText(
                        '✔ Registrar entrada e saída de veículos'),
                    FuncDisponiveisText('✔ Acompanhar viagens em andamento'),
                    FuncDisponiveisText('✔ Gerenciar funcionários e motoristas'),
                    FuncDisponiveisText('✔ Gerar relatórios administrativos'),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
