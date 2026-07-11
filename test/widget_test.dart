import 'package:flutter_test/flutter_test.dart';

import 'package:batta_tracker/core/constants/app_constants.dart';

void main() {
  test('app constants are configured', () {
    expect(AppConstants.appName, 'Batta Tracker');
    expect(AppConstants.locationRefreshSeconds, 5);
  });
}
