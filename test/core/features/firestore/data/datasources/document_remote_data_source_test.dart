import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mailchimp/core/error/exceptions.dart';
import 'package:mailchimp/core/features/firestore/data/datasources/document_remote_data_source.dart';
import 'package:mailchimp/core/features/firestore/data/models/document_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

class MockFirestore extends Mock implements Firestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockQuery extends Mock implements Query {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockStream<MockQuerySnapshot> extends Mock
    implements Stream<QuerySnapshot> {}

void main() {
  DocumentRemoteDataSource dataSource;
  MockFirestore mockFirestore;
  String collection;
  MockCollectionReference mockCollectionReference;
  MockQuerySnapshot mockQuerySnapshot;
  MockDocumentSnapshot mockDocumentSnapshot1;
  MockDocumentSnapshot mockDocumentSnapshot2;
  MockDocumentSnapshot mockDocumentSnapshot3;
  MockDocumentReference mockDocumentReference;
  List<DocumentSnapshot> documents;

  setUp(() {
    mockFirestore = MockFirestore();
    mockCollectionReference = MockCollectionReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockDocumentSnapshot1 = MockDocumentSnapshot();
    mockDocumentSnapshot2 = MockDocumentSnapshot();
    mockDocumentSnapshot3 = MockDocumentSnapshot();
    mockDocumentReference = MockDocumentReference();
    collection = 'test';
    dataSource = DocumentRemoteDataSource(
        firestore: mockFirestore, collection: collection);
    documents = [
      mockDocumentSnapshot1,
      mockDocumentSnapshot2,
      mockDocumentSnapshot3,
    ];
  });

  final Map<String, dynamic> tDocumentSnapshotData = {
    'double': 2.0,
    'int': 1,
    'bool': true,
    'string': 'test string',
    'array': ["Ford", "BMW", "Fiat"],
    'datetime': DateTime.parse("1969-07-20 20:18:04Z"),
  };

  final tDocumentModel1 = DocumentModel(
    id: '1',
    data: tDocumentSnapshotData,
  );

  final tDocumentModel2 = DocumentModel(
    id: '2',
    data: tDocumentSnapshotData,
  );

  final tDocumentModel3 = DocumentModel(
    id: '3',
    data: tDocumentSnapshotData,
  );

  final tDocumentModelBeforeSave = DocumentModel(
    data: tDocumentSnapshotData,
  );

  final tDocumentModelAfterSave = DocumentModel(
    id: 'testId',
    data: tDocumentSnapshotData,
  );

  final List<DocumentModel> testDocumentModelList = [
    tDocumentModel1,
    tDocumentModel2,
    tDocumentModel3,
  ];

  void setupMockDocumentSnapshots() {
    when(mockDocumentSnapshot1.data)
        .thenReturn(tDocumentSnapshotData);
    when(mockDocumentSnapshot1.documentID)
        .thenReturn('1');

    when(mockDocumentSnapshot2.data)
        .thenReturn(tDocumentSnapshotData);
    when(mockDocumentSnapshot2.documentID)
        .thenReturn('2');

    when(mockDocumentSnapshot3.data)
        .thenReturn(tDocumentSnapshotData);
    when(mockDocumentSnapshot3.documentID)
        .thenReturn('3');
  }

  void setupMockFirestoreSuccess() {
    when(mockQuerySnapshot.documents)
        .thenReturn(documents);

    when(mockCollectionReference.getDocuments())
        .thenAnswer((_) async => mockQuerySnapshot);

    when(mockFirestore.collection(any))
        .thenReturn(mockCollectionReference);
  }

  void setupMockFirestoreFailure() {
    when(mockCollectionReference.getDocuments())
        .thenThrow(PlatformException(code: 'test-code'));

    when(mockFirestore.collection(any))
        .thenReturn(mockCollectionReference);
  }

  group('getList', () {
    test(
      'should return a DocumentModel list when call to firestore is successful',
      () async {
        // arrange
        setupMockDocumentSnapshots();
        setupMockFirestoreSuccess();
        // act
        final result = await dataSource.getList();
        // assert
        expect(result, equals(testDocumentModelList));
      },
    );

    test(
      'should throw a ServerException when call to firestore is unsuccessful',
      () async {
        // arrange
        setupMockFirestoreFailure();
        // act
        final call = dataSource.getList;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getById', () {
    test(
      'should return a DocumentModel when call to firestore is successful',
      () async {
        // arrange
        setupMockDocumentSnapshots();
        when(mockFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.document(any))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot1);
        // act
        final result = await dataSource.getById('1');
        // assert
        expect(result, equals(tDocumentModel1));
      },
    );

    test(
      'should return null when a document with specified ID does not exist',
      () async {
        // arrange
        when(mockFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.document(any))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => null);
        // act
        final result = await dataSource.getById('1');
        // assert
        expect(result, equals(null));
      },
    );
  });

  group('delete', () {
    test(
      'should delete the document when the call to firestore is successful',
      () async {
        // arrange
        when(mockFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.document(any))
            .thenReturn(mockDocumentReference);
        // act
        await dataSource.delete(tDocumentModel1);
        // assert
        verify(mockDocumentReference.delete());
      },
    );
  });

  group('deleteById', () {
    test(
      'should delete the document when the call to firestore is successful',
      () async {
        // arrange
        when(mockFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.document(any))
            .thenReturn(mockDocumentReference);
        // act
        await dataSource.deleteById('1');
        // assert
        verify(mockDocumentReference.delete());
      },
    );
  });

  group('save', () {
    test(
      'should save the document with specified ID when the call to firestore is successful',
      () async {
        // arrange
        when(mockFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.document(any))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.documentID)
            .thenReturn(tDocumentModel1.documentId);
        // act
        final result = await dataSource.save(tDocumentModel1);
        // assert
        expect(result, equals(tDocumentModel1));
        verify(mockCollectionReference.document(any));
      },
    );

    test(
      'should save the document with no specified ID when the call to firestore is successful',
      () async {
        // arrange
        when(mockFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.document(any))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.documentID)
            .thenReturn('testId');
        // act
        final result = await dataSource.save(tDocumentModelBeforeSave);
        // assert
        expect(result, equals(tDocumentModelAfterSave));
        expect(result.documentId, equals('testId'));
        verify(mockCollectionReference.document());
      },
    );
  });
}
