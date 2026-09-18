import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network_scan/presentation/scan_controller.dart';
import '../../../core/database/app_database.dart';

class NetworkHistory extends ConsumerWidget {
  const NetworkHistory({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Network history')),
      body: StreamBuilder<List<Network>>(
        stream: db.select(db.networks).watch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Could not read local network history.'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = [...snapshot.data!]
            ..sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
          if (rows.isEmpty) {
            return const Center(child: Text('No networks recorded yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: rows.length,
            itemBuilder: (context, i) {
              final n = rows[i];
              return Card(
                child: ExpansionTile(
                  title: Text(n.ssid ?? 'Wi-Fi network'),
                  subtitle: Text(
                    '${n.cidr}\nLast seen ${n.lastSeen.toLocal().toString().split('.').first}',
                  ),
                  children: [
                    FutureBuilder(
                      future: db.loadDevices(n.id),
                      builder: (context, devices) {
                        if (devices.hasError) {
                          return const ListTile(
                            title: Text('Device history unavailable'),
                          );
                        }
                        return Column(
                          children: (devices.data ?? [])
                              .map(
                                (d) => ListTile(
                                  leading: Icon(
                                    d.isGateway
                                        ? Icons.router_outlined
                                        : Icons.devices_other,
                                  ),
                                  title: Text(d.name),
                                  subtitle: Text(
                                    '${d.ipAddress} · ${d.vendor ?? 'Unknown manufacturer'}',
                                  ),
                                  trailing: Text(
                                    d.isOnline ? 'Seen online' : 'Not seen',
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: (db.select(
                        db.scanSessions,
                      )..where((s) => s.networkId.equals(n.id))).watch(),
                      builder: (context, sessions) {
                        final scans = [...?sessions.data]
                          ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
                        return Column(
                          children: scans
                              .map(
                                (s) => ListTile(
                                  dense: true,
                                  title: Text(
                                    '${s.status.toUpperCase()} · ${s.found} found · ${s.scanned}/${s.total} checked',
                                  ),
                                  subtitle: Text(
                                    s.startedAt
                                        .toLocal()
                                        .toString()
                                        .split('.')
                                        .first,
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
