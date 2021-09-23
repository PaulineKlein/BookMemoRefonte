import 'package:book_memo/bloc/bookBloc.dart';
import 'package:book_memo/bloc/bookEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../strings.dart';

class BuildFilter extends StatefulWidget {
  const BuildFilter({Key? key}) : super(key: key);

  _BuildFilter createState() => _BuildFilter();
}

class _BuildFilter extends State<BuildFilter> {
  List _categories = [
    Strings.formTypeLiterature,
    Strings.formTypeManga,
    Strings.formTypeComic,
    Strings.bookFinish,
    Strings.bookNotFinish,
    Strings.bookBuy,
    Strings.bookNotBuy
  ];
  List _selectedIndexs = [];

  void _filterList() {
    String? query = _getFilterQuery();
    BlocProvider.of<BookBloc>(context).add(FilterBook(query));
  }

  String? _getFilterQuery() {
    List<String> query = [];

    // type query :
    List<int> typeSelected = [];
    for (var i = 0; i < 3; i++) {
      if (_selectedIndexs.contains(i)) {
        typeSelected.add(i);
      }
    }
    if (typeSelected.isNotEmpty) {
      query.add("${Strings.dbHasType} (${typeSelected.join(', ')})");
    }

    // isFinished query :
    List<int> isFinishedSelected = [];
    if (_selectedIndexs.contains(3)) {
      isFinishedSelected.add(1); // bookFinish
    }
    if (_selectedIndexs.contains(4)) {
      isFinishedSelected.add(0); // bookNotFinish
    }
    if (isFinishedSelected.isNotEmpty) {
      query.add("${Strings.dbIsFinished} (${isFinishedSelected.join(', ')})");
    }

    // isBought query :
    List<int> isBoughtSelected = [];
    if (_selectedIndexs.contains(5)) {
      isBoughtSelected.add(1); // bookBought
    }
    if (_selectedIndexs.contains(6)) {
      isBoughtSelected.add(0); // bookNotBought
    }
    if (isBoughtSelected.isNotEmpty) {
      query.add("${Strings.dbIsBought} (${isBoughtSelected.join(', ')})");
    }

    // final query :
    if (query.isNotEmpty) {
      String lastQuery = query.join('AND ');
      return lastQuery;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 13,
            color: Colors.black12,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.tune, color: Colors.deepPurple),
              SizedBox(width: 15.0),
              Text(
                Strings.filterCategory,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.apply(color: Colors.deepPurple),
              )
            ],
          ),
          SizedBox(height: 9.0),
          Container(
            height: 35,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (ctx, i) {
                  final _isSelected = _selectedIndexs.contains(i);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_isSelected) {
                          _selectedIndexs.remove(i);
                          _filterList();
                        } else {
                          _selectedIndexs.add(i);
                          _filterList();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7.5),
                      margin: const EdgeInsets.symmetric(horizontal: 9.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isSelected ? Colors.deepPurple : null,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: Colors.grey.withOpacity(.43),
                        ),
                      ),
                      child: Text(
                        "${_categories[i]}",
                        style: Theme.of(context).textTheme.button?.apply(
                              color: _isSelected
                                  ? Colors.white
                                  : Colors.deepPurple,
                            ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
