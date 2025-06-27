import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/presentation/blocs/graph_token_bloc/graph_data_bloc.dart';
import 'package:graph/presentation/blocs/bloc/graph_amount_bloc.dart';
import 'package:graph/presentation/widgets/chart_error.dart';
import 'package:graph/presentation/widgets/chart_initial.dart';
import 'package:graph/presentation/widgets/chart_line.dart';
import 'package:graph/presentation/widgets/chart_loading.dart';

import '../../domain/entities/graph_data_entity.dart';
import '../../domain/entities/amount_entity.dart';

class ChartWidget extends StatelessWidget {
  final double animationValue;
  List<AmountEntity>? _amountData;

  ChartWidget({
    super.key,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<GraphDataBloc, GraphDataState>(
      builder: (context, graphState) {
        return BlocBuilder<GraphAmountBloc, GraphAmountState>(
          builder: (context, amountState) {
            return Container(
              height: size.height * 0.4,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F3A),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: _buildChartContent(graphState, amountState, context),
            );
          },
        );
      },
    );
  }

  Widget _buildChartContent(GraphDataState graphState,
      GraphAmountState amountState, BuildContext context) {
    if (graphState is GraphDataLoading || amountState is GraphAmountLoading) {
      return const ChartLoadingWidget();
    } else if (graphState is GraphDataFailure ||
        amountState is GraphAmountError) {
      return ChartErrorWidget(onRetry: () {
        BlocProvider.of<GraphDataBloc>(context).add(FetchGraphDataEvent());
      });
    } else if (graphState is GraphDataFetched &&
        amountState is GraphAmountLoaded) {
      _amountData = amountState.data;
      final marginChartData =
          _convertEntityListToFlSpots(graphState.data, amountState.data);
      final priceChartData = _convertAmountListToFlSpots(amountState.data);
      return ChartLineWidget(
        marginData: marginChartData,
        priceData: priceChartData,
        amountData: _amountData!,
        animationValue: animationValue,
      );
    } else {
      return const ChartInitialWidget();
    }
  }

  List<FlSpot> _convertEntityListToFlSpots(
      List<GraphDataEntity> tokenDataList, List<AmountEntity> amountDataList) {
    if (tokenDataList.isEmpty || amountDataList.isEmpty) {
      return [];
    }

    List<FlSpot> spots = [];

    final sortedTokenData = List<GraphDataEntity>.from(tokenDataList)
      ..sort((a, b) => a.date.compareTo(b.date));
    final sortedAmountData = List<AmountEntity>.from(amountDataList)
      ..sort((a, b) => a.date.compareTo(b.date));

    final Map<DateTime, double> tokenDataByDate = {};
    for (var token in sortedTokenData) {
      final dateKey =
          DateTime(token.date.year, token.date.month, token.date.day);
      tokenDataByDate[dateKey] = token.marginAmount;
    }

    double previousDifference = 0.0;
    double cumulativeValue = 0.0;
    int spotIndex = 0;

    for (int i = 0; i < sortedAmountData.length; i++) {
      final amountData = sortedAmountData[i];
      final dateKey = DateTime(
          amountData.date.year, amountData.date.month, amountData.date.day);

      if (tokenDataByDate.containsKey(dateKey)) {
        final tokenValue = tokenDataByDate[dateKey]!;

        if (i == 0) {
          cumulativeValue = amountData.price + tokenValue;
          previousDifference = cumulativeValue - amountData.price;
        } else {
          cumulativeValue = previousDifference + amountData.price + tokenValue;
          previousDifference = cumulativeValue - amountData.price;
        }
      } else {
        if (i == 0) {
          cumulativeValue = amountData.price;
          previousDifference = 0.0;
        } else {
          cumulativeValue = previousDifference + amountData.price;
        }
      }

      spots.add(FlSpot(spotIndex.toDouble(), cumulativeValue));
      spotIndex++;
    }

    final lastAmountDate = sortedAmountData.last.date;
    final remainingTokenData = sortedTokenData
        .where((token) => token.date.isAfter(lastAmountDate))
        .toList();

    for (var tokenData in remainingTokenData) {
      final lastAmountPrice = sortedAmountData.last.price;
      cumulativeValue =
          previousDifference + lastAmountPrice + tokenData.marginAmount;
      previousDifference = cumulativeValue - lastAmountPrice;

      spots.add(FlSpot(spotIndex.toDouble(), cumulativeValue));
      spotIndex++;
    }

    return spots;
  }

  List<FlSpot> _convertAmountListToFlSpots(List<AmountEntity> dataList) {
    List<FlSpot> spots = [];

    for (int i = 0; i < dataList.length; i++) {
      spots.add(FlSpot(i.toDouble(), dataList[i].price));
    }

    return spots;
  }
}