import 'package:equatable/equatable.dart';
import 'package:health_project/models/weather_dto.dart';
import 'package:health_project/models/weather_search_dto.dart';

class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitialState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherDisableState extends WeatherState {}

class WeatherEnableState extends WeatherState {}

class WeatherDenyPermissionState extends WeatherState {}

class WeatherRequestPermissionState extends WeatherState {}

class WeatherSuccessState extends WeatherState {
  final WeatherDTO weatherDTO;
  const WeatherSuccessState({required this.weatherDTO});

  @override
  List<Object> get props => [weatherDTO];
}

class WeatherFailedState extends WeatherState {}

//weather search states
class WeatherSearchLoadingState extends WeatherState {}

class WeatherSearchFailedState extends WeatherState {}

class WeatherSearchEmptyState extends WeatherState {}

class WeatherSearchSuccessState extends WeatherState {
  final List<WeatherSearchDTO> list;
  const WeatherSearchSuccessState({required this.list});
  @override
  List<Object> get props => [list];
}

class WeatherClearSearchState extends WeatherState {}

class WeatherLoadingAccessState extends WeatherState {}

class WeatherSuccessAccessState extends WeatherState {
  final WeatherDTO weatherDTO;
  const WeatherSuccessAccessState({required this.weatherDTO});

  @override
  List<Object> get props => [weatherDTO];
}
