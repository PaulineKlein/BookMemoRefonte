import 'dart:io';

import 'package:bookmemo/bloc/bookBloc.dart';
import 'package:bookmemo/bloc/bookEvent.dart';
import 'package:bookmemo/data/model/book.dart';
import 'package:bookmemo/ui/generic/orangeBlurredBoxDecoration.dart';
import 'package:bookmemo/ui/home/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../strings.dart';
import '../bookMemo_theme.dart';
import 'buildActions.dart';

class DisplayBookArguments {
  final Book book;

  DisplayBookArguments({required this.book});
}

class DisplayBookPage extends StatefulWidget {
  DisplayBookPage({Key? key}) : super(key: key);
  static const routeName = '/display_book';

  @override
  _DisplayBookState createState() => _DisplayBookState();
}

class _DisplayBookState extends State<DisplayBookPage> {
  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    final arguments =
        ModalRoute.of(context)!.settings.arguments as DisplayBookArguments;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _displayHeader(arguments.book),
            SizedBox(height: 130),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _displayTitle(arguments.book),
                  SizedBox(height: 16),
                  _displayDetail(arguments.book),
                  SizedBox(height: 16),
                  _displayNotes(arguments.book),
                  SizedBox(height: 24),
                  _displayBookInfoInChip(arguments.book),
                  SizedBox(height: 24),
                  _displayIncrement(arguments.book),
                  SizedBox(height: 24),
                  _displayActions(arguments.book),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayHeader(Book book) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.topCenter,
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          height: 230,
          width: double.infinity,
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: colorPrimaryLight,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 70),
              child: _displayBackArrow()),
        ),
        Positioned(
          top: 120,
          child: Container(
            alignment: Alignment.center,
            decoration: orangeBlurredBoxDecoration(Colors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: _displayImage(book),
            ),
          ),
        )
      ],
    );
  }

  Widget _displayImage(Book book) {
    String? path = book.imagePath;
    if (path != null) {
      if (path.contains("https") == true && Uri.parse(path).isAbsolute) {
        return CachedNetworkImage(
          imageUrl: path,
          width: 150,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Image.asset(
              "assets/images/icon_${book.bookType.index}.png",
              width: 150),
        );
      } else {
        if (File(path).existsSync()) {
          return Image.file(File(path), width: 150, fit: BoxFit.cover);
        }
      }
    }
    return Image.asset("assets/images/icon_${book.bookType.index}.png",
        width: 150);
  }

  Widget _displayTitle(Book book) {
    String author =
        book.author.isEmpty ? 'bookAuthorNotKnown'.tr() : book.author;
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(book.title, style: Theme.of(context).textTheme.headline1),
              Text(author, style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: _buildFavoriteIcon(book),
        ),
      ],
    );
  }

  Widget _displayDetail(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            book.year != null && book.year.toString().isNotEmpty
                ? book.year.toString()
                : 'bookYearNotKnown'.tr(),
            style: Theme.of(context).textTheme.bodyText2),
        Text(
            book.editor != null && book.editor.toString().isNotEmpty
                ? book.editor.toString()
                : 'bookEditorNotKnown'.tr(),
            style: Theme.of(context).textTheme.bodyText2),
        Text(book.getNameFromType(),
            style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }

  Widget _displayNotes(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('formDescription'.tr(),
            style: Theme.of(context).textTheme.caption),
        Text(
            book.description != null && book.description.toString().isNotEmpty
                ? book.description.toString()
                : '/',
            style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }

  Widget _displayBookInfoInChip(Book book) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildBookInfoInChip(book.isBought ? 'bookBuy'.tr() : 'bookNotBuy'.tr(),
            book.isBought ? "" : ""), // todo add images
        SizedBox(width: 16),
        _buildBookInfoInChip(
            book.isFinished ? 'bookFinish'.tr() : 'bookNotFinish'.tr(),
            book.isFinished ? "" : "icon_inprogress"), // todo add images
      ],
    );
  }

  Widget _buildBookInfoInChip(String textStatus, String? imagePath) {
    return Row(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorPrimaryLight,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: imagePath != null && imagePath.toString().isNotEmpty
              ? SvgPicture.asset("assets/images/$imagePath.svg",
                  semanticsLabel: imagePath)
              : null,
        ),
        SizedBox(width: 8),
        Text(textStatus, style: Theme.of(context).textTheme.overline),
      ],
    );
  }

  Widget _displayIncrement(Book book) {
    return Table(
      border: TableBorder(
        bottom: BorderSide(color: Colors.black, width: 1),
        top: BorderSide(color: Colors.black, width: 1),
        horizontalInside: BorderSide(color: Colors.black, width: 1),
      ),
      columnWidths: {0: FractionColumnWidth(.3)},
      children: [
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('bookVolume'.tr(),
                style: Theme.of(context).textTheme.bodyText1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(book.volume > 0 ? "${book.volume}" : "-",
                style: Theme.of(context).textTheme.bodyText1),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('bookChapter'.tr(),
                style: Theme.of(context).textTheme.bodyText1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(book.chapter > 0 ? "${book.chapter}" : "- ",
                style: Theme.of(context).textTheme.bodyText1),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('bookEpisode'.tr(),
                style: Theme.of(context).textTheme.bodyText1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(book.episode > 0 ? "${book.episode}" : "-",
                style: Theme.of(context).textTheme.bodyText1),
          ),
        ]),
      ],
    );
  }

  Widget _displayActions(Book book) {
    return BuildActions(
      book: book,
      onIncreaseValue: (String column, int updateValue) {
        setState(() {
          switch (column) {
            case Strings.columnVolume:
              book.volume = updateValue;
              break;
            case Strings.columnChapter:
              book.chapter = updateValue;
              break;
            case Strings.columnEpisode:
              book.episode = updateValue;
              break;
          }
        });
      },
      onDeleteBook: () {
        _onBackPressedClick();
      },
    );
  }

  Widget _buildFavoriteIcon(Book book) {
    // on click on the icon, inverse the value of favorite
    int isfavoriteUpdate = book.isFavorite ? 0 : 1;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: IconButton(
          icon: Icon(book.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: colorPrimary),
          key: ValueKey<int>(isfavoriteUpdate),
          onPressed: () {
            BlocProvider.of<BookBloc>(context).add(
                IncreaseBook(book, Strings.columnIsFavorite, isfavoriteUpdate));
            setState(() {
              book.isFavorite = !book.isFavorite;
            });
          }),
    );
  }

  Widget _displayBackArrow() {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      decoration: orangeBlurredBoxDecoration(Colors.black),
      child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            _onBackPressedClick();
          }),
    );
  }

  void _onBackPressedClick() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (Route<dynamic> route) => false);
      BlocProvider.of<BookBloc>(context).add(LoadBook());
    });
  }
}
