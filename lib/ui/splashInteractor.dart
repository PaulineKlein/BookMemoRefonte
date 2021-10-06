import 'package:bookmemo/bloc/bookBloc.dart';
import 'package:bookmemo/bloc/bookEvent.dart';
import 'package:bookmemo/data/model/bookRepository.dart';
import 'package:bookmemo/widget/widgetHelper.dart';
import 'package:flutter/cupertino.dart';
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
      await prefs.setBool(hasMigrateDatabase, true); // don't migrate next time
      BlocProvider.of<BookBloc>(context).add(LoadBook()); // refresh UI
      widgetHelper.sendAndUpdate(); // refresh home widget
    }
  }
}
