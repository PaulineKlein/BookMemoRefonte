import 'package:bookmemo/data/model/book.dart';
import 'package:bookmemo/ui/home/statistics/buildPieChart.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import 'buildBarChart.dart';
import 'buildBarChartPercent.dart';

class BuildStatistics extends StatefulWidget {
  BuildStatistics({
    Key? key,
    required this.listBook,
  }) : super(key: key);

  final List<Book> listBook;

  @override
  _BuildStatisticsState createState() => _BuildStatisticsState();
}

class _BuildStatisticsState extends State<BuildStatistics> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Text(
                'chartExplanation',
                style: Theme.of(context).textTheme.bodyLarge,
              ).tr()),
          _listGraphics()
        ],
      ),
    );
  }

  Widget _listGraphics() {
    if (widget.listBook.length == 0) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 150),
          child: Align(
            alignment: Alignment.center,
            child: Text('filterEmptyList'.tr(), style: TextStyle(fontSize: 18)),
          ),
        ),
      );
    } else {
      return Column(children: <Widget>[
        BuildPieChart(listBook: widget.listBook),
        BuildBarChart(listBook: widget.listBook),
        BuildBarChartPercent(
            listBook: widget.listBook, type: BarChartType.isFinished),
        BuildBarChartPercent(
            listBook: widget.listBook, type: BarChartType.isBought)
      ]);
    }
  }
}
