import 'package:casher_mobile_app/app_state/app_state_provider.dart';
import 'package:casher_mobile_app/helpers/preferences.dart';
import 'package:casher_mobile_app/routing_constants.dart';
import 'package:casher_mobile_app/widgets/unique/guest_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LandingLoadingPage extends HookWidget {
  const LandingLoadingPage({Key? key}) : super(key: key);
  _loadCurrentHost(ValueNotifier<bool> loading) async {
    final context = useContext();
    final appStateProviderInstance = appStateProvider(context);
    final prefs = await getPreferences();
    final url = prefs.getString(PreferencesKeys.currentSelectedHost);
    if (url != null) appStateProviderInstance.updateHost(url);
    loading.value = false;
  }

  Widget resolveQuery(result, ValueNotifier<bool> loading) {
    // loading while getting the host from the shared preferences
    if (loading.value) return const Center(child: CircularProgressIndicator());
    if (result.hasException) return const Text("Losing connection to the host");
    if (result.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    String? data = result.data?['testConnection'];

    if (data == null) {
      return const Center(child: Text('Something went wrong'));
    }
    // Navigator.of(context).pushReplacementNamed(GUEST_HOME);
    return Center(
      child: Text(data),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loadingHost = useState(true);

    final query = useQuery(QueryOptions(
      document: gql(q),
    ));

    useEffect(() {
      _loadCurrentHost(loadingHost);
      return null;
    }, []);

    useEffect(() {
      if (query.result.data?['testConnection'] == "Connected to GraphQL") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed(AUTH_HOME);
        });
      }
      return null;
    }, [query.result]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashier App'),
      ),
      drawer: const GuestDrawer(),
      body: resolveQuery(query.result, loadingHost),
    );
  }
}

const q = """
  query{
    testConnection
  }
""";
