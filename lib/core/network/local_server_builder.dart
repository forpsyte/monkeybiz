import 'dart:async';
import 'dart:io';

import 'local_server.dart';
import 'local_server_interface.dart';

class LocalServerBuilder {
  Future<LocalServerInterface> build() async {
    final HttpServer server =
      await HttpServer.bind(InternetAddress.loopbackIPv4, 8080, shared: true);
    return LocalServer(
      stream: StreamController<Map<String, String>>(),
      httpServer: server
    );
  }
}