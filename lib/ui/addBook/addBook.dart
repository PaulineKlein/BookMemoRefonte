import 'package:bookmemo/bloc/bookBloc.dart';
import 'package:bookmemo/bloc/bookEvent.dart';
import 'package:bookmemo/ui/generic/alertDialog.dart';
import 'package:bookmemo/ui/generic/customFloatingActionButton.dart';
import 'package:bookmemo/ui/generic/loadingDialog.dart';
import 'package:bookmemo/ui/home/home.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'bookFormBloc.dart';
import 'buildBookForm.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage({Key? key}) : super(key: key);
  static const routeName = '/add_book';

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBookPage> {
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
    return BlocProvider(
      create: (context) => BookFormBloc(null),
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
              appBar: AppBar(title: Text('addBookTitle'.tr())),
              floatingActionButton: customFloatingActionButton(
                  isSmallFAB, 'addBookSend'.tr(), () {
                return formBloc.submit;
              }),
              body: FormBlocListener<BookFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    LoadingDialog.show(context);
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);
                    AlertDialogUtility.getInstance().showAlertDialogTwoChoices(
                        context: context,
                        alertTitle: 'alertDialogAddTitle'.tr(),
                        alertMessage: 'alertDialogAddMessage'.tr(),
                        strCancelButton: 'genericYes'.tr(),
                        onCancelClick: _onCancelClick,
                        strConfirmButton: 'genericNo'.tr(),
                        onConfirmClick: _onConfirmClick);
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
                      formBloc: formBloc, scrollController: _scrollController)),
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
}
