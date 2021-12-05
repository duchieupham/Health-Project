import 'package:equatable/equatable.dart';
import 'package:health_project/models/event_dto.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}

class CalendarEventCheck extends CalendarEvent {
  final int accountId;
  const CalendarEventCheck({required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class CalendarEventGetFromServer extends CalendarEvent {
  final int accountId;
  const CalendarEventGetFromServer({required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class CalendarEventGetFromLocal extends CalendarEvent {
  final int accountId;
  const CalendarEventGetFromLocal({required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class CalendarEventChange extends CalendarEvent {
  final int accountId;
  final List<EventDTO> list;
  final List<EventDTO> listEventLocal;

  const CalendarEventChange({
    required this.accountId,
    required this.list,
    required this.listEventLocal,
  });

  @override
  List<Object> get props => [accountId, list, listEventLocal];
}
