import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/core/network/vendor_lookup_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'offline OUI lookup avoids guessing locally administered identities',
    () async {
      final service = VendorLookupService();
      await service.load();
      expect(
        service.lookup('00:00:0C:12:34:56')?.toLowerCase(),
        contains('cisco'),
      );
      expect(service.lookup('02:00:0C:12:34:56'), isNull);
      expect(service.lookup(null), isNull);
    },
  );
}
