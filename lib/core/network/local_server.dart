import 'dart:async';
import 'dart:io';

import 'local_server_interface.dart';

class LocalServer extends LocalServerInterface {
  final StreamController<Map<String, String>> onRequestParams;
  final HttpServer server;

  LocalServer(this.onRequestParams, this.server) : super(onRequestParams, server);

  @override
  void handleRequest(HttpRequest request) async {
    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", ContentType.html.mimeType)
      ..write("<html><h1>You can now close this window</h1></html>");
    await request.response.close();
    onRequestParams.add(request.uri.queryParameters);
  }
}