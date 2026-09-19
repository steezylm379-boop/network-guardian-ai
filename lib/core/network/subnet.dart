class Ipv4Subnet {
  Ipv4Subnet(String address, this.prefix) : address = parse(address) {
    if (prefix < 0 || prefix > 32) {
      throw const FormatException('Invalid IPv4 prefix');
    }
  }

  final int address;
  final int prefix;

  static final RegExp _ipv4Pattern = RegExp(
    r'^(?:0|[1-9]\d{0,2})\.(?:0|[1-9]\d{0,2})\.(?:0|[1-9]\d{0,2})\.(?:0|[1-9]\d{0,2})$',
  );

  static int parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || !_ipv4Pattern.hasMatch(trimmed)) {
      throw const FormatException('Invalid IPv4 address');
    }
    final parts = trimmed.split('.');
    if (parts.length != 4) throw const FormatException('Invalid IPv4 address');
    var result = 0;
    for (final part in parts) {
      final n = int.tryParse(part);
      if (n == null || n < 0 || n > 255) {
        throw const FormatException('Invalid IPv4 address');
      }
      result = (result << 8) | n;
    }
    return result;
  }

  static String format(int n) =>
      [24, 16, 8, 0].map((s) => (n >> s) & 255).join('.');

  int get mask => prefix == 0 ? 0 : (0xffffffff << (32 - prefix)) & 0xffffffff;
  int get network => address & mask;
  int get broadcast => network | (0xffffffff ^ mask);
  int get first => prefix >= 31 ? network : network + 1;
  int get last => prefix >= 31 ? broadcast : broadcast - 1;
  int get count {
    if (prefix == 0) return 4294967294; // 2^32 - 2 hosts
    if (prefix >= 31) return (broadcast - network + 1).clamp(0, 0xffffffff);
    final c = broadcast - network - 1;
    return c > 0 ? c : 0;
  }

  String get cidr => '${format(network)}/$prefix';

  bool contains(String ip) {
    try {
      return (parse(ip) & mask) == network;
    } on FormatException {
      return false;
    }
  }

  Iterable<String> get hosts sync* {
    if (count <= 0) return;
    for (var n = first; n <= last; n++) {
      yield format(n);
    }
  }
}
