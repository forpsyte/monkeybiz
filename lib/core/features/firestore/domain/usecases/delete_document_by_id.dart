import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../../../../usecases/usecase.dart';
import '../repositories/document_repository_interface.dart';

class DeleteDocumentById extends UseCase<void, String> {
  final DocumentRepositoryInterface repository;

  DeleteDocumentById(this.repository);

  @override
  Future<Either<Failure, void>> call(String documentId) async {
    return await repository.deleteById(documentId);
  }
}