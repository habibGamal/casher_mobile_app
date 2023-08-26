import 'package:casher_mobile_app/app_state/app_state_provider.dart';
import 'package:casher_mobile_app/pages/auth_pages/home_page.dart';
import 'package:casher_mobile_app/pages/auth_pages/stocks_page.dart';
import 'package:casher_mobile_app/pages/guest_home_page.dart';
import 'package:casher_mobile_app/pages/landing_loading_page.dart';
import 'package:casher_mobile_app/pages/login_page.dart';
import 'package:casher_mobile_app/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppStateProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: Provider.of<AppStateProvider>(context).client,
      child: MaterialApp(
        title: 'Cashier App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routes: {
          LANDING_LOADING: (context) => const LandingLoadingPage(),
          GUEST_HOME: (context) => const GuestHomePage(),
          // BARCODE_SCANNER: (context) => const BarcodeScannerPage(),
          // LINK_NEW_SYSTEM: (context) => const LinkNewSystemPage(),
          LOGIN: (context) => LoginPage(),
          AUTH_HOME: (context) => const AuthHomePage(),
          STOCKS: (context) => const StocksPage(),
        },
        initialRoute: LANDING_LOADING,
      ),
    );
  }
}
