import 'package:flutter/services.dart' show rootBundle;
import '_exports.dart';

class VoxelApp extends FlameGame {
  static const description = '''
A little fun and educational project for jimmyff (Uncle) & 
williamff (Nephew). Disclaimer: This is almost certainly not 
an optimal way to make a simple 3D voxel engine! If you make 
any cool changes, please document the code and send us a pull 
request! :-)
  ''';

  late Player player;

  List<Color> colors = [];
  double uiPadding = 0;

  @override
  Future<void> onLoad() async {
    final mapFile = List<int>.from(
        json.decode(await rootBundle.loadString('assets/maps/hills.json')));

    colors = generateMapColors();

    player = Player(position: const Offset(8, 8), height: 30.0, direction: pi);

    add(Map2dComponent(
      map: mapFile,
    ));

    add(FpsTextComponent(position: Vector2(uiPadding, uiPadding)));
  }

  /// Recalculate map position & size
  @override
  void onGameResize(Vector2 size) {
    uiPadding = min(size.y, size.x) * 0.025;
    super.onGameResize(size);
  }

  List<Color> generateMapColors() {
    final colors = <Color>[];
    final colorHeights = {
      0: const Color.fromRGBO(0, 0, 255, 1.0),
      30: const Color.fromRGBO(20, 90, 185, 1.0),
      60: const Color.fromRGBO(170, 125, 155, 1.0),
      100: const Color.fromRGBO(90, 150, 70, 1.0),
      130: const Color.fromRGBO(50, 150, 50, 1.0),
      190: const Color.fromRGBO(40, 120, 40, 1.0),
      210: const Color.fromRGBO(80, 80, 90, 1.0),
      240: const Color.fromRGBO(110, 110, 120, 1.0),
      250: const Color.fromRGBO(180, 180, 180, 1.0),
      256: const Color.fromRGBO(230, 230, 230, 1.0),
    };
    final keyList = colorHeights.keys.toList();
    for (var height1 in keyList) {
      final heightIndex = keyList.indexOf(height1);
      // print(height1);
      if (heightIndex == keyList.length - 1) {
        break;
      }
      var height2 = keyList[heightIndex + 1];
      var c1 = colorHeights[height1];
      var c2 = colorHeights[height2];
      final steps = height2 - height1;
      colors.addAll(
          List.generate(steps, (step) => Color.lerp(c1, c2, step / steps)!));
    }
    return colors;
  }

  @override
  void update(double dt) {
    player.direction += ((pi / 180) * (dt * 60));

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
