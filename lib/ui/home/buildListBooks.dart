import 'package:book_memo/data/model/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../strings.dart';
import 'buildFilter.dart';

class BuildListBook extends StatelessWidget {
  const BuildListBook({Key? key, required this.listBook, this.message})
      : super(key: key);

  final List<Book> listBook;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: BuildFilter(),
            ),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(3),
                  child: SizedBox(height: 500.0, child: _bookList(listBook))))
          //SingleChildScrollView(child: _bookList())),
        ],
      ),
    );
  }

  Widget _bookList(List<Book> listBook) {
    if (listBook.length == 0) {
      return Align(
          alignment: Alignment.center,
          child: Text(message == null ? Strings.genericError : message!,
              style: TextStyle(fontSize: 18)));
    } else {
      return ListView.builder(
          itemCount: listBook.length,
          itemBuilder: (context, position) {
            return _buildCard(position, listBook[position]);
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
                  book.isBought
                      ? Icons.shopping_cart_outlined
                      : Icons.remove_shopping_cart_outlined,
                  color: cardColor),
              SizedBox(width: 5),
              Text(
                book.isBought ? Strings.bookBuy : Strings.bookNotBuy,
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
              Icon(book.isFinished ? Icons.check : Icons.hourglass_bottom,
                  color: cardColor),
              SizedBox(width: 5),
              Text(
                book.isFinished ? Strings.bookFinish : Strings.bookNotFinish,
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
