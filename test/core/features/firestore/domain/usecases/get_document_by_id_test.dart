import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailchimp/core/features/firestore/domain/entities/document.dart';
import 'package:mailchimp/core/features/firestore/domain/repositories/document_repository_interface.dart';
import 'package:mailchimp/core/features/firestore/domain/usecases/get_document_by_id.dart';

class MockDocumentRepository extends Mock
    implements DocumentRepositoryInterface {}

void main() {
  GetDocumentById usecase;
  MockDocumentRepository mockDocumentRepository;

  setUp(() {
    mockDocumentRepository = MockDocumentRepository();
    usecase = GetDocumentById(mockDocumentRepository);
  });

  final Document tDocument = Document(
    id: 'testId',
    data: {'test_field': 1},
  );

  test(
    'should return the document specified by the id',
    () async {
      // arrange
      when(mockDocumentRepository.getById(any))
          .thenAnswer((_) async => Right(tDocument));
      // act
      final result = await usecase('testId');
      // assert
      expect(result, Right(tDocument));
      verify(mockDocumentRepository.getById('testId'));
      verifyNoMoreInteractions(mockDocumentRepository);
    },
  );
}
