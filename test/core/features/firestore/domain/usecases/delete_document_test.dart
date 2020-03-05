import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailchimp/core/features/firestore/domain/entities/document.dart';
import 'package:mailchimp/core/features/firestore/domain/repositories/document_repository_interface.dart';
import 'package:mailchimp/core/features/firestore/domain/usecases/delete_document.dart';

class MockDocumentRepository extends Mock
    implements DocumentRepositoryInterface {}

void main() {
  MockDocumentRepository mockDocumentRepository;
  DeleteDocument usecase;

  setUp((){
    mockDocumentRepository = MockDocumentRepository();
    usecase = DeleteDocument(mockDocumentRepository);
  });

  final Document tDocument = Document(
    id: 'testId',
    data: {'test_field': 1},
  );

  test(
    'should return true when document is deleted successfully',
    () async {
      // arrange
      when(mockDocumentRepository.delete(any))
          .thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(tDocument);
      // assert
      expect(result, Right(true));
      verify(mockDocumentRepository.delete(tDocument));
      verifyNoMoreInteractions(mockDocumentRepository);
    },
  );
}