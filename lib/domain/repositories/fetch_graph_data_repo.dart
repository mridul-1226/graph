import 'package:graph/domain/entities/graph_data_entity.dart';

abstract class FetchGraphDataRepo {
  Future<List<GraphDataEntity>> fetchGraphData();
}