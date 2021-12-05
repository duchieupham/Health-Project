import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NotificationEventUpdate extends NotificationEvent {
  final int notiId;
  final int index;
  final int accountId;
  final BuildContext context;
  const NotificationEventUpdate({
    required this.notiId,
    required this.index,
    required this.accountId,
    required this.context,
  });

  @override
  List<Object> get props => [notiId, index, accountId, context];
}

class NotificationEventGetList extends NotificationEvent {
  final int accountId;
  const NotificationEventGetList({required this.accountId});
  @override
  List<Object> get props => [accountId];
}

class NotificationEventGetUnreadCount extends NotificationEvent {
  final int accountId;
  final BuildContext context;
  const NotificationEventGetUnreadCount({
    required this.accountId,
    required this.context,
  });
  @override
  List<Object> get props => [accountId, context];
}
