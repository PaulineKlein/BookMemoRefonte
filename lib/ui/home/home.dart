import 'dart:async';
import 'dart:io';

import 'package:bookmemo/helper/fileHelper.dart';
import 'package:bookmemo/helper/widgetHelper.dart';
import 'package:bookmemo/ui/addBook/addBook.dart';
import 'package:bookmemo/ui/generic/alertDialog.dart';
import 'package:bookmemo/ui/modifyBook/modifyBook.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';

import '../../bloc/bookBloc.dart';
import '../../bloc/bookEvent.dart';
import '../../bloc/bookState.dart';
import 'buildListBooks.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription? subscription;
  int _selectedIndex = 0;

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

  Future<void> _importCsv() async {
    int? result = await FileHelper().importCsv();

    if (result == null || result == 0) {
      AlertDialogUtility.getInstance().showAlertDialogTwoChoices(
          context: context,
          alertTitle: 'genericError'.tr(),
          alertMessage: 'genericRetry'.tr(),
          strCancelButton: 'genericYes'.tr(),
          onCancelClick: _onConfirmClick,
          strConfirmButton: 'genericNo'.tr(),
          onConfirmClick: _onCancelClick);
    } else if (result > 0) {
      AlertDialogUtility.getInstance().showPopup(
        context: context,
        alertTitle: 'alertDialogImportTitle'.tr(),
        alertMessage: "${'alertDialogImportMessage'.tr()} $result",
        strCancelButton: 'genericYes'.tr(),
      );
      BlocProvider.of<BookBloc>(this.context).add(LoadBook());
    }
  }

  void _onCancelClick() {
    Navigator.pop(context);
  }

  void _onConfirmClick() {
    Navigator.pop(context);
    _importCsv();
  }

  void _handleMenuClick(String value) {
    if (value == 'menuImport'.tr()) {
      _importCsv();
    } else if (value == 'menuExport'.tr()) {
      FileHelper().createCsv();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('homeTitle'.tr()),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _handleMenuClick,
            itemBuilder: (BuildContext context) {
              return {'menuImport'.tr(), 'menuExport'.tr()}
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
          if(_selectedIndex == 0) {
            if (state is BookHasData) {
              return BuildListBook(listBook: state.booksList);
            } else if (state is BookNoData) {
              return BuildListBook(listBook: [], message: state.message);
            } else if (state is BookError) {
              return BuildListBook(listBook: [], message: state.message);
            } else {
              return BuildListBook(listBook: [], message: "");
            }
          } else {
            return Text("toto");
          }
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: "")
        ],
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'AddBook',
        child: Icon(Icons.add),
      ),
    );
  }
}
