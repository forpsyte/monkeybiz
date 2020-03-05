import '../../domain/entities/document.dart';

abstract class DocumentRemoteDataSourceInterface {
  /// Uses the firestore api to retrive all documents.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<Document>> getList();

  /// Uses the firestore api to retrive a document specified
  /// by ID.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<Document> getById(String id);

  /// Uses the firestore api to create/update a document.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<Document> save(Document document);

  /// Uses the firestore api to delete a document.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<bool> delete(Document document);

  /// Uses the firestore api to delete a document specified
  /// by ID.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<bool> deleteById(String id);
}