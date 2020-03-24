import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../injection_container.dart' as di;
import '../../../authentication/presentation/state/authentication_store.dart';
import '../pages/index_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monkey Biz',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.teal.shade500,
        textTheme: TextTheme(
          display1: TextStyle(
            fontSize: 50.0,
            color: Colors.black,
            fontFamily: "Pacifico",
          ),
          display2: TextStyle(
            fontSize: 12.0,
            color: Colors.black,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w300
          )
        ),
      ),
      home: Injector(
        inject: [
          Inject<AuthenticationStore>(() => di.sl<AuthenticationStore>()),
        ],
        builder: (context) => IndexPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
