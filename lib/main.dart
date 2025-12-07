import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'pages/login_screen.dart';
import 'pages/pos_screen.dart';
//import 'pages/sales_history_screen.dart';
import 'pages/home_screen.dart';

import 'services/AuthService.dart';
import 'providers/CartProvider.dart';
import 'services/ProductService.dart';
import 'services/SalesService.dart';

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

      // REGISTER ROUTES
      routes: {
        '/pos': (context) => const PoSScreen(),
       // '/sales-history': (context) => const SalesHistoryScreen(),
        '/home': (context) => const HomeScreen(),
      },

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
      return const HomeScreen();
    } else {
      return const LoginPage();
    }
  }
}
