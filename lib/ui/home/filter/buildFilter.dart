import 'package:bookmemo/bloc/bookBloc.dart';
import 'package:bookmemo/bloc/bookEvent.dart';
import 'package:bookmemo/data/model/bookRepository.dart';
import 'package:bookmemo/ui/generic/orangeBlurredBoxDecoration.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
  late FilterInteractor interactor;
  List<int> _selectedIndexs = [];

  void _filterList() {
    String? query = interactor.getFilterQuery(
        _selectedIndexs, myTitleSearchController.text);
    BlocProvider.of<BookBloc>(context).add(FilterBook(query));
  }

  @override
  initState() {
    super.initState();
    interactor = FilterInteractor(
        repository: Provider.of<BookRepository>(context, listen: false));
    myTitleSearchController.addListener(_filterList);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          decoration: orangeBlurredBoxDecoration(Colors.white),
          child: ListTile(
            leading: Icon(
              Icons.search,
              color: Colors.black,
              size: 28,
            ),
            title: TextField(
              autofocus: false,
              controller: myTitleSearchController,
              decoration: InputDecoration(
                hintText: 'homeSearchTitle'.tr(),
                hintStyle: Theme.of(context).textTheme.bodyLarge,
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 24.0),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.5, horizontal: 10),
                      margin: const EdgeInsets.only(right: 7.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Text(
                        "${_categories[i]}",
                        style: Theme.of(context).textTheme.labelLarge?.apply(
                              color: _isSelected ? Colors.white : Colors.black,
                            ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
