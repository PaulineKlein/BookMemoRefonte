import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../strings.dart';
import 'bookFormBloc.dart';

class BuildBookForm extends StatelessWidget {
  const BuildBookForm({Key? key, required this.formBloc}) : super(key: key);

  final BookFormBloc formBloc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextFieldBlocBuilder(
              textFieldBloc: formBloc.textTitle,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: Strings.formTitle,
                labelStyle: TextStyle(fontSize: 18.0),
                prefixIcon: Icon(Icons.text_fields),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: formBloc.textAuthor,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: Strings.formAuthor,
                labelStyle: TextStyle(fontSize: 18.0),
                prefixIcon: Icon(Icons.assignment_ind_rounded),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: formBloc.textYear,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: Strings.formYear,
                labelStyle: TextStyle(fontSize: 18.0),
                prefixIcon: Icon(Icons.calendar_today),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: formBloc.textDescription,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: Strings.formDescription,
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
                          Text(Strings.formAdvancement,
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.blue)),
                          TextFieldBlocBuilder(
                            textFieldBloc: formBloc.textVolume,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: Strings.formVolume,
                              labelStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.calculate_outlined),
                            ),
                          ),
                          TextFieldBlocBuilder(
                            textFieldBloc: formBloc.textChapter,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: Strings.formChapter,
                              labelStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.calculate_outlined),
                            ),
                          ),
                          TextFieldBlocBuilder(
                            textFieldBloc: formBloc.textEpisode,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: Strings.formEpisode,
                              labelStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.calculate_outlined),
                            ),
                          ),
                        ]))),
            RadioButtonGroupFieldBlocBuilder<String>(
              selectFieldBloc: formBloc.selectType,
              decoration: InputDecoration(
                  labelText: Strings.formType,
                  labelStyle: TextStyle(fontSize: 20.0, color: Colors.blue),
                  prefixIcon: SizedBox(),
                  contentPadding: EdgeInsets.all(5.0)),
              itemBuilder: (context, item) => item,
            ),
            RadioButtonGroupFieldBlocBuilder<String>(
              selectFieldBloc: formBloc.selectIsfinished,
              decoration: InputDecoration(
                  labelText: Strings.formIsFinished,
                  labelStyle: TextStyle(fontSize: 20.0, color: Colors.blue),
                  prefixIcon: SizedBox(),
                  contentPadding: EdgeInsets.all(5.0)),
              itemBuilder: (context, item) => item,
            ),
            SwitchFieldBlocBuilder(
              booleanFieldBloc: formBloc.booleanBought,
              body: Container(
                alignment: Alignment.centerLeft,
                child: Text(Strings.formIsBought),
              ),
            ),
            SwitchFieldBlocBuilder(
              booleanFieldBloc: formBloc.booleanFavorite,
              body: Container(
                alignment: Alignment.centerLeft,
                child: Text(Strings.formIsFavorite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
