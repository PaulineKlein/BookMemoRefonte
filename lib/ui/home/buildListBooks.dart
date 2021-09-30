import 'package:book_memo/bloc/bookBloc.dart';
import 'package:book_memo/bloc/bookEvent.dart';
import 'package:book_memo/data/model/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              widget.message == null
                  ? Strings.filterEmptyList
                  : widget.message!,
              style: TextStyle(fontSize: 18)));
    } else {
      return ListView.builder(
          itemCount: widget.listBook.length,
          itemBuilder: (context, position) {
            return _buildCard(position, context);
          });
    }
  }

  Widget _buildCard(int pos, BuildContext context) {
    Color cardColor = pos % 2 == 0 ? Colors.blue : Colors.deepPurple;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: cardColor)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
            colorScheme: ThemeData().colorScheme.copyWith(primary: cardColor),
          ),
          child: ExpansionTile(
              childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
              title: _buildTitleTile(pos),
              children: [_buildExpansionTile(pos, cardColor, context)]),
        ),
      ),
    );
  }

  Widget _buildTitleTile(int pos) {
    return Row(children: <Widget>[
      Image.asset(
        "assets/images/icon_${widget.listBook[pos].getNameFromType()}.png",
        width: 50,
      ),
      SizedBox(width: 10),
      Flexible(
          child: Text(
        widget.listBook[pos].title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        maxLines: 5,
      )),
    ]);
  }

  Widget _buildExpansionTile(int pos, Color cardColor, BuildContext context) {
    Book book = widget.listBook[pos];
    String author =
        book.author.isEmpty ? Strings.bookAuthorNotKnown : book.author;
    BoxDecoration decorateTile = BoxDecoration(
      boxShadow: [
        BoxShadow(blurRadius: 13, color: cardColor.withOpacity(0.2)),
      ],
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          _buildBookInfoInChip(
              cardColor,
              book.isBought ? Strings.bookBuy : Strings.bookNotBuy,
              book.isBought
                  ? Icons.shopping_cart_outlined
                  : Icons.remove_shopping_cart_outlined),
          SizedBox(width: 5),
          _buildBookInfoInChip(
              cardColor,
              book.isFinished ? Strings.bookFinish : Strings.bookNotFinish,
              book.isFinished ? Icons.check : Icons.hourglass_bottom),
          new Spacer(),
          _buildFavoriteIcon(pos, cardColor),
        ]),
        SizedBox(height: 10),
        Container(
          decoration: decorateTile,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildBookInfoInRow(
                    cardColor,
                    book.year != null ? "$author (${book.year})" : author,
                    Icons.assignment_ind_rounded),
                if (book.description != null &&
                    book.description?.isNotEmpty == true)
                  _buildBookInfoInRow(
                      cardColor, book.description!, Icons.description_outlined),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: cardColor.withOpacity(0.2),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Table(
                    columnWidths: {
                      0: FixedColumnWidth(100.0), // fixed to 100 width
                      1: FixedColumnWidth(50.0),
                    },
                    children: [
                      TableRow(children: [
                        Text(Strings.bookVolume,
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.black)),
                        Text(book.volume > 0 ? "${book.volume}" : "-",
                            style: TextStyle(
                                fontSize: 13.0,
                                color: cardColor,
                                fontWeight: FontWeight.bold)),
                      ]),
                      TableRow(children: [
                        Text(Strings.bookChapter,
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.black)),
                        Text(book.chapter > 0 ? "${book.chapter}" : "- ",
                            style: TextStyle(
                                fontSize: 13.0,
                                color: cardColor,
                                fontWeight: FontWeight.bold)),
                      ]),
                      TableRow(children: [
                        Text(Strings.bookEpisode,
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.black)),
                        Text(book.episode > 0 ? "${book.episode}" : "-",
                            style: TextStyle(
                                fontSize: 13.0,
                                color: cardColor,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ],
                  ),
                ),
              ]),
        ),
        SizedBox(height: 10),
        Container(
            decoration: decorateTile,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: BuildListActions(
              book: book,
              cardColor: cardColor,
              onIncreaseValue: (String column, int updateValue) {
                setState(() {
                  switch (column) {
                    case Strings.columnVolume:
                      widget.listBook[pos].volume = updateValue;
                      break;
                    case Strings.columnChapter:
                      widget.listBook[pos].chapter = updateValue;
                      break;
                    case Strings.columnEpisode:
                      widget.listBook[pos].episode = updateValue;
                      break;
                  }
                });
              },
              onDeleteBook: () {
                setState(() {
                  widget.listBook.remove(widget.listBook[pos]);
                });
              },
            )),
      ],
    );
  }

  Widget _buildBookInfoInRow(
      Color cardColor, String textStatus, IconData iconStatus) {
    return Row(children: <Widget>[
      Icon(iconStatus, color: cardColor),
      SizedBox(width: 5),
      Flexible(
        child: Text(
          textStatus,
          style: TextStyle(fontSize: 13.0, color: Colors.black),
        ),
      ),
    ]);
  }

  Widget _buildBookInfoInChip(
      Color cardColor, String textStatus, IconData iconStatus) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: cardColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(children: <Widget>[
        Icon(iconStatus, color: cardColor),
        SizedBox(width: 5),
        Text(
          textStatus,
          style: TextStyle(fontSize: 13.0, color: Colors.black),
        ),
      ]),
    );
  }

  Widget _buildFavoriteIcon(int pos, Color cardColor) {
    // on click on the icon, inverse the value of favorite
    int isfavoriteUpdate = widget.listBook[pos].isFavorite ? 0 : 1;
    return IconButton(
        icon: Icon(
            widget.listBook[pos].isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.pink[400]),
        onPressed: () {
          BlocProvider.of<BookBloc>(context).add(IncreaseBook(
              widget.listBook[pos],
              Strings.columnIsFavorite,
              isfavoriteUpdate));
          setState(() {
            widget.listBook[pos].isFavorite = !widget.listBook[pos].isFavorite;
          });
        });
  }
}
