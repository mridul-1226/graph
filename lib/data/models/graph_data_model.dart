import 'package:graph/domain/entities/graph_data_entity.dart';

class GraphDataModel extends GraphDataEntity {
  GraphDataModel({required super.marginAmount, required super.date});

  factory GraphDataModel.fromJson(Map<String, dynamic> json) {
    return GraphDataModel(
      marginAmount: json['margin_amount'],
      date: DateTime.parse(json['date']),
    );
  }
}
