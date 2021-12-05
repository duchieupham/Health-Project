class PeripheralInformationDTO {
  final String name;
  final String serialNumber;
  final String softwareRevision;
  final String hardwareRevision;
  final int pinPercentage;
  final String lastChargedTime;

  const PeripheralInformationDTO({
    required this.name,
    required this.serialNumber,
    required this.softwareRevision,
    required this.hardwareRevision,
    required this.pinPercentage,
    required this.lastChargedTime,
  });
}
