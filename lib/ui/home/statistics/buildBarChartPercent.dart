import 'package:bookmemo/data/model/book.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

enum BarChartType { isFinished, isBought }

class BuildBarChartPercent extends StatefulWidget {
  BuildBarChartPercent({Key? key, required this.listBook, required this.type})
      : super(key: key);
  final List<Book> listBook;
  final BarChartType type;

  @override
  _BuildBarChartPercentState createState() => _BuildBarChartPercentState();
}

class _BuildBarChartPercentState extends State<BuildBarChartPercent> {
  static const double barWidth = 24;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

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
            widget.type == BarChartType.isFinished
                ? 'barChartTitleIsFinish'.tr()
                : 'barChartTitleIsBought'.tr(),
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.apply(color: Colors.deepPurple),
          ),
          SizedBox(height: 15),
          Row(children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.3,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    maxY: 100,
                    minY: 0,
                    groupsSpace: 30,
                    barTouchData: BarTouchData(
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        if (!event.isInterestedForInteractions ||
                            barTouchResponse == null ||
                            barTouchResponse.spot == null) {
                          setState(() {
                            touchedIndex = -1;
                          });
                          return;
                        }
                        setState(() {
                          touchedIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) =>
                            const TextStyle(color: Colors.black, fontSize: 10),
                        margin: 10,
                        rotateAngle: 0,
                        getTitles: (double value) {
                          switch (value.toInt()) {
                            case 0:
                              return 'formTypeLiterature'.tr();
                            case 1:
                              return 'formTypeManga'.tr();
                            case 2:
                              return 'formTypeComic'.tr();
                            case 3:
                              return 'formTypeMovie'.tr();
                            default:
                              return '';
                          }
                        },
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) =>
                            const TextStyle(color: Colors.black, fontSize: 10),
                        rotateAngle: 0,
                        getTitles: (double value) {
                          return '${value.toInt()}%';
                        },
                        interval: 20,
                        margin: 8,
                        reservedSize: 30,
                      ),
                      rightTitles: SideTitles(showTitles: false),
                    ),
                    gridData: FlGridData(
                      show: true,
                      checkToShowHorizontalLine: (value) => value % 10 == 0,
                      getDrawingHorizontalLine: (value) {
                        if (value == 0) {
                          return FlLine(
                              color: const Color(0xff363753), strokeWidth: 3);
                        }
                        return FlLine(
                          color: Colors.black12,
                          strokeWidth: 0.8,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
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
                Indicator(
                  color: Color(0xfff8b250),
                  text: widget.type == BarChartType.isFinished
                      ? 'bookNotFinish'.tr()
                      : 'bookBuy'.tr(),
                ),
                SizedBox(height: 4),
                Indicator(
                  color: Color(0xff0293ee),
                  text: widget.type == BarChartType.isFinished
                      ? 'bookFinish'.tr()
                      : 'bookNotBuy'.tr(),
                ),
                SizedBox(height: 18),
              ],
            ),
            const SizedBox(width: 28),
          ]),
        ]),
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

    int totalCount = filter.length;
    int finishCount = filter
        .where((i) => widget.type == BarChartType.isFinished
            ? i.isFinished == false
            : i.isBought == true)
        .toList()
        .length;
    double finishCountPercent = 0.0;
    if (totalCount > 0) {
      finishCountPercent = (finishCount * 100) / totalCount;

      return BarChartGroupData(
        x: axis,
        barRods: [
          BarChartRodData(
            y: 100,
            width: barWidth,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  finishCountPercent,
                  const Color(0xfff8b250),
                  BorderSide(
                      color: Colors.white, width: touchedIndex == 0 ? 2 : 0)),
              BarChartRodStackItem(
                  finishCountPercent,
                  100,
                  const Color(0xff0293ee),
                  BorderSide(
                      color: Colors.white, width: touchedIndex == 0 ? 2 : 0)),
            ],
          ),
        ],
      );
    }
  }
}
