import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AccessToken extends Equatable{
  final String token;
  final int expiresIn;
  final String scope;

  AccessToken({
    @required this.token,
    @required this.expiresIn,
    @required this.scope,
  });

  @override
  List<Object> get props => [token, expiresIn, scope];
}
