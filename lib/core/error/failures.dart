import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import 'exceptions.dart';

abstract class Failure extends Equatable {
  final Exception exception;
  
  Failure([this.exception]);

  String get message => exception.toString();
}

// General failures
class ServerFailure extends Failure {
  final ServerException exception;

  ServerFailure([this.exception]);
  
  @override
  List<Object> get props => [];
}

class ConnectionFailure extends Failure{
  final ConnectionException exception;

  ConnectionFailure([this.exception]);

  @override
  List<Object> get props => [];
}

class CacheFailure extends Failure {
  final CacheException exception;

  CacheFailure([this.exception]);

  @override
  List<Object> get props => [exception];
}

class DuplicateFailure extends Failure {
  final DuplicateException exception;

  DuplicateFailure([this.exception]);
  
  @override
  List<Object> get props => [];
}

class PlatformFailure extends Failure {
  final PlatformException exception;

  PlatformFailure([this.exception]);

  @override
  List<Object> get props => [];
}

class MissingPluginFailure extends Failure {
  final MissingPluginException exception;

  MissingPluginFailure([this.exception]);

  @override
  List<Object> get props => [];
}

class InvalidEmailFailure extends Failure {
  @override
  List<Object> get props => [];
}

class AuthenticationFailure extends Failure {
  final AuthenticationException exception;

  AuthenticationFailure([this.exception]);

  @override
  List<Object> get props => [];
}