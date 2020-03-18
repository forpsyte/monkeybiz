import 'package:flutter/material.dart';
import 'package:mailchimp/features/authentication/presentation/pages/authentication_page.dart';
import 'package:mailchimp/features/authentication/presentation/state/authentication_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monkey Biz',
      theme: ThemeData(
        primaryColor: Colors.yellow.shade800,
        accentColor: Colors.yellow.shade600,
      ),
      home: Injector(
        inject: [
          Inject<AuthenticationStore>(() => di.sl<AuthenticationStore>()),
        ],
        builder: (context) => AuthenticationPage(),
      ),
    );
  }
}
