import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PriceCardWidget extends StatelessWidget {
  final double currentPrice;
  final double priceChange;
  final bool isPriceUp;
  final double animationValue;

  const PriceCardWidget({
    super.key,
    required this.currentPrice,
    required this.priceChange,
    required this.isPriceUp,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E2A5E), Color(0xFF2A3B7D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Gold',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$${NumberFormat('#,##0.00').format(currentPrice * animationValue)}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isPriceUp
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPriceUp ? Icons.trending_up : Icons.trending_down,
                  color: isPriceUp ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isPriceUp ? '+' : '-'}\$${NumberFormat('#,##0.00').format(priceChange)} (${(priceChange / currentPrice * 100).toStringAsFixed(2)}%)',
                  style: GoogleFonts.poppins(
                    color: isPriceUp ? Colors.green : Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
