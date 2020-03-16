import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../error/exceptions.dart';
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
  Future<Either<Failure, void>> delete(Document doc) async {
    if (!(await networkInfo.isConnected)) {
      return Left(ConnectionFailure());
    }

    try {
      final result = await remoteDataSource.delete(doc);
      await localDataSource.delete(doc);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteById(String id) async {
    if (!(await networkInfo.isConnected)) {
      return Left(ConnectionFailure());
    }

    try {
      final result = await remoteDataSource.deleteById(id);
      await localDataSource.deleteById(id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Document>> getById(String id,
      [bool cache = false]) async {
    if (await networkInfo.isConnected) {
      try {
        final document = await remoteDataSource.getById(id);
        if (cache) {
          localDataSource.cache(document);
        }
        return Right(document);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final document = await localDataSource.getById(id);
        return Right(document);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Document>>> getList([bool cache = false]) async {
    if (await networkInfo.isConnected) {
      try {
        final documents = await remoteDataSource.getList();
        if (cache) {
          localDataSource.cacheList(documents);
        }
        return Right(documents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final documents = await localDataSource.getList();
        return Right(documents);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Document>> save(Document doc) async {
    if (!(await networkInfo.isConnected)) {
      return Left(ConnectionFailure());
    }

    try {
      final document = await remoteDataSource.save(doc);
      return Right(document);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
