part of 'graph_amount_bloc.dart';

@immutable
sealed class GraphAmountState {}

final class GraphAmountInitial extends GraphAmountState {}

final class GraphAmountLoading extends GraphAmountState {}

final class GraphAmountLoaded extends GraphAmountState {
  final List<AmountEntity> data;

  GraphAmountLoaded({required this.data});
}

final class GraphAmountError extends GraphAmountState {
  final String message;

  GraphAmountError({required this.message});
}
