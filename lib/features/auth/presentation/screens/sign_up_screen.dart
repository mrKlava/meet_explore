import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../routes/app_routes.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_form.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            Navigator.pushReplacementNamed(context, AppRoutes.events);
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.signUpFailed}: $error')),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.signUpTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: AuthForm(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          isLoading: isLoading,
          buttonText: AppStrings.signUpTitle,
          onSubmit: _signUp,
        ),
      ),
    );
  }
}
