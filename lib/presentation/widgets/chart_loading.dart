import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartLoadingWidget extends StatelessWidget {
  const ChartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading chart data...',
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}