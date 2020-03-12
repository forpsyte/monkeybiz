import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Document extends Equatable {
  final String documentId;
  final Map<String, dynamic> _data;

  Document({
    id,
    @required data,
  })  : assert(data != null),
        this.documentId = id,
        this._data = data;

  @override
  List<Object> get props => [documentId, _data];
}
