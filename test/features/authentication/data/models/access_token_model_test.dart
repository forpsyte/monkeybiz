import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mailchimp/features/authentication/data/models/access_token_model.dart';
import 'package:mailchimp/features/authentication/domain/entities/access_token.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tAccessTokenModel = AccessTokenModel(
    token: "5c6ccc561059aa386da9d112215bae55",
    expiresIn: 0,
    scope: null,
  );

  test(
    'should be a subclass of AccessToken entity',
    () async {
      // assert
      expect(tAccessTokenModel, isA<AccessToken>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid AccessTokenModel from json string',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = 
          json.decode(fixture('token_response.json'));
        // act
        final result = AccessTokenModel.fromJson(jsonMap);
        // assert
        expect(result, equals(tAccessTokenModel));
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tAccessTokenModel.toJson();
        // assert
        final expectedMap = {
          "access_token": "5c6ccc561059aa386da9d112215bae55",
          "expires_in": 0,
          "scope": null,
        };
        expect(result, equals(expectedMap));
      },
    );
  });
}
