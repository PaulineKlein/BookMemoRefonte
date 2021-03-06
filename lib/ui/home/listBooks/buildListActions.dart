import 'package:bookmemo/bloc/bookBloc.dart';
import 'package:bookmemo/bloc/bookEvent.dart';
import 'package:bookmemo/data/model/book.dart';
import 'package:bookmemo/ui/displayBook/displayBook.dart';
import 'package:bookmemo/ui/generic/alertDialog.dart';
import 'package:bookmemo/ui/modifyBook/modifyBook.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../strings.dart';

class BuildListActions extends StatefulWidget {
  BuildListActions(
      {Key? key,
      required this.book,
      required this.cardColor,
      required this.onIncreaseValue,
      required this.onDeleteBook})
      : super(key: key);

  final Book book;
  final Color cardColor;
  final Function(String, int) onIncreaseValue;
  final Function() onDeleteBook;

  @override
  _BuildListActionsState createState() => _BuildListActionsState();
}

class _BuildListActionsState extends State<BuildListActions> {
  void _deleteBook(BuildContext context) {
    AlertDialogUtility.getInstance().showAlertDialogTwoChoices(
        context: context,
        alertTitle: 'alertDialogDeleteTitle'.tr(),
        alertMessage: 'alertDialogDeleteMessage'.tr(),
        strCancelButton: 'genericYes'.tr(),
        onCancelClick: () {
          Navigator.pop(context);
          BlocProvider.of<BookBloc>(context).add(RemoveBook(widget.book));
          widget.onDeleteBook();
        },
        strConfirmButton: 'genericNo'.tr(),
        onConfirmClick: () {
          Navigator.pop(context);
        });
  }

  void _increaseBook(BuildContext context) {
    AlertDialogUtility.getInstance().showAlertDialogAdvancement(
        context: context,
        alertTitle: widget.book.title,
        onVolumeClick: () {
          int updateValue = widget.book.volume + 1;
          BlocProvider.of<BookBloc>(context).add(
              IncreaseBook(widget.book, Strings.columnVolume, updateValue));
          Navigator.pop(context);
          widget.onIncreaseValue(Strings.columnVolume, updateValue);
        },
        onChapterClick: () {
          int updateValue = widget.book.chapter + 1;
          BlocProvider.of<BookBloc>(context).add(
              IncreaseBook(widget.book, Strings.columnChapter, updateValue));
          Navigator.pop(context);
          widget.onIncreaseValue(Strings.columnChapter, updateValue);
        },
        onEpisodeClick: () {
          int updateValue = widget.book.episode + 1;
          BlocProvider.of<BookBloc>(context).add(
              IncreaseBook(widget.book, Strings.columnEpisode, updateValue));
          Navigator.pop(context);
          widget.onIncreaseValue(Strings.columnEpisode, updateValue);
        });
  }

  void _updateBook(BuildContext context) {
    Navigator.pushNamed(context, ModifyBookPage.routeName,
        arguments: ModifyBookArguments(book: widget.book));
  }

  void _displayBook(BuildContext context) {
    Navigator.pushNamed(context, DisplayBookPage.routeName,
        arguments: DisplayBookArguments(book: widget.book));
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
        Widget>[
      IconButton(
          icon: Icon(Icons.account_balance_outlined,
              color: widget.cardColor, size: 40),
          onPressed: () {
            _displayBook(context);
          }),
      SizedBox(width: 5),
      IconButton(
          icon: Icon(Icons.brush_outlined, color: widget.cardColor, size: 40),
          onPressed: () {
            _updateBook(context);
          }),
      SizedBox(width: 5),
      IconButton(
          icon: Icon(Icons.exposure_plus_1, color: widget.cardColor, size: 40),
          onPressed: () {
            _increaseBook(context);
          }),
      SizedBox(width: 5),
      IconButton(
          icon: Icon(Icons.delete_forever_rounded,
              color: Colors.blueGrey, size: 40),
          onPressed: () {
            _deleteBook(context);
          }),
    ]);
  }
}
