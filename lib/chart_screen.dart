import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

import 'data_source.dart';
import 'models/time_series.dart';

// Refine the color palette for a more professional look
final List<Color> seriesColors = [
  Colors.deepPurple, // Rich, professional color
  Colors.teal,       // Complementary, engaging color
  Colors.amber,      // Warm, inviting color
  Colors.indigo,     // Deep, thoughtful color
];

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  Future<WeatherChartData>? chartData;

  @override
  void initState() {
    super.initState();
    chartData = loadChartData();
  }

  Future<WeatherChartData> loadChartData() {
    // Fetch chart data using the DataSource provider
    return context.read<DataSource>().getChartData();
  }

  Future<void> _onRefresh() async {
    setState(() {
      chartData = loadChartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.deepPurple, // Enhanced refresh indicator color
          onRefresh: _onRefresh,
          child: FutureBuilder<WeatherChartData>(
            future: chartData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.redAccent, fontSize: 16), // Error message styling
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available', style: TextStyle(fontSize: 16)));
              }
              final variables = snapshot.data!.daily!;
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: charts.TimeSeriesChart(
                        [
                          for (int i = 0; i < variables.length; i++)
                            charts.Series<TimeSeriesDatum, DateTime>(
                              id: '${variables[i].name} ${variables[i].unit}',
                              domainFn: (datum, _) => datum.domain,
                              measureFn: (datum, _) => datum.measure,
                              data: variables[i].values,
                              colorFn: (_, __) => charts.ColorUtil.fromDartColor(seriesColors[i % seriesColors.length]),
                            ),
                        ],
                        animate: true,
                        dateTimeFactory: const charts.LocalDateTimeFactory(),
                        behaviors: [
                          charts.SeriesLegend(
                            // Series legend styling for a cleaner look
                            position: charts.BehaviorPosition.bottom,
                            horizontalFirst: false,
                            cellPadding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
                            showMeasures: true,
                            legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                            entryTextStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.gray.shadeDefault,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
