import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/impl/auth_datasource_impl.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/impl/funcionario_datasource_impl.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/impl/registro_dataresource_impl.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/impl/veiculo_datasource_impl.dart';
import 'package:portaria_flutter/shared/auth/domain/repositories/auth_repository_impl.dart';
import 'package:portaria_flutter/shared/auth/domain/usecases/autenticar_funcionario_usecase.dart';
import 'package:portaria_flutter/shared/auth/presentation/controllers/login_controller.dart';
import 'package:portaria_flutter/shared/auth/presentation/controllers/regsitro_controller.dart';
import 'package:portaria_flutter/shared/auth/presentation/pages/funcionario_page.dart';
import 'package:portaria_flutter/shared/auth/presentation/pages/home_page.dart';
import 'package:portaria_flutter/shared/auth/presentation/pages/login_page.dart';
import 'package:portaria_flutter/shared/auth/presentation/pages/registro_page.dart';
import 'package:portaria_flutter/shared/auth/presentation/pages/veiculo_page.dart';
import 'package:provider/provider.dart';

void main() {
  final dio = Dio();

  final registroDatasource = RegistroDatasourceImpl(dio);
  final funcionarioDatasource = FuncionarioDatasourceImpl(dio);
  final veiculoDatasource = VeiculoDatasourceImpl(dio);

  final authDatasource = AuthDatasourceImpl(dio);
  final authRepository = AuthRepositoryImpl(authDatasource);
  final autenticarUsecase = AutenticarFuncionarioUsecase(authRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginController(autenticarUsecase),
        ),
        ChangeNotifierProvider(
          create: (_) => RegistroController(
            registroDatasource,
            funcionarioDatasource,
            veiculoDatasource,
          )..init(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: {
        '/home': (_) => const HomePage(),
        '/registro': (_) => const RegistroPage(),
        '/veiculo': (_) => const VeiculoPage(),
        '/funcionario': (_) => const FuncionarioPage(),
      },
    );
  }
}
