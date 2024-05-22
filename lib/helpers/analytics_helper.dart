import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsHelper {
  /// enable or disable Firebase Analytics and Crashlytics
  void enableAnalytics(bool enable) {
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enable);
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enable);
  }
}
