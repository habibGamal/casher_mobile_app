import 'package:casher_mobile_app/tools/connect_to_system/connect_to_system.dart';
import 'package:casher_mobile_app/widgets/unique/guest_drawer.dart';
import 'package:flutter/material.dart';

class LandingLoadingPage extends StatelessWidget {
  const LandingLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading please wait...'),
      ),
      drawer: const GuestDrawer(),
      body: FutureBuilder(
        future: ConnectToSystem.instance.connect(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
                child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Just a moment please...'),
              ],
            ));
          }
        },
      ),
    );
  }
}
