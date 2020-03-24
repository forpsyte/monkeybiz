import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../authentication/presentation/state/authentication_store.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: FloatingActionButton.extended(
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text('Sign In'),
        ),
        onPressed: () => login(context),
        shape: RoundedRectangleBorder(),
      ),
    );
  }

  void login(BuildContext context) {
    final reactiveModel = Injector.getAsReactive<AuthenticationStore>();
    reactiveModel.setState(
      (store) => store.login(),
      onError: (context, error) {
        print(error);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Couldn't sign in. Is the device online?"),
          ),
        );
      },
    );
  }
}