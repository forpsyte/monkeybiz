import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class RequestParams extends Equatable {
  final Map<String, dynamic> fields;

  RequestParams({
    @required this.fields,
  });

  @override
  List<Object> get props => [fields];
}

class OauthParams extends Equatable {
  final String clientId;
  final String clientSecret;
  final String redirectUri;

  OauthParams({
    this.clientId,
    this.clientSecret,
    this.redirectUri,
  });

  @override
  List<Object> get props => [clientId, clientSecret, redirectUri];
}
