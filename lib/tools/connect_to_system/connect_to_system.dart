import 'package:casher_mobile_app/app_state/app_state_provider.dart';
import 'package:casher_mobile_app/helpers/preferences.dart';
import 'package:casher_mobile_app/routing_constants.dart';
import 'package:casher_mobile_app/tools/http_requsets/api_requsets.dart';
import 'package:casher_mobile_app/utils/loading_dialog.dart';
import 'package:flutter/material.dart';

class ConnectToSystem {
  static final ConnectToSystem _instance = ConnectToSystem();
  static ConnectToSystem get instance => _instance;
  String? _currentSelectedHost;
  String? get currentSelectedHost => _currentSelectedHost;

  Future<void> _loadPreviousHost() async {
    final prefs = await getPreferences();
    final previeusHost = prefs.getString(PreferencesKeys.currentSelectedHost);
    _currentSelectedHost = previeusHost;
    previeusHost ?? ApiRequests.setHost(previeusHost!);
  }

  Future<void> _updateCurrentHost(String host) async {
    final prefs = await getPreferences();
    prefs.setString(PreferencesKeys.currentSelectedHost, host);
    _currentSelectedHost = host;
    ApiRequests.setHost(host);
  }

  Future<void> _determineHost(String? host) async {
    host == null ? _loadPreviousHost() : _updateCurrentHost(host);
  }

  Future<void> connect(BuildContext context,
      {String? host, LoadingDialog? loading}) async {
    final actions = _ConnectionActions(context);
    await _determineHost(host);
    if (currentSelectedHost == null) actions.noSystemChosen();
    // ignore: use_build_context_synchronously
    final statusCode = await ApiRequests.of(context).testAuthentication();
    loading?.endLoading();
    switch (statusCode) {
      case 401:
        actions.unauthorized();
        break;
      case 200:
        actions.authorized();
        break;
      case 502:
        actions.connectionProblem();
        break;
      default:
        actions.unknownError();
    }
  }
}

class _ConnectionActions {
  final BuildContext context;
  late final navigator = Navigator.of(context);
  late final appStateProviderInstance = appStateProvider(context);
  late final messager = ScaffoldMessenger.of(context);
  _ConnectionActions(this.context);

  _redirectToLogin() {
    appStateProviderInstance.updateAuthState(AuthState.guest);
    navigator.pushReplacementNamed(LOGIN);
  }

  _redirectToGuestHome() {
    appStateProviderInstance.updateAuthState(AuthState.guest);
    navigator.pushReplacementNamed(GUEST_HOME);
  }

  _redirectToAuthHome() {
    appStateProviderInstance.updateAuthState(AuthState.authorized);
    navigator.pushReplacementNamed(AUTH_HOME);
  }

  unauthorized() {
    _redirectToLogin();
  }

  connectionProblem() {
    _redirectToGuestHome();
  }

  unknownError() {
    _redirectToGuestHome();
  }

  noSystemChosen() {
    _redirectToGuestHome();
    messager.showSnackBar(const SnackBar(
      content: Text('No system chosen to connect'),
    ));
  }

  authorized() {
    _redirectToAuthHome();
  }
}
