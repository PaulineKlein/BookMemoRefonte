import 'package:bookmemo/data/model/book.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class BuildPieChart extends StatefulWidget {
  BuildPieChart({Key? key, required this.listBook}) : super(key: key);
  final List<Book> listBook;

  @override
  _BuildPieChartState createState() => _BuildPieChartState();
}

class _BuildPieChartState extends State<BuildPieChart> {
  int touchedIndex = -1;
  bool showLiterature = true;
  bool showManga = true;
  bool showComic = true;
  bool showMovie = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Text(
            'pieChartTitle'.tr(),
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.apply(color: Colors.deepPurple),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        }),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections()),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: createLegend(),
              ),
              const SizedBox(width: 28),
            ],
          ),
        ]),
      ),
    );
  }

  List<Widget> createLegend() {
    List<Widget> result = [];

    if (showLiterature) {
      result.add(Indicator(
        color: Color(0xff0293ee),
        text: 'formTypeLiterature'.tr(),
      ));
      result.add(SizedBox(height: 4));
    }
    if (showManga) {
      result.add(Indicator(
        color: Color(0xfff8b250),
        text: 'formTypeManga'.tr(),
      ));
      result.add(SizedBox(height: 4));
    }
    if (showComic) {
      result.add(Indicator(
        color: Color(0xff845bef),
        text: 'formTypeComic'.tr(),
      ));
      result.add(SizedBox(height: 4));
    }
    if (showMovie) {
      result.add(Indicator(
        color: Color(0xff13d38e),
        text: 'formTypeMovie'.tr(),
      ));
      result.add(SizedBox(height: 4));
    }

    return result;
  }

  List<PieChartSectionData> showingSections() {
    int countLiterature = widget.listBook
        .where((i) => i.bookType == BookType.literature)
        .toList()
        .length;

    int countManga = widget.listBook
        .where((i) => i.bookType == BookType.manga)
        .toList()
        .length;

    int countComic = widget.listBook
        .where((i) => i.bookType == BookType.comic)
        .toList()
        .length;

    int countMovie = widget.listBook
        .where((i) => i.bookType == BookType.movie)
        .toList()
        .length;

    if (countLiterature == 0) showLiterature = false;
    if (countManga == 0) showManga = false;
    if (countComic == 0) showComic = false;
    if (countMovie == 0) showMovie = false;

    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: countLiterature.toDouble(),
            title: '$countLiterature',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: countManga.toDouble(),
            title: '$countManga',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: countComic.toDouble(),
            title: '$countComic',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: countMovie.toDouble(),
            title: '$countMovie',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
