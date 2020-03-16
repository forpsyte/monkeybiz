import 'package:mailchimp/features/authentication/domain/entities/access_token.dart';

class AccessTokenModel extends AccessToken {
  final String token;
  final int expiresIn;
  final String scope;

  AccessTokenModel({
    this.token,
    this.expiresIn,
    this.scope,
  }) : super(token: token, expiresIn: expiresIn, scope: scope);

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) {
    return AccessTokenModel(
      token: json['access_token'],
      expiresIn: (json['expires_in'] as num).toInt(),
      scope: json['scope'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access_token": token,
      "expires_in": expiresIn,
      "scope": scope
    };
  }
}
