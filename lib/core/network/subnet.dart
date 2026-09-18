class Ipv4Subnet {
  Ipv4Subnet(String address, this.prefix) : address = parse(address) {
    if (prefix < 0 || prefix > 32) {
      throw const FormatException('Invalid IPv4 prefix');
    }
  }
  final int address;
  final int prefix;
  static int parse(String value) {
    final parts = value.split('.');
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
  int get count => last - first + 1;
  String get cidr => '${format(network)}/$prefix';
  bool contains(String ip) => (parse(ip) & mask) == network;
  Iterable<String> get hosts sync* {
    for (var n = first; n <= last; n++) {
      yield format(n);
    }
  }
}
