import 'package:flutter_test/flutter_test.dart';
import 'package:munshi/features/transactions/data/codecs/category_icon_spec_codec.dart';
import 'package:munshi/features/transactions/domain/value_objects/category_icon_spec.dart';

void main() {
  group('CategoryIconSpecCodec', () {
    test('encodes the existing database format', () {
      const icon = CategoryIconSpec(
        codePoint: 0xee52,
        fontFamily: 'Iconsax',
        fontPackage: 'icons_plus',
      );

      expect(
        CategoryIconSpecCodec.encode(icon),
        '61010,Iconsax,icons_plus',
      );
    });

    test('decodes the existing database format', () {
      expect(
        CategoryIconSpecCodec.decode('61010,Iconsax,icons_plus'),
        const CategoryIconSpec(
          codePoint: 0xee52,
          fontFamily: 'Iconsax',
          fontPackage: 'icons_plus',
        ),
      );
    });

    test('preserves nullable font metadata', () {
      const icon = CategoryIconSpec(codePoint: 42);

      expect(
        CategoryIconSpecCodec.decode(CategoryIconSpecCodec.encode(icon)),
        icon,
      );
    });

    test('rejects malformed stored values', () {
      expect(
        () => CategoryIconSpecCodec.decode('invalid'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
