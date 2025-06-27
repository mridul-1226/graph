part of 'graph_amount_bloc.dart';

@immutable
sealed class GraphAmountEvent {}

final class GetAmountDataEvent extends GraphAmountEvent {
  final String duration;

  GetAmountDataEvent({this.duration = '15_days'});
}
