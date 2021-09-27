import 'package:book_memo/bloc/bookBloc.dart';
import 'package:book_memo/bloc/bookEvent.dart';
import 'package:book_memo/data/model/book.dart';
import 'package:book_memo/strings.dart';
import 'package:book_memo/ui/addBook/bookFormBloc.dart';
import 'package:book_memo/ui/addBook/buildBookForm.dart';
import 'package:book_memo/ui/generic/alertDialog.dart';
import 'package:book_memo/ui/generic/loadingDialog.dart';
import 'package:book_memo/ui/home/home.dart';
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
              appBar: AppBar(title: Text(Strings.addBookTitle)),
              floatingActionButton: FloatingActionButton(
                onPressed: formBloc.submit,
                child: Icon(Icons.send),
              ),
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
