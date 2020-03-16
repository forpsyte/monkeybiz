import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info_interface.dart';
import '../../domain/entities/access_token.dart';
import '../../domain/repositories/access_token_repository_interface.dart';
import '../datasources/access_token_local_data_source_interface.dart';
import '../datasources/access_token_remote_data_source_interface.dart';

class AccessTokenRepository implements AccessTokenRepositoryInterface {
  final AccessTokenRemoteDataSourceInterface remoteDataSource;
  final AccessTokenLocalDataSourceInterface localDataSource;
  final NetworkInfoInterface networkInfo;

  AccessTokenRepository({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, AccessToken>> getToken(
    String clientId,
    String clientSecret,
    String redirectUri,
  ) async {
    if (await networkInfo.isConnected) {
      final token = await remoteDataSource.getToken(clientId, clientSecret, redirectUri);
      return Right(token);
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, AccessToken>> getCachedToken() async {
    final token = await localDataSource.getToken();
    if (token == null) {
      return Left(CacheFailure());
    }
    return Right(token);
  }
}