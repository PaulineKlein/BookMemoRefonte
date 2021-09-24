import '../../strings.dart';

enum BookType { literature, manga, comic }

class Book {
  int? id;
  final BookType bookType;
  final String title;
  final String author;
  final int? year;
  bool isBought;
  bool isFinished;
  bool isFavorite = false;
  int volume = 0;
  int chapter = 0;
  int episode = 0;
  String? description;

  Book(
      {this.id,
      required this.bookType,
      required this.title,
      required this.author,
      this.year,
      required this.isBought,
      required this.isFinished,
      required this.isFavorite,
      required this.volume,
      required this.chapter,
      required this.episode,
      this.description});

  String getNameFromType() {
    switch (this.bookType) {
      case BookType.manga:
        return "manga";
      case BookType.comic:
        return "comic";
      case BookType.literature:
        return "literature";
    }
  }

  Map<String, dynamic> toMap() {
    var map = {
      Strings.columnBookType: bookType.index,
      Strings.columnTitle: title,
      Strings.columnAuthor: author,
      Strings.columnYear: year,
      Strings.columnIsBought: isBought == true ? 1 : 0,
      Strings.columnIsFinished: isFinished == true ? 1 : 0,
      Strings.columnIsFavorite: isFavorite == true ? 1 : 0,
      Strings.columnVolume: volume,
      Strings.columnChapter: chapter,
      Strings.columnEpisode: episode,
      Strings.columnDescription: description,
    };

    if (id != null) map[Strings.columnId] = id;
    return map;
  }

  factory Book.fromMap(Map<String, dynamic> map) => new Book(
      id: map[Strings.columnId],
      bookType: BookType.values[map[Strings.columnBookType]],
      title: map[Strings.columnTitle],
      author: map[Strings.columnAuthor],
      year: map[Strings.columnYear],
      isBought: map[Strings.columnIsBought] == 1,
      isFinished: map[Strings.columnIsFinished] == 1,
      isFavorite: map[Strings.columnIsFavorite] == 1,
      volume: map[Strings.columnVolume],
      chapter: map[Strings.columnChapter],
      episode: map[Strings.columnEpisode],
      description: map[Strings.columnDescription]);
}
