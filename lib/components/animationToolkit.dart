import 'package:flutter/material.dart';

class AnimationToolkit {
  // ...
  static const FloatingActionButtonAnimator floatingButtonAnimator =
      _FloatingButtonAnimator();
}

class _FloatingButtonAnimator extends FloatingActionButtonAnimator {
  const _FloatingButtonAnimator();
  @override
  Offset getOffset({Offset begin, Offset end, double progress}) {
    return end;
  }

  @override
  Animation<double> getRotationAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 0.5, end: 0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }
}
