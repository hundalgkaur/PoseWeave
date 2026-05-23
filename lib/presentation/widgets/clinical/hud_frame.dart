import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';

/// Four cyan L-shaped corner brackets framing a viewport (the clinical/HUD
/// "scanning" aesthetic). Decorative; ignores pointer events.
class HudFrame extends StatelessWidget {
  const HudFrame({super.key, this.inset = 16});

  final double inset;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: EdgeInsets.all(inset),
        child: const Stack(
          children: <Widget>[
            Align(alignment: Alignment.topLeft, child: _Corner(top: true, left: true)),
            Align(alignment: Alignment.topRight, child: _Corner(top: true, left: false)),
            Align(alignment: Alignment.bottomLeft, child: _Corner(top: false, left: true)),
            Align(alignment: Alignment.bottomRight, child: _Corner(top: false, left: false)),
          ],
        ),
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  const _Corner({required this.top, required this.left});
  final bool top;
  final bool left;

  @override
  Widget build(BuildContext context) {
    const BorderSide side = BorderSide(color: AppColors.primary, width: 2);
    return SizedBox(
      width: 18,
      height: 18,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: top ? side : BorderSide.none,
            bottom: top ? BorderSide.none : side,
            left: left ? side : BorderSide.none,
            right: left ? BorderSide.none : side,
          ),
        ),
      ),
    );
  }
}
