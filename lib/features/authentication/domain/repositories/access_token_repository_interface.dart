import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/access_token.dart';

abstract class AccessTokenRepositoryInterface {
  Future<Either<Failure, AccessToken>> getToken(
    String clientId,
    String clientSecret,
    String redirectUri,
  );

  Future<Either<Failure, AccessToken>> getCachedToken();
}
