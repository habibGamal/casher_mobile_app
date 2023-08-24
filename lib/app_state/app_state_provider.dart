import 'package:casher_mobile_app/tools/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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

  ValueNotifier<GraphQLClient> _client = ValueNotifier(
    GraphQLClient(
      link: HttpLink(
        'https://0.0.0.0/graphql',
      ),
      cache: GraphQLCache(),
    ),
  );

  HttpLink? _httpLink;

  ValueNotifier<GraphQLClient> get client => _client;

  void updateHost(String host) {
    _httpLink = HttpLink(
      'https://$host/graphql',
    );
    final AuthLink authLink = AuthLink(getToken: () async {
      return 'Bearer ${await SecureStorage.instance.getAuthToken()}';
    });
    final Link link = authLink.concat(_httpLink!);
    _client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );
    notifyListeners();
  }

  void refreshAuthToken() {
    if (_httpLink == null) return;
    final AuthLink authLink = AuthLink(getToken: () async {
      return 'Bearer ${await SecureStorage.instance.getAuthToken()}';
    });
    final Link link = authLink.concat(_httpLink!);
    _client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );
    notifyListeners();
  }
}
