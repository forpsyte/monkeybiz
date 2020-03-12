import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailchimp/core/features/firestore/domain/repositories/document_repository_interface.dart';
import 'package:mailchimp/core/features/firestore/domain/usecases/delete_document_by_id.dart';

class MockDocumentRepository extends Mock
    implements DocumentRepositoryInterface {}

void main() {
  MockDocumentRepository mockDocumentRepository;
  DeleteDocumentById usecase;

  setUp((){
    mockDocumentRepository = MockDocumentRepository();
    usecase = DeleteDocumentById(mockDocumentRepository);
  });

  var testId = 'testId';

  test(
    'should delete a document by ID when call is made to the repository',
    () async {
      // act
      await usecase(testId);
      // assert
      verify(mockDocumentRepository.deleteById(testId));
      verifyNoMoreInteractions(mockDocumentRepository);
    },
  );
}