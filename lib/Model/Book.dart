class Book {
  final String title;
  final String author;
  final int? year;
  bool buy;
  bool finish;
  int volume = 0;
  int chapter = 0;
  int episode = 0;
  String? description;

  Book(
      {required this.title,
      required this.author,
      this.year,
      required this.buy,
      required this.finish,
      required this.volume,
      required this.chapter,
      required this.episode,
      this.description});
}
