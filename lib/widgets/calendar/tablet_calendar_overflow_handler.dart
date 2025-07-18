import 'package:appoint/theme/app_breakpoints.dart';
import 'package:appoint/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Enhanced calendar overflow handler for tablet devices
class TabletCalendarOverflowHandler extends StatelessWidget {

  const TabletCalendarOverflowHandler({
    required this.child, super.key,
    this.maxWidth,
    this.maxHeight,
    this.padding,
    this.enableHorizontalScroll = true,
    this.enableVerticalScroll = true,
    this.physics,
  });
  final Widget child;
  final double? maxWidth;
  final double? maxHeight;
  final EdgeInsetsGeometry? padding;
  final bool enableHorizontalScroll;
  final bool enableVerticalScroll;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;

        if (!isTablet) {
          return child;
        }

        return _buildTabletLayout(context, constraints);
      },
    );

  Widget _buildTabletLayout(BuildContext context, BoxConstraints constraints) {
    final effectiveMaxWidth = maxWidth ?? constraints.maxWidth * 0.9;
    final effectiveMaxHeight = maxHeight ?? constraints.maxHeight * 0.9;

    Widget content = Container(
      constraints: BoxConstraints(
        maxWidth: effectiveMaxWidth,
        maxHeight: effectiveMaxHeight,
      ),
      child: child,
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // Handle horizontal overflow
    if (enableHorizontalScroll && constraints.maxWidth < effectiveMaxWidth) {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: physics ?? const BouncingScrollPhysics(),
        child: content,
      );
    }

    // Handle vertical overflow
    if (enableVerticalScroll && constraints.maxHeight < effectiveMaxHeight) {
      content = SingleChildScrollView(
        physics: physics ?? const BouncingScrollPhysics(),
        child: content,
      );
    }

    return Center(child: content);
  }
}

/// Responsive calendar grid that adapts to tablet screen sizes
class ResponsiveCalendarGrid extends StatelessWidget {

  const ResponsiveCalendarGrid({
    required this.children, super.key,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.padding,
    this.enableOverflowHandling = true,
  });
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;
  final bool enableOverflowHandling;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;

        int crossAxisCount;
        double childAspectRatio;

        if (isDesktop) {
          crossAxisCount = 4;
          childAspectRatio = 1.2;
        } else if (isTablet) {
          crossAxisCount = 3;
          childAspectRatio = 1.0;
        } else {
          crossAxisCount = 2;
          childAspectRatio = 0.8;
        }

        Widget grid = GridView.builder(
          gridDelegate: REDACTED_TOKEN(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );

        if (padding != null) {
          grid = Padding(padding: padding!, child: grid);
        }

        if (enableOverflowHandling) {
          grid = TabletCalendarOverflowHandler(
            enableHorizontalScroll: false,
            child: grid,
          );
        }

        return grid;
      },
    );
}

/// Responsive calendar list that adapts to tablet screen sizes
class ResponsiveCalendarList extends StatelessWidget {

  const ResponsiveCalendarList({
    required this.children, super.key,
    this.padding,
    this.enableOverflowHandling = true,
    this.physics,
  });
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool enableOverflowHandling;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;

        Widget list;

        if (isTablet) {
          // Use a grid layout for tablets
          list = GridView.builder(
            gridDelegate: const REDACTED_TOKEN(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
            shrinkWrap: true,
            physics: physics ?? const NeverScrollableScrollPhysics(),
          );
        } else {
          // Use a list layout for mobile
          list = ListView.separated(
            itemCount: children.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => children[index],
            shrinkWrap: true,
            physics: physics ?? const NeverScrollableScrollPhysics(),
          );
        }

        if (padding != null) {
          list = Padding(padding: padding!, child: list);
        }

        if (enableOverflowHandling) {
          list = TabletCalendarOverflowHandler(
            enableHorizontalScroll: false,
            child: list,
          );
        }

        return list;
      },
    );
}

/// Responsive calendar week view for tablets
class ResponsiveCalendarWeekView extends StatelessWidget {

  const ResponsiveCalendarWeekView({
    required this.dayColumns, required this.dayHeaders, super.key,
    this.columnWidth,
    this.headerHeight,
    this.padding,
  });
  final List<Widget> dayColumns;
  final List<String> dayHeaders;
  final double? columnWidth;
  final double? headerHeight;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;

        final effectiveColumnWidth = columnWidth ??
            (isDesktop
                ? 200.0
                : isTablet
                    ? 150.0
                    : 120.0);
        final effectiveHeaderHeight = headerHeight ?? (isTablet ? 60.0 : 50.0);

        Widget weekView = Column(
          children: [
            // Day headers
            SizedBox(
              height: effectiveHeaderHeight,
              child: Row(
                children: dayHeaders
                    .map(
                      (header) => Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              header,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            // Day columns
            Expanded(
              child: Row(
                children: dayColumns
                    .map(
                      (column) => Expanded(child: column),
                    )
                    .toList(),
              ),
            ),
          ],
        );

        if (padding != null) {
          weekView = Padding(padding: padding!, child: weekView);
        }

        return TabletCalendarOverflowHandler(
          child: weekView,
        );
      },
    );
}

/// Responsive calendar month view for tablets
class ResponsiveCalendarMonthView extends StatelessWidget {

  const ResponsiveCalendarMonthView({
    required this.weekRows, required this.dayHeaders, super.key,
    this.cellHeight,
    this.headerHeight,
    this.padding,
  });
  final List<List<Widget>> weekRows;
  final List<String> dayHeaders;
  final double? cellHeight;
  final double? headerHeight;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;

