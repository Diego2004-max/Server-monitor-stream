import 'package:flutter/material.dart';
import '../../bloc/monitoring_bloc.dart';
import '../../models/server_metrics.dart';
import '../widgets/metric_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MonitoringBloc bloc = MonitoringBloc();
  final List<double> _cpuHistory = [];

  @override
  void initState() {
    super.initState();
    bloc.start();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Color _barColor(double value) {
    if (value > 80) return const Color(0xFFE24B4A);
    if (value > 50) return const Color(0xFFEF9F27);
    return const Color(0xFF1D9E75);
  }

  Widget _statusBanner(String status) {
    final bool isAlert = status == 'ALERTA';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isAlert ? const Color(0xFFFCEBEB) : const Color(0xFFE1F5EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isAlert ? const Color(0xFFF7C1C1) : const Color(0xFF9FE1CB),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isAlert ? const Color(0xFFF7C1C1) : const Color(0xFF9FE1CB),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAlert ? Icons.warning_rounded : Icons.check_rounded,
              size: 18,
              color: isAlert ? const Color(0xFFA32D2D) : const Color(0xFF0F6E56),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ESTADO DEL SISTEMA',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                  color: isAlert
                      ? const Color(0xFFA32D2D)
                      : const Color(0xFF0F6E56),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isAlert
                    ? 'Alerta — revisar métricas críticas'
                    : 'Operando con normalidad',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isAlert
                      ? const Color(0xFFA32D2D)
                      : const Color(0xFF0F6E56),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sparkline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0x26000000),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HISTORIAL CPU',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
              color: Color(0xFF888780),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _cpuHistory.map((v) {
                final h = (v / 100 * 44).clamp(4.0, 48.0);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: h,
                      decoration: BoxDecoration(
                        color: _barColor(v).withAlpha(191),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        surfaceTintColor: const Color(0x00000000),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INFRASTRUCTURE',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                color: const Color(0xFF9E9E9E),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'Server monitoring',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE1F5EE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1D9E75),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'En vivo',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF0F6E56),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            height: 0.5,
            color: const Color(0xFFE0E0E0),
          ),
        ),
      ),
      body: StreamBuilder<ServerMetrics>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }

          final data = snapshot.data!;
          _cpuHistory.add(data.cpu);
          if (_cpuHistory.length > 14) _cpuHistory.removeAt(0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MetricCard(
                        title: 'CPU',
                        value: data.cpu,
                        color: _barColor(data.cpu),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MetricCard(
                        title: 'RAM',
                        value: data.ram,
                        color: _barColor(data.ram),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MetricCard(
                  title: 'DISK',
                  value: data.disk,
                  color: _barColor(data.disk),
                  horizontal: true,
                ),
                const SizedBox(height: 12),
                _statusBanner(data.status),
                const SizedBox(height: 12),
                _sparkline(),
                const SizedBox(height: 8),
                Text(
                  'Actualiza cada 2 segundos',
                  style: TextStyle(
                    fontSize: 11,
                    color: const Color(0xFFBDBDBD),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}