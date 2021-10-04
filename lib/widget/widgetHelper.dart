import 'dart:convert';

import 'package:book_memo/data/model/book.dart';
import 'package:book_memo/data/model/bookRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

import '../strings.dart';

class WidgetHelper {
  final BookRepository repository = BookRepository();

  Future<List<bool?>?> _sendData(
      List<String> mListTitle, List<String> mListInfo) async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('bookTitles', jsonEncode(mListTitle)),
        HomeWidget.saveWidgetData<String>('bookInfos', jsonEncode(mListInfo)),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future<bool?> _updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'WidgetProvider', iOSName: 'WidgetProvider');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  Future<void> sendAndUpdate() async {
    List<String> mListTitle = [];
    List<String> mListInfo = [];
    List<Book> booksList =
        await repository.getBooks(Strings.dbIsFavorite, null);

    if (booksList.isNotEmpty) {
      for (var i = 0; i < booksList.length; i++) {
        mListTitle.add(booksList[i].title);
        mListInfo.add(
            "T${booksList[i].volume}, chap.${booksList[i].chapter}, ep.${booksList[i].episode}");
      }
      await _sendData(mListTitle, mListInfo);
      await _updateWidget();
    }
  }
}
