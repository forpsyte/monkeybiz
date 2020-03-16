import '../../domain/entities/access_token.dart';
import 'access_token_remote_data_source_interface.dart';

class AccessTokenRemoteDataSource implements AccessTokenRemoteDataSourceInterface {
  @override
  Future<AccessToken> getToken(String clientId, String clientSecret, String redirectUri) {
    // TODO: implement getToken
    return null;
  }
}