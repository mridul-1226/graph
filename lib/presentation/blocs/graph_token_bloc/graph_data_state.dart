part of 'graph_data_bloc.dart';

@immutable
sealed class GraphDataState {}

final class GraphDataInitial extends GraphDataState {}

final class GraphDataLoading extends GraphDataState {}

final class GraphDataFetched extends GraphDataState {
  final List<GraphDataEntity> data;

  GraphDataFetched({required this.data});
}

final class GraphDataFailure extends GraphDataState {}
