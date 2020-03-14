import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../entities/document.dart';

abstract class DocumentRepositoryInterface {
  Future<Either<Failure, List<Document>>> getList([bool cache = false]);
  Future<Either<Failure, Document>> getById(String id, [bool cache = false]);
  Future<Either<Failure, Document>> save(Document doc);
  Future<Either<Failure, void>> delete(Document doc);
  Future<Either<Failure, void>> deleteById(String id);
}