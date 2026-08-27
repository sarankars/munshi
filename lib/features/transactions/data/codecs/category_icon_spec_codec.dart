import 'package:munshi/features/transactions/domain/value_objects/category_icon_spec.dart';

/// Encodes category icon metadata using the format already stored in Drift.
abstract final class CategoryIconSpecCodec {
  /// Decodes `codePoint,fontFamily,fontPackage` into a [CategoryIconSpec].
  static CategoryIconSpec decode(String value) {
    final parts = value.split(',');
    if (parts.length != 3) {
      throw const FormatException('Invalid category icon format');
    }

    return CategoryIconSpec(
      codePoint: int.parse(parts[0]),
      fontFamily: parts[1].isEmpty ? null : parts[1],
      fontPackage: parts[2].isEmpty ? null : parts[2],
    );
  }

  /// Encodes [icon] as `codePoint,fontFamily,fontPackage`.
  static String encode(CategoryIconSpec icon) {
    return '${icon.codePoint},${icon.fontFamily ?? ''},'
        '${icon.fontPackage ?? ''}';
  }
}
