import 'package:dartz/dartz.dart';
import 'package:mailchimp/features/authentication/data/models/access_token_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mailchimp/core/error/exceptions.dart';
import 'package:mailchimp/core/error/failures.dart';
import 'package:mailchimp/core/network/network_info_interface.dart';
import 'package:mailchimp/features/authentication/data/datasources/access_token_local_data_source.dart';
import 'package:mailchimp/features/authentication/data/datasources/access_token_remote_data_source.dart';
import 'package:mailchimp/features/authentication/data/repositories/access_token_repository.dart';

class MockAccessTokenRemoteDataSource extends Mock
    implements AccessTokenRemoteDataSource {}

class MockAccessTokenLocalDataSource extends Mock
    implements AccessTokenLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfoInterface {}

void main() {
  AccessTokenRepository repository;
  MockAccessTokenRemoteDataSource mockRemoteDataSource;
  MockAccessTokenLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAccessTokenRemoteDataSource();
    mockLocalDataSource = MockAccessTokenLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AccessTokenRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tClientId = 'test_client_id';
  final tClientSecret = 'test_client_secret';
  final tRedirectUri = 'http://127.0.0.1:8080';

  final tAccessToken = AccessTokenModel(
    token: '5c6ccc561059aa386da9d112215bae55',
    expiresIn: 0,
    scope: null,
  );

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getToken', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) async => true);
        // act
        repository.getToken(tClientId, tClientSecret, tRedirectUri);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline((){
      test(
        'should return remote data when call to remote datasource is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getToken(tClientId, tClientSecret, tRedirectUri))
            .thenAnswer((_) async => tAccessToken);
          // act
          final result = await repository.getToken(tClientId, tClientSecret, tRedirectUri);
          // assert
          expect(result, equals(Right(tAccessToken)));
        },
      );

      test(
        'should cache the result when call to remote datasource is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getToken(tClientId, tClientSecret, tRedirectUri))
            .thenAnswer((_) async => tAccessToken);
          // act
          await repository.getToken(tClientId, tClientSecret, tRedirectUri);
          // assert
          verify(mockLocalDataSource.setToken(tAccessToken));
        },
      );

      test(
        'should return AuthenticationFailure when call to remote datasource is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getToken(tClientId, tClientSecret, tRedirectUri))
              .thenThrow(AuthenticationException());
          // act
          final result = await repository.getToken(tClientId, tClientSecret, tRedirectUri);
          // assert
          expect(result, equals(Left(AuthenticationFailure())));
      
        },
      );
    });

    runTestsOffline((){
      test(
        'should return ConnectionFailure when the device is offline',
        () async {
          // act
          final result = await repository.getToken(tClientId, tClientSecret, tRedirectUri);
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('getCachedToken', () {
    test(
      'should return AccessToken when call to local datasource successful',
      () async {
        // arrange
        when(mockLocalDataSource.getToken())
            .thenAnswer((_) async => tAccessToken);
        // act
        final result = await repository.getCachedToken();
        // assert
        expect(result, equals(Right(tAccessToken)));
      },
    );

    test(
      'should return CacheFailure when call to local datasource unsuccessful',
      () async {
        // arrange
        when(mockLocalDataSource.getToken())
            .thenAnswer((_) async => null);
        // act
        final result = await repository.getCachedToken();
        // assert
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });
}
