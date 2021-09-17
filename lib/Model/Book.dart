enum BookType { literature, manga, comic }

class Book {
  final BookType bookType;
  final String title;
  final String author;
  final int? year;
  bool buy;
  bool finish;
  bool favorite = false;
  int volume = 0;
  int chapter = 0;
  int episode = 0;
  String? description;

  Book(
      {required this.bookType,
      required this.title,
      required this.author,
      this.year,
      required this.buy,
      required this.finish,
      required this.favorite,
      required this.volume,
      required this.chapter,
      required this.episode,
      this.description});
}
