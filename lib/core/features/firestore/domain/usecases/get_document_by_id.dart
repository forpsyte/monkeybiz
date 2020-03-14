import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../../../../usecases/usecase.dart';
import '../entities/document.dart';
import '../repositories/document_repository_interface.dart';

class GetDocumentById extends UseCase<Document, String> {
  final DocumentRepositoryInterface repository;

  GetDocumentById(this.repository);

  @override
  Future<Either<Failure, Document>> call(String documentId, [bool cache = false]) async {
    return await repository.getById(documentId, cache);
  }
}

