import 'dart:async';

class WaterService {
  Stream<double> getWaterUsageStream() async* {
    double total = 14.0;
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      total += 0.1;
      yield total;
    }
  }

  bool checkLeak(double flowRate) {
    return flowRate > 5.0;
  }
}