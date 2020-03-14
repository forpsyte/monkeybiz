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

class MockNetworkInfo extends Mock implements NetworkInfoInterface {}

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

  final testId = 'testid';

  final tDocument =
      DocumentModel.fromJson(json.decode(fixture('document.json')));

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

  group('getList', () {
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
          await repository.getList(true);
          // assert
          verify(mockRemoteDataSource.getList());
          verify(mockLocalDataSource.cacheList(tDocumentList));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getList()).thenThrow(ServerException());
          // act
          final result = await repository.getList();
          // assert
          verify(mockRemoteDataSource.getList());
          verifyNoMoreInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data list when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getList())
              .thenAnswer((_) async => tDocumentList);
          // act
          final result = await repository.getList();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getList());
          expect(result, equals(Right(tDocumentList)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getList())
              .thenThrow(CacheException());
          // act
          final result = await repository.getList();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getList());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getById', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getById(testId);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getById(any))
              .thenAnswer((_) async => tDocument);
          // act
          final result = await repository.getById(testId);
          // assert
          expect(result, equals(Right(tDocument)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getById(any))
              .thenAnswer((_) async => tDocument);
          // act
          await repository.getById(testId, true);
          // assert
          verify(mockRemoteDataSource.getById(testId));
          verify(mockLocalDataSource.cache(tDocument));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getById(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getById(testId);
          // assert
          verify(mockRemoteDataSource.getById(testId));
          verifyNoMoreInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline((){
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getById(any))
              .thenAnswer((_) async => tDocument);
          // act
          final result = await repository.getById(testId);
          // assert
          expect(result, Right(tDocument));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getById(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.getById(testId);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getById(testId));
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('delete', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) async => true);
        // act
        repository.delete(tDocument);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should delete a document when there is a call to the remote data source',
        () async {
          // act
          await repository.delete(tDocument);
          // assert
          verify(mockRemoteDataSource.delete(tDocument));
        },
      );

      test(
        'should delete the cached data when call to remote data sourc is successful',
        () async {
          // act
          await repository.delete(tDocument);
          // assert
          verify(mockLocalDataSource.delete(tDocument));
        },
      );

      test(
        'should return a server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.delete(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.delete(tDocument);
          // assert
          expect(result, equals(Left(ServerFailure())));
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
    });

    runTestsOffline((){
      test(
        'should return a ConnectionFailure when device is offline',
        () async {
          // act
          final result = await repository.delete(tDocument);
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('deleteById', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) async => true);
        // act
        repository.deleteById(testId);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should delete a document when there is a call to the remote data source',
        () async {
          // act
          await repository.deleteById(testId);
          // assert
          verify(mockRemoteDataSource.deleteById(testId));
        },
      );

      test(
        'should delete the cached data when call to remote data sourc is successful',
        () async {
          // act
          await repository.deleteById(testId);
          // assert
          verify(mockLocalDataSource.deleteById(testId));
        },
      );

      test(
        'should return a server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.deleteById(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.deleteById(testId);
          // assert
          expect(result, equals(Left(ServerFailure())));
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
    });

    runTestsOffline((){
      test(
        'should return a ConnectionFailure when device is offline',
        () async {
          // act
          final result = await repository.deleteById(testId);
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('save', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) async => true);
        // act
        repository.save(tDocument);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return Document object when call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.save(any))
              .thenAnswer((_) async => tDocument);
          // act
          final result = await repository.save(tDocument);
          // assert
          verify(mockRemoteDataSource.save(tDocument));
          expect(result, equals(Right(tDocument)));
        },
      );

      test(
        'should return a server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.save(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.save(tDocument);
          // assert
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return a ConnectionFailure when device is offline',
        () async {
          // act
          final result = await repository.save(tDocument);
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
