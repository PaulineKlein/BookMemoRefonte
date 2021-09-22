class Strings {
  static const String homeTitle = "Votre bibliothèque";
  static const String homeEmptyList = "Pas encore de livre enregistré";
  static const String homeSearchTitle = "entrez un titre, un auteur ...";
  static const String bookBuy = "Acheté";
  static const String bookNotBuy = "Non acheté";
  static const String bookFinish = "Terminé";
  static const String bookNotFinish = "En cours";
  static const String bookVolume = "Volume :";
  static const String bookChapter = "Chapitre :";
  static const String bookEpisode = "Episode :";
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
  static const String formTypeLiterature = "Litterature";
  static const String formTypeManga = "Manga";
  static const String formTypeComic = "BD";
  static const String formIsFinished = "Collection";
  static const String formIsBought = "Acheté ?";
  static const String formIsFavorite = "Favori ?";
  static const String alertDialogAddTitle = "Livre ajouté avec Succès";
  static const String alertDialogAddMessage =
      "Souhaitez-vous en ajouter un autre ?";

  static const String dbCompareTitle = "lower(title) = ?";
  static const String dbCompareTitleAndAuthor =
      "lower(title) LIKE ? OR lower(author) LIKE ?";
}
