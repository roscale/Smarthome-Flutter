import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppBarAnimatedBuilder extends AnimatedBuilder implements PreferredSizeWidget {
  @override final Size preferredSize;

  const AppBarAnimatedBuilder({
    Key key,
    @required Listenable animation,
    @required builder,
    Widget child,
    @required this.preferredSize
  }) : super(key: key, animation: animation, builder: builder, child: child);
}