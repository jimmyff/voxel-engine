import '../_exports.dart';

class Map2dComponent extends PositionComponent with HasGameRef<VoxelApp> {
  final List<int> map;
  late Offset offset;
  late Size renderSize;

  Map2dComponent({required this.map}) {
    super.positionType = PositionType.viewport;
  }

  /// Recalculate map position & size
  @override
  void onGameResize(Vector2 size) {
    const maxMapSize = 300;
    final mapComponentSize = (max(size.x, size.y) * .5)
        .clamp(min(min(size.x, size.y) * 0.7, maxMapSize), maxMapSize)
        .toDouble();
    offset = Offset(size.x - mapComponentSize - gameRef.uiPadding,
        size.y - mapComponentSize - gameRef.uiPadding);
    renderSize = Size(mapComponentSize, mapComponentSize);

    super.onGameResize(size);
  }

  /// Draw the 2d map
  @override
  void render(Canvas canvas) {
    canvas.translate(
        // floored to align pixels
        offset.dx.floor().toDouble(),
        offset.dy.floor().toDouble());
    var mapWidth = sqrt(map.length);
    final pixelSize = renderSize.width / mapWidth;

    for (var i = 0, l = map.length; i < l; i++) {
      final cell = Point(
            (i / mapWidth).floor().toDouble(),
            i % mapWidth.toDouble(),
          ) *
          pixelSize;

      // floor the starting coords and ceil the end coords to avoid cell border
      canvas.drawRect(
          Rect.fromLTRB(
              cell.x.floor().toDouble(),
              cell.y.floor().toDouble(),
              (cell.x + pixelSize).ceil().toDouble(),
              (cell.y + pixelSize).ceil().toDouble()),
          Paint()
            ..color = gameRef
                .colors[map[i]] // Color.fromRGBO(map[i], map[i], map[i], 1.0)
            ..style = PaintingStyle.fill);
    }

    // draw player
    final direction = Offset.fromDirection(gameRef.player.direction) * 2;
    final directionProject = gameRef.player.position + direction;
    canvas
      ..drawCircle(
          gameRef.player.position * pixelSize,
          pixelSize,
          Paint()
            ..color = const Color.fromRGBO(80, 200, 200, 1.0)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2)
      ..drawPath(
          Path()
            ..moveTo(gameRef.player.position.dx * pixelSize,
                gameRef.player.position.dy * pixelSize)
            ..lineTo(directionProject.dx * pixelSize,
                directionProject.dy * pixelSize),
          Paint()
            ..color = const Color.fromRGBO(0, 200, 200, 1.0)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);

    // Draw map border
    canvas.drawRect(
        Rect.fromLTRB(0, 0, renderSize.width, renderSize.height),
        Paint()
          ..color = const Color.fromRGBO(255, 255, 255, 1.0)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    canvas.restore();
  }
}
