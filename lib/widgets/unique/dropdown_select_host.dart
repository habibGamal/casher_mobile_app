import 'package:flutter/material.dart';
import 'package:casher_mobile_app/helpers/preferences.dart';
import 'package:casher_mobile_app/tools/connect_to_system/connect_to_system.dart';
import 'package:casher_mobile_app/utils/loading_dialog.dart';

class DropdownSelectHost extends StatefulWidget {
  const DropdownSelectHost({super.key});

  @override
  State<DropdownSelectHost> createState() => _DropdownSelectHostState();
}

class _DropdownSelectHostState extends State<DropdownSelectHost> {
  String? _currentSystemLink;
  final List<String> _systemLinks = [];
  _loadSystemLinks() async {
    final prefs = await getPreferences();
    final systemLinks = prefs.getStringList(PreferencesKeys.hosts) ?? [];
    _systemLinks.addAll(systemLinks);
    setState(() {});
  }

  _loadCurrentLinkedSystem() async {
    final prefs = await getPreferences();
    final url = prefs.getString(PreferencesKeys.currentSelectedHost);
    _currentSystemLink = url;
    setState(() {});
  }

  @override
  void initState() {
    _loadSystemLinks();
    _loadCurrentLinkedSystem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loadingDialog = LoadingDialog(context);
    return ListTile(
      title: DropdownButtonFormField<String>(
        value: _currentSystemLink,
        onChanged: (String? newValue) async {
          _currentSystemLink = newValue!;
          setState(() {});
          loadingDialog.startLoading();
          await ConnectToSystem.instance
              .connect(context, host: newValue, loading: loadingDialog);
        },
        hint: const Text('Choose a system'),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        items: _systemLinks.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
