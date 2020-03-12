import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../../../../usecases/usecase.dart';
import '../entities/document.dart';
import '../repositories/document_repository_interface.dart';

class DeleteDocument extends UseCase<void, Document> {
  final DocumentRepositoryInterface repository;

  DeleteDocument(this.repository);
  
  @override
  Future<Either<Failure, void>> call(Document document) async {
    return await repository.delete(document);
  }
}