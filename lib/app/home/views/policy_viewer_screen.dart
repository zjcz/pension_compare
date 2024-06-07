import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyViewerScreen extends StatelessWidget {
  final PolicyType policyType;
  const PolicyViewerScreen({super.key, required this.policyType});

  @override
  Widget build(BuildContext context) {
    late String mdFileName;
    late String appBarTitle;

    if (policyType == PolicyType.termsAndConditions) {
      mdFileName = 'terms_and_conditions.md';
      appBarTitle = 'Terms & Conditions';
    } else {
      mdFileName = 'privacy_policy.md';
      appBarTitle = 'Privacy Policy';
    }

    return Scaffold(
        appBar: AppBar(title: Text(appBarTitle)),
        body: SafeArea(
            minimum: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    FutureBuilder(
                      future: rootBundle.loadString('assets/$mdFileName'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return MarkdownBody(
                              data: snapshot.data!,
                              onTapLink: (text, href, title) async {
                                if (href != null) {
                                  await launchUrl(
                                    Uri.parse(href),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              });
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  ],
                ))));
  }
}

enum PolicyType { termsAndConditions, privacyPolicy }
