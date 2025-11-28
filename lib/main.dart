import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'pages/login_screen.dart';
import 'pages/pos_screen.dart';
import 'services/AuthService.dart';
import 'package:pos_restoran/providers/CartProvider.dart';
import 'package:pos_restoran/services/ProductService.dart';
import 'package:pos_restoran/services/SalesService.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService()..checkLoginStatus(),
        ),

        ChangeNotifierProvider(create: (_) => CartProvider()),

        ChangeNotifierProvider(create: (_) => ProductService()),

        ProxyProvider2<AuthService, CartProvider, SalesService>(
          update: (context, authService, cartProvider, previousSalesService) {
            return SalesService(
              Dio(),
              const FlutterSecureStorage(),
              cartProvider,
            );
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventara F&B PoS',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (authService.isLoggedIn) {
      return const PoSScreen();
    } else {
      return const LoginPage();
    }
  }
}
