import 'package:flutter_test/flutter_test.dart';
import 'package:esof/flutter_flow/nav/nav.dart';

void main() {
  group('Change of Worker State', () {
    test('setAdmin should update isAdmin correctly', () {
      final notifier = AppStateNotifier.instance;

      expect(notifier.isAdmin, false);

      notifier.setAdmin(true);

      expect(notifier.isAdmin, true);

      notifier.setAdmin(false);

      expect(notifier.isAdmin, false);
    });
  });
}
