import 'dart:ui';

import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import 'animated_background.dart';

class Rectangle {
  HSVColor color;
  HSVColor initialColor;
  HSVColor fadeTo;
  double t = 0.0;
  Rect rect;
}

class RectanglesBehaviour extends Behaviour {
  static math.Random random = math.Random();
  List<Rectangle> _rectList;

  @override
  bool get isInitialized => _rectList != null;

  HSVColor randomColor() {
    return HSVColor.fromAHSV(1.0, ((random.nextDouble() * 360) % 36) * 10, random.nextDouble() * 0.2 + 0.1, random.nextDouble() * 0.1 + 0.9);
  }

  @override
  void init() {
    _rectList = new List(4 * 4);
    Size tileSize = size / 4.0;
    for (int x = 0; x < 4; ++x) {
      for (int y = 0; y < 4; ++y) {
        var rect = Rectangle()
          ..initialColor = randomColor()
          ..color = HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0)
          ..fadeTo = randomColor()
          ..rect = Offset(tileSize.width * x, tileSize.height * y) & tileSize;
        _rectList[x * 4 + y] = rect;
      }
    }
  }

  @override
  void initFrom(Behaviour oldBehaviour) {
    if (oldBehaviour is RectanglesBehaviour) {
      if (_rectList != null)
        _rectList = oldBehaviour._rectList;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final Paint rectPaint = Paint()
      ..strokeWidth = 1.0;
    for (Rectangle rect in _rectList) {
      rectPaint.color = rect.color.toColor();
      canvas.drawRect(rect.rect, rectPaint);
    }
  }

  @override
  bool tick(double delta, Duration elapsed) {
    if (_rectList == null)
      return false;
    for (Rectangle rect in _rectList) {
      rect.t = math.min(rect.t + delta * 0.5, 1.0);

      rect.color = HSVColor.lerp(rect.initialColor, rect.fadeTo, rect.t);
      if (rect.fadeTo.toColor().value == rect.color.toColor().value) {
        rect.initialColor = rect.fadeTo;
        rect.fadeTo = randomColor();
        rect.t = 0.0;
      }
    }
    return true;
  }
}