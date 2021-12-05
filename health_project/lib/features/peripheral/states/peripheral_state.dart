import 'package:equatable/equatable.dart';
import 'package:health_project/models/peripheral_information_dto.dart';
import 'package:health_project/models/vital_sign_checking_dto.dart';

class PeripheralState extends Equatable {
  const PeripheralState();
  @override
  List<Object> get props => [];
}

//get peripheral information states
class PeripheralInfoInitialState extends PeripheralState {}

class PeripheralInfoLoadingState extends PeripheralState {}

class PeripheralInfoSuccessState extends PeripheralState {
  final PeripheralInformationDTO peripheralInformationDTO;
  final List<VitalSignCheckingDTO> listVitalSignChecking;
  const PeripheralInfoSuccessState({
    required this.peripheralInformationDTO,
    required this.listVitalSignChecking,
  });
  @override
  List<Object> get props => [peripheralInformationDTO, listVitalSignChecking];
}

class PeripheralInfoFailedState extends PeripheralState {}
