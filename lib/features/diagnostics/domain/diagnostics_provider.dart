import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'diagnostics_service.dart';

final diagnosticsProvider = Provider<DiagnosticsApi>((_) => DiagnosticsService());
