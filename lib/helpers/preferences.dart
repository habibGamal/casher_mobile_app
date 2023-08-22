import 'package:shared_preferences/shared_preferences.dart';

class PreferencesKeys {
  static const String ip = 'ip';
  static const String code = 'code';
  static const String hosts = 'systemLinks';
  static const String currentSelectedHost = 'currentLinkedSystem';
}

Future<SharedPreferences> getPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}