        final effectiveCellHeight = cellHeight ??
            (isDesktop
                ? 120.0
                : isTablet
                    ? 100.0
                    : 80.0);
        final effectiveHeaderHeight = headerHeight ?? (isTablet ? 50.0 : 40.0);

        Widget monthView = Column(
          children: [
            // Day headers
            SizedBox(
              height: effectiveHeaderHeight,
              child: Row(
                children: dayHeaders
                    .map(
                      (header) => Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              header,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            // Week rows
            Expanded(
              child: Column(
                children: weekRows
                    .map(
                      (weekRow) => Expanded(
                        child: Row(
                          children: weekRow
                              .map(
                                (cell) => Expanded(child: cell),
                              )
                              .toList(),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );

        if (padding != null) {
          monthView = Padding(padding: padding!, child: monthView);
        }

        return TabletCalendarOverflowHandler(
          child: monthView,
        );
      },
    );
}

/// Responsive calendar day view for tablets
class ResponsiveCalendarDayView extends StatelessWidget {

  const ResponsiveCalendarDayView({
    required this.timeSlots, required this.timeLabels, super.key,
    this.slotHeight,
    this.labelWidth,
    this.padding,
  });
  final List<Widget> timeSlots;
  final List<String> timeLabels;
  final double? slotHeight;
  final double? labelWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;

        final effectiveSlotHeight = slotHeight ??
            (isDesktop
                ? 80.0
                : isTablet
                    ? 70.0
                    : 60.0);
        final effectiveLabelWidth = labelWidth ??
            (isDesktop
                ? 100.0
                : isTablet
                    ? 80.0
                    : 60.0);

        Widget dayView = Row(
          children: [
            // Time labels
            SizedBox(
              width: effectiveLabelWidth,
              child: Column(
                children: timeLabels
                    .map(
                      (label) => Container(
                        height: effectiveSlotHeight,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            label,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            // Time slots
            Expanded(
              child: Column(
                children: timeSlots
                    .map(
                      (slot) => Container(
                        height: effectiveSlotHeight,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: slot,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );

        if (padding != null) {
          dayView = Padding(padding: padding!, child: dayView);
        }

        return TabletCalendarOverflowHandler(
          child: dayView,
        );
      },
    );
}

/// Responsive calendar event card that adapts to tablet screen sizes
class ResponsiveCalendarEventCard extends StatelessWidget {

  const ResponsiveCalendarEventCard({
    required this.title, super.key,
    this.subtitle,
    this.time,
    this.location,
    this.color,
    this.onTap,
    this.isSelected = false,
  });
  final String title;
  final String? subtitle;
  final String? time;
  final String? location;
  final Color? color;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;

        return Card(
          elevation: isSelected ? 4 : 2,
          color: color?.withOpacity(0.1) ?? Theme.of(context).cardColor,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? AppSpacing.md : AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 16 : 14,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: isTablet ? 14 : 12,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (time != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: isTablet ? 16 : 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            time!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: isTablet ? 12 : 10,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (location != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: isTablet ? 16 : 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: isTablet ? 12 : 10,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
}

/// Responsive calendar navigation controls
class ResponsiveCalendarNavigation extends StatelessWidget {

  const ResponsiveCalendarNavigation({
    required this.title, super.key,
    this.onPrevious,
    this.onNext,
    this.onToday,
    this.showTodayButton = true,
  });
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onToday;
  final String title;
  final bool showTodayButton;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;

        return Container(
          padding: EdgeInsets.all(isTablet ? AppSpacing.lg : AppSpacing.md),
          child: Row(
            children: [
              // Navigation buttons
              Row(
                children: [
                  Semantics(
                    label: 'Previous period',
                    child: IconButton(
                      onPressed: onPrevious,
                      icon: const Icon(Icons.chevron_left),
                      iconSize: isTablet ? 28 : 24,
                    ),
                  ),
                  Semantics(
                    label: 'Next period',
                    child: IconButton(
                      onPressed: onNext,
                      icon: const Icon(Icons.chevron_right),
                      iconSize: isTablet ? 28 : 24,
                    ),
                  ),
                ],
              ),
              // Title
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: isTablet ? 24 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              // Today button
              if (showTodayButton)
                Semantics(
                  label: 'Go to today',
                  child: ElevatedButton(
                    onPressed: onToday,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? AppSpacing.lg : AppSpacing.md,
                        vertical: isTablet ? AppSpacing.md : AppSpacing.sm,
                      ),
                    ),
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
}

/// Responsive calendar view selector
class ResponsiveCalendarViewSelector extends StatelessWidget {

  const ResponsiveCalendarViewSelector({
    required this.views, required this.selectedIndex, required this.onViewChanged, super.key,
  });
  final List<String> views;
  final int selectedIndex;
  final ValueChanged<int> onViewChanged;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;

        return Container(
          padding: EdgeInsets.all(isTablet ? AppSpacing.md : AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: views.asMap().entries.map((entry) {
              final index = entry.key;
              final view = entry.value;
              final isSelected = index == selectedIndex;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? AppSpacing.sm : AppSpacing.xs,
                ),
                child: ElevatedButton(
                  onPressed: () => onViewChanged(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    foregroundColor: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? AppSpacing.lg : AppSpacing.md,
                      vertical: isTablet ? AppSpacing.md : AppSpacing.sm,
                    ),
                  ),
                  child: Text(
                    view,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
}
