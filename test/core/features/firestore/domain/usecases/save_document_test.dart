import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailchimp/core/features/firestore/domain/entities/document.dart';
import 'package:mailchimp/core/features/firestore/domain/repositories/document_repository_interface.dart';
import 'package:mailchimp/core/features/firestore/domain/usecases/save_document.dart';

class MockDocumentRepository extends Mock
    implements DocumentRepositoryInterface {}

void main() {
  MockDocumentRepository mockDocumentRepository;
  SaveDocument usecase;

  setUp(() {
    mockDocumentRepository = MockDocumentRepository();
    usecase = SaveDocument(mockDocumentRepository);
  });

  final Document tDocument = Document(
    id: 'testId',
    data: {'test_field': 1},
  );

  test(
    'should return the document that was saved successfully',
    () async {
      // arrange
      when(mockDocumentRepository.save(any))
          .thenAnswer((_) async => Right(tDocument));
      // act
      final result = await usecase(tDocument);
      // assert
      expect(result, Right(tDocument));
      verify(mockDocumentRepository.save(tDocument));
      verifyNoMoreInteractions(mockDocumentRepository);
    },
  );
}