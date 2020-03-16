import 'package:mailchimp/features/authentication/domain/entities/access_token.dart';

import 'access_token_local_data_source_interface.dart';

class AccessTokenLocalDataSource implements AccessTokenLocalDataSourceInterface {

  @override
  Future<bool> setToken(AccessToken token) {
    // TODO: implement setToken
    return null;
  }

  @override
  Future<AccessToken> getToken() {
    // TODO: implement getToken
    return null;
  }

  @override
  Future<bool> removeToken() {
    // TODO: implement removeToken
    return null;
  }
}