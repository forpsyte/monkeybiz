import '../models/access_token_model.dart';

abstract class AccessTokenLocalDataSourceInterface {
  Future<AccessTokenModel> getToken();
  Future<bool> setToken(AccessTokenModel token);
  Future<bool> removeToken();
}