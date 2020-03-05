import 'package:mailchimp/core/features/firestore/data/datasources/document_local_data_source_interface.dart';
import 'package:mailchimp/core/features/firestore/domain/entities/document.dart';

class DocumentLocalDataSource implements DocumentLocalDataSourceInterface {
  @override
  Future<void> cache(Document document) {
    // TODO: implement cache
    return null;
  }

  @override
  Future<void> cacheList(List<Document> documents) {
    // TODO: implement cacheList
    return null;
  }

  @override
  Future<bool> delete(Document document) {
    // TODO: implement delete
    return null;
  }

  @override
  Future<bool> deleteById(String id) {
    // TODO: implement deleteById
    return null;
  }

  @override
  Future<Document> getById(String id) {
    // TODO: implement getById
    return null;
  }

  @override
  Future<List<Document>> getList() {
    // TODO: implement getList
    return null;
  }
}