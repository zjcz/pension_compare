import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  int launchModeCallCount = 0;
  bool launchUrlReturnValue = true;

  void setLaunchUrlExpectation(bool returnValue) {
    launchUrlReturnValue = returnValue;
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) {
    launchModeCallCount++;
    return Future.value(launchUrlReturnValue);
  }

  int launchUrlCalledCount() {
    return launchModeCallCount;
  }
}
