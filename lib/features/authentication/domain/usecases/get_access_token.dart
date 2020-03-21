import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/access_token.dart';
import '../repositories/access_token_repository_interface.dart';

class GetAccessToken extends UseCase<AccessToken, OauthParams> {
  final AccessTokenRepositoryInterface repository;

  GetAccessToken(this.repository);

  @override
  Future<Either<Failure, AccessToken>> call([OauthParams params]) async {
    if (params == null) {
      return await repository.getCachedToken();
    }
    return await repository.getToken(
      params.clientId,
      params.accessTokenUri,
      params.redirectUri,
    );
  }
}
