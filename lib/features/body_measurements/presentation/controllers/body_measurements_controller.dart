import 'package:get/get.dart';
import '../../domain/models/body_measurement_entry.dart';

class BodyMeasurementsController extends GetxController {
  var entries = <BodyMeasurementEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Add some mock data for the UI chart
    entries.add(BodyMeasurementEntry(
      id: '1',
      date: DateTime.now().subtract(const Duration(days: 30)),
      bodyFat: 20.0,
      chest: 40.0,
      waist: 34.0,
      hips: 38.0,
      arms: 14.0,
    ));
  }

  void addEntry(BodyMeasurementEntry entry) {
    entries.add(entry);
    entries.sort((a, b) => a.date.compareTo(b.date));
  }
}
