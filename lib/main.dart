import 'package:bookmemo/ui/addBook/addBook.dart';
import 'package:bookmemo/ui/addBook/bookInteractor.dart';
import 'package:bookmemo/ui/modifyBook/modifyBook.dart';
import 'package:bookmemo/ui/splash.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import "bloc/bookBloc.dart";
import 'bloc/bookBlocObserver.dart';
import 'ui/home/home.dart';

void main() async {
  Bloc.observer = BookBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MultiBlocProvider(providers: [
        BlocProvider<BookBloc>(
          create: (context) => BookBloc(interactor: BookInteractor()),
        ),
      ], child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Memo',
      theme: ThemeData(
        dividerColor: Colors.transparent,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[100],
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,
      routes: {
        AddBookPage.routeName: (context) => AddBookPage(),
        HomePage.routeName: (context) => HomePage(),
        ModifyBookPage.routeName: (context) => ModifyBookPage(),
      },
      home: SplashPage(),
    );
  }
}
