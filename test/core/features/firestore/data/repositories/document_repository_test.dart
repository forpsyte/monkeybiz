import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:mailchimp/core/error/exceptions.dart';
import 'package:mailchimp/core/error/failures.dart';
import 'package:mailchimp/core/features/firestore/data/datasources/document_local_data_source_interface.dart';
import 'package:mailchimp/core/features/firestore/data/datasources/document_remote_data_source_interface.dart';
import 'package:mailchimp/core/features/firestore/data/models/document_model.dart';
import 'package:mailchimp/core/features/firestore/data/repositories/document_repository.dart';
import 'package:mailchimp/core/network/network_info_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockDocumentRemoteDataSource extends Mock
    implements DocumentRemoteDataSourceInterface {}

class MockDocumentLocalDataSource extends Mock
    implements DocumentLocalDataSourceInterface {}

class MockNetworkInfo extends Mock
    implements NetworkInfoInterface {}

void main() {
  DocumentRepository repository;
  MockDocumentRemoteDataSource mockRemoteDataSource;
  MockDocumentLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockDocumentRemoteDataSource();
    mockLocalDataSource = MockDocumentLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = DocumentRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tDocument = DocumentModel.fromJson(json.decode(fixture('document.json')));
  
  final tDocumentList = [
    tDocument,
    tDocument,
  ];

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  test(
    'should check if device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getList();
      // assert
      verify(mockNetworkInfo.isConnected);
    },
  );

  runTestsOnline(() {
    group('getList', () {
      test(
        'should return remote data when call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getList())
              .thenAnswer((_) async => tDocumentList);
          // act
          final result = await repository.getList();
          // assert
          expect(result, equals(Right(tDocumentList)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getList())
              .thenAnswer((_) async => tDocumentList);
          // act
          await repository.getList();
          // assert
          verify(mockRemoteDataSource.getList());
          verify(mockLocalDataSource.cacheList(tDocumentList));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getList())
              .thenThrow(ServerException());
          // act
          final result = await repository.getList();
          // assert
          verify(mockRemoteDataSource.getList());
          verifyNoMoreInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('getById', () {
      test(
        'should return remote data when call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getById(any))
              .thenAnswer((_) async => tDocument);
          // act
          final result = await repository.getById('testid');
          // assert
          expect(result, Right(tDocument));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getById(any))
              .thenAnswer((_) async => tDocument);
          // act
          await repository.getById('testid');
          // assert
          verify(mockRemoteDataSource.getById('testid'));
          verify(mockLocalDataSource.cache(tDocument));
        },
      );

      test(
        'should return remote data when call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getById(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getById('testid');
          // assert
          verify(mockRemoteDataSource.getById(any));
          verifyNoMoreInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
  });
}
