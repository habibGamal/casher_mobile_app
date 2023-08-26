import 'package:casher_mobile_app/graphql/mutaions.dart';
import 'package:casher_mobile_app/helpers/dd.dart';
import 'package:casher_mobile_app/routing_constants.dart';
import 'package:casher_mobile_app/widgets/unique/dropdown_select_host.dart';
import 'package:flutter/material.dart';
import 'package:casher_mobile_app/widgets/typography/Title.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthDrawer extends HookWidget {
  const AuthDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final logoutMutation = useMutation(MutationOptions(
        document: gql(Mutations.logout),
        onCompleted: (data) {
          dd(data);
          if (data != null && data['logout'] == '1') {
            Navigator.pushReplacementNamed(context, AUTH_HOME);
          }
        }));

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
              Navigator.pushNamed(context, STOCKS);
            },
          ),
          // logout with icon
          ListTile(
            title: const Text('Logout'),
            trailing: logoutMutation.result.isLoading
                ? const SizedBox(
                    width: 15, height: 15, child: CircularProgressIndicator())
                : const Icon(Icons.logout),
            onTap: () {
              logoutMutation.runMutation({});
            },
          ),
        ],
      ),
    );
  }
}
