import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailchimp/core/usecases/usecase.dart';
import 'package:mailchimp/features/authentication/domain/entities/access_token.dart';
import 'package:mailchimp/features/authentication/domain/repositories/access_token_repository_interface.dart';
import 'package:mailchimp/features/authentication/domain/usecases/get_access_token.dart';
import 'package:mockito/mockito.dart';

class MockAccessTokenRepository extends Mock
    implements AccessTokenRepositoryInterface {}

void main() {
  MockAccessTokenRepository mockAccessTokenRepository;
  GetAccessToken usecase;

  setUp(() {
    mockAccessTokenRepository = MockAccessTokenRepository();
    usecase = GetAccessToken(mockAccessTokenRepository);
  });

  final tClientId = 'test_client_id';
  final tClientSecret = 'test_client_secret';
  final tRedirectUri = 'http://127.0.0.1:8080';

  final tAccessToken =
      AccessToken(token: '5c6ccc561059aa386da9d112215bae55', expiresIn: 0, scope: null);

  test(
    'should return the AccessToken from the repository',
    () async {
      // arrange
      when(mockAccessTokenRepository.getToken(any, any, any))
          .thenAnswer((_) async => Right(tAccessToken));
      // act
      final result = await usecase(RequestParams(
        fields: {
          'client_id': tClientId,
          'client_secret': tClientSecret,
          'redirect_uri': tRedirectUri,
        },
      ));
      // assert
      expect(result, Right(tAccessToken));
			verify(mockAccessTokenRepository.getToken(tClientId, tClientSecret, tRedirectUri));
			verifyNoMoreInteractions(mockAccessTokenRepository);
    },
  );
}
