import 'package:book_memo/data/model/book.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../strings.dart';
import 'bookInteractor.dart';

class BookFormBloc extends FormBloc<String, String> {
  bool isUpdating = false;
  int? idUpdating;

  final interactor = BookInteractor();
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

  BookFormBloc(Book? book) {
    if (book != null) {
      isUpdating = true;
      idUpdating = book.id;
      textTitle.updateInitialValue(book.title);
      textAuthor.updateInitialValue(book.author);
      textYear
          .updateInitialValue(book.year != null ? book.year.toString() : "");
      textVolume.updateInitialValue(book.volume.toString());
      textChapter.updateInitialValue(book.chapter.toString());
      textEpisode.updateInitialValue(book.episode.toString());
      textDescription.updateInitialValue(book.description);
      booleanBought.updateInitialValue(book.isBought);
      booleanFavorite.updateInitialValue(book.isFavorite);
      selectIsfinished.updateInitialValue(
          book.isFinished ? Strings.bookFinish : Strings.bookNotFinish);
      selectType.updateInitialValue(book.getNameFromType());
    }

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
    if (title == null || isUpdating) {
      // si on met à jour un titre, il ne faut pas vérifier qu'il existe déjà en bdd :
      return null;
    } else {
      var books = await interactor
          .getBooks(Strings.dbCompareTitle, [title.toLowerCase()]);
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
          bookType: Book.getTypeFromName(selectType.value),
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

      var result = 0;
      if (isUpdating) {
        book.id = idUpdating;
        result = await interactor.updateBook(book);
      } else {
        result = await interactor.insertBook(book);
      }

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
