import 'package:flutter/material.dart';

class VerticalDividerSplitMode extends StatelessWidget {
  final Function(double) updateVerticalPosition;
  final double fullHeightScreen;
  const VerticalDividerSplitMode({
    super.key,
    required this.updateVerticalPosition,
    required this.fullHeightScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (details.globalPosition.dy + 32 < fullHeightScreen &&
                details.globalPosition.dy > 162) {
              double delta = details.delta.dy;
              updateVerticalPosition(delta);
            }
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Divider(
                  height: 8,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[200],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  height: 24.0,
                  width: 48.0,
                ),
              ),
            ],
          ),
        ));
  }
}
