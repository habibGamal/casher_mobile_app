import 'package:casher_mobile_app/widgets/unique/auth_drawer.dart';
import 'package:flutter/material.dart';

class AuthHomePage extends StatelessWidget {
  const AuthHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashier App'),
      ),
      drawer: const AuthDrawer(),
      body: const Center(
        child: Text('Auth Home Page'),
      ),
    );
  }
}
