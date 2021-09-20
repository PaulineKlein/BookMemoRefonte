import 'package:book_memo/data/model/bookRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import "bloc/bookBloc.dart";
import 'bloc/bookBlocObserver.dart';
import 'ui/home/home.dart';

void main() {
  Bloc.observer = BookBlocObserver();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<BookBloc>(
      create: (context) => BookBloc(repository: BookRepository()),
    ),
  ], child: MyApp()));
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
      home: HomePage(title: 'Book Memo'),
    );
  }
}
