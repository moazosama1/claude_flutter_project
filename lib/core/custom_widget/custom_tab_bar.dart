import 'package:flutter/material.dart';
import 'package:initialize_project/core/extensions/theme_extension.dart';
import 'package:initialize_project/core/responsive/app_measurements.dart';

class CustomTabItem<T> {
  final String label;
  final T value;

  CustomTabItem({required this.label, required this.value});
}

class CustomTabBar<T> extends StatefulWidget {
  final List<CustomTabItem<T>> tabs;
  final T selectedTab;
  final ValueChanged<T> onTabChanged;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  State<CustomTabBar<T>> createState() => _CustomTabBarState<T>();
}

class _CustomTabBarState<T> extends State<CustomTabBar<T>> {
  final ScrollController _tabScrollController = ScrollController();

  void _scrollTabs(double offset) {
    if (_tabScrollController.hasClients) {
      final newOffset = (_tabScrollController.offset + offset).clamp(
        0.0,
        _tabScrollController.position.maxScrollExtent,
      );
      _tabScrollController.animateTo(
        newOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _tabScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Row(
      children: [
        _buildScrollButton(
          context,
          icon: Icons.chevron_left,
          onPressed: () => _scrollTabs(isRtl ? 200 : -200),
        ),
        const SizedBox(width: AppMeasurements.paddingSmall),
        Expanded(
          child: SingleChildScrollView(
            controller: _tabScrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: widget.tabs.map((tab) {
                final isSelected = widget.selectedTab == tab.value;
                return Padding(
                  padding: const EdgeInsets.only(
                    right: AppMeasurements.paddingSmall,
                  ),
                  child: _buildTabButton(
                    context,
                    label: tab.label,
                    isSelected: isSelected,
                    onTap: () => widget.onTabChanged(tab.value),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: AppMeasurements.paddingSmall),
        _buildScrollButton(
          context,
          icon: Icons.chevron_right,
          onPressed: () => _scrollTabs(isRtl ? -200 : 200),
        ),
      ],
    );
  }

  Widget _buildScrollButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppMeasurements.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.all(AppMeasurements.paddingSmall),
          child: Icon(
            icon,
            size: 24,
            color: context.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isSelected ? context.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
        elevation: isSelected ? 2 : 0,
        shadowColor: context.primaryColor.withValues(alpha: 0.3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppMeasurements.paddingLarge,
              vertical: AppMeasurements.padding12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
              border: isSelected
                  ? null
                  : Border.all(
                      color: context.onSurface.withValues(alpha: 0.1),
                      width: 1,
                    ),
            ),
            child: Text(
              label,
              style: context.labelMedium?.copyWith(
                color: isSelected
                    ? context.onPrimary
                    : context.onSurface.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
