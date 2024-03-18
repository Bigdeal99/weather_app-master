import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WeatherSliverAppBar extends StatelessWidget {
  const WeatherSliverAppBar({
    super.key, this.onRefresh,
  });

  final AsyncCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    // Updated color scheme for a more vibrant look
    final Color primaryColor = Colors.deepPurple[400]!; // Example vibrant primary color
    final Color secondaryColor = Colors.deepPurple[700]!; // Example deeper secondary color for gradient

    return SliverAppBar(
      pinned: true,
      stretch: true,
      onStretchTrigger: onRefresh,
      backgroundColor: primaryColor,
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(12), // Adjust padding for title
        centerTitle: true, // Center the title
        title: Text(
          'Weather Forecast',
          style: TextStyle(
            color: Colors.white, // Ensure title is clearly visible
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Color.fromARGB(150, 0, 0, 0), // Soft shadow for depth
              ),
            ],
          ),
        ),
        background: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[
                secondaryColor, // Starts with a deeper purple
                primaryColor.withOpacity(0.3), // Ends with a transparent variant of the primary color
              ],
            ),
          ),
          child: Image.asset(
            'assets/images/header.jpg', // Ensure this asset exists in your project
            fit: BoxFit.cover,
            color: Color.fromRGBO(255, 255, 255, 0.5), // Slightly lighten the image
            colorBlendMode: BlendMode.modulate,
          ),
        ),
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
          StretchMode.blurBackground,
        ],
      ),
    );
  }
}
