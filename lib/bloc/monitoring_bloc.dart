import 'dart:async';
import 'dart:math';
import '../models/server_metrics.dart';

class MonitoringBloc {
  final _controller = StreamController<ServerMetrics>.broadcast();
  Stream<ServerMetrics> get stream => _controller.stream;
  final Random _random = Random();
  Timer? _timer;

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      final cpu = _random.nextDouble() * 100;
      final ram = _random.nextDouble() * 100;
      final disk = _random.nextDouble() * 100;
      final status = (cpu > 80 || ram > 80 || disk > 80) ? "ALERTA" : "OK";
      _controller.add(ServerMetrics(cpu: cpu, ram: ram, disk: disk, status: status));
    });
  }

  void stop() => _timer?.cancel();

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}