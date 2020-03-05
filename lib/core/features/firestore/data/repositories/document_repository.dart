import 'package:dartz/dartz.dart';
import 'package:mailchimp/core/error/exceptions.dart';
import 'package:meta/meta.dart';

import '../../../../error/failures.dart';
import '../../../../network/network_info_interface.dart';
import '../../domain/entities/document.dart';
import '../../domain/repositories/document_repository_interface.dart';
import '../datasources/document_local_data_source_interface.dart';
import '../datasources/document_remote_data_source_interface.dart';

class DocumentRepository implements DocumentRepositoryInterface {
  final DocumentRemoteDataSourceInterface remoteDataSource;
  final DocumentLocalDataSourceInterface localDataSource;
  final NetworkInfoInterface networkInfo;

  DocumentRepository({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });
  @override
  Future<Either<Failure, bool>> delete(Document doc) {
    // TODO: implement delete
    return null;
  }

  @override
  Future<Either<Failure, bool>> deleteById(String doc) {
    // TODO: implement deleteById
    return null;
  }

  @override
  Future<Either<Failure, Document>> getById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final document = await remoteDataSource.getById(id);
        localDataSource.cache(document);
        return Right(document);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Document>>> getList() async {
    if (await networkInfo.isConnected) {
      try {
        final documents = await remoteDataSource.getList();
        localDataSource.cacheList(documents);
        return Right(documents);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Document>> save(Document doc) {
    // TODO: implement save
    return null;
  }
}
