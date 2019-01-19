import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpandableCard extends StatefulWidget {
  final Widget header;
  final Widget body;
  final bool isInitiallyExpanded;
  final ValueChanged<bool> hasExpansionChanged;

  ExpandableCard({
    Key key,
    @required this.header,
    @required this.body,
    this.isInitiallyExpanded = false,
    this.hasExpansionChanged,
  });

  @override
  State createState() => ExpandableCardState(isInitiallyExpanded);
}

class ExpandableCardState extends State<ExpandableCard>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isInitiallyExpanded;

  AnimationController controller;
  CurvedAnimation easeInOutCurve;
  CurvedAnimation linearCurve;
  Animation<double> arrowRotationTween;
  Animation<EdgeInsets> paddingTween;
  Animation<double> elevationTween;

  ExpandableCardState(this.isInitiallyExpanded);

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    easeInOutCurve =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    linearCurve = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    arrowRotationTween =
        Tween<double>(begin: 0.0, end: 0.5).animate(easeInOutCurve);
    paddingTween = EdgeInsetsTween(
            begin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
            end: EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0))
        .animate(easeInOutCurve);

    elevationTween = Tween<double>(begin: 2.0, end: 5.0).animate(linearCurve);

    if (isInitiallyExpanded) {
      controller.value = 1;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildCard(BuildContext context, Widget body) {
    return Padding(
      padding: paddingTween.value,
      child: Card(
        elevation: elevationTween.value,
        margin: EdgeInsets.symmetric(vertical: 0.5, horizontal: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Header
            InkWell(
              child: ListTile(
                  title: widget.header,
                  trailing: RotationTransition(
                    child: const Icon(Icons.expand_more),
                    turns: arrowRotationTween,
                  )),
              onTap: () {
                if (!isInitiallyExpanded) {
                  controller.forward();
                  setState(() {});
                } else {
                  controller.reverse().then((void value) {
                    if (!mounted) return;
                    setState(() {
                      // Rebuild without body.
                    });
                  });
                }
                isInitiallyExpanded = !isInitiallyExpanded;

                if (widget.hasExpansionChanged != null) {
                  widget.hasExpansionChanged(isInitiallyExpanded);
                }
              },
            ),

            // Body
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: easeInOutCurve.value,
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: (widget.isInitiallyExpanded || !controller.isDismissed)
          ? widget.body
          : null,
      builder: buildCard,
    );
  }

  // Keep the card state alive even when not rendered.
  @override
  bool get wantKeepAlive => true;
}
