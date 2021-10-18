import 'dart:convert';

import 'package:bookmemo/data/httpResponse/bookResponse.dart';
import 'package:bookmemo/data/model/book.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../strings.dart';

class ApiHelper {
  static Future<BookResponse?> getInformationFromApi(
      BookType booktype, String searchInput) async {
    String pathType = Strings.pathTypeManga;
    if (booktype == BookType.movie) {
      pathType = Strings.pathTypeAnime;
    }
    var client = http.Client();

    var url = Uri.https(Strings.serverURL, Strings.pathEndpoint + pathType, {
      Strings.pathGetFilter: searchInput,
      Strings.pathGetInclude: Strings.pathGetIncludeValue,
      Strings.pathGetPageLimit: Strings.pathGetPageLimitValue,
      Strings.pathGetPageOffset: Strings.pathGetPageOffsetValue
    });

    try {
      var uriResponse = await client.get(url, headers: <String, String>{
        Strings.headerAccept: Strings.headerAcceptValue,
        Strings.headerContentType: Strings.headerContentTypeValue,
      });

      if (uriResponse.statusCode == 200) {
        return BookResponse.fromJson(jsonDecode(uriResponse.body));
      }
    } catch (exception) {
      debugPrint('Error Sending API request Json. $exception');
      FirebaseCrashlytics.instance.recordError(exception, null,
          reason: 'non-fatal error : Error API request Json');
      return null;
    } finally {
      client.close();
    }
  }
}
