class Strings {
  // -- DATABASE
  static const String bookTable = 'book';
  static const String columnId = 'id';
  static const String columnBookType = 'bookType';
  static const String columnTitle = 'title';
  static const String columnAuthor = 'author';
  static const String columnYear = 'year';
  static const String columnIsBought = 'isBought';
  static const String columnIsFinished = 'isFinished';
  static const String columnIsFavorite = 'isFavorite';
  static const String columnVolume = 'volume';
  static const String columnChapter = 'chapter';
  static const String columnEpisode = 'episode';
  static const String columnDescription = 'description';
  static const String dbCompareTitle = "lower(title) = ?";
  static const String dbHasTitle = "lower(title) LIKE ";
  static const String dbHasAuthor = "lower(author) LIKE ";
  static const String dbHasType = "bookType IN ";
  static const String dbIsFinished = "isFinished IN ";
  static const String dbIsBought = "isBought IN ";
  static const String dbIsFavorite = "isFavorite = 1 ";
}
