import 'dart:convert';

import 'package:bookmemo/data/model/book.dart';
import 'package:bookmemo/data/model/bookRepository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

import '../../strings.dart';

class WidgetHelper {
  final BookRepository repository;

  WidgetHelper({required this.repository});

  Future<List<bool?>?> _sendData(List<String> mListTitle,
      List<String> mListInfo, List<int> mListId) async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('bookTitles', jsonEncode(mListTitle)),
        HomeWidget.saveWidgetData<String>('bookInfos', jsonEncode(mListInfo)),
        HomeWidget.saveWidgetData<String>('bookIds', jsonEncode(mListId)),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
      await FirebaseCrashlytics.instance.recordError(exception, null,
          reason: 'non-fatal error : Error Sending Data WidgetHelper');
    }
  }

  Future<bool?> _updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'WidgetProvider', iOSName: 'WidgetProvider');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
      await FirebaseCrashlytics.instance.recordError(exception, null,
          reason: 'non-fatal error : Error Updating Data WidgetHelper');
    }
  }

  Future<void> sendAndUpdate() async {
    List<String> mListTitle = [];
    List<String> mListInfo = [];
    List<int> mListId = [];
    List<Book> booksList =
        await repository.getBooks(Strings.dbIsFavorite, null);

    if (booksList.isNotEmpty) {
      for (var i = 0; i < booksList.length; i++) {
        mListTitle.add(booksList[i].title);
        mListInfo.add(
            "T${booksList[i].volume}, chap.${booksList[i].chapter}, ep.${booksList[i].episode}");
        mListId.add(booksList[i].id != null ? booksList[i].id! : 0);
      }
    }
    await _sendData(mListTitle, mListInfo, mListId);
    await _updateWidget();
  }

  Future<Book?> launchedFromWidget(var uri) async {
    debugPrint("launchedFromWidget : my URI = $uri");
    if (uri != null && uri.host == "updatebook") {
      var bookList = await repository.getBooks(uri.query, null);
      if (bookList.isNotEmpty) {
        return bookList[0];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
