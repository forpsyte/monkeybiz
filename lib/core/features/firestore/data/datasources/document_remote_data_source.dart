import '../../domain/entities/document.dart';
import 'document_remote_data_source_interface.dart';

class DocumentRemoteDataSource implements DocumentRemoteDataSourceInterface {
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

  @override
  Future<Document> save(Document document) {
    // TODO: implement save
    return null;
  }
  
}