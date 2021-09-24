import 'package:book_memo/data/model/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../strings.dart';
import 'buildFilter.dart';
import 'buildListActions.dart';

class BuildListBook extends StatefulWidget {
  BuildListBook({Key? key, required this.listBook, this.message})
      : super(key: key);

  final List<Book> listBook;
  final String? message;

  @override
  _BuildListBookState createState() => _BuildListBookState();
}

class _BuildListBookState extends State<BuildListBook> {
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
                  child: SizedBox(height: 500.0, child: _bookList(context))))
        ],
      ),
    );
  }

  Widget _bookList(BuildContext context) {
    if (widget.listBook.length == 0) {
      return Align(
          alignment: Alignment.center,
          child: Text(
              widget.message == null ? Strings.genericError : widget.message!,
              style: TextStyle(fontSize: 18)));
    } else {
      return ListView.builder(
          itemCount: widget.listBook.length,
          itemBuilder: (context, position) {
            return _buildCard(position, context);
          });
    }
  }

  Widget _buildCard(int position, BuildContext context) {
    Color cardColor = position % 2 == 0 ? Colors.blue : Colors.deepPurple;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: cardColor)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ExpansionTile(
            childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
            title: Row(children: <Widget>[
              Image.asset(
                "assets/images/icon_${widget.listBook[position].getNameFromType()}.png",
                width: 50,
              ),
              SizedBox(width: 10),
              Text(widget.listBook[position].title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
            children: [_buildExpansionTile(position, cardColor, context)]),
      ),
    );
  }

  Widget _buildExpansionTile(
      int position, Color cardColor, BuildContext context) {
    Book book = widget.listBook[position];

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
        SizedBox(height: 10),
        Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 13,
                  color: Colors.black12,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: BuildListActions(
              book: book,
              cardColor: cardColor,
              position: position,
              onIncreaseValue: (String column, int updateValue) {
                setState(() {
                  switch (column) {
                    case "volume":
                      widget.listBook[position].volume = updateValue;
                      break;
                    case "chapter":
                      widget.listBook[position].chapter = updateValue;
                      break;
                    case "episode":
                      widget.listBook[position].episode = updateValue;
                      break;
                  }
                });
              },
            )),
      ],
    );
  }
}
