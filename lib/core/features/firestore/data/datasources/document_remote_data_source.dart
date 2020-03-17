import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../../../error/exceptions.dart';
import '../../domain/entities/document.dart';
import '../models/document_model.dart';
import 'document_remote_data_source_interface.dart';

class DocumentRemoteDataSource implements DocumentRemoteDataSourceInterface {
  final Firestore firestore;
  final String collection;

  DocumentRemoteDataSource({
    @required this.firestore,
    @required this.collection,
  });

  @override
  Future<void> delete(Document document) async {
    return await firestore
        .collection(collection)
        .document(document.documentId)
        .delete();
  }

  @override
  Future<void> deleteById(String id) async {
    return await firestore
        .collection(collection)
        .document(id)
        .delete();
  }

  @override
  Future<DocumentModel> getById(String id) async {
    final DocumentSnapshot doc =
        await firestore.collection(collection).document(id).get();

    if (doc == null) {
      return null;
    }

    return DocumentModel.fromDocumentSnapshot(doc);
  }

  @override
  Future<List<DocumentModel>> getList() async {
    try {
      final querySnapshot =
          await firestore.collection(collection).getDocuments();

      return querySnapshot.documents.map((document) {
        return DocumentModel.fromDocumentSnapshot(document);
      }).toList();
    } on PlatformException {
      throw ServerException();
    } on MissingPluginException {
      throw ServerException();
    }
  }

  @override
  Future<DocumentModel> save(DocumentModel document) async {
    final colRef = firestore.collection(collection);
    final docRef = document.documentId == null
        ? colRef.document()
        : colRef.document(document.documentId);
    await docRef.setData(document.data);
    final result = DocumentModel(
      id: docRef.documentID,
      data: document.data,
    );
    return Future.value(result);
  }
}
