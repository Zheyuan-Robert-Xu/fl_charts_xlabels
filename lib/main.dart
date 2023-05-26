import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  List<DateTime> timestamps = [
    DateTime(2023, 5, 1, 0, 0, 0),
    DateTime(2023, 5, 2, 0, 0, 0),
    DateTime(2023, 5, 5, 0, 0, 0),
    DateTime(2023, 5, 17, 0, 0, 0),
    DateTime(2023, 5, 20, 0, 0, 0),
    DateTime(2023, 5, 25, 0, 0, 0),
  ];

  DateTime currentDay = timestamps.first;

  List<DateTime> timeWholeStamps = [];

  while (currentDay.isBefore(timestamps.last)) {
    timeWholeStamps.add(currentDay);
    currentDay = currentDay.add(Duration(days: 1));
  }

  timeWholeStamps.add(timestamps.last);

  // Calculate time differences between timestamps
  List<double> timeDifferences = [];
  for (int i = 0; i < timestamps.length - 1; i++) {
    Duration difference = timestamps[i + 1].difference(timestamps[i]);
    timeDifferences.add(difference.inDays.toDouble());
  }

  List<FlSpot> generateData(
      List<double> timeDifferences, List<double> yValues) {
    List<FlSpot> data = [];
    double cumulativeX = 0.0;

    for (int i = 0; i < timeDifferences.length; i++) {
      double x = cumulativeX;
      double y = yValues[i];

      FlSpot spot = FlSpot(x, y);

      cumulativeX += timeDifferences[i];

      data.add(spot);
    }
    data.add(FlSpot(cumulativeX, yValues.last));
    return data;
  }

  int calculateDayDifference(DateTime var1, DateTime var2) {
    Duration difference = var2.difference(var1);
    return difference.inDays.abs();
  }

  List<double> yValues = [4, 3.5, 6, 8, 10, 7];

  List<FlSpot> data = generateData(timeDifferences, yValues);

  // Define a custom method to calculate the interval based on time differences
  double? calculateInterval(List<double> timeDifferences, int index) {
    if (index >= 0 && index < timeDifferences.length) {
      // Get the interval for the specified index
      double interval = timeDifferences[index];
      return interval;
    }
    return null; // Return null if the index is out of range
  }

  Widget getTitleWidget(double value, TitleMeta meta) {
    if (value >= 0 && value < timeWholeStamps.length) {
      DateTime timestamp = timeWholeStamps[value.toInt()];

      return Text(
        '${timestamp.month}/${timestamp.day}',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        textAlign: TextAlign.right,
      );
    }
    return Container();
  }

  // Create a LineChartData object
  LineChartData chartData = LineChartData(
    minX: 0,
    maxX: calculateDayDifference(timestamps.last, timestamps.first).toDouble(),
    minY: 0,
    maxY: yValues.reduce(max) + 1,
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: 3,
          getTitlesWidget: getTitleWidget,
        ),
      ),
    ),
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey,
          strokeWidth: 0.5,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.grey,
          strokeWidth: 0.5,
        );
      },
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(
        color: Colors.black,
        width: 0.5,
      ),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: data,
        isCurved: true,
        color: Colors.blue,
        barWidth: 1, // Increase the barWidth to create gaps
        dotData: FlDotData(show: true),
      ),
    ],
  );

  // Build your chart widget using the LineChart widget
  LineChart chart = LineChart(
    chartData,
    swapAnimationDuration: const Duration(milliseconds: 250),
  );

  // Add the chart widget to your app's UI
  runApp(MaterialApp(home: Scaffold(body: chart)));
}
