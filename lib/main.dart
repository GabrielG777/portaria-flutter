import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/data/datasources/auth_datasource_impl.dart';
import 'package:portaria_flutter/shared/auth/domain/repositories/auth_repository_impl.dart';
import 'package:portaria_flutter/shared/auth/domain/usecases/autenticar_funcionario_usecase.dart';
import 'package:portaria_flutter/shared/auth/presentation/controllers/login_controller.dart';
import 'package:portaria_flutter/shared/auth/presentation/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  final dio = Dio();

  final datasource = AuthDatasourceImpl(dio);
  final repository = AuthRepositoryImpl(datasource);
  final usecase = AutenticarFuncionarioUsecase(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginController(usecase),
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
    );
  }
}
