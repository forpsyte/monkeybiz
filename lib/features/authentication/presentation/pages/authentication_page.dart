import 'package:flutter/material.dart';
import 'package:mailchimp/features/authentication/domain/entities/access_token.dart';
import 'package:mailchimp/features/authentication/presentation/state/authentication_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StateBuilder<AuthenticationStore>(
          models: [Injector.getAsReactive<AuthenticationStore>()],
          builder: (_, reactiveModel) {
            return reactiveModel.whenConnectionState(
              onIdle: () => buildInitialInput(),
              onWaiting: () => buildLoading(),
              onData: (store) => buildColumnWithData(store.accessToken),
              onError: (_) => buildInitialInput(),
            );
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

  Column buildColumnWithData(AccessToken accessToken) {
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
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: FloatingActionButton.extended(
        label: Text('Sign In'),
        onPressed: () => login(context),
      ),
    );
  }

  void login(BuildContext context) {
    final reactiveModel = Injector.getAsReactive<AuthenticationStore>();
    reactiveModel.setState(
      (store) => store.login(),
      onError: (context, error) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Couldn't sign in. Is the device online?"),
          ),
        );
      },
    );
  }
}
