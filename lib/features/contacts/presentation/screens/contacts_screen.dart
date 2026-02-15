import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meet_explore/features/contacts/presentation/widgets/contact_form_card.dart';
import 'package:meet_explore/features/contacts/presentation/widgets/social_section.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/contact_message.dart';
import '../providers/contact_provider.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final message = ContactMessage(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      message: _messageController.text,
    );

    await ref.read(contactControllerProvider.notifier).send(message);

    ref.read(contactControllerProvider).whenOrNull(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.contactSuccess)),
        );

        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _messageController.clear();
      },
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.contactErrorPrefix}: $e')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactControllerProvider);

    return AppScaffold(
      title: AppStrings.contactTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: Column(
          children: [
            ContactFormCard(
              formKey: _formKey,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              emailController: _emailController,
              messageController: _messageController,
              isLoading: state.isLoading,
              onSubmit: _submitForm,
            ),
            const SizedBox(height: AppDimens.space24),
            const SocialSection(),
          ],
        ),
      ),
    );
  }
}
