import 'package:flutter/material.dart';
import 'package:mailchimp/features/index/presentation/widgets/login_button.dart';
import 'package:mailchimp/features/index/presentation/widgets/logout_button.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../authentication/domain/entities/access_token.dart';
import '../../../authentication/presentation/state/authentication_store.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({ Key key }) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final reactiveModel = Injector.getAsReactive<AuthenticationStore>();
    
    if(state == AppLifecycleState.paused) {
      return;
    }
    
    if(state == AppLifecycleState.resumed && !reactiveModel.state.completedLogin) {
      return checkLoginStatus(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow.shade700,
        child: StateBuilder<AuthenticationStore>(
          models: [Injector.getAsReactive<AuthenticationStore>()],
          builder: (_, reactiveModel) {
            return reactiveModel.whenConnectionState(
              onIdle: () => buildLoading(),
              onWaiting: () => buildLoading(),
              onData: (store) => buildInitialScreen(context, store.accessToken),
              onError: (_) => buildLoginScreen(context),
            );
          },
          afterInitialBuild: (context, reactiveModel) {
            checkLoginStatus(context);
          },
        ),
      ),
    );
  }

  Widget buildLoginScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: 75.0,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  "MonkeyBiz",
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "A Mailchimp Application",
                  style: Theme.of(context).textTheme.display2,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          LoginButton(),
        ],
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildInitialScreen(BuildContext context, AccessToken accessToken) {
    if (accessToken == null) {
      return buildLoginScreen(context);
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

  void checkLoginStatus(BuildContext context) async {
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