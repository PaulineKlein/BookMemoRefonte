import 'package:book_memo/bloc/bookBloc.dart';
import 'package:book_memo/bloc/bookEvent.dart';
import 'package:book_memo/strings.dart';
import 'package:book_memo/ui/generic/alertDialog.dart';
import 'package:book_memo/ui/generic/loadingDialog.dart';
import 'package:book_memo/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'AddBookFormBloc.dart';
import 'buildBookForm.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage({Key? key}) : super(key: key);
  static const routeName = '/add_book';

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBookPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddBookFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<AddBookFormBloc>(context);
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
              appBar: AppBar(title: Text(Strings.addBookTitle)),
              floatingActionButton: FloatingActionButton(
                onPressed: formBloc.submit,
                child: Icon(Icons.send),
              ),
              body: FormBlocListener<AddBookFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    LoadingDialog.show(context);
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);
                    AlertDialogUtility.getInstance().showAlertDialogTwoChoices(
                        context: context,
                        alertTitle: Strings.alertDialogAddTitle,
                        alertMessage: Strings.alertDialogAddMessage,
                        strCancelButton: Strings.genericYes,
                        onCancelClick: _onCancelClick,
                        strConfirmButton: Strings.genericNo,
                        onConfirmClick: _onConfirmClick);
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);
                    AlertDialogUtility.getInstance().showAlertDialogTwoChoices(
                        context: context,
                        alertTitle: Strings.genericError,
                        alertMessage: Strings.genericRetry,
                        strCancelButton: Strings.genericYes,
                        onCancelClick: _onCancelClick,
                        strConfirmButton: Strings.genericNo,
                        onConfirmClick: _onConfirmClick);
                  },
                  child: BuildBookForm(formBloc: formBloc)),
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
    Navigator.pushNamed(context, HomePage.routeName);
    BlocProvider.of<BookBloc>(context).add(LoadBook());
  }
}
