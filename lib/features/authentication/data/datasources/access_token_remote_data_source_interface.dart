import 'package:mailchimp/features/authentication/domain/entities/access_token.dart';

abstract class AccessTokenRemoteDataSourceInterface {
  Future<AccessToken> getToken(String clientId, String clientSecret, String redirectUri);
}