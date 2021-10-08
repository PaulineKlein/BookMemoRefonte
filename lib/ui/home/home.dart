import 'dart:async';
import 'dart:io';

import 'package:bookmemo/helper/fileHelper.dart';
import 'package:bookmemo/helper/widgetHelper.dart';
import 'package:bookmemo/ui/addBook/addBook.dart';
import 'package:bookmemo/ui/modifyBook/modifyBook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';

import '../../bloc/bookBloc.dart';
import '../../bloc/bookEvent.dart';
import '../../bloc/bookState.dart';
import '../../strings.dart';
import 'buildListBooks.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon customIcon = const Icon(Icons.search);
  StreamSubscription? subscription;

  @override
  initState() {
    super.initState();
    BlocProvider.of<BookBloc>(this.context).add(LoadBook());
    if (Platform.isAndroid) {
      subscription = HomeWidget.widgetClicked.listen(_launchedFromWidget);
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void _addBook() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Navigator.pushNamed(this.context, AddBookPage.routeName);
    });
  }

  void _launchedFromWidget(var uri) {
    WidgetHelper().launchedFromWidget(uri).then((value) => {
          if (value != null)
            {
              Navigator.pushReplacementNamed(
                  this.context, ModifyBookPage.routeName,
                  arguments: ModifyBookArguments(book: value))
            }
        });
  }

  void _handleMenuClick(String value) {
    switch (value) {
      case Strings.menuImport:
        break;
      case Strings.menuExport:
        FileHelper().createCsv();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.homeTitle),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _handleMenuClick,
            itemBuilder: (BuildContext context) {
              return {Strings.menuImport, Strings.menuExport}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: BlocListener<BookBloc, BookState>(
        listenWhen: (previousState, state) {
          return state is BookSuccess;
        },
        listener: (context, state) {
          BlocProvider.of<BookBloc>(context).add(LoadBook());
        },
        child: BlocBuilder<BookBloc, BookState>(builder: (context, state) {
          if (state is BookHasData) {
            return BuildListBook(listBook: state.booksList);
          } else if (state is BookNoData) {
            return BuildListBook(listBook: [], message: state.message);
          } else if (state is BookError) {
            return BuildListBook(listBook: [], message: state.message);
          } else {
            return BuildListBook(listBook: [], message: "");
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'AddBook',
        child: Icon(Icons.add),
      ),
    );
  }
}
