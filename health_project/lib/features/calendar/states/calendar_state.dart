import 'package:equatable/equatable.dart';
import 'package:health_project/models/event_dto.dart';

class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitialState extends CalendarState {}

class CalendarLoadingState extends CalendarState {}

class CalendarFailedState extends CalendarState {}

class CalendarSuccessState extends CalendarState {
  final List<EventDTO> list;
  const CalendarSuccessState({required this.list});

  @override
  List<Object> get props => [list];
}
