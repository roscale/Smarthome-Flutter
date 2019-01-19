import 'package:flutter/widgets.dart';


class AnimatedStack extends StatefulWidget {
  final Duration duration;
  final int currentIndex;
  final List<Widget> children;

  AnimatedStack({key, this.duration = const Duration(milliseconds: 200), this.currentIndex = 0, @required this.children}) :
        assert(currentIndex >= 0 && currentIndex < children.length),
        super(key: key);

  @override
  State createState() => AnimatedStackState();
}


class AnimatedStackState extends State<AnimatedStack> with TickerProviderStateMixin {
  int oldIndex;

  List<FadeTransition> _transitions = [];

  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();

    oldIndex = widget.currentIndex;

    for (int i = 0; i < widget.children.length; i++) {
      var controller = AnimationController(
        duration: widget.duration,
        vsync: this,
      );
      _controllers.add(controller);

      var animation = controller.drive(CurveTween(
        curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ));
      _animations.add(animation);
      _transitions.add(
          FadeTransition(
            key: GlobalKey(),
            opacity: animation,
            child: SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 0.02), // Slightly down.
                  end: Offset.zero,
                ),
              ),
              child: widget.children[i]
            ),
          )
      );
    }

    // Build the stack for the first time (Bug: Page not interactable on launch)
    _buildTransitionsStack();
  }

  Widget _buildTransitionsStack() {
    _transitions.sort((FadeTransition a, FadeTransition b) {
      return (a.opacity.value).compareTo(b.opacity.value);
    });

    return Stack(children: _transitions);
  }

  @override
  Widget build(BuildContext context) {
    _controllers[oldIndex].reverse().then((void a) {setState(() {});});
    _controllers[widget.currentIndex].forward();

    oldIndex = widget.currentIndex;

    return _buildTransitionsStack();
  }
}