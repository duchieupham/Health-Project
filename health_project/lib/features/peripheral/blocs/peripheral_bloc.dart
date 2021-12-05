import 'package:health_project/features/peripheral/events/peripheral_event.dart';
import 'package:health_project/features/peripheral/repositories/peripheral_repository.dart';
import 'package:health_project/features/peripheral/states/peripheral_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/models/peripheral_information_dto.dart';
import 'package:health_project/models/vital_sign_checking_dto.dart';

class PeripheralBLoc extends Bloc<PeripheralEvent, PeripheralState> {
  final PeripheralRepository peripheralRepository;

  PeripheralBLoc({required this.peripheralRepository})
      : super(PeripheralInfoInitialState());

  @override
  Stream<PeripheralState> mapEventToState(PeripheralEvent event) async* {
    if (event is PeripheralEventGet) {
      yield PeripheralInfoLoadingState();
      try {
        final PeripheralInformationDTO dto =
            await peripheralRepository.getPeripheralInformation(event.id);
        final List<VitalSignCheckingDTO> list =
            await peripheralRepository.checkServices(event.id);
        yield PeripheralInfoSuccessState(
          peripheralInformationDTO: dto,
          listVitalSignChecking: list,
        );
      } catch (e) {
        print('Error at PeripheralBLoc: $e');
        yield PeripheralInfoFailedState();
      }
    }
    if (event is PeripheralEventDisconnect) {
      peripheralRepository.disposePeripheralService();
    }
  }
}
