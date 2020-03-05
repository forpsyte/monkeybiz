import 'package:dartz/dartz.dart';
import 'package:mailchimp/core/usecases/usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailchimp/core/features/firestore/domain/entities/document.dart';
import 'package:mailchimp/core/features/firestore/domain/repositories/document_repository_interface.dart';
import 'package:mailchimp/core/features/firestore/domain/usecases/get_all_documents.dart';

class MockDocumentRepository extends Mock
    implements DocumentRepositoryInterface {}

void main() {
  GetAllDocuments usecase;
  MockDocumentRepository mockDocumentRepository;

  setUp(() {
    mockDocumentRepository = MockDocumentRepository();
    usecase = GetAllDocuments(mockDocumentRepository);
  });

  var tData = {
    'test_field_1': 1,
    'test_field_2': 2,
  };

  Document tDocument1 = Document(id: 'testId1', data: tData);
  Document tDocument2 = Document(id: 'testId2', data: tData);

  List<Document> tDocumentList = [tDocument1, tDocument2];

  test(
    'should get the list of documents from the repository',
    () async {
      // arrange
      when(mockDocumentRepository.getList())
          .thenAnswer((_) async => Right(tDocumentList));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, equals(Right(tDocumentList)));
      verify(mockDocumentRepository.getList());
      verifyNoMoreInteractions(mockDocumentRepository);
    },
  );
}
