import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_charts_xlabels/hover_text.dart';

// flutter imports
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class _CustomizedLineChart extends StatelessWidget {
  _CustomizedLineChart(
      {Key? key,
      required this.dataList,
      required this.isShowingDot,
      required this.xLabelList,
      this.xAxisTooltipList,
      required this.highNormalLowList,
      required this.yAxisRange,
      required this.yLabelsList,
      required this.yAxisShowDouble,
      required this.showMeasurement,
      this.xAxisHasTooltip = false})
      : super(key: key);

  final List<double> dataList;
  final List<String> xLabelList;
  final List<String>? xAxisTooltipList;
  final List<double> highNormalLowList;
  final bool isShowingDot;
  final List<double> yAxisRange;
  final List<String> yLabelsList;
  final bool yAxisShowDouble;
  final String showMeasurement;
  final bool xAxisHasTooltip;

  List<int> get showIndexes => [for (var i = 0; i < dataList.length; i++) i];

  Color toolTipBgColor1 = Colors.blueGrey.withOpacity(0.8);
  double smallTextSize = 15.0;
  Color bottomBorderSideColor1 = Color(0xff4e4964);
  Color defaultLineColor1 = Color(0xff4af690);
  Color defaultLineColor2 = Colors.grey;

  Color warningLabelColor = Color(0xFFF44336);
  Color normalLabelColor = Color(0xffa5d6a7);
  Color lowLabelColor = Color(0xff90caf7);

  // static const interval = yAxisRange.first < 10 ? 1 : 0;

  LineChartData get lineData => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsLineData,
        minX: 0,
        maxX: (dataList.length - 1) * 1.0,
        minY: yAxisRange.first * 0.9,
        maxY: yAxisRange.last, // be aware of the customized y axis range
      );

  LineChartData get dotData => LineChartData(
        showingTooltipIndicators: showIndexes.map((index) {
          return ShowingTooltipIndicators([
            LineBarSpot(tooltipsOnBar, lineBarsDotData.indexOf(tooltipsOnBar),
                tooltipsOnBar.spots[index]),
          ]);
        }).toList(),
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsDotData,
        maxX: (dataList.length - 1) * 1.0,
        minY: yAxisRange.first * 0.9,
        maxY: yAxisRange.last * 1, // be aware of the customized y axis range
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: toolTipBgColor1,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.asMap().entries.map((lineBarSpot) {
              // Only show one value
              int index = lineBarSpot.key;
              if (index != 0) {
                return null;
              }
              return LineTooltipItem(
                lineBarSpot.value.y.toString(),
                TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: smallTextSize),
              );
            }).toList();
          },
        ),
      );

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                // color: Colors.purpleAccent.shade700,
                color: Colors.transparent,
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: lerpGradient(
                    barData.gradient!.colors,
                    barData.gradient!.stops!,
                    percent / 100,
                  ),
                  strokeWidth: 2,
                  strokeColor: Colors.black54,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: EdgeInsets.all(4),
          tooltipBgColor: Colors.pinkAccent.shade200,
          tooltipRoundedRadius: 4,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              return LineTooltipItem(
                lineBarSpot.y.toString(),
                const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 9),
              );
            }).toList();
          },
        ),
      );

  FlGridData get gridData => FlGridData(show: false);

  FlTitlesData get titlesData => FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: rightTitles(),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: leftTitles(),
      ));

  // SideTitles get bottomTitles => SideTitles(
  //       showTitles: true,
  //       reservedSize: 32,
  //       interval: 1,
  //       getTitlesWidget: bottomTitleWidgets,
  //     );

  FlBorderData get borderData => FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: bottomBorderSideColor1, width: 4),
        left: BorderSide(color: Colors.transparent),
        right: BorderSide(color: Colors.transparent),
        top: BorderSide(color: Colors.transparent),
      ));

  List<LineChartBarData> get lineBarsLineData => [
        lineChartBarData1,
        lineChartBarData2,
        lineChartBarData3,
      ];

  LineChartBarData get lineChartBarData1 => LineChartBarData(
        isCurved: true,
        color: defaultLineColor2,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (FlSpot spot, double percent, LineChartBarData barData,
              int index) {
            final color = defaultLineColor1; // Change the color for dots
            return FlDotCirclePainter(radius: 4, color: color);
          },
        ),
        aboveBarData: BarAreaData(
          show: true,
          color: Colors.redAccent.withOpacity(0.2),
          cutOffY: highNormalLowList.first,
          applyCutOffY: true,
        ),
        spots: flSpotDataList(dataList),
      );

  LineChartBarData get lineChartBarData2 => LineChartBarData(
        isCurved: true,
        // gradient?
        color: defaultLineColor2,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (FlSpot spot, double percent, LineChartBarData barData,
              int index) {
            final color = defaultLineColor1; // Change the color for dots
            return FlDotCirclePainter(radius: 4, color: color);
          },
        ),
        aboveBarData: BarAreaData(
          show: true,
          color: Colors.greenAccent.withOpacity(0.3),
          cutOffY: highNormalLowList[1],
          applyCutOffY: true,
        ),
        spots: flSpotDataList(dataList),
      );

  LineChartBarData get lineChartBarData3 => LineChartBarData(
        isCurved: true,
        // gradient?
        color: defaultLineColor2,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (FlSpot spot, double percent, LineChartBarData barData,
              int index) {
            final color = defaultLineColor1; // Change the color for dots
            return FlDotCirclePainter(radius: 4, color: color);
          },
        ),
        aboveBarData: BarAreaData(
          show: true,
          color: Colors.blueAccent.withOpacity(0.3),
          cutOffY: highNormalLowList[2],
          applyCutOffY: true,
        ),
        spots: flSpotDataList(dataList),
      );

  List<LineChartBarData> get lineBarsDotData => [
        dotChartBarData1,
      ];

  LineChartBarData get dotChartBarData1 => LineChartBarData(
        showingIndicators: showIndexes,
        isCurved: true,
        curveSmoothness: 0,
        color: defaultLineColor2,
        barWidth: 1,
        isStrokeCapRound: true,
        shadow: const Shadow(
          blurRadius: 10,
          color: Colors.black,
        ),
        dotData: FlDotData(
          show: true,
          getDotPainter: (FlSpot spot, double percent, LineChartBarData barData,
              int index) {
            final color = defaultLineColor1; // Change the color for dots
            return FlDotCirclePainter(radius: 4, color: color);
          },
        ),
        belowBarData: BarAreaData(show: false),
        spots: flSpotDataList(dataList),
        gradient: LinearGradient(
          colors: [
            Color(0xff12c2e9),
            Color(0xffc471ed),
            Color(0xfff64f59),
          ],
          stops: [0.1, 0.4, 0.9],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      );

  List<FlSpot> flSpotDataList(List<double> dataList) {
    List<FlSpot> rtn = [];
    for (int i = 0; i < dataList.length; i++) {
      rtn.add(FlSpot(i * 1.0, dataList[i]));
    }
    return rtn;
  }

  // ignore: long-method
  Widget rightTitleWidgets(double value, TitleMeta meta) {
    Widget text = Text('');

    /// List to store colors of fl_charts labels
    List<Color> flChartLabelsColorList = [
      warningLabelColor,
      normalLabelColor,
      lowLabelColor
    ];
    List labelsColorList = flChartLabelsColorList;

    /// Make labelsColors list have enough numbers of colors
    if (highNormalLowList.length > flChartLabelsColorList.length) {
      labelsColorList = labelsColorList + labelsColorList;
    }

    for (int indexLabels = 0;
        indexLabels < highNormalLowList.length;
        indexLabels++) {
      if (yAxisShowDouble) {
        // To Avoid duplicated value
        if ((value - highNormalLowList[indexLabels]).abs() < 0.01) {
          text = Container(
            margin: const EdgeInsets.only(left: 1.0),
            child: Text(
              yLabelsList[indexLabels],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 0.0),
                    blurRadius: 10.0,
                    color: Colors.black54,
                  ),
                ],
                color: labelsColorList[indexLabels],
              ),
              textAlign: TextAlign.left,
            ),
          );
        }
      } else {
        if (value.toInt() == highNormalLowList[indexLabels].toInt()) {
          text = Container(
            margin: const EdgeInsets.only(left: 1.0),
            child: Text(
              yLabelsList[indexLabels],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 0.0),
                    blurRadius: 10.0,
                    color: Colors.black54,
                  ),
                ],
                color: labelsColorList[indexLabels],
              ),
              textAlign: TextAlign.left,
            ),
          );
        }
      }
    }

    return text;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: 15,
    );
    String text = '';
    // show every tick in yAxisRange
    for (int i = 0; i < yAxisRange.length; i++) {
      if (value == yAxisRange[i]) {
        text = yAxisShowDouble ? '${value}' : '${value.toInt()}';
      }
    }
    return Container(
      margin: const EdgeInsets.only(right: 2),
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text = Text('');
    for (int i = 0; i < xLabelList.length; i++) {
      if (value.toInt() == i) {
        text = HoverText(
          text: xLabelList[i],
        );
      }
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: yAxisShowDouble
            ? 0.5
            : 1, // can set to be 5 for larger scale, be aware that any value that's not divisible by interval will not show up correctly
        reservedSize: 40,
      );

  SideTitles rightTitles() => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: yAxisShowDouble ? 0.01 : 1,
        reservedSize: 10,
      );

  SideTitles bottomTitles() => SideTitles(
        getTitlesWidget: bottomTitleWidgets,
        showTitles: true,
        interval:
            2, // can set to be 5 for larger scale, be aware that any value that's not divisible by interval will not show up correctly
        reservedSize: 32,
      );

  LineChartBarData get tooltipsOnBar => lineBarsDotData.first;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingDot ? dotData : lineData,
      swapAnimationDuration: const Duration(microseconds: 250),
    );
  }
}

