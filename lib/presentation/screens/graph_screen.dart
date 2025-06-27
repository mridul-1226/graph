import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/bloc/graph_amount_bloc.dart';
import '../widgets/price_card_widget.dart';
import '../widgets/chart_widget.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double currentGoldPrice = 2045.30;
  double priceChange = 15.25;
  bool isPriceUp = true;
  String selectedDuration = '15_days';

  final Map<String, String> durationOptions = {
    '15_days': '15 Days',
    '1_month': '1 Month',
    '1_year': '1 Year',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDurationChanged(String? newDuration) {
    if (newDuration != null && newDuration != selectedDuration) {
      setState(() {
        selectedDuration = newDuration;
      });

      // Trigger data fetch with new duration
      BlocProvider.of<GraphAmountBloc>(context)
          .add(GetAmountDataEvent(duration: selectedDuration));

      // Restart animation
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E27),
        elevation: 0,
        title: Text(
          'Gold Price Tracker',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: selectedDuration,
              onChanged: _onDurationChanged,
              dropdownColor: const Color(0xFF1A1F3A),
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              items: durationOptions.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
          ),
          IconButton(
            onPressed: () {
              BlocProvider.of<GraphAmountBloc>(context)
                  .add(GetAmountDataEvent(duration: selectedDuration));
              _animationController.reset();
              _animationController.forward();
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PriceCardWidget(
                    currentPrice: currentGoldPrice,
                    priceChange: priceChange,
                    isPriceUp: isPriceUp,
                    animationValue: _animation.value,
                  ),
                  const SizedBox(height: 24),
                  ChartWidget(
                    animationValue: _animation.value,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
