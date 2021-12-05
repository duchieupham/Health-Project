import 'package:equatable/equatable.dart';
import 'package:health_project/models/notification_dto.dart';

class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitialState extends NotificationState {
  const NotificationInitialState();
}

class NotificationLoadingState extends NotificationState {
  const NotificationLoadingState();
}

class NotificationFailedState extends NotificationState {
  const NotificationFailedState(int count);
}

class NotificationSuccessState extends NotificationState {
  final List<NotificationDTO> list;
  const NotificationSuccessState({required this.list});

  @override
  List<Object> get props => [list];
}

class NotificationUpdateState extends NotificationState {
  final bool response;
  final int index;
  const NotificationUpdateState({
    required this.response,
    required this.index,
  });

  @override
  List<Object> get props => [response, index];
}

class NotificationGetUnreadCountState extends NotificationState {
  final int count;
  const NotificationGetUnreadCountState({required this.count});

  @override
  List<Object> get props => [count];
}
