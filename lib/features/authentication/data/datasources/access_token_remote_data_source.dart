import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/local_server_builder.dart';
import '../../../../core/utils/url_builder.dart';
import '../../../../core/utils/url_launcher.dart';
import '../models/access_token_model.dart';
import 'access_token_remote_data_source_interface.dart';

class AccessTokenRemoteDataSource
    implements AccessTokenRemoteDataSourceInterface {
  final String authorizePath = '/oauth2/authorize';
  final String accessTokenPath = '/production/token';
  final String authorizeBaseUri = 'login.mailchimp.com';
  final http.Client client;
  final LocalServerBuilder serverBuilder;
  final UrlBuilder urlBuilder;
  final UrlLauncher urlLauncher;

  AccessTokenRemoteDataSource({
    @required this.client,
    @required this.serverBuilder,
    @required this.urlBuilder,
    @required this.urlLauncher,
  });

  @override
  Future<AccessTokenModel> getToken(
    String clientId,
    String accessTokenUri,
    String redirectUri,
  ) async {

    final server = await serverBuilder.build();
    Stream<Map<String, String>> onRequestParams = await server.start();

    final authorizeUrl = urlBuilder.build(
        authorizeBaseUri, authorizePath, true, {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri
    });

    if (!(await urlLauncher.canLaunch(authorizeUrl.toString()))) {
      throw AuthenticationException();
    }

    await urlLauncher.launch(authorizeUrl.toString(), forceSafariVC: true);

    final Map<String, String> params = await onRequestParams.first;

    if (!params.containsKey('code')) {
      throw AuthenticationException(
          "Failed authenticating user. Invalid request.");
    }

    final String code = params['code'];

    final accessTokenUrl = urlBuilder.build(
      accessTokenUri,
      accessTokenPath,
      true,
      {'code': code},
    );

    final http.Response response = await client.post(
      accessTokenUrl.toString(),
      body: json.encode(accessTokenUrl.queryParameters),
    );

    final token = AccessTokenModel.fromJson(json.decode(response.body));

    await urlLauncher.closeWebView();

    return token;
  }
}
