import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok/features/authentications/widgets/form_button.dart';

void main() {
  group("Form Button Tests", () {
    testWidgets("Enabled State", (WidgetTester tester) async {
      // pumpWidget은 주어진 widget으로부터 UI를 그린다.
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: FormButton(disabled: false),
        ),
      );
      expect(find.text("Next"), findsOneWidget);
      expect(
        tester
            .firstWidget<AnimatedDefaultTextStyle>(
                find.byType(AnimatedDefaultTextStyle))
            .style
            .color,
        Colors.white,
      );
    });
    testWidgets("Disabled State", (WidgetTester tester) async {
      // pumpWidget은 주어진 widget으로부터 UI를 그린다.
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: FormButton(disabled: false),
        ),
      );
      expect(find.text("Next"), findsOneWidget);
      expect(
        tester
            .firstWidget<AnimatedDefaultTextStyle>(
                find.byType(AnimatedDefaultTextStyle))
            .style
            .color,
        Colors.grey,
      );
    });
  });
}
