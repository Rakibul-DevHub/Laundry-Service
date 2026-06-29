// features/business/widgets/business_hours_day_selector.dart

// ignore_for_file: inference_failure_on_function_return_type

import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/features/profile/model/business_hours_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BusinessHoursDaySelector extends StatelessWidget {
  final List<DaySchedule> schedules;
  final Function(String day) onDayToggled;
  final Function(String day) on24HoursToggled;
  final Function(String day, String time) onOpenTimeChanged;
  final Function(String day, String time) onCloseTimeChanged;

  const BusinessHoursDaySelector({
    super.key,
    required this.schedules,
    required this.onDayToggled,
    required this.on24HoursToggled,
    required this.onOpenTimeChanged,
    required this.onCloseTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: schedules.map((DaySchedule schedule) {
        return _CompactDayScheduleCard(
          schedule: schedule,
          onDayToggled: onDayToggled,
          on24HoursToggled: on24HoursToggled,
          onOpenTimeChanged: onOpenTimeChanged,
          onCloseTimeChanged: onCloseTimeChanged,
        );
      }).toList(),
    );
  }
}

class _CompactDayScheduleCard extends StatelessWidget {
  final DaySchedule schedule;
  final Function(String day) onDayToggled;
  final Function(String day) on24HoursToggled;
  final Function(String day, String time) onOpenTimeChanged;
  final Function(String day, String time) onCloseTimeChanged;

  const _CompactDayScheduleCard({
    required this.schedule,
    required this.onDayToggled,
    required this.on24HoursToggled,
    required this.onOpenTimeChanged,
    required this.onCloseTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: schedule.isOpen
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.body.withValues(alpha: 0.15),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          // Main Row: Day + Toggle + 24h Checkbox
          Row(
            children: <Widget>[
              // Day Name
              Expanded(
                child: Row(
                  children: <Widget>[
                    Icon(
                      schedule.isOpen ? Icons.calendar_today : Icons.cancel,
                      size: 18,
                      color: schedule.isOpen
                          ? AppColors.primary
                          : AppColors.body,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      schedule.displayName,
                      style: AppTextStyles.paragraph1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: schedule.isOpen
                            ? AppColors.title
                            : AppColors.body,
                      ),
                    ),
                  ],
                ),
              ),
              // 24 Hours Checkbox (only if open)
              if (schedule.isOpen) ...<Widget>[
                InkWell(
                  onTap: () => on24HoursToggled(schedule.day),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: schedule.is24Hours
                                ? AppColors.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: schedule.is24Hours
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '24h',
                          style: AppTextStyles.paragraph1.copyWith(
                            color: schedule.is24Hours
                                ? AppColors.primary
                                : AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              // Open/Closed Toggle
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: schedule.isOpen,
                  onChanged: (bool value) => onDayToggled(schedule.day),
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),

          // Time Pickers (only if open and not 24h)
          if (schedule.isOpen && !schedule.is24Hours) ...<Widget>[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  // Open Time
                  _MinimalTimePicker(
                    label: 'Open',
                    time: schedule.openTime,
                    onTimeSelected: (String time) =>
                        onOpenTimeChanged(schedule.day, time),
                  ),
                  const SizedBox(width: 8),
                  // Close Time
                  _MinimalTimePicker(
                    label: 'Close',
                    time: schedule.closeTime,
                    onTimeSelected: (String time) =>
                        onCloseTimeChanged(schedule.day, time),
                  ),
                ],
              ),
            ),
          ] else if (!schedule.isOpen) ...<Widget>[
            // Closed Label
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Closed',
                style: AppTextStyles.paragraph0.copyWith(
                  color: AppColors.body,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ] else ...<Widget>[
            // 24 Hours Label
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Open 24 hours',
                style: AppTextStyles.paragraph0.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MinimalTimePicker extends StatelessWidget {
  final String label;
  final String? time;
  final Function(String time) onTimeSelected;

  const _MinimalTimePicker({
    required this.label,
    this.time,
    required this.onTimeSelected,
  });

  Future<void> _pickTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time != null
          ? TimeOfDay(
              hour: int.parse(time!.split(':')[0]),
              minute: int.parse(time!.split(':')[1]),
            )
          : TimeOfDay(hour: now.hour, minute: now.minute),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final String hour = picked.hour.toString().padLeft(2, '0');
      final String minute = picked.minute.toString().padLeft(2, '0');
      onTimeSelected('$hour:$minute');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.body,
            width: .2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: AppTextStyles.paragraph0.copyWith(
                color: AppColors.body,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  time != null ? _formatTime(time!) : 'Set',
                  style: AppTextStyles.paragraph2.copyWith(
                    color: time != null ? AppColors.title : AppColors.body,
                    fontWeight: time != null
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.body,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time24) {
    try {
      final DateFormat format = DateFormat.Hm();
      final DateTime dateTime = format.parse(time24);
      return DateFormat.jm().format(dateTime);
    } catch (e) {
      return time24;
    }
  }
}
