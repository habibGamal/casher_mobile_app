import 'package:casher_mobile_app/widgets/unique/guest_drawer.dart';
import 'package:flutter/material.dart';

class GuestHomePage extends StatelessWidget {
  const GuestHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Home Page'),
      ),
      drawer: const GuestDrawer(),
      body: const Text('Welcome to the guest home page!'),
    );
  }
}
