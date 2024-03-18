import 'package:flutter/material.dart';

class ConstantScrollBehavior extends MaterialScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    // This example simply disables the overscroll glow effect. Adjust according to your requirements.
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // You can customize the scroll physics if needed. This example uses ClampingScrollPhysics.
    return const ClampingScrollPhysics();
  }
}
