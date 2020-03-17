import 'dart:convert';

import 'package:mailchimp/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/access_token_model.dart';
import 'access_token_local_data_source_interface.dart';

const ACCESS_TOKEN = 'access_token';

class AccessTokenLocalDataSource
    implements AccessTokenLocalDataSourceInterface {
  final SharedPreferences sharedPreferences;

  AccessTokenLocalDataSource({
    @required this.sharedPreferences,
  });

  @override
  Future<bool> setToken(AccessTokenModel token) async{
    final jsonString = json.encode(token.toJson());
    return await sharedPreferences.setString(ACCESS_TOKEN, jsonString);
  }

  @override
  Future<AccessTokenModel> getToken() {
    if (!(sharedPreferences.containsKey(ACCESS_TOKEN))) {
      throw CacheException();
    }
    final jsonString = sharedPreferences.getString(ACCESS_TOKEN);
    final token = AccessTokenModel.fromJson(json.decode(jsonString));
    return Future.value(token);
  }

  @override
  Future<bool> removeToken() {
    if (!(sharedPreferences.containsKey(ACCESS_TOKEN))) {
      throw CacheException();
    }
    return sharedPreferences.remove(ACCESS_TOKEN);
  }
}
