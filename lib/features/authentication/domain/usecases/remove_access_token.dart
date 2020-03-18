import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/access_token_repository_interface.dart';

class RemoveAccessToken extends UseCase<bool, NoParams> {
  final AccessTokenRepositoryInterface repository;

  RemoveAccessToken(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.removeToken();
  }
}