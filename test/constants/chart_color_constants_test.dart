import 'package:test/test.dart';
import 'package:pension_compare/constants/chart_color_constants.dart';

void main() {
  group('ChartColorConstants', () {
    late ChartColorConstants chartColorConstants;

    setUp(() {
      chartColorConstants = ChartColorConstants();
    });

    test('Given getColorForPension is called with a new id, '
        'When the method is called, '
        'Then it should return a color', () {
      // Arrange
      const id = 1;      

      // Act
      final color = chartColorConstants.getColorForPension(id);

      // Assert
      expect(color, isNotNull);
    });

    test('Given getColorForPension is called with a existing id, '
        'When the method is called, '
        'Then it should return the same color', () {
      // Arrange
      const id = 1;      

      // Act
      final color1 = chartColorConstants.getColorForPension(id);
      final color2 = chartColorConstants.getColorForPension(id);

      // Assert
      expect(color1, color2);
    });

    test('Given getColorForPension is called with a different id, '
        'When the method is called, '
        'Then it should return a new color', () {
      // Arrange
      const id1 = 1;      
      const id2 = 2;      

      // Act
      final color1 = chartColorConstants.getColorForPension(id1);
      final color2 = chartColorConstants.getColorForPension(id2);

      // Assert
      expect(color1 == color2, isFalse);
    });
  });
}
