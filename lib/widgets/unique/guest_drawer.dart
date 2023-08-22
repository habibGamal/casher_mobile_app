import 'package:casher_mobile_app/routing_constants.dart';
import 'package:casher_mobile_app/widgets/unique/dropdown_select_host.dart';
import 'package:flutter/material.dart';
import 'package:casher_mobile_app/widgets/typography/Title.dart';

class GuestDrawer extends StatelessWidget {
  const GuestDrawer({super.key});

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
            title: const Text('Barcode Scanner'),
            onTap: () {
              Navigator.pushNamed(context, BARCODE_SCANNER);
            },
          ),
          ListTile(
            title: const Text('Link a new system'),
            onTap: () {
              Navigator.pushNamed(context, LINK_NEW_SYSTEM);
            },
          ),
        ],
      ),
    );
  }
}
