import 'package:flutter/material.dart';

class AlertDialogUtility {
  static AlertDialogUtility? alert;

  static AlertDialogUtility getInstance() {
    if (alert == null) {
      alert = AlertDialogUtility();
    }
    return alert!;
  }

  showAlertDialog(
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

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text(alertMessage)],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
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
