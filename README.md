![test status](https://github.com/zjcz/pension_compare/actions/workflows/tests.yml/badge.svg)

# Pension Compare App

A Flutter application to allow users to compare the performance of their pension funds. The app works be allowing the user to input the details of their pensions from their annual statements, then view the performance of each pension as well as how well they are performing in total.

## Dev Notes

Uses the following packages:

- [Drift](https://pub.dev/packages/drift) for database management. Database is encrypted.
- [fl_chart](https://pub.dev/packages/fl_chart) for charting. See [Documentation](https://github.com/imaNNeo/fl_chart/tree/main/repo_files/documentations) for more information.
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) for state management.
- [file_picker](https://pub.dev/packages/file_picker) for file selection during backup / restore.
- [archive](https://pub.dev/packages/archive) for backup / restore of data and settings.
- [go_router](https://pub.dev/packages/go_router) for routing / page navigation.

## Terms and Conditions, Privacy Policy

The Terms and Conditions and the Privicy Policy was generated at [App Privacy Policy Generator](https://app-privacy-policy-generator.firebaseapp.com/)

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

## Database Security

The database is encrypted by Drift using the sqlcipher_flutter_libs packaged, as document [here](https://drift.simonbinder.eu/docs/platforms/encryption/#encrypted-version-of-a-nativedatabase).

The password for the database is entered by the user in for form of a passcode, which is then encrypted using the [Crypt](https://pub.dev/packages/crypt) package. The hash of this is used as thr password for the database. See also [SqlCipher Documentation](https://www.zetetic.net/sqlcipher/sqlcipher-api/#Changing_Key)
