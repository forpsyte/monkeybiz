import 'dart:async';
import 'dart:io';

abstract class LocalServerInterface {
  final StreamController<Map<String, String>> onRequestParams;
  final HttpServer server;

  LocalServerInterface(this.onRequestParams, this.server);

  Future<Stream<Map<String, String>>> start() {
    server.listen(_handleRequest);
    return Future.value(onRequestParams.stream);
  }
  
  void _handleRequest(HttpRequest request) async {
    handleRequest(request);
    await server.close(force: true);
    await onRequestParams.close();
  }
  
  void handleRequest(HttpRequest request);
}