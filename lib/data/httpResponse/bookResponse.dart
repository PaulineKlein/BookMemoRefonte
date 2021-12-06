import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'apiResponse.dart';

class BookResponse implements ApiResponse {
  final String? title;
  final String? startDate;
  final String? author;
  final String? editor;

  @override
  String? get imagePath => null;

  BookResponse({this.title, this.startDate, this.author, this.editor});

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    String? title;
    String? startDate;
    String? author;
    String? editor;
    List<String?> authorList = [];
    List<String?> editorList = [];

    try {
      var listData = json["docs"];
      if (listData is List<dynamic> && listData.length > 0) {
        title = listData[0]["title"];
        startDate = listData[0]["first_publish_year"].toString();

        var listAuthor = listData[0]["author_name"];
        if (listAuthor is List<dynamic> && listAuthor.length > 0) {
          int limitNb = 0;
          for (var i = 0; i < listAuthor.length; i++) {
            if (limitNb < 3) {
              authorList.add(listAuthor[i]);
              limitNb += 1; // limit nb of author to 3 persons
            }
          }
          author = authorList.join(", ");
        }

        var listEditor = listData[0]["publisher"];
        if (listEditor is List<dynamic> && listEditor.length > 0) {
          int limitNb = 0;
          for (var i = 0; i < listEditor.length; i++) {
            if (limitNb < 3) {
              editorList.add(listEditor[i]);
              limitNb += 1; // limit nb of author to 3 persons
            }
          }
          editor = editorList.join(", ");
        }
      }
    } catch (exception) {
      debugPrint('Error API request Json. $exception');
      FirebaseCrashlytics.instance.recordError(exception, null,
          reason: 'non-fatal error : Error API request Json');
    }

    return BookResponse(
      title: title,
      startDate: startDate,
      author: author,
      editor: editor
    );
  }
}
