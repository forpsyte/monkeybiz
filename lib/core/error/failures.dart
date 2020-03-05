import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const<dynamic>[]]);
}

// General failures
class ServerFailure extends Failure {
  @override
  List<Object> get props => [];
}

class ConnectionFailure extends Failure{
  @override
  List<Object> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}

class DuplicateFailure extends Failure {
  @override
  List<Object> get props => [];
}

class PlatformFailure extends Failure {
  @override
  List<Object> get props => [];
}

class MissingPluginFailure extends Failure {
  @override
  List<Object> get props => [];
}

class InvalidEmailFailure extends Failure {
  @override
  List<Object> get props => [];
}