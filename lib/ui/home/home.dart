import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Model/Book.dart';
import '../../Strings.dart';
import '../../bloc/BookBloc.dart';
import '../../bloc/BookEvent.dart';
import '../../bloc/BookState.dart';
import 'buildListBooks.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    BlocProvider.of<BookBloc>(context).add(LoadBook());
  }

  void _addBook() {
    BlocProvider.of<BookBloc>(context).add(AddBook(Book(
        bookType: BookType.manga,
        title: "Naruto",
        author: "Masashi Kishimoto",
        year: 2010,
        isBought: false,
        isFinished: false,
        isFavorite: false,
        volume: 71,
        chapter: 0,
        episode: 0,
        description: "les ninjas sont trop chouettes")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocListener<BookBloc, BookState>(
        listenWhen: (previousState, state) {
          return state is BookSuccess;
        },
        listener: (context, state) {
          BlocProvider.of<BookBloc>(context).add(LoadBook());
        },
        child: BlocBuilder<BookBloc, BookState>(builder: (context, state) {
          if (state is BookHasData) {
            return BuildListBook(listBook: state.booksList);
          } else if (state is BookNoData) {
            return Text(state.message);
          } else if (state is BookError) {
            return Text(state.message);
          } else {
            return Text(Strings.error);
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'AddBook',
        child: Icon(Icons.add),
      ),
    );
  }
}
