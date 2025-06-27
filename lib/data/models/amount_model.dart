import 'package:graph/domain/entities/amount_entity.dart';

class AmountModel extends AmountEntity {
  AmountModel({required super.date, required super.price});

  factory AmountModel.fromJson(Map<String, dynamic> json) {
    return AmountModel(
      date: DateTime.parse(json['label'] as String),
      price: (json['y']).toDouble() * 5000,
    );
  }
}
