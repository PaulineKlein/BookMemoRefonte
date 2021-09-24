import 'package:book_memo/bloc/bookBloc.dart';
import 'package:book_memo/bloc/bookEvent.dart';
import 'package:book_memo/data/model/book.dart';
import 'package:book_memo/ui/generic/alertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../strings.dart';

class BuildListActions extends StatefulWidget {
  BuildListActions(
      {Key? key,
      required this.book,
      required this.cardColor,
      required this.position,
      required this.onIncreaseValue})
      : super(key: key);

  final Book book;
  final Color cardColor;
  final int position;
  final Function(String, int) onIncreaseValue;

  @override
  _BuildListActionsState createState() => _BuildListActionsState();
}

class _BuildListActionsState extends State<BuildListActions> {
  void _deleteBook(BuildContext context, Book book) {
    AlertDialogUtility.getInstance().showAlertDialogTwoChoices(
        context: context,
        alertTitle: Strings.alertDialogDeleteTitle,
        alertMessage: Strings.alertDialogDeleteMessage,
        strCancelButton: Strings.genericYes,
        onCancelClick: () {
          Navigator.pop(context);
          BlocProvider.of<BookBloc>(context).add(RemoveBook(book));
        },
        strConfirmButton: Strings.genericNo,
        onConfirmClick: () {
          Navigator.pop(context);
        });
  }

  void _increaseBook(BuildContext context, int position) {
    AlertDialogUtility.getInstance().showAlertDialogAdvancement(
        context: context,
        alertTitle: widget.book.title,
        onVolumeClick: () {
          int updateValue = widget.book.volume + 1;
          BlocProvider.of<BookBloc>(context)
              .add(IncreaseBook(widget.book, "volume", updateValue));
          Navigator.pop(context);
          widget.onIncreaseValue("volume", updateValue);
        },
        onChapterClick: () {
          int updateValue = widget.book.chapter + 1;
          BlocProvider.of<BookBloc>(context)
              .add(IncreaseBook(widget.book, "chapter", updateValue));
          Navigator.pop(context);
          widget.onIncreaseValue("chapter", updateValue);
        },
        onEpisodeClick: () {
          int updateValue = widget.book.episode + 1;
          BlocProvider.of<BookBloc>(context)
              .add(IncreaseBook(widget.book, "episode", updateValue));
          Navigator.pop(context);
          widget.onIncreaseValue("episode", updateValue);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
        Widget>[
      IconButton(
          icon: Icon(Icons.brush_outlined, color: widget.cardColor, size: 40),
          onPressed: () {
            //_deleteBook(context);
          }),
      SizedBox(width: 5),
      IconButton(
          icon: Icon(Icons.exposure_plus_1, color: widget.cardColor, size: 40),
          onPressed: () {
            _increaseBook(context, widget.position);
          }),
      SizedBox(width: 5),
      IconButton(
          icon: Icon(Icons.delete_forever_rounded,
              color: Colors.blueGrey, size: 40),
          onPressed: () {
            _deleteBook(context, widget.book);
          }),
    ]);
  }
}
