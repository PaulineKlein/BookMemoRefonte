import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookmemo/data/model/book.dart';
import 'package:bookmemo/data/model/bookRepository.dart';
import 'package:bookmemo/helper/extension/stringExtension.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_extend/share_extend.dart';

import '../../strings.dart';

class FileHelper {
  final BookRepository repository = BookRepository();

  Future<void> createCsv() async {
    var status = await getStoragePermission();
    if (status.isGranted) {
      // récupération du directory pour enregistrer le document :
      String directory = "";
      if (Platform.isAndroid) {
        Directory? externalStorage = await getExternalStorageDirectory();
        directory = externalStorage?.path ?? "";
      } else {
        // enregistrement dans le bac à sable de l'applicatif iOS :
        directory = (await getApplicationDocumentsDirectory()).path;
      }
      var today = DateFormat("dd-MM-yyyy").format(DateTime.now());
      String path = join(directory, "Export_$today.csv");

      List<Book> books = await repository.getBooks(null, null);
      createFile(books, path);
      ShareExtend.share(path, "file");
    }
  }

  File createFile(List<Book> books, String path) {
    // create rows with books informations :
    List<List<dynamic>> rows = <List<dynamic>>[];
    rows.add([
      Strings.formType,
      Strings.formTitle,
      Strings.formAuthor,
      Strings.formYear,
      Strings.formIsBought,
      Strings.formIsFinished,
      Strings.formIsFavorite,
      Strings.formVolume,
      Strings.formChapter,
      Strings.formEpisode,
      Strings.formDescription
    ]);

    for (int i = 0; i < books.length; i++) {
      List<dynamic> row = [];
      row.add(books[i].getNameFromType());
      row.add(books[i].title.removeCsvDelimiter);
      row.add(books[i].author.removeCsvDelimiter);
      row.add(books[i].year ?? "");
      row.add(
          books[i].isBought == true ? Strings.genericYes : Strings.genericNo);
      row.add(books[i].isFinished == true
          ? Strings.bookFinish
          : Strings.bookNotFinish);
      row.add(
          books[i].isFavorite == true ? Strings.genericYes : Strings.genericNo);
      row.add(books[i].volume);
      row.add(books[i].chapter);
      row.add(books[i].episode);
      row.add(books[i].description?.removeCsvDelimiter ?? "");
      rows.add(row);
    }

    String csv = const ListToCsvConverter(fieldDelimiter: ";").convert(rows);
    File newFile = new File(path);
    newFile.writeAsString(csv.removeAccents);

    return newFile;
  }

  Future<int?> importCsv() async {
    String path = await getPathPicker('csv');

    if (path.isNotEmpty) {
      final input = File(path).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter(fieldDelimiter: ";"))
          .toList();

      int nbRows = 0;
      for (int i = 1; i < fields.length; i++) {
        if (fields[i].length == 11) {
          Book book = Book(
              bookType: Book.getTypeFromName(fields[i][0]),
              title: fields[i][1],
              author: fields[i][2],
              year: fields[i][3] == "" ? null : fields[i][3],
              isBought: fields[i][4] == Strings.genericYes ? true : false,
              isFinished: fields[i][5] == Strings.bookFinish ? true : false,
              isFavorite: fields[i][6] == Strings.genericYes ? true : false,
              volume: fields[i][7] == "" ? 0 : fields[i][7],
              chapter: fields[i][8] == "" ? 0 : fields[i][8],
              episode: fields[i][9] == "" ? 0 : fields[i][9],
              description: fields[i][10]);

          repository.insertBook(book);
          nbRows += 1;
        }
      }
      return nbRows;
    } else {
      // User canceled the picker
      return -1;
    }
  }

  Future<PermissionStatus> getStoragePermission() async {
    // pour android besoin d'une permission pour enregistrer le document :
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status;
  }

  Future<String> getPathPicker(String fileType) async {
    // choose the csv file :
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [fileType],
    );
    return result?.files.single.path ?? "";
  }
}
