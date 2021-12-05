import 'package:equatable/equatable.dart';

class PeripheralEvent extends Equatable {
  const PeripheralEvent();

  @override
  List<Object> get props => [];
}

class PeripheralEventGet extends PeripheralEvent {
  final String id;

  const PeripheralEventGet({required this.id});

  @override
  List<Object> get props => [id];
}

class PeripheralEventDisconnect extends PeripheralEvent {
  final String id;

  const PeripheralEventDisconnect({required this.id});

  @override
  List<Object> get props => [id];
}
