import 'package:book_memo/ui/addBook/addBook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bookBloc.dart';
import '../../bloc/bookEvent.dart';
import '../../bloc/bookState.dart';
import '../../strings.dart';
import 'buildListBooks.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon customIcon = const Icon(Icons.search);

  @override
  initState() {
    super.initState();
    BlocProvider.of<BookBloc>(context).add(LoadBook());
  }

  void _addBook() {
    Navigator.pushNamed(context, AddBookPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.homeTitle),
        centerTitle: true,
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
            return BuildListBook(listBook: [], message: state.message);
          } else if (state is BookError) {
            return BuildListBook(listBook: [], message: state.message);
          } else {
            return BuildListBook(listBook: [], message: Strings.genericError);
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
