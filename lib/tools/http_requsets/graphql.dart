import 'package:casher_mobile_app/tools/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _GraphQLAdapter {
  static final _GraphQLAdapter _instance = _GraphQLAdapter();
  static _GraphQLAdapter get instance => _instance;
  late GraphQLClient _qlClient;

  BuildContext? _context;
  GraphQLClient of(BuildContext? context) {
    _context = context;
    return _qlClient;
  }

  _GraphQLAdapter() {
    HttpLink httpLink = HttpLink("");
    AuthLink authLink = AuthLink(
      getToken: () async =>
          'Bearer ${await SecureStorage.instance.getAuthToken()}',
    );
    Link link = authLink.concat(httpLink);
    _qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
  }

  set setHost(String host) {
    HttpLink httpLink = HttpLink("https://$host/graphql");
    AuthLink authLink = AuthLink(
      getToken: () async =>
          'Bearer ${await SecureStorage.instance.getAuthToken()}',
    );
    Link link = authLink.concat(httpLink);
    _qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
  }
}

void fetchData() async {
  HttpLink httpLink = HttpLink("https://rickandmortyapi.com/graphql");
  AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer ${await SessionManager.getAuthToken()}',
  );

  Link link = authLink.concat(apiKey).concat(httpLink);

  GraphQLClient qlClient = GraphQLClient(
    link: link,
    cache: GraphQLCache(
      store: HiveStore(),
    ),
  );
  QueryResult queryResult = await qlClient.query(
    QueryOptions(
      document: gql(
        """query {
            characters() {
              results {
                name
                image 
              }
            }
          }
""",
      ),
    ),
  );

// queryResult.data  // contains data
// queryResult.exception // will give what exception you got /errors
// queryResult.hasException // you can check if you have any exception

// queryResult.context.entry<HttpLinkResponseContext>()?.statusCode  // to get status code of response

  setState(() {
    characters = queryResult.data!['characters']['results'];
    _loading = false;
  });
}
