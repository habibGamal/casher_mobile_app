// import 'package:casher_mobile_app/helpers/is_host.dart';
// import 'package:casher_mobile_app/helpers/preferences.dart';
// import 'package:casher_mobile_app/helpers/qr_scanner.dart';
// import 'package:casher_mobile_app/tools/connect_to_system/connect_to_system.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// class AddNewSystem {
//   static final AddNewSystem _instance = AddNewSystem();
//   static AddNewSystem get instance => _instance;

//   _testConnection(host) async {
//     final dio = Dio();
//     dio.options.headers['accept'] = 'application/json';
//     dio.options.baseUrl = 'https://$host/api';
//     try {
//       final connection = await dio.get('/test-connection');
//       return connection.statusCode == 200;
//     } on DioException catch (_) {
//       return false;
//     }
//   }

//   _saveSystemHost(String host) async {
//     final prefs = await getPreferences();
//     final systemLinks = prefs.getStringList(PreferencesKeys.hosts) ?? [];
//     if (systemLinks.contains(host)) return;
//     systemLinks.add(host);
//     prefs.setStringList(PreferencesKeys.hosts, systemLinks);
//   }

//   Future<String> linkNewSystem(BuildContext context) async {
//     try {
//       final host = await qrScanner();
//       if (isValidHost(host)) return 'Invalid host';
//       final isConnected = await _testConnection(host);
//       if (!isConnected) return 'Can\'t connect to this host';
//       await _saveSystemHost(host);
//       // ignore: use_build_context_synchronously
//       await ConnectToSystem.instance.connect(context, host: host);
//       return 'Connected successfully';
//     } catch (e) {
//       debugPrint(e.toString());
//       return 'Error occurred!';
//     }
//   }
// }
