import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/news/events/weather_event.dart';
import 'package:health_project/features/news/repositories/weather_repository.dart';
import 'package:health_project/features/news/states/weather_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health_project/models/weather_dto.dart';
import 'package:health_project/models/weather_search_dto.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc({required this.weatherRepository}) : super(WeatherInitialState());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    LocationPermission permission;
    yield WeatherLoadingState();
    try {
      //GPS in user's phone is off.
      if (!await Geolocator.isLocationServiceEnabled()) {
        yield WeatherDisableState();
      } else {
        //Check permission status
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          yield WeatherRequestPermissionState();
        } else if (permission == LocationPermission.deniedForever) {
          yield WeatherDenyPermissionState();
        } else if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          //get lat - long position
          Position position = await Geolocator.getCurrentPosition();
          //get weather
          WeatherDTO weatherDTO = await weatherRepository.getWeather(
            position.latitude.toString(),
            position.longitude.toString(),
          );
          yield WeatherSuccessState(weatherDTO: weatherDTO);
        } else {
          yield WeatherFailedState();
        }
      }
    } catch (e) {
      print('Exception at Weather Bloc: $e');
      yield WeatherFailedState();
    }
  }
}

class WeatherSearchBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherSearchBloc({required this.weatherRepository})
      : super(WeatherClearSearchState());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    try {
      if (event is WeatherSearchEvent) {
        yield WeatherSearchLoadingState();
        List<WeatherSearchDTO> result =
            await weatherRepository.searchWeather(event.keyword);
        if (result.isNotEmpty) {
          yield WeatherSearchSuccessState(list: result);
        } else {
          yield WeatherSearchEmptyState();
        }
      }
      if (event is WeatherClearSearchEvent) {
        yield WeatherClearSearchState();
      }
      if (event is WeatherAccessLocationEvent) {
        yield WeatherLoadingAccessState();
        WeatherDTO weatherDTO =
            await weatherRepository.getWeatherByWoeid(event.woeid);
        if (weatherDTO.title != 'n/a') {
          yield WeatherSuccessAccessState(weatherDTO: weatherDTO);
        } else {
          yield WeatherSearchFailedState();
        }
      }
    } catch (e) {
      print('Exception at Weather Search bloc: $e');
      yield WeatherSearchFailedState();
    }
  }
}
