import 'dart:convert';
import 'package:casher_mobile_app/helpers/preferences.dart';
import 'package:dio/dio.dart';

class Connector {
  String _ip = '192.168.1.5';
  String _code = '';
  final String _port = '8000';
  final String _route = '/api/typing';
  static final Connector _instance = Connector();
  static Connector get instance => _instance;

  init() async {
    final prefs = await getPreferences();
    _ip = prefs.get(PreferencesKeys.ip) as String? ?? _ip;
    _code = prefs.get(PreferencesKeys.code) as String? ?? '';
  }

  reInit(String jsonObj) async {
    final jsonMap = json.decode(jsonObj);
    if (jsonMap.runtimeType != Map<String, dynamic>) return;
    if (jsonMap['ip'] == null || jsonMap['code'] == null) {
      throw Exception('error');
    }
    _ip = jsonMap['ip']!;
    _code = jsonMap['code']!;
    final prefs = await getPreferences();
    prefs.setString(PreferencesKeys.ip, _ip);
    prefs.setString(PreferencesKeys.code, _code);
  }

  Future<Response> request(String barcode) async {
    final dio = Dio();
    dio.options.headers['accept'] = 'application/json';
    dio.options.baseUrl = 'http://$_ip:$_port';
    return await dio.post('$_route/$barcode', data: {'scanner_code': _code});
  }

  Future<bool> tryConnect() async {
    final response = await request('test_connection');
    return response.statusCode == 200;
  }
}
