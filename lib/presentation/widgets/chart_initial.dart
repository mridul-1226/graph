import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartInitialWidget extends StatelessWidget {
  const ChartInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.show_chart,
            color: Colors.white60,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull to refresh or check your connection',
            style: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}