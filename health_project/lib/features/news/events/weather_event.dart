import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class WeatherGetEvent extends WeatherEvent {
  const WeatherGetEvent();
  @override
  List<Object> get props => [];
}

// weather search events

class WeatherSearchEvent extends WeatherEvent {
  final String keyword;
  const WeatherSearchEvent({required this.keyword});

  @override
  List<Object> get props => [keyword];
}

class WeatherClearSearchEvent extends WeatherEvent {
  const WeatherClearSearchEvent();
  @override
  List<Object> get props => [];
}

class WeatherAccessLocationEvent extends WeatherEvent {
  final int woeid;
  const WeatherAccessLocationEvent({required this.woeid});

  @override
  List<Object> get props => [woeid];
}
