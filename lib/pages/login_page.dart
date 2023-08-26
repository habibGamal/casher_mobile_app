import 'package:casher_mobile_app/app_state/app_state_provider.dart';
import 'package:casher_mobile_app/graphql/mutaions.dart';
import 'package:casher_mobile_app/routing_constants.dart';
import 'package:casher_mobile_app/tools/secure_storage/secure_storage.dart';
import 'package:casher_mobile_app/widgets/unique/guest_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

class LoginPage extends HookWidget {
  LoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final loginMutaion = useMutation(MutationOptions(
      document: gql(Mutations.login),
      onCompleted: (data) async {
        if (data?['login'] != null) {
          final appStateProviderInstance = appStateProvider(context);
          final navigator = Navigator.of(context);
          await SecureStorage.instance.setAuthToken(data!['login']);
          await appStateProviderInstance.refreshAuthToken();
          navigator.pushReplacementNamed(AUTH_HOME);
        }
      },
    ));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
      ),
      drawer: const GuestDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
              const SizedBox(height: 16.0),
              FormBuilderTextField(
                name: 'password',
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                ]),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    final formData = _formKey.currentState!.value;
                    loginMutaion.runMutation({
                      'email': formData['email'],
                      'password': formData['password'],
                      'deviceInfo':
                          (await _deviceInfo.androidInfo).model.toString(),
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (loginMutaion.result.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    const Text('Submit'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
