class BodyMeasurementEntry {
  final String id;
  final DateTime date;
  final double? bodyFat;
  final double? chest;
  final double? waist;
  final double? hips;
  final double? arms;

  BodyMeasurementEntry({
    required this.id,
    required this.date,
    this.bodyFat,
    this.chest,
    this.waist,
    this.hips,
    this.arms,
  });
}
