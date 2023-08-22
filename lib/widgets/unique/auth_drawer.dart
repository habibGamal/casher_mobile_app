import 'package:casher_mobile_app/routing_constants.dart';
import 'package:casher_mobile_app/widgets/unique/dropdown_select_host.dart';
import 'package:flutter/material.dart';
import 'package:casher_mobile_app/widgets/typography/Title.dart';

class AuthDrawer extends StatelessWidget {
  const AuthDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Row(children: [
              SizedBox(
                width: 60,
                child: Image(image: AssetImage('assets/images/logo.png')),
              ),
              SizedBox(width: 30),
              TypoTitle('Cashier App'),
            ]),
          ),
          const DropdownSelectHost(),
          ListTile(
            title: const Text('Stocks'),
            onTap: () {
              Navigator.pushNamed(context, AUTH_STOCKS);
            },
          ),
          // logout with icon
          ListTile(
            title: const Text('Logout'),
            trailing: const Icon(Icons.logout),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
