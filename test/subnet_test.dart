import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/core/network/subnet.dart';

void main() {
  test('subnets use actual prefix, including /23 and /20', () {
    final s = Ipv4Subnet('192.168.3.34', 23);
    expect(s.cidr, '192.168.2.0/23');
    expect(s.count, 510);
    expect(s.hosts.first, '192.168.2.1');
    expect(s.hosts.last, '192.168.3.254');
    expect(Ipv4Subnet('10.20.31.5', 20).cidr, '10.20.16.0/20');
  });
  test('point-to-point and host routes retain valid hosts', () {
    expect(Ipv4Subnet('10.0.0.0', 31).hosts.toList(), ['10.0.0.0', '10.0.0.1']);
    expect(Ipv4Subnet('10.0.0.7', 32).hosts.toList(), ['10.0.0.7']);
    expect(Ipv4Subnet('10.0.0.7', 0).count, 4294967294);
  });
  test('invalid addresses and prefixes fail clearly', () {
    expect(() => Ipv4Subnet('10.0.0.256', 24), throwsFormatException);
    expect(() => Ipv4Subnet('10.0.0.1', 33), throwsFormatException);
    expect(() => Ipv4Subnet('::1', 24), throwsFormatException);
  });
}
