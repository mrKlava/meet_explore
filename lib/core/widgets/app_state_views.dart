import 'package:flutter/material.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class AppErrorView extends StatelessWidget {
  final Object error;
  final String? prefix;

  const AppErrorView({
    super.key,
    required this.error,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final message = prefix == null ? '$error' : '$prefix: $error';
    return Center(child: Text(message));
  }
}

class AppEmptyView extends StatelessWidget {
  final String message;

  const AppEmptyView({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
