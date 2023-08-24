import 'package:casher_mobile_app/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:casher_mobile_app/helpers/preferences.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DropdownSelectHost extends HookWidget {
  const DropdownSelectHost({super.key});
  _loadHosts(ValueNotifier<List<String>> hosts) async {
    final prefs = await getPreferences();
    final storedHosts = prefs.getStringList(PreferencesKeys.hosts) ?? [];
    hosts.value = storedHosts;
  }

  _loadCurrentLinkedSystem(ValueNotifier<String?> currentHost) async {
    final prefs = await getPreferences();
    final url = prefs.getString(PreferencesKeys.currentSelectedHost);
    currentHost.value = url;
  }

  @override
  Widget build(BuildContext context) {
    final hosts = useState<List<String>>([]);
    final currentHost = useState<String?>(null);
    useEffect(() {
      _loadHosts(hosts);
      _loadCurrentLinkedSystem(currentHost);
      return null;
    }, []);
    return ListTile(
      title: DropdownButtonFormField<String>(
        value: currentHost.value,
        onChanged: (String? newValue) async {
          currentHost.value = newValue!;
          final prefs = await getPreferences();
          prefs.setString(PreferencesKeys.currentSelectedHost, newValue);
          Navigator.pushReplacementNamed(context, LANDING_LOADING);
        },
        hint: const Text('Choose a system'),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        items: hosts.value.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
