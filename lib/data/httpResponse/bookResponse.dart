import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

class BookResponse {
  final String? title;
  final String? startDate;
  final String? imagePath;
  final String? author;

  BookResponse({this.title, this.startDate, this.imagePath, this.author});

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    String? title;
    String? startDate;
    String? imagePath;
    String? author;
    List<String?> authorList = [];

    try {
      var listData = json["data"];
      if (listData is List<dynamic> && listData.length > 0) {
        if (listData[0]["attributes"] != null) {
          title = listData[0]["attributes"]["canonicalTitle"];
          startDate = listData[0]["attributes"]["startDate"].substring(0, 4);
          if (listData[0]["attributes"]["posterImage"] != null) {
            imagePath = listData[0]["attributes"]["posterImage"]["tiny"];
          }
        }
      }
      var listIncluded = json["included"];
      if (listIncluded is List<dynamic> && listIncluded.length > 0) {
        for (var i = 0; i < listIncluded.length; i++) {
          if (listIncluded[i]["type"] == "people" &&
              listIncluded[i]["attributes"] != null) {
            authorList.add(listIncluded[i]["attributes"]["name"]);
          }
        }
        author = authorList.join(", ");
      }
    } catch (exception) {
      debugPrint('Error API request Json. $exception');
      FirebaseCrashlytics.instance.recordError(exception, null,
          reason: 'non-fatal error : Error API request Json');
    }

    return BookResponse(
      title: title,
      startDate: startDate,
      imagePath: imagePath,
      author: author,
    );
  }
}
