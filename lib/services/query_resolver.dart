import 'package:casher_mobile_app/app_state/app_state_provider.dart';
import 'package:casher_mobile_app/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class QueryResolver {
  @protected
  QueryResult<Object?> result;

  QueryResolver(this.result);

  Widget unexpectedError() {
    return const Center(child: Text('Unexpected error occured!'));
  }

  Widget loading() {
    return const Center(child: CircularProgressIndicator());
  }

  void interceptor() {}

  void unauthenticated() {
    final context = useContext();
    final errors = result.exception!.graphqlErrors;
    if (errors.isEmpty) return;
    final isUnauthenticated = errors.first.message == "Unauthenticated.";
    if (isUnauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appStateProvider(context).updateAuthState(AuthState.guest);
        Navigator.of(context).pushReplacementNamed(LOGIN);
      });
    }
  }

  Widget handleExeptions() {
    unauthenticated();
    interceptor();
    return unexpectedError();
  }

  Widget resolve() {
    if (result.hasException) return handleExeptions();

    if (result.isLoading) return loading();

    return onFinish(dataFormat());
  }

  T? dataFormat<T>();

  Widget onFinish<T>(T? data);
}
