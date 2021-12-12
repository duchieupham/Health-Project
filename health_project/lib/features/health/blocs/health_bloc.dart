import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/utils/array_validator.dart';
import 'package:health_project/features/health/events/health_event.dart';
import 'package:health_project/features/health/repositories/health_repository.dart';
import 'package:health_project/features/health/states/health_state.dart';
import 'package:health_project/features/peripheral/repositories/peripheral_repository.dart';
import 'package:health_project/models/activitiy_dto.dart';
import 'package:health_project/models/bmi_dto.dart';
import 'package:health_project/models/vital_sign_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:health_project/services/sqflite_helper.dart';

class ActivityBloc extends Bloc<HealthEvent, HealthState> {
  final PeripheralRepository peripheralRepository;
  final HealthRepository healthRepository;
  final SQFLiteHelper sqfLiteHelper;

  ActivityBloc({
    required this.peripheralRepository,
    required this.healthRepository,
    required this.sqfLiteHelper,
  }) : super(ActivityPInitialState());

  @override
  Stream<HealthState> mapEventToState(HealthEvent event) async* {
    if (event is ActivityEventGet) {
      try {
        yield ActivityPLoadingState();
        final ActivityDTO activityDTO = await peripheralRepository.getActivity(
            event.peripheralId, event.accountId);
        if (activityDTO.id != 'n/a') {
          await sqfLiteHelper.addActivity(activityDTO);
          yield ActivityPSuccessState(dto: activityDTO);
        }
      } catch (e) {
        print('Error at ActivityBloc: $e');
        yield ActivityPFailedState();
      }
    }
    if (event is ActivityEventGetList) {
      try {
        yield ActivityPLoadingState();
        final List<ActivityDTO> activityList =
            await sqfLiteHelper.getListActivity(event.accountId);
        if (activityList.isNotEmpty) {
          yield ActivityPGetListSuccessState(list: activityList);
        }
      } catch (e) {
        print('Error at Activity get list bloc: $e');
        yield ActivityPGetListFailedState();
      }
    }
  }
}

class BMIBloc extends Bloc<HealthEvent, HealthState> {
  final HealthRepository healthRepository;

  BMIBloc({
    required this.healthRepository,
  }) : super(BMIInitialState());

  @override
  Stream<HealthState> mapEventToState(HealthEvent event) async* {
    if (event is BMIEventGet) {
      try {
        yield BMILoadingState();
        final BMIDTO bmiDTO =
            await healthRepository.getBMIInformation(event.accountId);
        if (bmiDTO.id != 0) {
          yield BMILoadSuccessState(dto: bmiDTO);
        }
      } catch (e) {
        print('Error at BMIBloc - BMIEventGets: $e');
        yield BMILoadFailedState();
      }
    }
    if (event is BMIEventUpdate) {
      try {
        yield BMILoadingState();
        if (ArrayValidator.instance.isValidWeight(event.dto.weight)) {
          final bool check = await healthRepository.updateBMI(event.dto);
          if (check) {
            yield BMIUpdateSuccessState();
          }
        } else {
          yield BMIUpdateFailedState(type: BMIUpdateMsgType.INVALID);
        }
      } catch (e) {
        print('Error at BMIBloc - BMIEventUpdate: $e');
        yield BMIUpdateFailedState(type: BMIUpdateMsgType.FAILED);
      }
    }
    if (state is BMIUpdateSuccessState) {
      this.add(
          BMIEventGet(accountId: AuthenticateHelper.instance.getAccountId()));
    }
  }
}

//
class HeartRateBloc extends Bloc<HealthEvent, HealthState> {
  final PeripheralRepository peripheralRepository;
  final HealthRepository healthRepository;
  final SQFLiteHelper sqfLiteHelper;

  HeartRateBloc({
    required this.peripheralRepository,
    required this.healthRepository,
    required this.sqfLiteHelper,
  }) : super(HeartRateInitialState());

  @override
  Stream<HealthState> mapEventToState(HealthEvent event) async* {
    try {
      //
      if (event is HeartRateAddValueEvent) {
        await sqfLiteHelper.addVitalSign(event.dto);
        yield HeartRateLoadingListState();
        VitalSignDTO lastValue = await sqfLiteHelper.getLastVitalSign(
            event.dto.accountId, event.dto.type);
        List<VitalSignDTO> list = await sqfLiteHelper.getListVitalSign(
          event.dto.accountId,
          event.dto.type,
          event.dto.time,
          event.chartType,
        );
        if (list.isNotEmpty) {
          yield HeartRateSuccessfulListState(list: list, lastValue: lastValue);
        }
      }
      if (event is HeartRateGetListEvent) {
        yield HeartRateLoadingListState();
        VitalSignDTO lastValue = await sqfLiteHelper.getLastVitalSign(
            event.dto.accountId, event.dto.type);
        List<VitalSignDTO> list = await sqfLiteHelper.getListVitalSign(
          event.dto.accountId,
          event.dto.type,
          event.dto.time,
          event.chartType,
        );
        yield HeartRateSuccessfulListState(list: list, lastValue: lastValue);
      }
      if (event is HeartRateMeasureEvent) {
        yield HeartRateMeasuringState();
        // await for (List<int> values
        //     in peripheralRepository.getHeartRate(event.peripheralId)) {
        //   if (values.isNotEmpty) {
        //     print('value: $values');
        //     this.add(HeartRateResponseEvent(value: values[1]));
        //   }
        // }
        await peripheralRepository.getHeartRate(event.peripheralId);
        PeripheralRepository.heartRateController.listen((value) {
          if (value != 0) {
            this.add(HeartRateResponseEvent(value: value));
          }
        });
      }
      if (event is HeartRateResponseEvent) {
        yield HeartRateValueResponseState(value: event.value);
      }
    } catch (e) {
      print('Error at Heart Rate Bloc: $e');
      yield HeartRateFailedState();
    }
  }
}
