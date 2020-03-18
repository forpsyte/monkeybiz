import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailchimp/core/error/failures.dart';
import 'package:mailchimp/core/usecases/usecase.dart';
import 'package:mailchimp/features/authentication/domain/repositories/access_token_repository_interface.dart';
import 'package:mailchimp/features/authentication/domain/usecases/remove_access_token.dart';
import 'package:mockito/mockito.dart';

class MockAccessTokenRepository extends Mock
    implements AccessTokenRepositoryInterface {}

void main() {
  MockAccessTokenRepository mockAccessTokenRepository;
  RemoveAccessToken usecase;

  setUp((){
    mockAccessTokenRepository = MockAccessTokenRepository();
    usecase = RemoveAccessToken(mockAccessTokenRepository);
  });

  test(
    'should return true when call to repository is unsuccessful',
    () async {
      // arrange
      when(mockAccessTokenRepository.removeToken())
          .thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, equals(Right(true)));
      verify(mockAccessTokenRepository.removeToken());
    },
  );

  test(
    'should return CacheFailure when call to repository is unsuccessful',
    () async {
      // arrange
      when(mockAccessTokenRepository.removeToken())
          .thenAnswer((_) async => Left(CacheFailure()));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Left(CacheFailure()));
    },
  );
}