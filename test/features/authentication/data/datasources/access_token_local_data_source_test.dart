import 'package:flutter_test/flutter_test.dart';
import 'package:mailchimp/core/error/exceptions.dart';
import 'package:mailchimp/features/authentication/data/datasources/access_token_local_data_source.dart';
import 'package:mailchimp/features/authentication/data/models/access_token_model.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  AccessTokenLocalDataSource dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        AccessTokenLocalDataSource(sharedPreferences: mockSharedPreferences);
  });

  final tAccessToken = AccessTokenModel(
    token: '5c6ccc561059aa386da9d112215bae55',
    expiresIn: 0,
    scope: null,
  );

  final tCachedAccessModel = fixture('token_response.json');

  group('setToken', () {
    test(
      'should return true when the token is stored successfully',
      () async {
        // arrange
        when(mockSharedPreferences.setString(ACCESS_TOKEN, any))
            .thenAnswer((_) async => true);
        // act
        final result = await dataSource.setToken(tAccessToken);
        // assert
        expect(result, equals(true));
        verify(mockSharedPreferences.setString(ACCESS_TOKEN, any));
      },
    );
  });

  group('getToken', () {

    test(
      'should return AccessTokenModel from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(true);
        when(mockSharedPreferences.getString(any))
            .thenReturn(tCachedAccessModel);
        // act
        final result = await dataSource.getToken();
        // assert
        expect(result, equals(tAccessToken));
        verify(mockSharedPreferences.containsKey(any));
      },
    );

    test(
      'should throw a CacheException when there in no cache data present',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(false);
        // act
        final call = dataSource.getToken;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('removeToken', () {
    test(
      'should return true when token is removed from the cache successfully',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(true);
        when(mockSharedPreferences.remove(ACCESS_TOKEN))
            .thenAnswer((_) async => true);
        // act
        final result = await dataSource.removeToken();
        // assert
        expect(result, equals(true));
        verify(mockSharedPreferences.containsKey(any));
      },
    );

    test(
      'should throw a CacheException when there in no cache data present',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(false);
        // act
        final call = dataSource.removeToken;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });
}
