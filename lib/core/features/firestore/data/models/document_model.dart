import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:validators/validators.dart';

import '../../domain/entities/document.dart';

class DocumentModel extends Document {
  final Map<String, dynamic> _data;

  DocumentModel({
    @required id,
    @required data,
  })  : assert(id != null),
        assert(data != null),
        this._data = data,
        super(id: id, data: data);

  factory DocumentModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    final documentId = documentSnapshot.documentID;
    final data = documentSnapshot.data;
    return DocumentModel(
      id: documentId,
      data: data,
    );
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    final Map<String,dynamic> data = Map.from(json['data']);
    data.forEach((key, value){
      if(isInt(value.toString())) {
        data[key] = (value as num).toInt();
      } else if(isFloat(value.toString())) {
        data[key] = (value as num).toDouble();
      } else if(isDate(value.toString())) {
        data[key] = DateTime.parse(value);
      }
    });

    return DocumentModel(
      id: json['document_id'],
      data: data,
    );
  }

  Map<String, dynamic> get data => _data;

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'data' : data,
    };
  }

  @override
  List<Object> get props => [documentId, _data];
}
