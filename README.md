# Pension Compare App

![test status](https://github.com/zjcz/pension_compare/actions/workflows/tests.yml/badge.svg)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Flutter Version](https://img.shields.io/badge/Flutter-^3.35.3-blue.svg)](https://flutter.dev/)

A Flutter application to allow users to compare the performance of their pension funds. The app works by allowing the user to input the details of their pensions from their annual statements, then view the performance of each pension as well as how well they are performing in total.

## ✨ Features

- Enter information about pensions, including state pension
- Compare performance using charts
- All data stored locally on device in an encrypted database
- Ability to backup and restore data

## 🖥️ Instructions

To run the app you will need to install flutter. Follow this [Get Started](https://docs.flutter.dev/get-started/install) guide.

- Clone the repository

```bash
git clone https://github.com/zjcz/pension_compare.git
```

- Install the dependencies

```bash
flutter pub get
```

- Start the emulator or connect a device
- Run the application

```bash
flutter run
```

## Testing

The project contains a comprehensive set of tests.

To run the tests, use the following command:

```bash
flutter test
```

## Maestro

The project uses [Maestro](https://maestro.mobile.dev/), a UI Testing framework for mobile to generate screenshots used in the app store. Uses the `maestro_android_screenshots.yaml` script to generate the images. See [API Reference - Commands](https://maestro.mobile.dev/api-reference/commands) for a list of commands, or [Automated Screenshot Generation with Maestro - Code With Andrea](https://codewithandrea.com/tips/automated-screenshot-generation-maestro/) for more information.

## 📸 Screenshots

![home screen](/docs/screenshots/home.png?raw=true "Home Screen")
![home screen - summary](/docs/screenshots/home-summary.png?raw=true "Home Screen - Summary")
![pension performance screen](/docs/screenshots/pension-performance.png?raw=true "Pension Performance Screen")
![pension details screen](/docs/screenshots/pension-details.png?raw=true "Pension Details Screen")
![settings screen](/docs/screenshots/settings.png?raw=true "Settings Screen")

## Database Security

The database is encrypted by Drift using the sqlcipher_flutter_libs packaged, as documented [here](https://drift.simonbinder.eu/docs/platforms/encryption/#encrypted-version-of-a-nativedatabase).

The password for the database is entered by the user in the form of a passcode, which is then encrypted using the [Crypt](https://pub.dev/packages/crypt) package. The hash of this is used as the password for the database. See also [SqlCipher Documentation](https://www.zetetic.net/sqlcipher/sqlcipher-api/#Changing_Key).

## Dev Notes

Uses the following packages:

- [Drift](https://pub.dev/packages/drift) for database management. Database is encrypted.
- [fl_chart](https://pub.dev/packages/fl_chart) for charting. See [Documentation](https://github.com/imaNNeo/fl_chart/tree/main/repo_files/documentations) for more information.
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) for state management.
- [file_picker](https://pub.dev/packages/file_picker) for file selection during backup / restore.
- [archive](https://pub.dev/packages/archive) for backup / restore of data and settings.
- [go_router](https://pub.dev/packages/go_router) for routing / page navigation.

## 🚂 Motivation

This app was originally released on the Google Play Store. However, due to a change in personal circumstance I have removed the app from the store and made the source code publically available. Feel free to fork the repo and build the app yourself for your own use.

## 📄 Terms and Conditions, Privacy Policy

The Terms and Conditions and the Privacy Policy was generated at [App Privacy Policy Generator](https://app-privacy-policy-generator.firebaseapp.com/)

## 💼 License

This project is licensed under the GNU General Public License v3.0 - see the [license.md](license.md) file for details.