class CustomizedLineChart extends StatefulWidget {
  const CustomizedLineChart(
      {Key? key,
      required this.dataList,
      required this.xLabelList,
      this.xAxisTooltipList,
      required this.title,
      required this.highNormalLowList,
      required this.yAxisRange,
      required this.yLabelsList,
      required this.enabledUpdate,
      required this.updateWidget,
      required this.measureSwitcherWidget,
      required this.yAxisShowDouble,
      required this.showMeasurement,
      this.xAxisHasTooltip = false})
      : super(key: key);

  final List<double> dataList;
  final List<String> xLabelList;
  final List<String>? xAxisTooltipList;
  final String title;
  final List<double> highNormalLowList;
  final List<double> yAxisRange;
  final List<String> yLabelsList;
  final bool enabledUpdate;
  final Widget? updateWidget;
  final Widget? measureSwitcherWidget;
  final bool yAxisShowDouble;
  final String showMeasurement;
  final bool? xAxisHasTooltip;

  @override
  State<CustomizedLineChart> createState() => _CustomizedLineChartState();
}

class _CustomizedLineChartState extends State<CustomizedLineChart> {
  late bool isShowingDot;

  @override
  void initState() {
    super.initState();
    isShowingDot = false;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(1.23)),
          gradient: LinearGradient(
            colors: [
              Color(0xFFBE830E),
              Color(0xff46646c),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      widget.title,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                                color: Colors.yellowAccent,
                                offset: Offset(1.0, 0.0),
                                blurRadius: 3),
                            Shadow(
                                color: Colors.black,
                                offset: Offset(1.0, 0.0),
                                blurRadius: 5)
                          ]),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (widget.measureSwitcherWidget != null)
                      widget.measureSwitcherWidget!,
                    const SizedBox(
                      width: 20,
                    ),
                    if (widget.enabledUpdate) widget.updateWidget!,
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: _CustomizedLineChart(
                      dataList: widget.dataList,
                      isShowingDot: isShowingDot,
                      xLabelList: widget.xLabelList,
                      xAxisTooltipList: widget.xAxisTooltipList,
                      highNormalLowList: widget.highNormalLowList,
                      yAxisRange: widget.yAxisRange,
                      yLabelsList: widget.yLabelsList,
                      yAxisShowDouble: widget.yAxisShowDouble,
                      showMeasurement: widget.showMeasurement,
                      xAxisHasTooltip: widget.xAxisHasTooltip ?? false,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isShowingDot = !isShowingDot;
                });
              },
              hoverColor: Colors.blueGrey,
              tooltip: "Toggle dot/line chart",
              icon: Icon(
                Icons.line_axis,
                color: Colors.white.withOpacity(isShowingDot ? 1.0 : 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors.first;
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s], rightStop = stops[s + 1];
    final leftColor = colors[s], rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
