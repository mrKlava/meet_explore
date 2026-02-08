import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meet & Explore Pau',
      debugShowCheckedModeBanner: false,

      // App theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow[600]!,
        ).copyWith(primary: Colors.yellow[600]!),

        useMaterial3: true,

        appBarTheme: const AppBarTheme(centerTitle: true),
      ),

      // Routing
      initialRoute: AppRoutes.events,
      routes: AppRoutes.routes,
    );
  }
}
