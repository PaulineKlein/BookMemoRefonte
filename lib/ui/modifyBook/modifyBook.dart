import 'dart:io';

import 'package:bookmemo/bloc/bookBloc.dart';
import 'package:bookmemo/bloc/bookEvent.dart';
import 'package:bookmemo/data/model/book.dart';
import 'package:bookmemo/ui/addBook/bookFormBloc.dart';
import 'package:bookmemo/ui/addBook/buildBookForm.dart';
import 'package:bookmemo/ui/generic/alertDialog.dart';
import 'package:bookmemo/ui/generic/customFloatingActionButton.dart';
import 'package:bookmemo/ui/generic/loadingDialog.dart';
import 'package:bookmemo/ui/home/home.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class ModifyBookArguments {
  final Book book;

  ModifyBookArguments({required this.book});
}

class ModifyBookPage extends StatefulWidget {
  ModifyBookPage({Key? key}) : super(key: key);
  static const routeName = '/modify_book';

  @override
  _ModifyBookState createState() => _ModifyBookState();
}

class _ModifyBookState extends State<ModifyBookPage> {
  bool isSmallFAB = false;
  ScrollController _scrollController = new ScrollController();

  @override
  initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        setState(() {
          isSmallFAB = true;
        });
      } else {
        setState(() {
          isSmallFAB = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ModifyBookArguments;

    return BlocProvider(
      create: (context) => BookFormBloc(arguments.book),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<BookFormBloc>(context);
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('modifyBookTitle'.tr())),
              floatingActionButton: customFloatingActionButton(
                  isSmallFAB, 'modifyBookSend'.tr(), () {
                return formBloc.submit;
              }),
              body: FormBlocListener<BookFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    LoadingDialog.show(context);
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);
                    _onConfirmClick();
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);
                    AlertDialogUtility.getInstance().showAlertDialogTwoChoices(
                        context: context,
                        alertTitle: 'genericError'.tr(),
                        alertMessage: 'genericRetry'.tr(),
                        strCancelButton: 'genericYes'.tr(),
                        onCancelClick: _onCancelClick,
                        strConfirmButton: 'genericNo'.tr(),
                        onConfirmClick: _onConfirmClick);
                  },
                  child: BuildBookForm(
                      formBloc: formBloc,
                      scrollController: _scrollController,
                      image: _getImageFileFromBook(arguments.book))),
            ),
          );
        },
      ),
    );
  }

  void _onCancelClick() {
    Navigator.pop(context);
  }

  void _onConfirmClick() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (Route<dynamic> route) => false);
      BlocProvider.of<BookBloc>(context).add(LoadBook());
    });
  }

  File? _getImageFileFromBook(Book book) {
    if (book.imagePath != null && File(book.imagePath!).existsSync())
      return File(book.imagePath!);
  }
}
