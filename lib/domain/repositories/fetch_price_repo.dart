import 'package:graph/domain/entities/amount_entity.dart';

abstract class FetchPriceRepo {
  Future<List<AmountEntity>> fetchPrice(String duration);
}
