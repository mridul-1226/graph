import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/domain/entities/amount_entity.dart';
import 'package:graph/domain/use_cases/fetch_price_use_case.dart';

part 'graph_amount_event.dart';
part 'graph_amount_state.dart';

class GraphAmountBloc extends Bloc<GraphAmountEvent, GraphAmountState> {
  final FetchPriceUseCase fetchPriceUseCase;
  GraphAmountBloc(this.fetchPriceUseCase) : super(GraphAmountInitial()) {
    on<GetAmountDataEvent>((event, emit) async {
      emit(GraphAmountLoading());
      try {
        final List<AmountEntity> amounts =
            await fetchPriceUseCase(event.duration);
        emit(GraphAmountLoaded(data: amounts));
      } catch (e) {
        emit(GraphAmountError(message: e.toString()));
      }
    });
  }
}
