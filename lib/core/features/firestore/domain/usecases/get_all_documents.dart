import 'package:dartz/dartz.dart';
import 'package:mailchimp/core/features/firestore/domain/repositories/document_repository_interface.dart';

import '../../../../error/failures.dart';
import '../../../../usecases/usecase.dart';
import '../entities/document.dart';

class GetAllDocuments extends UseCase<List<Document>, NoParams> {
  final DocumentRepositoryInterface repository;

  GetAllDocuments(this.repository);

  @override
  Future<Either<Failure, List<Document>>> call(NoParams params, [bool cache = false]) async {
    return await repository.getList(cache);
  }
}
