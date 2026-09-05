import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tracking_your_habits/l10n/app_localizations.dart';
import '/src/viewmodels/login_viewmodel.dart';
import '../home/home_view.dart';
import '../register/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = context.read<LoginViewModel>();

    final success = await viewModel.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      //purhReplacement para evitar que se houver retorno volte para login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeView(),
          )
      );
      return;
    }

    _showError(viewModel.errorCode);
  }

  void _showError(String? errorCode) {
    if (errorCode == null) return;

    final l10n = AppLocalizations.of(context)!;

    String message;

    switch (errorCode) {
      case 'invalid-email':
        message = l10n.invalidEmail;
        break;

      case 'user-not-found':
        message = l10n.userNotFound;
        break;

      case 'wrong-password':
        message = l10n.wrongPassword;
        break;

      case 'invalid-credential':
        message = l10n.invalidCredential;
        break;

      case 'email-already-in-use':
        message = l10n.emailAlreadyInUse;
        break;

      case 'weak-password':
        message = l10n.weakPassword;
        break;

      case 'network-request-failed':
        message = l10n.networkRequestFailed;
        break;

      case 'too-many-requests':
        message = l10n.tooManyRequests;
        break;

      default:
        message = l10n.authenticationError;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.login),
      ),
      body: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.enterEmail;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.enterPassword;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading ? null : _login,
                        child: viewModel.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(),
                              )
                            : Text(l10n.login),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterView(),
                          ),
                        );
                      },
                      child: const Text('Criar uma conta'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}