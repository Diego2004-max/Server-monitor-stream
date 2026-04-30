import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;
  final bool horizontal;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.horizontal = false,
  });

  MetricLevel get _level {
    if (value > 80) return MetricLevel.critical;
    if (value > 50) return MetricLevel.warning;
    return MetricLevel.normal;
  }

  Color get _badgeBg {
    switch (_level) {
      case MetricLevel.critical: return const Color(0xFFFCEBEB);
      case MetricLevel.warning:  return const Color(0xFFFAEEDA);
      case MetricLevel.normal:   return const Color(0xFFE1F5EE);
    }
  }

  Color get _badgeText {
    switch (_level) {
      case MetricLevel.critical: return const Color(0xFFA32D2D);
      case MetricLevel.warning:  return const Color(0xFF854F0B);
      case MetricLevel.normal:   return const Color(0xFF0F6E56);
    }
  }

  String get _levelLabel {
    switch (_level) {
      case MetricLevel.critical: return 'Crítico';
      case MetricLevel.warning:  return 'Moderado';
      case MetricLevel.normal:   return 'Normal';
    }
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
            color: Color(0xFF888780),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _badgeBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _levelLabel,
            style: TextStyle(
              fontSize: 10,
              color: _badgeText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _progressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value / 100,
        minHeight: 4,
        backgroundColor: const Color(0xFFEEEEEE),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildVertical() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 10),
        Text(
          '${value.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 10),
        _progressBar(),
      ],
    );
  }

  Widget _buildHorizontal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              '${value.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: _progressBar()),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
      child: horizontal ? _buildHorizontal() : _buildVertical(),
    );
  }
}

enum MetricLevel { normal, warning, critical }