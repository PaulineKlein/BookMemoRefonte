import 'package:bookmemo/data/model/bookRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../strings.dart';
import 'buildFilter.dart';

class FilterInteractor {
  final BookRepository repository = BookRepository();
  static const String filterSelectedIndex = "FILTER_SELECTED_INDEX";

  Future<List<int>> getSelectedIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedStrList = prefs.getStringList(filterSelectedIndex) ?? [];
    return savedStrList.map((i) => int.parse(i)).toList();
  }

  Future<void> setSelectedIndex(List<int> selectedIndex) async {
    List<String> strList = selectedIndex.map((i) => i.toString()).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(filterSelectedIndex, strList);
  }

  String? getFilterQuery(List<int> _selectedIndexs, String searchInput) {
    List<String> query = [];

    // type query :
    List<int> typeSelected = [];
    for (var i = 0; i < 4; i++) {
      if (_selectedIndexs.contains(i)) {
        typeSelected.add(i);
      }
    }
    if (typeSelected.isNotEmpty) {
      query.add("${Strings.dbHasType} (${typeSelected.join(', ')})");
    }

    // isFavorite query :
    if (_selectedIndexs.contains(FilterType.favorite.index)) {
      query.add(Strings.dbIsFavorite);
    }

    // isFinished query :
    List<int> isFinishedSelected = [];
    if (_selectedIndexs.contains(FilterType.finish.index)) {
      isFinishedSelected.add(1); // bookFinish
    }
    if (_selectedIndexs.contains(FilterType.notFinish.index)) {
      isFinishedSelected.add(0); // bookNotFinish
    }
    if (isFinishedSelected.isNotEmpty) {
      query.add("${Strings.dbIsFinished} (${isFinishedSelected.join(', ')})");
    }

    // isBought query :
    List<int> isBoughtSelected = [];
    if (_selectedIndexs.contains(FilterType.bought.index)) {
      isBoughtSelected.add(1); // bookBought
    }
    if (_selectedIndexs.contains(FilterType.notBought.index)) {
      isBoughtSelected.add(0); // bookNotBought
    }
    if (isBoughtSelected.isNotEmpty) {
      query.add("${Strings.dbIsBought} (${isBoughtSelected.join(', ')})");
    }

    // title query :
    if (searchInput.isNotEmpty) {
      String search = searchInput.toLowerCase();
      query.add(
          "${Strings.dbHasTitle} \"%$search%\" OR ${Strings.dbHasAuthor} \"%$search%\"");
    }

    // final query :
    if (query.isNotEmpty) {
      String lastQuery = query.join(' AND ');
      return lastQuery;
    } else {
      return null;
    }
  }
}
