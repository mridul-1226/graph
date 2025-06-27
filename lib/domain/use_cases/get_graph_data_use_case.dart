import 'package:graph/domain/entities/graph_data_entity.dart';
import 'package:graph/domain/repositories/fetch_graph_data_repo.dart';

class GetGraphDataUseCase {
  final FetchGraphDataRepo repository;

  GetGraphDataUseCase(this.repository);

  Future<List<GraphDataEntity>> call() async {
    return await repository.fetchGraphData();
  }
}