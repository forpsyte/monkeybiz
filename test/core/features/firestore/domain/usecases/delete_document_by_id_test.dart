import 'package:dartz/dartz.dart';
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
    'should return true when document specified by id is delete successfully',
    () async {
      // arrange
      when(mockDocumentRepository.deleteById(any))
          .thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(testId);
      // assert
      expect(result, Right(true));
      verify(mockDocumentRepository.deleteById(testId));
      verifyNoMoreInteractions(mockDocumentRepository);
    },
  );
}