import 'package:bookmemo/bloc/bookBloc.dart';
import 'package:bookmemo/bloc/bookEvent.dart';
import 'package:bookmemo/data/model/book.dart';
import 'package:bookmemo/ui/generic/alertDialog.dart';
import 'package:bookmemo/ui/generic/orangeBlurredBoxDecoration.dart';
import 'package:bookmemo/ui/modifyBook/modifyBook.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../strings.dart';

class BuildActions extends StatefulWidget {
  BuildActions(
      {Key? key,
      required this.book,
      required this.onIncreaseValue,
      required this.onDeleteBook})
      : super(key: key);

  final Book book;
  final Function(String, int) onIncreaseValue;
  final Function() onDeleteBook;

  @override
  _BuildActionsState createState() => _BuildActionsState();
}

class _BuildActionsState extends State<BuildActions> {
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

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: () {
              _updateBook(context);
            },
            child: _buildActionButton("icon_modify", "Modifier"),
          ),
          SizedBox(width: 5),
          InkWell(
            onTap: () {
              _increaseBook(context);
            },
            child: _buildActionButton("icon_add", "Ajouter"),
          ),
          SizedBox(width: 5),
          InkWell(
            onTap: () {
              _deleteBook(context);
            },
            child: _buildActionButton("icon_delete", "Supprimer"),
          ),
        ]);
  }

  Widget _buildActionButton(String imagePath, String title) {
    return Container(
        alignment: Alignment.center,
        width: 100,
        height: 100,
        decoration: orangeBlurredBoxDecoration(Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset("assets/images/$imagePath.svg",
                semanticsLabel: imagePath),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white)),
          ],
        ));
  }
}
