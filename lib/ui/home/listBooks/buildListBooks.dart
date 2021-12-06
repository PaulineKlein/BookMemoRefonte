import 'dart:io';

import 'package:bookmemo/bloc/bookBloc.dart';
import 'package:bookmemo/bloc/bookEvent.dart';
import 'package:bookmemo/data/model/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../strings.dart';
import '../../bookMemo_theme.dart';
import '../filter/buildFilter.dart';
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
                  padding: EdgeInsets.all(16),
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
              widget.message == null ? 'filterEmptyList'.tr() : widget.message!,
              style: TextStyle(fontSize: 18)));
    } else {
      return ListView.builder(
          itemCount: widget.listBook.length,
          itemBuilder: (context, position) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: _buildCard(position, context),
            );
          });
    }
  }

  Widget _buildCard(int pos, BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: colorPrimary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.black)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
            colorScheme:
                ThemeData().colorScheme.copyWith(primary: Colors.black),
          ),
          child: ExpansionTile(
              childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
              title: _buildTitleTile(pos),
              children: [_buildExpansionTile(pos, context)]),
        ),
      ),
    );
  }

  Widget _buildTitleTile(int pos) {
    return Row(children: <Widget>[
      _displayImage(pos),
      SizedBox(width: 10),
      Flexible(
          child: Text(
        widget.listBook[pos].title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        maxLines: 5,
      )),
    ]);
  }

  Widget _buildExpansionTile(int pos, BuildContext context) {
    Book book = widget.listBook[pos];
    String author =
        book.author.isEmpty ? 'bookAuthorNotKnown'.tr() : book.author;
    BoxDecoration decorateTile = BoxDecoration(
      boxShadow: [
        BoxShadow(blurRadius: 13, color: colorPrimaryLight),
      ],
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          _buildBookInfoInChip(
              colorPrimary,
              book.isBought ? 'bookBuy'.tr() : 'bookNotBuy'.tr(),
              book.isBought
                  ? Icons.shopping_cart_outlined
                  : Icons.remove_shopping_cart_outlined),
          SizedBox(width: 5),
          _buildBookInfoInChip(
              colorPrimary,
              book.isFinished ? 'bookFinish'.tr() : 'bookNotFinish'.tr(),
              book.isFinished ? Icons.check : Icons.hourglass_bottom),
          new Spacer(),
          _buildFavoriteIcon(pos, colorPrimary),
        ]),
        SizedBox(height: 10),
        Container(
          decoration: decorateTile,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            _buildBookInfoInRow(
                colorPrimary,
                book.year != null ? "$author (${book.year})" : author,
                Icons.assignment_ind_rounded),
            if (book.description != null &&
                book.description?.isNotEmpty == true)
              _buildBookInfoInRow(
                  colorPrimary, book.description!, Icons.description_outlined),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: colorPrimary.withOpacity(0.2),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Table(
                columnWidths: {
                  0: FixedColumnWidth(100.0), // fixed to 100 width
                  1: FixedColumnWidth(50.0),
                },
                children: [
                  TableRow(children: [
                    Text('bookVolume'.tr(),
                        style: TextStyle(fontSize: 13.0, color: Colors.black)),
                    Text(book.volume > 0 ? "${book.volume}" : "-",
                        style: TextStyle(
                            fontSize: 13.0,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                  ]),
                  TableRow(children: [
                    Text('bookChapter'.tr(),
                        style: TextStyle(fontSize: 13.0, color: Colors.black)),
                    Text(book.chapter > 0 ? "${book.chapter}" : "- ",
                        style: TextStyle(
                            fontSize: 13.0,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                  ]),
                  TableRow(children: [
                    Text('bookEpisode'.tr(),
                        style: TextStyle(fontSize: 13.0, color: Colors.black)),
                    Text(book.episode > 0 ? "${book.episode}" : "-",
                        style: TextStyle(
                            fontSize: 13.0,
                            color: colorPrimary,
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
              cardColor: colorPrimary,
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: IconButton(
          icon: Icon(
              widget.listBook[pos].isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.pink[400]),
          key: ValueKey<int>(isfavoriteUpdate),
          onPressed: () {
            BlocProvider.of<BookBloc>(context).add(IncreaseBook(
                widget.listBook[pos],
                Strings.columnIsFavorite,
                isfavoriteUpdate));
            setState(() {
              widget.listBook[pos].isFavorite =
                  !widget.listBook[pos].isFavorite;
            });
          }),
    );
  }

  Widget _displayImage(int pos) {
    String? path = widget.listBook[pos].imagePath;
    if (path != null) {
      if (path.contains("https") == true && Uri.parse(path).isAbsolute) {
        return CachedNetworkImage(
          imageUrl: path,
          width: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Image.asset(
              "assets/images/icon_${widget.listBook[pos].bookType.index}.png",
              width: 50),
        );
      } else {
        if (File(path).existsSync()) {
          return Image.file(File(path), width: 50, fit: BoxFit.cover);
        }
      }
    }
    return Image.asset(
        "assets/images/icon_${widget.listBook[pos].bookType.index}.png",
        width: 50);
  }
}
