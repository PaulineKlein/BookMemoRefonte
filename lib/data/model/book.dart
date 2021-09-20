enum BookType { literature, manga, comic }

class Book {
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
      {required this.bookType,
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

  Map<String, dynamic> toMap() {
    return {
      'bookType': bookType.index,
      'title': title,
      'author': author,
      'year': year,
      'isBought': isBought,
      'isFinished': isFinished,
      'isFavorite': isFavorite,
      'volume': volume,
      'chapter': chapter,
      'episode': episode,
      'description': description,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) => new Book(
      bookType: BookType.values[map['bookType']],
      title: map['title'],
      author: map['author'],
      year: map['year'],
      isBought: map['isBought'] == 1,
      isFinished: map['isFinished'] == 1,
      isFavorite: map['isFavorite'] == 1,
      volume: map['volume'],
      chapter: map['chapter'],
      episode: map['episode'],
      description: map['description']);
}
