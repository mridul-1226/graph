import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graph/data/models/amount_model.dart';
import 'package:graph/domain/entities/amount_entity.dart';
import 'package:graph/domain/repositories/fetch_price_repo.dart';

class FetchAmoutRepoImpl extends FetchPriceRepo {
  final dio = Dio();

  @override
  Future<List<AmountEntity>> fetchPrice(String duration) async {
    const endPoint = 'https://uat-test.aiiongold.com/api/gold-prices';

    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'duration': duration,
          'currency': 'USD',
        },
        options: Options(
          headers: {
            'x-api-key': 'AIzaSyAxsCahMywG27JQz76amLWLHEUXr7a5MyI',
            'Authorization':
                'Bearer 452|f7hQQvY3T1H9icv6QX3umSQYTQeHyz9HaptrYl6p',
          },
        ),
      );

      if (response.statusCode == 200) {
        final res = (response.data['dataPoints'] as List)
            .map((e) => AmountModel.fromJson(e as Map<String, dynamic>))
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
