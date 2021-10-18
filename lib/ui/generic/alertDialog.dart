import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class AlertDialogUtility {
  static AlertDialogUtility? alert;

  static AlertDialogUtility getInstance() {
    if (alert == null) {
      alert = AlertDialogUtility();
    }
    return alert!;
  }

  void showPopup(
      {required BuildContext context,
      required String alertTitle,
      required String alertMessage}) {

    Widget cancelButton = TextButton(
      child: Text('genericOk'.tr()),
      onPressed: () {
          Navigator.pop(context);
      },
    );

    _showDialog(
        context: context,
        alertTitle: alertTitle,
        alertMessage: alertMessage,
        listButton: [cancelButton]);
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
      child: Text('formVolume'.tr()),
      onPressed: () {
        onVolumeClick();
      },
    );
    Widget chapterButton = TextButton(
      child: Text('formChapter'.tr()),
      onPressed: () {
        onChapterClick();
      },
    );
    Widget episodeButton = TextButton(
      child: Text('formEpisode'.tr()),
      onPressed: () {
        onEpisodeClick();
      },
    );

    _showDialog(
        context: context,
        alertTitle: alertTitle,
        alertMessage: 'alertDialogAdvancementMessage'.tr(),
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

  void showCustomImageDialog(
      {required BuildContext context,
      required String alertTitle,
      required String alertMessage,
      required String? imagePath,
      required Function()? onCancelClick,
      required Function()? onConfirmClick}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text('genericNo'.tr()),
      onPressed: () {
        if (onCancelClick == null) {
          Navigator.pop(context);
        } else {
          onCancelClick();
        }
      },
    );
    Widget continueButton = TextButton(
      child: Text('genericYes'.tr()),
      onPressed: () {
        Navigator.pop(context);
        if (onConfirmClick != null) {
          onConfirmClick();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text(alertMessage, maxLines: 20)),
                imagePath != null && Uri.parse(imagePath).isAbsolute
                    ? CachedNetworkImage(
                        imageUrl: imagePath,
                        width: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/add_image.png'),
                      )
                    : Image.asset('assets/images/add_image.png')
              ],
            )
          ],
        ),
      ),
      actions: [continueButton, cancelButton],
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
