class Strings {
  static const String homeTitle = "Votre bibliothèque";
  static const String homeEmptyList = "Pas encore de livre enregistré";
  static const String homeSearchTitle = "Entrez un titre, un auteur ...";
  static const String bookBuy = "Possédé";
  static const String bookNotBuy = "Prêté";
  static const String bookFinish = "Terminé";
  static const String bookNotFinish = "En cours";
  static const String bookVolume = "Volume :";
  static const String bookChapter = "Chapitre :";
  static const String bookEpisode = "Episode :";
  static const String bookAuthorNotKnown = "Auteur inconnu";
  static const String filterCategory = "Catégories";
  static const String filterEmptyList = "Aucun Résultat";
  static const String genericError = "Une erreur est survenue";
  static const String genericRetry = "Souhaitez-vous réessayer ?";
  static const String genericYes = "Oui";
  static const String genericNo = "Non";
  static const String addBookTitle = "Ajouter un livre";
  static const String formTitle = "Titre";
  static const String formTitleError =
      "Ce titre est déja présent dans la bilbiothèque";
  static const String formEmptyError = "Ce champ est obligatoire";
  static const String formAuthor = "Auteur";
  static const String formYear = "Année";
  static const String formAdvancement = "Avancement :";
  static const String formVolume = "Volume";
  static const String formChapter = "Chapitre";
  static const String formEpisode = "Episode";
  static const String formDescription = "Description";
  static const String formType = "Type";
  static const String formTypeLiterature = "Roman";
  static const String formTypeManga = "Manga";
  static const String formTypeComic = "BD";
  static const String formIsFinished = "Collection";
  static const String formIsBought = "Acheté ?";
  static const String formIsFavorite = "Favori ?";
  static const String alertDialogAddTitle = "Livre ajouté avec Succès";
  static const String alertDialogAddMessage =
      "Souhaitez-vous en ajouter un autre ?";
  static const String alertDialogDeleteTitle = "Suppression en cours";
  static const String alertDialogDeleteMessage =
      "Souhaitez-vous vraiment supprimer ce livre ?";
  static const String alertDialogAdvancementMessage =
      "Voulez-vous incrémenter cette série ?";

// -- DATABASE
  static const String bookTable = 'book';
  static const String columnId = 'id';
  static const String columnBookType = 'bookType';
  static const String columnTitle = 'title';
  static const String columnAuthor = 'author';
  static const String columnYear = 'year';
  static const String columnIsBought = 'isBought';
  static const String columnIsFinished = 'isFinished';
  static const String columnIsFavorite = 'isFavorite';
  static const String columnVolume = 'volume';
  static const String columnChapter = 'chapter';
  static const String columnEpisode = 'episode';
  static const String columnDescription = 'description';
  static const String dbCompareTitle = "lower(title) = ?";
  static const String dbHasTitle = "lower(title) LIKE ";
  static const String dbHasAuthor = "lower(author) LIKE ";
  static const String dbHasType = "bookType IN ";
  static const String dbIsFinished = "isFinished IN ";
  static const String dbIsBought = "isBought IN ";
  static const String dbIsFavorite = "isFavorite = 1 ";
}
