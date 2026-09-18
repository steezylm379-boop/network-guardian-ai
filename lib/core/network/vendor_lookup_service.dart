import 'dart:convert';
import 'package:flutter/services.dart';
import '../../features/network_scan/domain/device_merge_service.dart';

class VendorLookupService {
  Map<String, dynamic> _entries = {};
  Future<void> load() async {
    if (_entries.isNotEmpty) return;
    _entries = jsonDecode(await rootBundle.loadString('assets/oui.json'));
  }

  String? lookup(String? address) {
    final mac = DeviceMergeService.normalizeMac(address);
    if (mac == null || (int.parse(mac.substring(0, 2), radix: 16) & 2) != 0) {
      return null;
    }
    final key = mac.replaceAll(':', '');
    for (final length in [9, 7, 6]) {
      final vendor = _entries[key.substring(0, length)];
      if (vendor is String) return vendor;
    }
    return null;
  }
}
