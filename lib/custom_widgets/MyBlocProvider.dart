import 'package:flutter/widgets.dart';

class MyBlocProvider<T> extends InheritedWidget {
  final T bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static MyBlocProvider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(MyBlocProvider) as MyBlocProvider)
          .bloc;

  MyBlocProvider({
    Key key,
    this.bloc,
    Widget child,
  }) : super(
          key: key,
          child: child,
        );
}
