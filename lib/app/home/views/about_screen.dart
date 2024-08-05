import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pension_compare/app/home/views/policy_viewer_screen.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/route_config.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo _packageInfo = PackageInfo(
      appName: 'unknown',
      packageName: 'unknown',
      version: 'unknown',
      buildNumber: 'unknown');

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('About')),
        body: SafeArea(
            minimum: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icon.png',
                    ),
                    CustomStyles.spacerBox,
                    Text('Pension Compare',
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text('by Happy Bunny Software Ltd',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                        'Version: ${_packageInfo.version}, build: ${_packageInfo.buildNumber}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    CustomStyles.spacerBox,
                    ElevatedButton(
                      child: const Text('Terms and Conditions'),
                      onPressed: () {
                        context.push(RouteDefs.policyViewer,
                            extra: PolicyType.termsAndConditions);
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Privacy Policy'),
                      onPressed: () {
                        context.push(RouteDefs.policyViewer,
                            extra: PolicyType.privacyPolicy);
                      },
                    )
                  ],
                ),
              ),
            )));
  }
}
