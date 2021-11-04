import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'apiResponse.dart';

class MangaResponse implements ApiResponse {
  final String? title;
  final String? startDate;
  final String? imagePath;
  final String? author;

  MangaResponse({this.title, this.startDate, this.imagePath, this.author});

  factory MangaResponse.fromJson(Map<String, dynamic> json) {
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
        int limitNb = 0;
        for (var i = 0; i < listIncluded.length; i++) {
          if (listIncluded[i]["type"] == "people" &&
              listIncluded[i]["attributes"] != null &&
              limitNb < 3) {
            authorList.add(listIncluded[i]["attributes"]["name"]);
            limitNb += 1; // limit nb of author to 3 persons
          }
        }
        author = authorList.join(", ");
      }
    } catch (exception) {
      debugPrint('Error API request Json. $exception');
      FirebaseCrashlytics.instance.recordError(exception, null,
          reason: 'non-fatal error : Error API request Json');
    }

    return MangaResponse(
      title: title,
      startDate: startDate,
      imagePath: imagePath,
      author: author,
    );
  }
}
