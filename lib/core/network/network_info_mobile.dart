import 'network_info_interface.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class NetworkInfoMobile implements NetworkInfoInterface {
  final DataConnectionChecker connectionChecker;

  NetworkInfoMobile(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}