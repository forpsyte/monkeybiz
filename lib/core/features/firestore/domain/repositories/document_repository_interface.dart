import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../entities/document.dart';

abstract class DocumentRepositoryInterface {
  Future<Either<Failure, List<Document>>> getList();
  Future<Either<Failure, Document>> getById(String id);
  Future<Either<Failure, Document>> save(Document doc);
  Future<Either<Failure, bool>> delete(Document doc);
  Future<Either<Failure, bool>> deleteById(String doc);
}