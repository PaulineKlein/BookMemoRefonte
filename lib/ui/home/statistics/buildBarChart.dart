import 'package:bookmemo/data/model/book.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class BuildBarChart extends StatefulWidget {
  BuildBarChart({Key? key, required this.listBook}) : super(key: key);
  final List<Book> listBook;

  @override
  _BuildBarChartState createState() => _BuildBarChartState();
}

class _BuildBarChartState extends State<BuildBarChart> {
  final Color volumeColor = const Color(0xfff8b250);
  final Color chapterColor = const Color(0xff0293ee);
  final Color episodeColor = const Color(0xff13d38e);
  final double width = 10;
  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Text(
              'barChartTitleCount'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.apply(color: Colors.deepPurple),
            ),
            SizedBox(height: 15),
            Row(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitlesWidgets,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 34,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          checkToShowHorizontalLine: (value) => value % 5 == 0,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.black12,
                              strokeWidth: 0.8,
                            );
                          },
                        ),
                        barGroups: getBarChartGroupData(),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Indicator(color: volumeColor, text: 'formVolume'.tr()),
                    SizedBox(height: 4),
                    Indicator(color: chapterColor, text: 'formChapter'.tr()),
                    SizedBox(height: 4),
                    Indicator(color: episodeColor, text: 'formEpisode'.tr()),
                    SizedBox(height: 18),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  List<BarChartGroupData> getBarChartGroupData() {
    List<BarChartGroupData> result = [];

    BarChartGroupData? data = getSection(0, BookType.literature);
    if (data != null) result.add(data);
    data = getSection(1, BookType.manga);
    if (data != null) result.add(data);
    data = getSection(2, BookType.comic);
    if (data != null) result.add(data);
    data = getSection(3, BookType.movie);
    if (data != null) result.add(data);

    return result;
  }

  BarChartGroupData? getSection(int axis, BookType bookType) {
    List<Book> filter =
        widget.listBook.where((i) => i.bookType == bookType).toList();

    if (filter.isNotEmpty) {
      double volumeCount = 0;
      double chapterCount = 0;
      double episodeCount = 0;
      for (var i = 0; i < filter.length; i++) {
        volumeCount += filter[i].volume;
        chapterCount += filter[i].chapter;
        episodeCount += filter[i].episode;
      }

      List<BarChartRodData> barRods = [];
      if (volumeCount > 0)
        barRods.add(BarChartRodData(
          toY: volumeCount,
          color: volumeColor,
          width: width,
        ));
      if (chapterCount > 0)
        barRods.add(BarChartRodData(
          toY: chapterCount,
          color: chapterColor,
          width: width,
        ));
      if (episodeCount > 0)
        barRods.add(BarChartRodData(
          toY: episodeCount,
          color: episodeColor,
          width: width,
        ));

      return BarChartGroupData(barsSpace: 4, x: axis, barRods: barRods);
    }
    return null;
  }

  Widget bottomTitlesWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontSize: 10);
    String text = "";
    switch (value.toInt()) {
      case 0:
        text = 'formTypeLiterature'.tr();
        break;
      case 1:
        text = 'formTypeManga'.tr();
        break;
      case 2:
        text = 'formTypeComic'.tr();
        break;
      case 3:
        text = 'formTypeMovie'.tr();
        break;
    }

    return FittedBox(
      child: Text(text, style: style, textAlign: TextAlign.center),
      fit: BoxFit.fitWidth,
    );
  }
}
