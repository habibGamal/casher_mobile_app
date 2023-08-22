import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthState { guest, authorized }

AppStateProvider appStateProvider(context) =>
    Provider.of<AppStateProvider>(context, listen: false);

class AppStateProvider extends ChangeNotifier {
  AuthState _authState = AuthState.guest;

  AuthState get authState => _authState;

  void updateAuthState(AuthState authState) {
    _authState = authState;
    notifyListeners();
  }
}
