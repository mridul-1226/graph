import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graph/domain/entities/amount_entity.dart';
import 'package:graph/presentation/widgets/chart_initial.dart';
import 'package:intl/intl.dart';

class ChartLineWidget extends StatelessWidget {
  final List<FlSpot> marginData;
  final List<FlSpot> priceData;
  final List<AmountEntity> amountData;
  final double animationValue;

  const ChartLineWidget({
    super.key,
    required this.marginData,
    required this.priceData,
    required this.amountData,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    if (marginData.isEmpty && priceData.isEmpty) {
      return const ChartInitialWidget();
    }

    final allData = [...marginData, ...priceData];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.white10,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < amountData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      DateFormat('dd/MM').format(amountData[index].date),
                      style: GoogleFonts.poppins(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 35000,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                );
              },
              reservedSize: 60,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (marginData.isNotEmpty ? marginData.length : priceData.length) -
            1.0,
        minY: _getMinY(allData),
        maxY: _getMaxY(allData),
        lineBarsData: [
          if (marginData.isNotEmpty)
            LineChartBarData(
              spots: marginData
                  .map((spot) => FlSpot(
                        spot.x,
                        spot.y * animationValue +
                            _getMinY(allData) * (1 - animationValue),
                      ))
                  .toList(),
              isCurved: true,
              gradient: const LinearGradient(
                colors: [
                  Colors.amber,
                  Colors.orange,
                  Colors.deepOrange,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: Colors.amber,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(0.18),
                    Colors.orange.withOpacity(0.12),
                    Colors.deepOrange.withOpacity(0.08),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          if (priceData.isNotEmpty)
            LineChartBarData(
              spots: priceData
                  .map((spot) => FlSpot(
                        spot.x,
                        spot.y * animationValue +
                            _getMinY(allData) * (1 - animationValue),
                      ))
                  .toList(),
              isCurved: true,
              gradient: const LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.cyan,
                  Colors.teal,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: Colors.blue,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.18),
                    Colors.cyan.withOpacity(0.12),
                    Colors.teal.withOpacity(0.08),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 12,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  '\$${NumberFormat('#,##0.00').format(touchedSpot.y)}',
                  GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: Colors.amber.withOpacity(0.8),
                  strokeWidth: 2,
                  dashArray: [5, 5],
                ),
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 6,
                    color: Colors.amber,
                    strokeWidth: 3,
                    strokeColor: Colors.white,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  double _getMinY(List<FlSpot> data) {
    if (data.isEmpty) return 0;
    final minValue = data.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    return minValue - 20;
  }

  double _getMaxY(List<FlSpot> data) {
    if (data.isEmpty) return 100;
    final maxValue = data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    return maxValue + 20;
  }
}