import 'dart:io';

import 'package:bookmemo/helper/fileHelper.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'bookFormBloc.dart';

class BuildBookForm extends StatefulWidget {
  BuildBookForm(
      {Key? key,
      required this.formBloc,
      required this.scrollController,
      this.image})
      : super(key: key);

  final BookFormBloc formBloc;
  final ScrollController scrollController;
  File? image;

  @override
  _BuildBookFormState createState() => _BuildBookFormState();
}

class _BuildBookFormState extends State<BuildBookForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
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
                color: Colors.blue[100],
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
              itemBuilder: (context, item) => item,
            ),
            RadioButtonGroupFieldBlocBuilder<String>(
              selectFieldBloc: widget.formBloc.selectIsfinished,
              decoration: InputDecoration(
                  labelText: 'formIsFinished'.tr(),
                  labelStyle: TextStyle(fontSize: 20.0, color: Colors.blue),
                  prefixIcon: SizedBox(),
                  contentPadding: EdgeInsets.all(5.0)),
              itemBuilder: (context, item) => item,
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
      color: Colors.blue[100],
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
                InkWell(
                  onTap: addImage,
                  child: (widget.image != null)
                      ? Image.file(
                          widget.image!,
                          width: 80,
                          fit: BoxFit.cover,
                        )
                      : Image.asset('assets/images/add_image.png'),
                ),
                SizedBox(width: 30),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: searchTitle,
                          child: Text('searchMangaButton'.tr())),
                      ElevatedButton(
                          onPressed: searchTitle,
                          child: Text('searchAnimeButton'.tr())),
                      ElevatedButton(
                          onPressed: deleteImage,
                          child: Text('deleteImageButton'.tr())),
                    ])
              ],
            ),
          ],
        ),
      ),
    );
  }

  void searchTitle() {}

  void deleteImage() {
    setState(() {
      widget.image = null;
      widget.formBloc.imagePath = null;
    });
  }

  void addImage() async {
    String path = await FileHelper().getPathPicker(["jpg", "png", "jpeg"]);
    if (path != "") {
      setState(() {
        widget.image = File(path);
        widget.formBloc.imagePath = path;
      });
    }
  }
}
