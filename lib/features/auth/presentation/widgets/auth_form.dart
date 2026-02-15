import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

typedef AuthCallback = Future<void> Function();

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String buttonText;
  final AuthCallback onSubmit;
  final VoidCallback? onSecondaryTap;
  final String? secondaryText;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.buttonText,
    required this.onSubmit,
    this.onSecondaryTap,
    this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: AppStrings.fieldEmail),
            validator: (v) =>
                (v == null || !v.contains('@')) ? AppStrings.validateEmail : null,
          ),
          const SizedBox(height: AppDimens.space12),
          TextFormField(
            controller: passwordController,
            decoration:
                const InputDecoration(labelText: AppStrings.fieldPassword),
            obscureText: true,
            validator: (v) => (v == null || v.length < 6)
                ? AppStrings.validatePassword
                : null,
          ),
          const SizedBox(height: AppDimens.space24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : Text(buttonText),
            ),
          ),
          if (secondaryText != null && onSecondaryTap != null) ...[
            const SizedBox(height: AppDimens.space12),
            TextButton(onPressed: onSecondaryTap, child: Text(secondaryText!)),
          ],
        ],
      ),
    );
  }
}
