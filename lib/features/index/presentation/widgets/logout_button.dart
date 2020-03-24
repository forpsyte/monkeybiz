import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../authentication/presentation/state/authentication_store.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: FloatingActionButton.extended(
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text('Sign Out'),
        ),
        onPressed: () => logout(context),
        shape: RoundedRectangleBorder(),
      ),
    );
  }

  void logout(BuildContext context) {
    final reactiveModel = Injector.getAsReactive<AuthenticationStore>();
    reactiveModel.setState(
      (store) => store.logout(),
      onError: (context, error) {
        print(error);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Couldn't sign out. Please try again."),
          ),
        );
      },
    );
  }
}