import 'dart:convert';

import 'package:mailchimp/core/error/exceptions.dart';
import 'package:mailchimp/core/features/firestore/data/datasources/document_local_data_soure.dart';
import 'package:mailchimp/core/features/firestore/data/models/document_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  DocumentLocalDataSource dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        DocumentLocalDataSource(sharedPreferences: mockSharedPreferences);
  });

  final Map<String, dynamic> tDocumentSnapshotData = {
    'double': 2.0,
    'int': 1,
    'bool': true,
    'string': 'test string',
    'array': ["Ford", "BMW", "Fiat"],
    'datetime': DateTime.parse("1969-07-20 20:18:04Z"),
  };

  final tDocumentModel = DocumentModel(
    id: 'testid',
    data: tDocumentSnapshotData,
  );

  final tDocumentModels = [
    tDocumentModel,
    tDocumentModel,
    tDocumentModel,
  ];

  final tCachedDocumentModel = json.encode(tDocumentModel.toJson());

  final tCachedDocumentModelList = [
    tCachedDocumentModel,
    tCachedDocumentModel,
    tCachedDocumentModel,
  ];

  group('cache', () {
    test(
      'should return true when call to cache data is successful',
      () async {
        // arrange
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);
        // act
        final result = await dataSource.cache(tDocumentModel);
        // assert
        final documentId = tDocumentModel.documentId;
        final encodedDoc = json.encode(tDocumentModel.toJson());
        expect(result, equals(true));
        verify(mockSharedPreferences.setString(documentId, encodedDoc));
      },
    );
  });

  group('cacheList', () {
    test(
      'should return true when call to cache data is successful',
      () async {
        // arrange
        when(mockSharedPreferences.setStringList(any, any))
            .thenAnswer((_) async => true);
        // act
        final result = await dataSource.cacheList(tDocumentModels);
        // assert
        expect(result, equals(true));
        verify(mockSharedPreferences.setStringList(
            DOCUMENT_LIST_CACHE_KEY, tCachedDocumentModelList));
      },
    );
  });

  group('clearList', () {
    test(
      'should return true when call to remove cached data is successful',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(true);
        when(mockSharedPreferences.remove(any))
          .thenAnswer((_) async => true);
        // act
        final result = await dataSource.clearList();
        // assert
        expect(result, equals(true));
        verify(mockSharedPreferences.remove(DOCUMENT_LIST_CACHE_KEY));
      },
    );

    test(
      'should throw a CacheException when there is no cached data present',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(false);
        // act
        final call = dataSource.clearList;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
        verify(mockSharedPreferences.containsKey(DOCUMENT_LIST_CACHE_KEY));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
  });

  group('delete', () {
    test(
      'should return true when call to remove cached data is successful',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(true);
        when(mockSharedPreferences.remove(any))
          .thenAnswer((_) async => true);
        // act
        final result = await dataSource.delete(tDocumentModel);
        // assert
        expect(result, equals(true));
        verify(mockSharedPreferences.remove(tDocumentModel.documentId));
      },
    );

    test(
      'should throw a CacheException when there is no cached data present',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(false);
        // act
        final call = dataSource.delete;
        // assert
        expect(() => call(tDocumentModel), throwsA(TypeMatcher<CacheException>()));
        verify(mockSharedPreferences.containsKey(tDocumentModel.documentId));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
  });

  group('deleteById', () {
    test(
      'should return true when call to remove cached data is successful',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(true);
        when(mockSharedPreferences.remove(any))
          .thenAnswer((_) async => true);
        // act
        final result = await dataSource.deleteById('testid');
        // assert
        expect(result, equals(true));
        verify(mockSharedPreferences.remove(tDocumentModel.documentId));
      },
    );

    test(
      'should throw a CacheException when there is no cached data present',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(false);
        // act
        final call = dataSource.deleteById;
        // assert
        expect(() => call('testid'), throwsA(TypeMatcher<CacheException>()));
        verify(mockSharedPreferences.containsKey('testid'));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
  });

  group('getById', () {
    test(
      'should return DocumentModel when there is string specified by ID in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(true);
        when(mockSharedPreferences.getString(any))
            .thenReturn(tCachedDocumentModel);
        // act
        final result = await dataSource.getById('testid');
        // assert
        expect(result, equals(tDocumentModel));
        verify(mockSharedPreferences.getString('testid'));
      },
    );

    test(
      'should throw a CacheException when there is no cache data present',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(false);
        // act
        final call = dataSource.getById;
        // assert
        expect(() => call('testid'), throwsA(TypeMatcher<CacheException>()));
        verify(mockSharedPreferences.containsKey('testid'));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
  });

  group('getList', () {
    test(
      'should return List<DocumentModel> when there is a string list in cache',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(true);
        when(mockSharedPreferences.getStringList(any))
            .thenReturn(tCachedDocumentModelList);
        // act
        final result = await dataSource.getList();
        // assert
        expect(result, equals(tDocumentModels));
        verify(mockSharedPreferences.getStringList(DOCUMENT_LIST_CACHE_KEY));
      },
    );

    test(
      'should throw a CacheException when there is no cache data present',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any))
            .thenReturn(false);
        // act
        final call = dataSource.getList;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
        verify(mockSharedPreferences.containsKey(DOCUMENT_LIST_CACHE_KEY));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
  });
}
