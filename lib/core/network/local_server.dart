import 'dart:async';
import 'dart:io';

import 'local_server_interface.dart';

class LocalServer extends LocalServerInterface {
  final StreamController<Map<String, String>> onRequestParams;
  final HttpServer server;

  LocalServer({
    StreamController<Map<String, String>> stream,
    HttpServer httpServer,
  })  : assert(stream != null),
        assert(httpServer != null),
        this.onRequestParams = stream,
        this.server = httpServer,
        super(stream, httpServer);

  @override
  void handleRequest(HttpRequest request) async {
    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", ContentType.html.mimeType)
      ..write("<html></html>");
    await request.response.close();
    onRequestParams.add(request.uri.queryParameters);
  }
}
