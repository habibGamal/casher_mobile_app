import 'package:casher_mobile_app/tools/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

enum AuthState { guest, authorized }

final policy = Policies(
  cacheReread: CacheRereadPolicy.ignoreAll,
  fetch: FetchPolicy.noCache,
);
final policies = DefaultPolicies(
  query: policy,
  mutate: policy,
  watchQuery: policy,
);

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
      defaultPolicies: policies,
    ),
  );

  HttpLink? _httpLink;

  ValueNotifier<GraphQLClient> get client => _client;

  Future<void> updateHost(String host) async {
    _httpLink = HttpLink(
      'https://$host/graphql',
    );
    final token = await SecureStorage.instance.getAuthToken();
    final AuthLink authLink = AuthLink(getToken: () {
      return 'Bearer $token';
    });
    final Link link = authLink.concat(_httpLink!);
    _client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
        defaultPolicies: policies,
      ),
    );
    notifyListeners();
  }

  Future<void> refreshAuthToken() async {
    if (_httpLink == null) return;
    final token = await SecureStorage.instance.getAuthToken();
    final AuthLink authLink = AuthLink(getToken: () {
      return 'Bearer $token';
    });
    final Link link = authLink.concat(_httpLink!);
    _client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
        defaultPolicies: policies,
      ),
    );
    notifyListeners();
  }
}
