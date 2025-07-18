import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/login_controller.dart';
import '../widgets/custom_button.dart';
// import 'dart:developer' as dev;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cnhController = TextEditingController();
  bool _obscureCNH = true;

  void _toggleObscure() {
    setState(() {
      _obscureCNH = !_obscureCNH;
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cnhController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Por favor, insira o nome'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cnhController,
                  decoration: InputDecoration(
                    labelText: 'CNH',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureCNH
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: _toggleObscure,
                    ),
                  ),
                  obscureText: _obscureCNH,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Por favor, insira a CNH'
                      : null,
                ),
                const SizedBox(height: 30),
                controller.loading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        label: 'Entrar',
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await controller.login(
                              _nomeController.text.trim(),
                              _cnhController.text.trim(),
                            );
                            // dev.log('nome: ${_nomeController.text.trim()}');
                            // dev.log('cnh ${_cnhController.text.trim()}');
                            if (controller.error != null) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(controller.error!)),
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context)
                                  .pushReplacementNamed('/home');

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login efetuado com sucesso!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
