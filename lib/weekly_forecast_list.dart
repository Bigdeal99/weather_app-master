import 'package:flutter/material.dart';
import 'models.dart';

class WeeklyForecastList extends StatelessWidget {
  final WeeklyForecastDto weeklyForecast;

  const WeeklyForecastList({super.key, required this.weeklyForecast});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final daily = weeklyForecast.daily!;
          final date = DateTime.parse(daily.time![index]);
          final weatherCode = WeatherCode.fromInt(daily.weatherCode![index]);
          final tempMax = daily.temperature2MMax![index];
          final tempMin = daily.temperature2MMin![index];
          final weekday = weekdayAsString(date);

          return Card(
            margin: const EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              onTap: () {
                // Implement onTap functionality if needed, like showing detailed forecast
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                    width: 125.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset(
                          WeatherCode.getImagePath(daily.weatherCode![index]),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            weekday,
                            style: textTheme.headline6?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Text(
                            '${date.day}',
                            style: textTheme.subtitle1?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            weatherCode.description,
                            style: textTheme.bodyText2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '$tempMax° | $tempMin°',
                            style: textTheme.subtitle1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: weeklyForecast.daily?.time?.length ?? 0,
      ),
    );
  }

  String weekdayAsString(DateTime time) {
    return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][time.weekday - 1];
  }
}
