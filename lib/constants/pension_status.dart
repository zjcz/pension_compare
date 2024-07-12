enum PensionStatus implements Comparable<PensionStatus> {
  active(dataValue: 0),
  closed(dataValue: 1),
  transferred(dataValue: 2),
  matured(dataValue: 3);

  final int dataValue;

  const PensionStatus({required this.dataValue});

  static PensionStatus fromDataValue(int dataValue) {
    switch (dataValue) {
      case 0:
        return PensionStatus.active;
      case 1:
        return PensionStatus.closed;
      case 2:
        return PensionStatus.transferred;
      case 3:
        return PensionStatus.matured;
      default:
        throw Exception('Unknown data value for PensionStatus: $dataValue');
    }
  }

  @override
  int compareTo(PensionStatus other) {
    return dataValue.compareTo(other.dataValue);
  }
}
