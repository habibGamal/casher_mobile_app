import 'package:casher_mobile_app/app_state/app_state_provider.dart';
import 'package:casher_mobile_app/graphql/queries.dart';
import 'package:casher_mobile_app/services/query_resolver.dart';
import 'package:casher_mobile_app/widgets/unique/auth_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _HomePageQueryResolver extends QueryResolver {
  _HomePageQueryResolver(QueryResult<Object?> result) : super(result);

  @override
  Widget onFinish<String>(data) {
    if (data == null) {
      return const Center(
        child: Text('Problem in fetching data!'),
      );
    }
    final context = useContext();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appStateProvider(context).updateAuthState(AuthState.authorized);
    });
    return const Center(
      child: Text('Welcome you in auth page'),
    );
  }

  @override
  String? dataFormat<String>() {
    return result.data?['me']?['id'] as String?;
  }
}

class AuthHomePage extends HookWidget {
  const AuthHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final query = useQuery(
      QueryOptions(document: gql(Queries.me)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashier App'),
      ),
      drawer: const AuthDrawer(),
      body: _HomePageQueryResolver(query.result).resolve(),
    );
  }
}
