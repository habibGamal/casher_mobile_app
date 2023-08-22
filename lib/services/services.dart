import 'package:casher_mobile_app/app_state/app_state_provider.dart';
import 'package:casher_mobile_app/tools/http_requsets/api_requsets.dart';
import 'package:casher_mobile_app/utils/loading_dialog.dart';
import 'package:flutter/material.dart';

abstract class Services {
  late BuildContext context;

  @protected
  ApiRequests fetch() {
    return ApiRequests.of(context);
  }

  @protected
  LoadingDialog loading() {
    return LoadingDialog(context);
  }

  @protected
  AppStateProvider appStateProviderInstance() {
    return appStateProvider(context);
  }

  @protected
  NavigatorState navigator() {
    return Navigator.of(context);
  }

  @protected
  ScaffoldMessengerState messager() {
    return ScaffoldMessenger.of(context);
  }
}
