import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import 'contact_text_field.dart';

class ContactFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const ContactFormCard({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.messageController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimens.elevation4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              ContactTextField(
                controller: firstNameController,
                label: AppStrings.firstName,
                icon: Icons.person,
                validator: (value) =>
                    value == null || value.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppDimens.space12),
              ContactTextField(
                controller: lastNameController,
                label: AppStrings.lastName,
                icon: Icons.person_outline,
                validator: (value) =>
                    value == null || value.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppDimens.space12),
              ContactTextField(
                controller: emailController,
                label: AppStrings.fieldEmail,
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.required;
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return AppStrings.invalidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimens.space12),
              ContactTextField(
                controller: messageController,
                label: AppStrings.message,
                icon: Icons.message,
                maxLines: 4,
                validator: (value) =>
                    value == null || value.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppDimens.space16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSubmit,
                  child: isLoading
                      ? const SizedBox(
                          width: AppDimens.space24,
                          height: AppDimens.space24,
                          child: CircularProgressIndicator(
                            color: AppColors.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(AppStrings.sendMessage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
