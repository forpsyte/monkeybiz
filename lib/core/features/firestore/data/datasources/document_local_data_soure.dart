import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../error/exceptions.dart';
import '../../domain/entities/document.dart';
import '../models/document_model.dart';
import 'document_local_data_source_interface.dart';

const DOCUMENT_LIST_CACHE_KEY = 'DOCUMENT_LIST';

class DocumentLocalDataSource implements DocumentLocalDataSourceInterface {
  final SharedPreferences sharedPreferences;

  DocumentLocalDataSource({
    @required this.sharedPreferences,
  });

  @override
  Future<bool> cache(DocumentModel document) {
    final _json = json.encode(document.toJson());
    return sharedPreferences.setString(document.documentId, _json);
  }

  @override
  Future<bool> cacheList(List<DocumentModel> documents) {
    final list = documents.map((doc) {
      return json.encode(doc.toJson());
    }).toList();
    return sharedPreferences.setStringList(DOCUMENT_LIST_CACHE_KEY, list);
  }

  Future<bool> clearList() async {
    if (!sharedPreferences.containsKey(DOCUMENT_LIST_CACHE_KEY)) {
      throw CacheException();
    }
    return await sharedPreferences.remove(DOCUMENT_LIST_CACHE_KEY);
  }

  @override
  Future<bool> delete(Document document) async{
    if (!sharedPreferences.containsKey(document.documentId)) {
      throw CacheException();
    }
    return await sharedPreferences.remove(document.documentId);
  }

  @override
  Future<bool> deleteById(String id) async {
    if (!sharedPreferences.containsKey(id)) {
      throw CacheException();
    }
    return await sharedPreferences.remove(id);
  }

  @override
  Future<Document> getById(String id) {
    if (!sharedPreferences.containsKey(id)) {
      throw CacheException();
    }
    final cache = sharedPreferences.getString(id);
    final document = DocumentModel.fromJson(json.decode(cache));
    return Future.value(document);
  }

  @override
  Future<List<Document>> getList() {
    if (!sharedPreferences.containsKey(DOCUMENT_LIST_CACHE_KEY)) {
      throw CacheException();
    }
    final cache = sharedPreferences.getStringList(DOCUMENT_LIST_CACHE_KEY);
    final documents = cache.map((doc){
      return DocumentModel.fromJson(json.decode(doc));
    }).toList();
    return Future.value(documents);
  }
}
