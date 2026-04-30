class ServerMetrics {
  final double cpu;
  final double ram;
  final double disk;
  final String status;

  ServerMetrics({
    required this.cpu,
    required this.ram,
    required this.disk,
    required this.status,
  });
}