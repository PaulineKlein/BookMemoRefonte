import 'package:bookmemo/bloc/bookBloc.dart';
import 'package:bookmemo/bloc/bookEvent.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'filterInteractor.dart';

enum FilterType {
  literature, // 0
  manga, // 1
  comic, // 2
  movie, // 3
  favorite, // 4
  finish, // 5
  notFinish, // 6
  bought, // 7
  notBought, // 8
}

class BuildFilter extends StatefulWidget {
  const BuildFilter({Key? key}) : super(key: key);

  _BuildFilter createState() => _BuildFilter();
}

class _BuildFilter extends State<BuildFilter> {
  List _categories = [
    'formTypeLiterature'.tr(), // 0
    'formTypeManga'.tr(), // 1
    'formTypeComic'.tr(), // 2
    'formTypeMovie'.tr(), // 3
    'bookFavorite'.tr(), // 4
    'bookFinish'.tr(), // 5
    'bookNotFinish'.tr(), // 6
    'bookBuy'.tr(), // 7
    'bookNotBuy'.tr(), // 8
  ];
  final myTitleSearchController = TextEditingController();
  final interactor = FilterInteractor();
  List<int> _selectedIndexs = [];

  void _filterList() {
    String? query = interactor.getFilterQuery(
        _selectedIndexs, myTitleSearchController.text);
    BlocProvider.of<BookBloc>(context).add(FilterBook(query));
  }

  @override
  initState() {
    super.initState();
    myTitleSearchController.addListener(_filterList);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _selectedIndexs = await interactor.getSelectedIndex();
      _filterList();
    });
  }

  @override
  void dispose() {
    myTitleSearchController.dispose();
    super.dispose();
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
          Row(children: <Widget>[
            Icon(Icons.tune, color: Colors.deepPurple),
            SizedBox(width: 15.0),
            Text(
              'filterCategory'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.apply(color: Colors.deepPurple),
            ),
          ]),
          SizedBox(height: 5.0),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                color: Colors.grey.withOpacity(.43),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.search,
                color: Colors.grey,
                size: 28,
              ),
              title: TextField(
                autofocus: false,
                controller: myTitleSearchController,
                decoration: InputDecoration(
                  hintText: 'homeSearchTitle'.tr(),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 9.0),
          Container(
            height: 42,
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
                          interactor.setSelectedIndex(_selectedIndexs);
                          _filterList();
                        } else {
                          _selectedIndexs.add(i);
                          interactor.setSelectedIndex(_selectedIndexs);
                          _filterList();
                        }
                      });
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Container(
                        key: ValueKey<int>(_isSelected ? 1 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
                        margin: const EdgeInsets.only(right: 7.0),
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
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
