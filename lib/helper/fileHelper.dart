import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookmemo/data/model/book.dart';
import 'package:bookmemo/data/model/bookRepository.dart';
import 'package:bookmemo/helper/extension/stringExtension.dart';
import 'package:csv/csv.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_extend/share_extend.dart';

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
      String path = join(directory, "Export_BookMemo.csv");

      List<Book> books = await repository.getBooks(null, null);
      createFile(books, path);
      ShareExtend.share(path, "file");
    }
  }

  File createFile(List<Book> books, String path) {
    // create rows with books informations :
    List<List<dynamic>> rows = <List<dynamic>>[];
    rows.add([
      'formType'.tr(),
      'formTitle'.tr(),
      'formAuthor'.tr(),
      'formYear'.tr(),
      'formIsBought'.tr(),
      'formIsFinished'.tr(),
      'formIsFavorite'.tr(),
      'formVolume'.tr(),
      'formChapter'.tr(),
      'formEpisode'.tr(),
      'formDescription'.tr()
    ]);

    for (int i = 0; i < books.length; i++) {
      List<dynamic> row = [];
      row.add(books[i].getNameFromType());
      row.add(books[i].title.removeCsvDelimiter);
      row.add(books[i].author.removeCsvDelimiter);
      row.add(books[i].year ?? "");
      row.add(books[i].isBought == true ? 'genericYes'.tr() : 'genericNo'.tr());
      row.add(books[i].isFinished == true
          ? 'bookFinish'.tr()
          : 'bookNotFinish'.tr());
      row.add(
          books[i].isFavorite == true ? 'genericYes'.tr() : 'genericNo'.tr());
      row.add(books[i].volume);
      row.add(books[i].chapter);
      row.add(books[i].episode);
      row.add(books[i].description?.removeCsvDelimiter ?? "");
      row.add(books[i].imagePath?.removeCsvDelimiter ?? "");
      rows.add(row);
    }

    String csv = const ListToCsvConverter(fieldDelimiter: ";").convert(rows);
    File newFile = new File(path);
    newFile.writeAsString(csv.removeAccents);

    return newFile;
  }

  Future<int?> importCsv() async {
    String path = await getPathPicker(['csv']);

    if (path.isNotEmpty) {
      final input = File(path).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter(fieldDelimiter: ";"))
          .toList();

      int nbRows = 0;
      for (int i = 1; i < fields.length; i++) {
        if (fields[i].length == 12) {
          Book book = Book(
              bookType: Book.getTypeFromName(fields[i][0]),
              title: fields[i][1],
              author: fields[i][2],
              year: fields[i][3] == "" ? null : fields[i][3],
              isBought: fields[i][4] == 'genericYes'.tr() ? true : false,
              isFinished: fields[i][5] == 'bookFinish'.tr() ? true : false,
              isFavorite: fields[i][6] == 'genericYes'.tr() ? true : false,
              volume: fields[i][7] == "" ? 0 : fields[i][7],
              chapter: fields[i][8] == "" ? 0 : fields[i][8],
              episode: fields[i][9] == "" ? 0 : fields[i][9],
              description: fields[i][10],
              imagePath: fields[i][11]);

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

  Future<String> getPathPicker(List<String> fileType) async {
    // choose the csv file :
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: fileType,
    );
    return result?.files.single.path ?? "";
  }
}
