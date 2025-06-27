import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/domain/entities/graph_data_entity.dart';
import 'package:graph/domain/use_cases/get_graph_data_use_case.dart';

part 'graph_data_event.dart';
part 'graph_data_state.dart';

class GraphDataBloc extends Bloc<GraphDataEvent, GraphDataState> {
  final GetGraphDataUseCase getGraphDataUseCase;
  GraphDataBloc(this.getGraphDataUseCase) : super(GraphDataInitial()) {
    on<FetchGraphDataEvent>((event, emit) async {
      emit(GraphDataLoading());
      try {
        final res = await getGraphDataUseCase();
        emit(GraphDataFetched(data: res));
      } catch (e) {
        emit(GraphDataFailure());
      }
    });
  }
}
