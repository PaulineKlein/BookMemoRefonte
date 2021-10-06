import 'package:bookmemo/bloc/bookBloc.dart';
import 'package:bookmemo/bloc/bookEvent.dart';
import 'package:bookmemo/data/model/bookRepository.dart';
import 'package:bookmemo/widget/widgetHelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashInteractor {
  final BookRepository repository = BookRepository();
  final WidgetHelper widgetHelper = WidgetHelper();
  static const String hasMigrateDatabase = "HAS_MIGRATE";

  Future<void> migrateOldDatabase(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasMigrate = prefs.getBool(hasMigrateDatabase) ?? false;

    if (!hasMigrate) {
      bool isMigrationSuccess = await repository.hasMigrateOldDatabase();
      debugPrint("SplashInteractor : migrateOldDatabase : $isMigrationSuccess");
      await FirebaseCrashlytics.instance.recordError(
          ArgumentError("migrateOldDatabase success ? : $isMigrationSuccess",
              "SplashInteractorError"),
          null,
          reason: 'non-fatal error');
      await prefs.setBool(hasMigrateDatabase, true); // don't migrate next time
      BlocProvider.of<BookBloc>(context).add(LoadBook()); // refresh UI
      widgetHelper.sendAndUpdate(); // refresh home widget
    }
  }

  // Define an async function to initialize FlutterFire
  Future<void> initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      FlutterError.onError = (FlutterErrorDetails details) async {
        await FirebaseCrashlytics.instance.recordFlutterError(details);
      };

      if (kDebugMode) {
        // Force disable Crashlytics collection while doing every day development.
        // Temporarily toggle this to true if you want to test crash reporting in your app.
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(true);
      } else {
        // Handle Crashlytics enabled status when not in Debug,
        // e.g. allow your users to opt-in to crash reporting.
      }
    } catch (exception) {
      debugPrint('Error initializeFlutterFire. $exception');
    }
  }
}
