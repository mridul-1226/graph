part of 'graph_data_bloc.dart';

@immutable
sealed class GraphDataEvent {}

final class FetchGraphDataEvent extends GraphDataEvent{}
