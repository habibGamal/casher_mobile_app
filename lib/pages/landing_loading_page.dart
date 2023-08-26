import 'package:casher_mobile_app/app_state/app_state_provider.dart';
import 'package:casher_mobile_app/graphql/queries.dart';
import 'package:casher_mobile_app/helpers/preferences.dart';
import 'package:casher_mobile_app/routing_constants.dart';
import 'package:casher_mobile_app/services/query_resolver.dart';
import 'package:casher_mobile_app/widgets/unique/guest_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _LoadingPageQueryResolver extends QueryResolver {
  _LoadingPageQueryResolver(QueryResult<Object?> result) : super(result);

  @override
  Widget onFinish<String>(data) {
    return const Center(
      child: Text('You will be redirected now'),
    );
  }

  @override
  String? dataFormat<String>() {
    return result.data?['testConnection'] as String?;
  }
}

class LandingLoadingPage extends HookWidget {
  const LandingLoadingPage({Key? key}) : super(key: key);
  _loadCurrentHost() async {
    final context = useContext();
    final appStateProviderInstance = appStateProvider(context);
    final prefs = await getPreferences();
    final url = prefs.getString(PreferencesKeys.currentSelectedHost);
    if (url != null) await appStateProviderInstance.updateHost(url);
  }

  @override
  Widget build(BuildContext context) {
    final query = useQuery(QueryOptions(
      document: gql(Queries.testConnection),
    ));

    useEffect(() {
      _loadCurrentHost();
      return null;
    }, []);

    useEffect(() {
      if (query.result.data != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, AUTH_HOME);
        });
      }
      return null;
    }, [query.result]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashier App'),
      ),
      drawer: const GuestDrawer(),
      body: _LoadingPageQueryResolver(query.result).resolve(),
    );
  }
}
