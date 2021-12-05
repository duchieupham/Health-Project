import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/calendar/events/calendar_event.dart';
import 'package:health_project/features/calendar/repositories/calendar_repository.dart';
import 'package:health_project/features/calendar/states/calendar_state.dart';
import 'package:connectivity/connectivity.dart';
import 'package:health_project/models/event_dto.dart';
import 'package:health_project/services/sqflite_helper.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepository calendarRepository;
  final SQFLiteHelper sqfLiteHelper;
  CalendarBloc({required this.calendarRepository, required this.sqfLiteHelper})
      : super(CalendarInitialState());

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    final Connectivity _connectivity = Connectivity();
    ConnectivityResult _connectionResult;
    yield CalendarLoadingState();
    try {
      // if (event is CalendarEventCheck) {
      //   _connectionResult = await _connectivity.checkConnectivity();
      //   if (_connectionResult == ConnectivityResult.wifi ||
      //       _connectionResult == ConnectivityResult.mobile) {
      //     this.add(CalendarEventGetFromServer(event.accountId));
      //   } else {
      //     this.add(CalendarEventGetFromLocal(event.accountId));
      //   }
      // }
      // if (event is CalendarEventGetFromServer) {
      //   List<EventDTO>? listEvent =
      //       await calendarRepository!.getEventsByPatientId(event.accountId);
      //   if (listEvent == null || listEvent.isEmpty)
      //     this.add(CalendarEventGetFromLocal(event.accountId));
      //   if (listEvent != null && listEvent.isNotEmpty) {
      //     List<EventDTO>? listEventLocal =
      //         await sqfLiteHelper!.getListCalendar(event.accountId);
      //     if (listEventLocal != null &&
      //         (listEvent.length == listEventLocal.length)) {
      //       //yield local
      //       yield CalendarSuccessState(list: listEventLocal);
      //     } else {
      //       this.add(CalendarEventChange(
      //           event.accountId, listEvent, listEventLocal));
      //     }
      //   }
      // }
      // if (event is CalendarEventGetFromLocal) {
      //   List<EventDTO>? listEventLocal =
      //       await sqfLiteHelper!.getListCalendar(event.accountId);
      //   yield CalendarSuccessState(list: listEventLocal);
      // }
      // if (event is CalendarEventChange) {
      //   for (var element in event.list) {
      //     if (event.listEventLocal!
      //         .where((elementLocal) => elementLocal.id == element.id)
      //         .isEmpty) {
      //       await sqfLiteHelper!.insertCalendar(element);
      //     }
      //   }
      //   this.add(CalendarEventGetFromLocal(event.accountId));
      // }
    } catch (e) {
      print('Error at calendar bloc: $e');
      yield CalendarFailedState();
    }
  }
}
