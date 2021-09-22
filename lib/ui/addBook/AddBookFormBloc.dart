import 'package:book_memo/data/model/book.dart';
import 'package:book_memo/data/model/bookRepository.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../strings.dart';

class AddBookFormBloc extends FormBloc<String, String> {
  final repository = BookRepository();

  final textTitle = TextFieldBloc(
    validators: [valueRequired],
    asyncValidatorDebounceTime: Duration(milliseconds: 300),
  );

  final textAuthor = TextFieldBloc();
  final textYear = TextFieldBloc();
  final textVolume = TextFieldBloc();
  final textChapter = TextFieldBloc();
  final textEpisode = TextFieldBloc();
  final textDescription = TextFieldBloc();

  final booleanBought = BooleanFieldBloc();
  final booleanFavorite = BooleanFieldBloc();

  final selectType = SelectFieldBloc(
    items: [
      Strings.formTypeManga,
      Strings.formTypeLiterature,
      Strings.formTypeComic
    ],
    initialValue: Strings.formTypeManga,
  );

  final selectIsfinished = SelectFieldBloc(
    items: [Strings.bookNotFinish, Strings.bookFinish],
    initialValue: Strings.bookNotFinish,
  );

  AddBookFormBloc() {
    addFieldBlocs(fieldBlocs: [
      textTitle,
      textAuthor,
      textYear,
      textVolume,
      textChapter,
      textEpisode,
      textDescription,
      booleanBought,
      booleanFavorite,
      selectType,
      selectIsfinished
    ]);

    textTitle.addAsyncValidators([_checkTitle]);
  }

  Future<String?> _checkTitle(String? title) async {
    if (title == null) {
      return null;
    } else {
      var books = await repository.checkTitle(title);
      if (books.isEmpty) {
        return null;
      } else {
        return Strings.formTitleError;
      }
    }
  }

  static String? valueRequired(dynamic value) {
    if (value == null ||
        value == false ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return Strings.formEmptyError;
    }
    return null;
  }

  @override
  void onSubmitting() async {
    try {
      var book = Book(
          bookType: checkTypeFrom(selectType.value),
          title: textTitle.value != null ? textTitle.value! : "",
          author: textAuthor.value != null ? textAuthor.value! : "",
          year: textYear.valueToInt,
          isBought: booleanBought.value != null ? booleanBought.value! : false,
          isFinished:
              selectIsfinished.value == Strings.bookFinish ? true : false,
          isFavorite:
              booleanFavorite.value != null ? booleanFavorite.value! : false,
          volume: textVolume.valueToInt != null ? textVolume.valueToInt! : 0,
          chapter: textChapter.valueToInt != null ? textChapter.valueToInt! : 0,
          episode: textEpisode.valueToInt != null ? textEpisode.valueToInt! : 0,
          description: textDescription.value);
      await Future<void>.delayed(Duration(milliseconds: 500));
      var result = await repository.insertBook(book);
      if (result > 0) {
        clearInputs();
        emitSuccess(canSubmitAgain: true);
      } else {
        emitFailure();
      }
    } catch (e) {
      emitFailure();
    }
  }

  BookType checkTypeFrom(String? selectedValue) {
    switch (selectedValue) {
      case Strings.formTypeManga:
        return BookType.manga;
      case Strings.formTypeComic:
        return BookType.comic;
      default:
        return BookType.literature;
    }
  }

  void clearInputs() {
    textTitle.clear();
    textAuthor.clear();
    textYear.clear();
    textVolume.clear();
    textChapter.clear();
    textEpisode.clear();
    textDescription.clear();
    booleanBought.updateInitialValue(false);
    booleanFavorite.updateInitialValue(false);
    selectType.updateInitialValue(Strings.formTypeManga);
    selectIsfinished.updateInitialValue(Strings.bookNotFinish);
  }
}
