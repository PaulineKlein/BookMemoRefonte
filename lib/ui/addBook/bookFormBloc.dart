import 'package:bookmemo/data/model/book.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../strings.dart';
import 'bookInteractor.dart';

class BookFormBloc extends FormBloc<String, String> {
  bool isUpdating = false;
  int? idUpdating;
  String? imagePath;

  late BookInteractor interactor;
  final textTitle = TextFieldBloc(
    validators: [valueRequired],
    asyncValidatorDebounceTime: Duration(milliseconds: 300),
  );
  final textAuthor = TextFieldBloc();
  final textEditor = TextFieldBloc();
  final textYear = TextFieldBloc();
  final textVolume = TextFieldBloc();
  final textChapter = TextFieldBloc();
  final textEpisode = TextFieldBloc();
  final textDescription = TextFieldBloc();
  final booleanBought = BooleanFieldBloc();
  final booleanFavorite = BooleanFieldBloc();

  final selectType = SelectFieldBloc(
    items: [
      'formTypeManga'.tr(),
      'formTypeLiterature'.tr(),
      'formTypeComic'.tr(),
      'formTypeMovie'.tr()
    ],
    initialValue: 'formTypeManga'.tr(),
  );

  final selectIsfinished = SelectFieldBloc(
    items: ['bookNotFinish'.tr(), 'bookFinish'.tr()],
    initialValue: 'bookNotFinish'.tr(),
  );

  BookFormBloc(Book? book, BookInteractor interactor) {
    this.interactor = interactor;
    if (book != null) {
      isUpdating = true;
      idUpdating = book.id;
      textTitle.updateInitialValue(book.title);
      textAuthor.updateInitialValue(book.author);
      textEditor.updateInitialValue(book.editor.toString());
      textYear
          .updateInitialValue(book.year != null ? book.year.toString() : "");
      textVolume.updateInitialValue(book.volume.toString());
      textChapter.updateInitialValue(book.chapter.toString());
      textEpisode.updateInitialValue(book.episode.toString());
      textDescription.updateInitialValue(book.description.toString());
      booleanBought.updateInitialValue(book.isBought);
      booleanFavorite.updateInitialValue(book.isFavorite);
      selectIsfinished.updateInitialValue(
          book.isFinished ? 'bookFinish'.tr() : 'bookNotFinish'.tr());
      selectType.updateInitialValue(book.getNameFromType());
      imagePath = book.imagePath;
    }

    addFieldBlocs(fieldBlocs: [
      textTitle,
      textAuthor,
      textEditor,
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
        return 'formTitleError'.tr();
      }
    }
  }

  static String? valueRequired(dynamic value) {
    if (value == null ||
        value == false ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return 'formEmptyError'.tr();
    }
    return null;
  }

  @override
  void onSubmitting() async {
    try {
      int volume = 0;
      int episode = 0;
      if (Book.getTypeFromName(selectType.value) != BookType.movie) {
        // it is a book, at least volume should be 1 :
        volume = textVolume.valueToInt != null ? textVolume.valueToInt! : 1;
        episode = textEpisode.valueToInt != null ? textEpisode.valueToInt! : 0;
      } else {
        // it is a movie, at least episode should be 1
        volume = textVolume.valueToInt != null ? textVolume.valueToInt! : 0;
        episode = textEpisode.valueToInt != null ? textEpisode.valueToInt! : 1;
      }

      var book = Book(
          bookType: Book.getTypeFromName(selectType.value),
          title: textTitle.value,
          author: textAuthor.value,
          editor: textEditor.value,
          year: textYear.valueToInt,
          isBought: booleanBought.value,
          isFinished:
              selectIsfinished.value == 'bookFinish'.tr() ? true : false,
          isFavorite:
              booleanFavorite.value,
          volume: volume,
          chapter: textChapter.valueToInt != null ? textChapter.valueToInt! : 0,
          episode: episode,
          description: textDescription.value,
          imagePath: imagePath);

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
    textEditor.clear();
    textYear.clear();
    textVolume.clear();
    textChapter.clear();
    textEpisode.clear();
    textDescription.clear();
    booleanBought.updateInitialValue(false);
    booleanFavorite.updateInitialValue(false);
    selectType.updateInitialValue('formTypeManga'.tr());
    selectIsfinished.updateInitialValue('bookNotFinish'.tr());
    imagePath = null;
  }
}
