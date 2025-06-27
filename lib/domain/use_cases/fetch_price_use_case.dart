import 'package:graph/domain/entities/amount_entity.dart';
import 'package:graph/domain/repositories/fetch_price_repo.dart';

class FetchPriceUseCase {
  final FetchPriceRepo repository;

  FetchPriceUseCase(this.repository);

  Future<List<AmountEntity>> call(String duration) async {
    return await repository.fetchPrice(duration);
  }
}
