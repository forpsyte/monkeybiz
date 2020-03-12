import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:mailchimp/core/features/firestore/data/models/document_model.dart';
import 'package:mailchimp/core/features/firestore/domain/entities/document.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockDocumentSnapshot extends Mock 
    implements DocumentSnapshot {}

void main() {
  MockDocumentSnapshot mockDocumentSnapshot;

  setUp(() {
    mockDocumentSnapshot = MockDocumentSnapshot();
  });

  final Map<String,dynamic> tDocumentSnapshotData = {
    'double': 2.0,
    'int': 1,
    'bool': true,
    'string': 'test string',
    'array': [ "Ford", "BMW", "Fiat" ],
    'datetime': DateTime.parse("1969-07-20 20:18:04Z"),
  };

  final tDocumentModel = DocumentModel(
    id: 'testid',
    data: tDocumentSnapshotData,
  );

  final tDocumentId = 'testid';

  test(
    'should be a subclass of Document',
    () async {
      // assert
      expect(tDocumentModel, isA<Document>());
    },
  );

  test(
    'should return a valid DocumentModel from a DocumentSnapshot object',
    () async {
      // arrange
      when(mockDocumentSnapshot.data)
          .thenReturn(tDocumentSnapshotData);
      when(mockDocumentSnapshot.documentID)
          .thenReturn(tDocumentId);
      // act
      final result = DocumentModel.fromDocumentSnapshot(mockDocumentSnapshot);
      // assert
      expect(result, equals(tDocumentModel));
      verify(mockDocumentSnapshot.data);
      verify(mockDocumentSnapshot.documentID);
    },
  );

  group('fromJson', () {
    test(
      'should return a valid DocumentModel from a json string',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = 
            json.decode(fixture('document.json'));
        // act
        final result = DocumentModel.fromJson(jsonMap);
        // assert
        expect(result, isA<DocumentModel>());
      },
    );

    test(
      'should return a valid DocumentModel with fields that have the correct datatypes',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = 
            json.decode(fixture('document.json'));
        // act
        final result = DocumentModel.fromJson(jsonMap);
        // assert
        expect(result, equals(tDocumentModel));
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tDocumentModel.toJson();
        // assert
        final Map<String,dynamic> expectedMap = {
          'document_id': 'testid',
          'data': {
            'double': 2.0,
            'int': 1,
            'bool': true,
            'string': 'test string',
            'array': [ "Ford", "BMW", "Fiat" ],
            'datetime': DateTime.parse("1969-07-20 20:18:04Z"),
          },
        };
        expect(result, equals(expectedMap));
      },
    );
  });

  group('field', () {
    test(
      'should return the field value specified by the name/key',
      () async {
        // arrange
        final name = 'double';
        // act
        final result = tDocumentModel.field(name);
        // assert
        expect(result, equals(2.0));
      },
    );
  });
}
