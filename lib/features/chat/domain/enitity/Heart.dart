
import 'dart:ui';

class Heart {
  Offset position;
  double size;
  Offset velocity;
  Color color;

  Heart({
    required this.position,
    required this.size,
    required this.velocity,
    required this.color,
  });

  void updatePosition(Size screenSize) {
    position += velocity;

    if (position.dx < 0 || position.dx > screenSize.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy < 0 || position.dy > screenSize.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }
  }
}
