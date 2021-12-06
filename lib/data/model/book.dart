import 'package:easy_localization/src/public_ext.dart';

import '../../strings.dart';

enum BookType { literature, manga, comic, movie }

class Book {
  int? id;
  final BookType bookType;
  final String title;
  final String author;
  final String? editor;
  final int? year;
  bool isBought;
  bool isFinished;
  bool isFavorite = false;
  int volume = 0;
  int chapter = 0;
  int episode = 0;
  String? description;
  String? imagePath;

  Book(
      {this.id,
      required this.bookType,
      required this.title,
      required this.author,
      this.editor,
      this.year,
      required this.isBought,
      required this.isFinished,
      required this.isFavorite,
      required this.volume,
      required this.chapter,
      required this.episode,
      this.description,
      this.imagePath});

  String getNameFromType() {
    switch (this.bookType) {
      case BookType.manga:
        return 'formTypeManga'.tr();
      case BookType.comic:
        return 'formTypeComic'.tr();
      case BookType.literature:
        return 'formTypeLiterature'.tr();
      case BookType.movie:
        return 'formTypeMovie'.tr();
    }
  }

  static BookType getTypeFromName(String? selectedValue) {
    if (selectedValue == 'formTypeManga'.tr()) {
      return BookType.manga;
    } else if (selectedValue == 'formTypeComic'.tr()) {
      return BookType.comic;
    } else if (selectedValue == 'formTypeLiterature'.tr()) {
      return BookType.literature;
    } else {
      return BookType.movie;
    }
  }

  Map<String, dynamic> toMap() {
    var map = {
      Strings.columnBookType: bookType.index,
      Strings.columnTitle: title,
      Strings.columnAuthor: author,
      Strings.columnEditor: editor,
      Strings.columnYear: year,
      Strings.columnIsBought: isBought == true ? 1 : 0,
      Strings.columnIsFinished: isFinished == true ? 1 : 0,
      Strings.columnIsFavorite: isFavorite == true ? 1 : 0,
      Strings.columnVolume: volume,
      Strings.columnChapter: chapter,
      Strings.columnEpisode: episode,
      Strings.columnDescription: description,
      Strings.columnImagePath: imagePath
    };

    if (id != null) map[Strings.columnId] = id;
    return map;
  }

  factory Book.fromMap(Map<String, dynamic> map) => new Book(
      id: map[Strings.columnId],
      bookType: BookType.values[map[Strings.columnBookType]],
      title: map[Strings.columnTitle],
      author: map[Strings.columnAuthor],
      editor: map[Strings.columnEditor],
      year: map[Strings.columnYear],
      isBought: map[Strings.columnIsBought] == 1,
      isFinished: map[Strings.columnIsFinished] == 1,
      isFavorite: map[Strings.columnIsFavorite] == 1,
      volume: map[Strings.columnVolume],
      chapter: map[Strings.columnChapter],
      episode: map[Strings.columnEpisode],
      description: map[Strings.columnDescription],
      imagePath: map[Strings.columnImagePath]);

  factory Book.fromMapOldDatabase(Map<String, dynamic> map) {
    var bookTypeOld = BookType.comic;
    if (map["type"] == "MANGA") {
      bookTypeOld = BookType.manga;
    } else if (map["type"] == "LITERATURE") {
      bookTypeOld = BookType.literature;
    }

    return new Book(
        id: map["id"],
        bookType: bookTypeOld,
        title: map["title"],
        author: map["author"],
        year: map["year"],
        isBought: map["bought"] == 1,
        isFinished: map["finish"] == 1,
        isFavorite: map["favorite"] == 1,
        volume: map["tome"],
        chapter: map["chapter"],
        episode: map["episode"],
        description: map["desc"]);
  }
}
