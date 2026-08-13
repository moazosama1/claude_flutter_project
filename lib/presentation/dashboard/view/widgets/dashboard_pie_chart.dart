import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../transactions/view/widgets/category_name_localization.dart';

/// Pie chart + legend for the dashboard expenses-by-category breakdown.
/// Stateless; the parent Section decides when to show it vs the empty state.
class DashboardPieChart extends StatelessWidget {
  final List<MapEntry<CategoryEntity, double>> entries;
  final String currency;

  const DashboardPieChart({
    super.key,
    required this.entries,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final total = entries.fold<double>(0, (sum, e) => sum + e.value);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 36,
              sections: entries.map((e) {
                final pct = total > 0 ? (e.value / total) * 100 : 0;
                return PieChartSectionData(
                  value: e.value,
                  color: _parseHex(e.key.colorHex),
                  title: '${pct.toStringAsFixed(0)}%',
                  radius: 40,
                  titleStyle: context.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: AppMeasurements.paddingLarge),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppMeasurements.paddingExtraSmall,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _parseHex(e.key.colorHex),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: AppMeasurements.paddingSmall),
                    Expanded(
                      child: Text(
                        localizeCategoryName(context, e.key.name),
                        style: context.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      e.value.toMoney(currency),
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _parseHex(String hex) {
    var cleaned = hex.replaceFirst('#', '');
    if (cleaned.length == 6) cleaned = 'FF$cleaned';
    return Color(int.parse(cleaned, radix: 16));
  }
}
