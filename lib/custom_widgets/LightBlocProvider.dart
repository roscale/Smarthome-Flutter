import 'package:flutter/widgets.dart';
import 'package:smarthome/blocs/LightBloc.dart';
import 'package:smarthome/custom_widgets/MyBlocProvider.dart';

class LightBlocProvider extends MyBlocProvider<LightBloc> {
  LightBlocProvider({key, LightBloc bloc, child})
      : super(key: key, bloc: bloc, child: child);

  static LightBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LightBlocProvider)
              as LightBlocProvider)
          .bloc;
}
