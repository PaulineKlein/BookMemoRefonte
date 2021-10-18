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
  static const String columnImagePath = 'imagePath';
  static const String dbCompareTitle = "lower(title) = ?";
  static const String dbHasTitle = "lower(title) LIKE ";
  static const String dbHasAuthor = "lower(author) LIKE ";
  static const String dbHasType = "bookType IN ";
  static const String dbIsFinished = "isFinished IN ";
  static const String dbIsBought = "isBought IN ";
  static const String dbIsFavorite = "isFavorite = 1 ";

  // -- API REQUEST
  static const String serverURL = "kitsu.io";
  static const String headerAccept = "Accept";
  static const String headerAcceptValue = "application/vnd.api+json";
  static const String headerContentType = "Content-Type";
  static const String headerContentTypeValue = "application/vnd.api+json";
  static const String pathEndpoint = "/api/edge/";
  static const String pathTypeManga = "manga";
  static const String pathTypeAnime = "anime";
  static const String pathGetFilter = "filter[text]";
  static const String pathGetInclude = "include";
  static const String pathGetIncludeValue = "staff.person";
  static const String pathGetPageLimit = "page[limit]";
  static const String pathGetPageLimitValue = "1";
  static const String pathGetPageOffset = "page[offset]";
  static const String pathGetPageOffsetValue = "0";
}
