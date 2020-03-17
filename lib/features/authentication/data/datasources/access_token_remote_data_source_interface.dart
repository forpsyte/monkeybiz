import '../models/access_token_model.dart';

abstract class AccessTokenRemoteDataSourceInterface {
  Future<AccessTokenModel> getToken(String clientId, String clientSecret, String redirectUri);
}