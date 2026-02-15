import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../routes/app_routes.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_form.dart';
import 'sign_up_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen(authControllerProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            Navigator.pushReplacementNamed(context, AppRoutes.events);
          }
        },
        loading: () {},
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.loginFailed}: $error')),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.signInTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: AuthForm(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          isLoading: isLoading,
          buttonText: AppStrings.signInTitle,
          onSubmit: _login,
          secondaryText: AppStrings.dontHaveAccount,
          onSecondaryTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignUpScreen()),
          ),
        ),
      ),
    );
  }
}
