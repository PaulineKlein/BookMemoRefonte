import 'package:flutter/material.dart';

import '../../strings.dart';

class AlertDialogUtility {
  static AlertDialogUtility? alert;

  static AlertDialogUtility getInstance() {
    if (alert == null) {
      alert = AlertDialogUtility();
    }
    return alert!;
  }

  void showAlertDialogTwoChoices(
      {required BuildContext context,
      required String alertTitle,
      required String alertMessage,
      required String strCancelButton,
      required Function()? onCancelClick,
      required String strConfirmButton,
      required Function() onConfirmClick}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(strCancelButton),
      onPressed: () {
        if (onCancelClick == null) {
          Navigator.pop(context);
        } else {
          onCancelClick();
        }
      },
    );
    Widget continueButton = TextButton(
      child: Text(strConfirmButton),
      onPressed: () {
        onConfirmClick();
      },
    );

    _showDialog(
        context: context,
        alertTitle: alertTitle,
        alertMessage: alertMessage,
        listButton: [cancelButton, continueButton]);
  }

  void showAlertDialogAdvancement(
      {required BuildContext context,
      required String alertTitle,
      required Function() onVolumeClick,
      required Function() onChapterClick,
      required Function() onEpisodeClick}) {
    // set up the buttons
    Widget volumeButton = TextButton(
      child: Text(Strings.formVolume),
      onPressed: () {
        onVolumeClick();
      },
    );
    Widget chapterButton = TextButton(
      child: Text(Strings.formChapter),
      onPressed: () {
        onChapterClick();
      },
    );
    Widget episodeButton = TextButton(
      child: Text(Strings.formEpisode),
      onPressed: () {
        onEpisodeClick();
      },
    );

    _showDialog(
        context: context,
        alertTitle: alertTitle,
        alertMessage: Strings.alertDialogAdvancementMessage,
        listButton: [volumeButton, chapterButton, episodeButton]);
  }

  void _showDialog(
      {required BuildContext context,
      required String alertTitle,
      required String alertMessage,
      required List<Widget> listButton}) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text(alertMessage)],
        ),
      ),
      actions: listButton,
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
