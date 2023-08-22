import 'package:casher_mobile_app/app_state/app_state_provider.dart';
import 'package:casher_mobile_app/routing_constants.dart';
import 'package:casher_mobile_app/services/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

class AuthServices extends Services {
  AuthServices._internal() : super();
  static final AuthServices _instance = AuthServices._internal();
  factory AuthServices.of(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  login(Map<String, dynamic> formData) async {
    loading().startLoading();
    final androidInfo = await _deviceInfo.androidInfo;
    final dioFormData =
        FormData.fromMap({...formData, 'device_name': androidInfo.model});
    final loginSuccess = await fetch().login(dioFormData);
    loading().endLoading();
    if (loginSuccess) {
      appStateProviderInstance().updateAuthState(AuthState.authorized);
      navigator().pushNamed(AUTH_HOME);
    } else {
      messager().showSnackBar(const SnackBar(
        content: Text('Login Failed'),
      ));
    }
  }
}
