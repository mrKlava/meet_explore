import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes/app_routes.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),

      error: (error, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: Text('Auth error: $error')),
        ),
      ),

      data: (user) {
        final isLoggedIn = user != null;

        return MaterialApp(
          title: 'Meet & Explore Pau',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.yellow[600]!,
            ).copyWith(primary: Colors.yellow[600]!),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(centerTitle: true),
          ),

          // 🔥 IMPORTANT CHANGE
          home: isLoggedIn
              ? AppRoutes.routes[AppRoutes.events]!(context)
              : const SignInScreen(),

          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}

