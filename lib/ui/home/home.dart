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
  Widget customSearchBar = Text(Strings.homeTitle);
  final mySearchController = TextEditingController();

  @override
  initState() {
    super.initState();
    BlocProvider.of<BookBloc>(context).add(LoadBook());
    mySearchController.addListener(_onSearchEditing);
  }

  @override
  void dispose() {
    mySearchController.dispose();
    super.dispose();
  }

  void _addBook() {
    Navigator.pushNamed(context, AddBookPage.routeName);
  }

  void _onSearchClick() {
    setState(() {
      if (customIcon.icon == Icons.search) {
        customIcon = const Icon(Icons.cancel);
        customSearchBar = ListTile(
          leading: Icon(
            Icons.search,
            color: Colors.white,
            size: 28,
          ),
          title: TextField(
            autofocus: true,
            controller: mySearchController,
            decoration: InputDecoration(
              hintText: Strings.homeSearchTitle,
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.white),
          ),
        );
      } else {
        customIcon = const Icon(Icons.search);
        customSearchBar = const Text(Strings.homeTitle);
        mySearchController.clear();
        BlocProvider.of<BookBloc>(context).add(LoadBook());
      }
    });
  }

  void _onSearchEditing() {
    BlocProvider.of<BookBloc>(context).add(SearchBook(mySearchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              _onSearchClick();
            },
            icon: customIcon,
          )
        ],
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
