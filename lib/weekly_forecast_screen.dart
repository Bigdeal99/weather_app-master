import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather_sliver_app_bar.dart';
import 'package:weather/weekly_forecast_list.dart';
import 'package:weather/models.dart';
import 'package:weather/data_source.dart';

class WeeklyForecastScreen extends StatefulWidget {
  const WeeklyForecastScreen({super.key});

  @override
  _WeeklyForecastScreenState createState() => _WeeklyForecastScreenState();
}

class _WeeklyForecastScreenState extends State<WeeklyForecastScreen> {
  late final StreamController<WeeklyForecastDto> controller;

  @override
  void initState() {
    super.initState();
    controller = StreamController<WeeklyForecastDto>();
    loadForecast();
  }

  Future<void> loadForecast() async {
    try {
      final forecast = await context.read<DataSource>().getWeeklyForecast();
      controller.add(forecast); // Update the stream with the new forecast
    } catch (error) {
      controller.addError(error); // Send error to the stream if any occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    // Adjust these colors to fit your app's theme
    const Color primaryColor = Colors.deepPurple; // Example primary color
    const Color accentColor = Colors.deepPurpleAccent; // Example accent color

    return Scaffold(
      body: RefreshIndicator(
        color: accentColor, // Color of the refresh indicator
        backgroundColor: primaryColor, // Background color of the refresh indicator
        edgeOffset: 50.0,
        onRefresh: loadForecast,
        child: CustomScrollView(
          slivers: <Widget>[
            const WeatherSliverAppBar(), // Consider customizing this as well
            StreamBuilder<WeeklyForecastDto>(
              stream: controller.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return WeeklyForecastList(weeklyForecast: snapshot.data!);
                } else if (snapshot.hasError) {
                  return buildError(snapshot.error, context);
                } else {
                  return buildSpinner();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildError(Object? error, BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: ${error.toString()}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.redAccent, // Example error message color
              fontSize: 18,
              fontWeight: FontWeight.bold, // Added for emphasis
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSpinner() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red), // Adjust spinner color
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.close(); // Close the StreamController to avoid memory leaks
    super.dispose();
  }
}
