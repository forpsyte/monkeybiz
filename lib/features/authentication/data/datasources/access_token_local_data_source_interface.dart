import '../../domain/entities/access_token.dart';

abstract class AccessTokenLocalDataSourceInterface {
  Future<AccessToken> getToken();
  Future<bool> setToken(AccessToken token);
  Future<bool> removeToken();
}