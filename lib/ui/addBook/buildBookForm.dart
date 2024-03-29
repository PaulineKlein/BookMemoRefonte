import 'dart:io';

import 'package:bookmemo/data/httpResponse/apiResponse.dart';
import 'package:bookmemo/data/model/book.dart';
import 'package:bookmemo/data/model/bookRepository.dart';
import 'package:bookmemo/helper/apiHelper.dart';
import 'package:bookmemo/helper/fileHelper.dart';
import 'package:bookmemo/ui/generic/alertDialog.dart';
import 'package:bookmemo/ui/generic/loadingDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'bookFormBloc.dart';

class BuildBookForm extends StatefulWidget {
  BuildBookForm(
      {Key? key,
      required this.formBloc,
      required this.scrollController,
      required this.repository})
      : super(key: key);

  final BookFormBloc formBloc;
  final ScrollController scrollController;
  final BookRepository repository;
  ApiResponse? apiResponse;

  @override
  _BuildBookFormState createState() => _BuildBookFormState();
}

class _BuildBookFormState extends State<BuildBookForm> {
  get exception => null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
                onPressed: scanBook,
                style: ElevatedButton.styleFrom(fixedSize: const Size(250, 50)),
                child: Text('Scanner un code barre')),
            SizedBox(height: 15),
            displaySearch(),
            TextFieldBlocBuilder(
              textFieldBloc: widget.formBloc.textAuthor,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'formAuthor'.tr(),
                labelStyle: TextStyle(fontSize: 18.0),
                prefixIcon: Icon(Icons.assignment_ind_rounded),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: widget.formBloc.textEditor,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'formEditor'.tr(),
                labelStyle: TextStyle(fontSize: 18.0),
                prefixIcon: Icon(Icons.assignment_ind_rounded),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: widget.formBloc.textYear,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'formYear'.tr(),
                labelStyle: TextStyle(fontSize: 18.0),
                prefixIcon: Icon(Icons.calendar_today),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: widget.formBloc.textDescription,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'formDescription'.tr(),
                labelStyle: TextStyle(fontSize: 18.0),
                prefixIcon: Icon(Icons.description),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.blue)),
                child: Padding(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('formAdvancement'.tr(),
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.blue)),
                          TextFieldBlocBuilder(
                            textFieldBloc: widget.formBloc.textVolume,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'formVolume'.tr(),
                              labelStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.calculate_outlined),
                            ),
                          ),
                          TextFieldBlocBuilder(
                            textFieldBloc: widget.formBloc.textChapter,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'formChapter'.tr(),
                              labelStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.calculate_outlined),
                            ),
                          ),
                          TextFieldBlocBuilder(
                            textFieldBloc: widget.formBloc.textEpisode,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'formEpisode'.tr(),
                              labelStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.calculate_outlined),
                            ),
                          ),
                        ]))),
            RadioButtonGroupFieldBlocBuilder<String>(
              selectFieldBloc: widget.formBloc.selectType,
              decoration: InputDecoration(
                  labelText: 'formType'.tr(),
                  labelStyle: TextStyle(fontSize: 20.0, color: Colors.blue),
                  prefixIcon: SizedBox(),
                  contentPadding: EdgeInsets.all(5.0)),
              itemBuilder: (context, item) => FieldItem(child: Text(item)),
            ),
            RadioButtonGroupFieldBlocBuilder<String>(
              selectFieldBloc: widget.formBloc.selectIsfinished,
              decoration: InputDecoration(
                  labelText: 'formIsFinished'.tr(),
                  labelStyle: TextStyle(fontSize: 20.0, color: Colors.blue),
                  prefixIcon: SizedBox(),
                  contentPadding: EdgeInsets.all(5.0)),
              itemBuilder: (context, item) => FieldItem(child: Text(item)),
            ),
            SwitchFieldBlocBuilder(
              booleanFieldBloc: widget.formBloc.booleanBought,
              body: Container(
                alignment: Alignment.centerLeft,
                child: Text('formIsBought'.tr()),
              ),
            ),
            SwitchFieldBlocBuilder(
              booleanFieldBloc: widget.formBloc.booleanFavorite,
              body: Container(
                alignment: Alignment.centerLeft,
                child: Text('formIsFavorite'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displaySearch() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blue)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            TextFieldBlocBuilder(
              textFieldBloc: widget.formBloc.textTitle,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'formTitle'.tr(),
                labelStyle: TextStyle(fontSize: 18.0),
                prefixIcon: Icon(Icons.text_fields),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: addImage,
                      child: _displayImage(),
                    ),
                    ElevatedButton(
                        onPressed: widget.formBloc.imagePath != null
                            ? deleteImage
                            : null,
                        child: Text('deleteImageButton'.tr())),
                  ],
                ),
                SizedBox(width: 15),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      ElevatedButton(
                          onPressed: searchBook,
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(200, 30)),
                          child: Text('searchBookButton'.tr())),
                      ElevatedButton(
                          onPressed: searchComic,
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(200, 30)),
                          child: Text('searchComicButton'.tr())),
                      ElevatedButton(
                          onPressed: searchManga,
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(200, 30)),
                          child: Text('searchMangaButton'.tr())),
                      ElevatedButton(
                          onPressed: searchAnime,
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(200, 30)),
                          child: Text('searchAnimeButton'.tr())),
                    ])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scanBook() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'genericCancel'.tr(), true, ScanMode.BARCODE);
      if (barcodeScanRes.isNotEmpty && barcodeScanRes != "-1") {
        searchBarCode(barcodeScanRes);
      }
    } on PlatformException {
      debugPrint('Error scanBarcode PlatformException. $exception');
      FirebaseCrashlytics.instance.recordError(exception, null,
          reason: 'non-fatal error : scanBarcode PlatformException');
    }
  }

  Future<void> searchBarCode(String barCode) async {
    LoadingDialog.show(context);
    widget.apiResponse = await ApiHelper.getInformationFromBarCodeApi(barCode);
    LoadingDialog.hide(context);
    _displayApiResponse();
  }

  Future<void> searchBook() {
    setState(() {
      widget.formBloc.selectType.updateInitialValue('formTypeLiterature'.tr());
    });
    return searchTitle(BookType.literature);
  }

  Future<void> searchComic() {
    setState(() {
      widget.formBloc.selectType.updateInitialValue('formTypeComic'.tr());
    });
    return searchTitle(BookType.comic);
  }

  Future<void> searchManga() {
    setState(() {
      widget.formBloc.selectType.updateInitialValue('formTypeManga'.tr());
    });
    return searchTitle(BookType.manga);
  }

  Future<void> searchAnime() {
    setState(() {
      widget.formBloc.selectType.updateInitialValue('formTypeMovie'.tr());
    });
    return searchTitle(BookType.movie);
  }

  Future<void> searchTitle(BookType bookType) async {
    if (widget.formBloc.textTitle.value.isNotEmpty) {
      LoadingDialog.show(context);
      if (bookType == BookType.manga || bookType == BookType.movie) {
        widget.apiResponse = await ApiHelper.getInformationFromMangaApi(
            bookType, widget.formBloc.textTitle.value);
      } else {
        widget.apiResponse = await ApiHelper.getInformationFromBookApi(
            widget.formBloc.textTitle.value);
      }
      LoadingDialog.hide(context);
      _displayApiResponse();
    } else {
      AlertDialogUtility().showPopup(
          context: context,
          alertTitle: 'genericError'.tr(),
          alertMessage: 'alertDialogSearchMessageEmpty'.tr());
    }
  }

  void _displayApiResponse() {
    if (widget.apiResponse != null && widget.apiResponse?.title != "") {
      String message =
          "${'formTitle'.tr()} = ${widget.apiResponse?.title ?? 'genericErrorLabel'.tr()}"
          "\n${'formAuthor'.tr()} = ${widget.apiResponse?.author ?? 'genericErrorLabel'.tr()}"
          "\n${'formEditor'.tr()} = ${widget.apiResponse?.editor ?? 'genericErrorLabel'.tr()}"
          "\n${'formYear'.tr()} = ${widget.apiResponse?.startDate ?? 'genericErrorLabel'.tr()}";
      AlertDialogUtility().showCustomImageDialog(
          context: context,
          alertTitle: 'alertDialogSearchMessageSuccess'.tr(),
          alertMessage: message,
          imagePath: widget.apiResponse?.imagePath,
          onCancelClick: null,
          onConfirmClick: _updateDataFromApi);
    } else {
      AlertDialogUtility().showPopup(
          context: context,
          alertTitle: 'genericError'.tr(),
          alertMessage: 'alertDialogSearchMessageError'.tr());
    }
  }

  void _updateDataFromApi() {
    setState(() {
      widget.formBloc.textTitle.updateInitialValue(
          widget.apiResponse?.title != null
              ? widget.apiResponse!.title!.toString()
              : "");
      widget.formBloc.textAuthor.updateInitialValue(
          widget.apiResponse?.author != null
              ? widget.apiResponse!.author!.toString()
              : "");
      widget.formBloc.textEditor.updateInitialValue(
          widget.apiResponse?.editor != null
              ? widget.apiResponse!.editor!.toString()
              : "");
      widget.formBloc.textYear.updateInitialValue(
          widget.apiResponse?.startDate != null
              ? widget.apiResponse!.startDate!.toString()
              : "");
      widget.formBloc.imagePath = widget.apiResponse?.imagePath;
    });
  }

  void deleteImage() {
    setState(() {
      widget.formBloc.imagePath = null;
    });
  }

  void addImage() async {
    String path = await FileHelper(repository: widget.repository)
        .getPathPicker(["jpg", "png", "jpeg"]);
    if (path != "") {
      setState(() {
        widget.formBloc.imagePath = path;
      });
    }
  }

  Widget _displayImage() {
    if (widget.formBloc.imagePath != null) {
      if (widget.formBloc.imagePath?.contains("https") == true &&
          Uri.parse(widget.formBloc.imagePath ?? "").isAbsolute) {
        return CachedNetworkImage(
          imageUrl: widget.formBloc.imagePath!,
          width: 80,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) =>
              Image.asset('assets/images/add_image.png'),
        );
      } else {
        if (File(widget.formBloc.imagePath!).existsSync()) {
          return Image.file(File(widget.formBloc.imagePath!),
              width: 80, fit: BoxFit.cover);
        }
      }
    }
    return Image.asset('assets/images/add_image.png');
  }
}
