import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import "BlocHelper/BookBloc.dart";
import "BlocHelper/BookEvent.dart";
import "BlocHelper/BookState.dart";
import "Model/Book.dart";
import "Strings.dart";

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> _expanded = [false, false];

  void _addBook() {
    BlocProvider.of<BookBloc>(context).add(AddProduct(Book(
        bookType: BookType.manga,
        title: "Naruto",
        author: "Masashi Kishimoto",
        year: 2010,
        buy: false,
        finish: false,
        favorite: false,
        volume: 71,
        chapter: 0,
        episode: 0,
        description: "les ninjas sont trop chouettes")));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(builder: (_, bookState) {
      List<Book> bookItem = bookState.bookItem;
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    Strings.homeTitle,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(3),
                      child:
                          SizedBox(height: 500.0, child: _bookList(bookItem))))
              //SingleChildScrollView(child: _bookList())),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addBook,
          tooltip: 'AddBook',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }

  Widget _bookList(List<Book> bookItem) {
    if (bookItem.length == 0) {
      return Text(Strings.homeEmptyList);
    } else {
      return ListView.builder(
          itemCount: bookItem.length,
          itemBuilder: (context, position) {
            return _buildCard(position, bookItem[position]);
          });
    }
  }

  // This function displays each new pair in a ListTile,
  // which allows you to make the rows more attractive in the next step
  Widget _buildCard(position, Book book) {
    Color cardColor = position % 2 == 0 ? Colors.blue : Colors.deepPurple;

    return Card(
      elevation: 0,
      //color: position % 2 == 0 ? Colors.blue[100] : Colors.deepPurple[100],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: cardColor)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ExpansionTile(
            childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
            onExpansionChanged: (isExpanded) =>
                _expanded[position] = !isExpanded,
            title: Row(children: <Widget>[
              Icon(Icons.auto_stories_outlined, color: cardColor),
              SizedBox(width: 10),
              Text(book.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
            children: [_buildExpansionTile(book, cardColor)]),
      ),
    );
  }

  Widget _buildExpansionTile(Book book, Color cardColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Icon(Icons.assignment_ind_rounded, color: cardColor),
          SizedBox(width: 5),
          Text(
            book.year != null ? "${book.author} (${book.year})" : book.author,
            style: TextStyle(fontSize: 13.0, color: Colors.black),
          ),
        ]),
        if (book.description != null)
          Row(children: <Widget>[
            Icon(Icons.description_outlined, color: cardColor),
            SizedBox(width: 5),
            Text(
              book.description!,
              style: TextStyle(fontSize: 13.0, color: Colors.black),
            ),
          ]),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: cardColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Row(children: <Widget>[
              Icon(
                  book.buy
                      ? Icons.shopping_cart_outlined
                      : Icons.remove_shopping_cart_outlined,
                  color: cardColor),
              SizedBox(width: 5),
              Text(
                book.buy ? Strings.bookBuy : Strings.bookNotBuy,
                style: TextStyle(fontSize: 13.0, color: Colors.black),
              ),
            ]),
          ),
          SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: cardColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Row(children: <Widget>[
              Icon(book.finish ? Icons.check : Icons.hourglass_bottom,
                  color: cardColor),
              SizedBox(width: 5),
              Text(
                book.finish ? Strings.bookFinish : Strings.bookNotFinish,
                style: TextStyle(fontSize: 13.0, color: Colors.black),
              ),
            ]),
          ),
        ]),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: cardColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Table(
            columnWidths: {
              0: FixedColumnWidth(100.0), // fixed to 100 width
              1: FixedColumnWidth(50.0),
            },
            children: [
              TableRow(children: [
                Text(Strings.bookVolume,
                    style: TextStyle(fontSize: 13.0, color: Colors.black)),
                Text(book.volume > 0 ? "${book.volume}" : "-",
                    style: TextStyle(fontSize: 13.0, color: cardColor)),
              ]),
              TableRow(children: [
                Text(Strings.bookChapter,
                    style: TextStyle(fontSize: 13.0, color: Colors.black)),
                Text(book.chapter > 0 ? "${book.chapter}" : "- ",
                    style: TextStyle(fontSize: 13.0, color: cardColor)),
              ]),
              TableRow(children: [
                Text(Strings.bookEpisode,
                    style: TextStyle(fontSize: 13.0, color: Colors.black)),
                Text(book.episode > 0 ? "${book.episode}" : "-",
                    style: TextStyle(fontSize: 13.0, color: cardColor)),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
