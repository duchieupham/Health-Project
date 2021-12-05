import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/notification/events/notification_event.dart';
import 'package:health_project/features/notification/repositories/notification_repository.dart';
import 'package:health_project/features/notification/states/notification_state.dart';
import 'package:health_project/models/notification_dto.dart';
import 'package:health_project/services/notification_count_provider.dart';
import 'package:provider/provider.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository})
      : super(NotificationInitialState());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    try {
      yield NotificationLoadingState();
      if (event is NotificationEventGetList) {
        List<NotificationDTO>? list = await notificationRepository
            .getListNotificationByAccountId(event.accountId);
        yield NotificationSuccessState(list: list);
      }
      if (event is NotificationEventUpdate) {
        final countProvider = Provider.of<NotificationCountProvider>(
            event.context,
            listen: false);
        final bool check =
            await notificationRepository.updateNotificationStatus(event.notiId);
        int count = countProvider.count - 1;
        countProvider.updateNotificationCount(count);
        yield NotificationUpdateState(response: check, index: event.index);
      }
      if (event is NotificationEventGetUnreadCount) {
        int count = await notificationRepository
            .getUnreadCountNotificationByAccountId(event.accountId);
        Provider.of<NotificationCountProvider>(event.context, listen: false)
            .updateNotificationCount(count);
        yield NotificationGetUnreadCountState(count: count);
      }
    } catch (e) {
      print('Error at notification bloc: $e');
      yield NotificationFailedState(0);
    }
  }
}
