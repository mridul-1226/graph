import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graph/data/models/graph_data_model.dart';
import 'package:graph/domain/entities/graph_data_entity.dart';
import 'package:graph/domain/repositories/fetch_graph_data_repo.dart';

class FetchGraphDataRepoImpl extends FetchGraphDataRepo {
  final Dio dio = Dio();

  @override
  Future<List<GraphDataEntity>> fetchGraphData() async {
    const endPoint = 'https://uat-test.aiiongold.com/api/token_screen_new';

    try {
      final response = await dio.post(
        endPoint,
        options: Options(
          headers: {
            'x-api-key': 'AIzaSyAxsCahMywG27JQz76amLWLHEUXr7a5MyI',
            'Authorization': 'Bearer 452|f7hQQvY3T1H9icv6QX3umSQYTQeHyz9HaptrYl6p',
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data['token_graph_data'] != null) {
        final res = (response.data['token_graph_data'] as List)
            .map((e) => GraphDataModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return res;
      } else {
        throw Exception('Failed to fetch graph data: Invalid response');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to fetch graph data: $e');
    }
  }
}
