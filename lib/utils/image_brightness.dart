import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

/// 画像の明るさを計算する関数
Future<double> calculateImageBrightness(String imageUrl) async {
  try {
    // ネットワークから画像データを取得
    final ByteData data =
        await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
    final Uint8List bytes = data.buffer.asUint8List();

    // 画像をデコード
    final img.Image? image = img.decodeImage(bytes);
    if (image == null) return 0.0;

    // 画像全体のピクセルの明るさを計算
    int totalBrightness = 0;
    int pixelCount = 0;

    for (int y = 0; y < image.height; y += 10) {
      for (int x = 0; x < image.width; x += 10) {
        final img.Color pixel = image.getPixel(x, y);
        final int brightness = (pixel.r + pixel.g + pixel.b) ~/ 3; // 明るさの計算
        totalBrightness += brightness;
        pixelCount++;
      }
    }

    return totalBrightness / pixelCount; // 平均明るさを返す
  } catch (e) {
    return 0.0; // エラー時のデフォルト値
  }
}
