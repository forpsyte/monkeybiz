import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/access_token.dart';
import '../repositories/access_token_repository_interface.dart';

class GetAccessToken extends UseCase<AccessToken, RequestParams> {
  final AccessTokenRepositoryInterface repository;

  GetAccessToken(this.repository);

  @override
  Future<Either<Failure, AccessToken>> call(RequestParams params) async {
    return await repository.getToken(
      params.fields['client_id'],
      params.fields['client_secret'],
      params.fields['redirect_uri'],
    );
  }
}
