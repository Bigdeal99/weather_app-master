import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/weekly_forecast_screen.dart';
import 'chart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final AnimationController _controller;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _pages = [
      const WeeklyForecastScreen(),
      const ChartScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _controller.forward(from: 0.0); // Restart the animation whenever a tab is selected
  }

  @override
  Widget build(BuildContext context) {
    // Example vibrant primary color and complementary secondary color
    const Color primaryColor = Colors.deepPurple;
    const Color secondaryColor = Colors.deepOrange;

    return Scaffold(
      body: FadeTransition(
        opacity: _controller,
        child: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), // Updated icon
            activeIcon: Icon(Icons.calendar_today), // Icon when tab is active
            label: 'Weekly Forecast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined), // Updated icon
            activeIcon: Icon(Icons.bar_chart), // Icon when tab is active
            label: 'Charts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: secondaryColor, // Use the vibrant secondary color
        unselectedItemColor: primaryColor.withOpacity(0.6), // Slightly transparent primary color
        onTap: _onItemTapped,
        backgroundColor: Colors.grey[100], // Lighter background color for the bar
        type: BottomNavigationBarType.fixed, // Change to fixed to maintain background color
        showUnselectedLabels: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
