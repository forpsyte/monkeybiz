import 'package:dartz/dartz.dart';
import 'package:mailchimp/core/error/failures.dart';
import 'package:mailchimp/core/usecases/usecase.dart';
import 'package:mailchimp/features/authentication/domain/repositories/access_token_repository_interface.dart';

class RemoveAccessToken extends UseCase<bool, NoParams> {
  final AccessTokenRepositoryInterface repository;

  RemoveAccessToken(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.removeToken();
  }
}