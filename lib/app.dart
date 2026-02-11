import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'core/services/auth_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges(),
      builder: (context, snapshot) {
        final isUser = snapshot.hasData;

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
          initialRoute: AppRoutes.events,
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.generateRoute,
          builder: (context, child) {
            // You could inject AuthService to child widgets if needed
            return child!;
          },
        );
      },
    );
  }
}
