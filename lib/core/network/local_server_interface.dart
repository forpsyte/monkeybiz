import 'dart:async';
import 'dart:io';

abstract class LocalServerInterface {
  final StreamController<Map<String, String>> onRequestParams;
  final HttpServer server;

  LocalServerInterface(this.onRequestParams, this.server);

  Future<Stream<Map<String, String>>> start() {
    server.listen(handleRequest);
    return Future.value(onRequestParams.stream);
  }
  
  Future<void> stop() async {
    await onRequestParams.close();
    await server.close(force: true);
  }
  
  void handleRequest(HttpRequest request);
}