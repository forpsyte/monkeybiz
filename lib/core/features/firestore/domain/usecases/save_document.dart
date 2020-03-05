import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../../../../usecases/usecase.dart';
import '../entities/document.dart';
import '../repositories/document_repository_interface.dart';

class SaveDocument extends UseCase<Document, Document> {
  final DocumentRepositoryInterface repository;

  SaveDocument(this.repository);

  @override
  Future<Either<Failure, Document>> call(Document document) async {
    return await repository.save(document);
  }
}