import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../authentication/domain/entities/access_token.dart';
import '../../../authentication/presentation/state/authentication_store.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StateBuilder<AuthenticationStore>(
          models: [Injector.getAsReactive<AuthenticationStore>()],
          builder: (_, reactiveModel) {
            return reactiveModel.whenConnectionState(
              onIdle: () => buildLoading(),
              onWaiting: () => buildLoading(),
              onData: (store) => buildInitialScreen(store.accessToken),
              onError: (_) => buildInitialInput(),
            );
          },
          afterInitialBuild: (context, reactiveModel) {
            checkLoginStatus(context);
          },
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: LoginButton(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildInitialScreen(AccessToken accessToken) {
    if (accessToken == null) {
      return buildInitialInput();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            accessToken.token,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          LogoutButton(),
        ],
      );
    }
  }

  void checkLoginStatus(BuildContext context) {
    final reactiveModel = Injector.getAsReactive<AuthenticationStore>();
    reactiveModel.setState(
      (store) => store.checkLoginStatus(),
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
