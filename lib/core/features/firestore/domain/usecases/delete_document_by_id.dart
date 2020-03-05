import 'package:dartz/dartz.dart';
import 'package:mailchimp/core/error/failures.dart';
import 'package:mailchimp/core/features/firestore/domain/repositories/document_repository_interface.dart';
import 'package:mailchimp/core/usecases/usecase.dart';

class DeleteDocumentById extends UseCase<bool, String> {
  final DocumentRepositoryInterface repository;

  DeleteDocumentById(this.repository);

  @override
  Future<Either<Failure, bool>> call(String documentId) async {
    return await repository.deleteById(documentId);
  }
}