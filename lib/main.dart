import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/data/repositories/fetch_amout_repo_impl.dart';
import 'package:graph/data/repositories/fetch_graph_data_repo_impl.dart';
import 'package:graph/domain/use_cases/fetch_price_use_case.dart';
import 'package:graph/domain/use_cases/get_graph_data_use_case.dart';
import 'package:graph/presentation/blocs/bloc/graph_amount_bloc.dart';
import 'package:graph/presentation/blocs/graph_token_bloc/graph_data_bloc.dart';
import 'package:graph/presentation/screens/graph_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                GraphDataBloc(GetGraphDataUseCase(FetchGraphDataRepoImpl()))
                  ..add(FetchGraphDataEvent()),
          ),
          BlocProvider(
            create: (context) =>
                GraphAmountBloc(FetchPriceUseCase(FetchAmoutRepoImpl()))
                  ..add(GetAmountDataEvent()),
          )
        ],
        child: const GraphScreen(),
      ),
    );
  }
}
