import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_screen.dart';
// import 'pages/pos_screen.dart';
import 'services/AuthService.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        // 1. Inisialisasi AuthService dan cek status login saat app dimulai
        ChangeNotifierProvider(
          create: (_) => AuthService()..checkLoginStatus(),
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
      // Set home ke AuthChecker untuk menentukan routing
      home: const AuthChecker(),
    );
  }
}

// Widget untuk mengarahkan pengguna ke Login atau Home (PoS)
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil state isLoggedIn dari AuthService
    final authService = Provider.of<AuthService>(context);

    if (authService.isLoggedIn) {
      // Jika sudah login, arahkan ke PoS Screen
      return const Scaffold(
        body: Center(child: Text('Welcome to Inventara PoS!')),
      );
    } else {
      // Jika belum login, arahkan ke Login Page
      return const LoginPage();
    }
  }
}
