// ignore_for_file: inference_failure_on_function_return_type

import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/services/user/models/provider_business_hours_model.dart';
import 'package:drop_n_fresh/features/services/user/notifier/provider_business_hours_notifier.dart';
import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Step1Schedule extends ConsumerStatefulWidget {
  final String providerId;
  final Function(DateTime date, String timeSlot) onScheduleSelected;
  final VoidCallback onNext;

  const Step1Schedule({
    super.key,
    required this.providerId,
    required this.onScheduleSelected,
    required this.onNext,
  });

  @override
  ConsumerState<Step1Schedule> createState() => _Step1ScheduleState();
}

class _Step1ScheduleState extends ConsumerState<Step1Schedule> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
  }

  List<DateTime> _generateWeekDates() {
    final DateTime now = DateTime.now();
    return List<DateTime>.generate(
      7,
      (int index) => now.add(Duration(days: index)),
    );
  }

  String _getDayName(DateTime date) {
    return DateFormat('EEEE').format(date).toLowerCase();
  }

  List<String> _getTimeSlotsForDate(
    DateTime date,
    ProviderBusinessHoursData? businessHours,
  ) {
    if (businessHours == null) {
      return <String>[];
    }

    final String dayName = _getDayName(date);
    final BusinessHour? schedule = businessHours.getScheduleForDay(dayName);

    if (schedule == null || !schedule.isOpen) {
      return <String>[];
    }

    return schedule.generateTimeSlots();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ProviderBusinessHoursData> businessHoursAsync = ref.watch(
      providerBusinessHoursProvider(widget.providerId),
    );

    final List<DateTime> weekDates = _generateWeekDates();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Available Schedule',
          style: AppTextStyles.heading4,
        ),
        const SizedBox(height: AppSizes.md),

        if (businessHoursAsync.isLoading)
          Container(
            padding: const EdgeInsets.all(16),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (businessHoursAsync.hasError)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Icons.error_outline, color: AppColors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    businessHoursAsync.error.toString(),
                    style: AppTextStyles.paragraph2.copyWith(
                      color: AppColors.red,
                    ),
                  ),
                ),
              ],
            ),
          )
        else ...<Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: AppSizes.md,
                    children: weekDates.map((DateTime date) {
                      final String dayName = DateFormat('EEE').format(date);
                      final String dayNum = DateFormat('d').format(date);
                      final bool isToday =
                          DateFormat('d').format(date) ==
                          DateFormat('d').format(DateTime.now());
                      final bool isSelected =
                          _selectedDate != null &&
                          DateFormat('d').format(_selectedDate!) == dayNum;

                      final ProviderBusinessHoursData? businessHours =
                          businessHoursAsync.value;
                      final BusinessHour? daySchedule = businessHours
                          ?.getScheduleForDay(_getDayName(date));
                      final bool isClosed =
                          daySchedule != null && !daySchedule.isOpen;

                      return GestureDetector(
                        onTap: isClosed
                            ? null
                            : () => setState(() {
                                _selectedDate = date;
                                _selectedTimeSlot = null;
                              }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isClosed
                                ? AppColors.body.withValues(alpha: 0.1)
                                : isSelected
                                ? AppColors.primary
                                : isToday
                                ? AppColors.paste50
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isClosed
                                ? Border.all(
                                    color: AppColors.body.withValues(
                                      alpha: 0.2,
                                    ),
                                  )
                                : null,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                isToday ? 'Today' : dayName,
                                style: TextStyle(
                                  color: isClosed
                                      ? AppColors.body
                                      : isSelected
                                      ? AppColors.white
                                      : AppColors.body,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dayNum,
                                style: TextStyle(
                                  color: isClosed
                                      ? AppColors.body
                                      : isSelected
                                      ? AppColors.white
                                      : AppColors.title,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isClosed) ...<Widget>[
                                const SizedBox(height: 4),
                                Text(
                                  'Closed',
                                  style: AppTextStyles.paragraph3.copyWith(
                                    color: AppColors.body,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.lg),

          if (_selectedDate != null) ...<Widget>[
            Text(
              'Available Time Slots',
              style: AppTextStyles.heading5,
            ),
            const SizedBox(height: AppSizes.sm),

            businessHoursAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, _) =>
                  Text('Error: $e', style: const TextStyle(color: Colors.red)),
              data: (ProviderBusinessHoursData businessHours) {
                final List<String> timeSlots = _getTimeSlotsForDate(
                  _selectedDate!,
                  businessHours,
                );

                if (timeSlots.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.body.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.info_outline, color: AppColors.body),
                        const SizedBox(width: 8),
                        Text(
                          'No available time slots for this day',
                          style: AppTextStyles.paragraph2.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: timeSlots.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String timeSlot = timeSlots[index];
                    final bool isSelected = _selectedTimeSlot == timeSlot;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedTimeSlot = timeSlot),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.body.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.04)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            timeSlot,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.title,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ] else ...<Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.paste50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.calendar_today, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Select a date to view available time slots',
                      style: AppTextStyles.paragraph0.copyWith(
                        color: AppColors.body,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],

        const SizedBox(height: AppSizes.xl),

        AppElevatedButton(
          label: "Continue",
          onPressed:
              (_selectedDate != null &&
                  _selectedTimeSlot != null &&
                  !businessHoursAsync.isLoading)
              ? () {
                  widget.onScheduleSelected(
                    _selectedDate!,
                    _selectedTimeSlot!,
                  );
                  widget.onNext();
                }
              : null,
        ),
      ],
    );
  }
}
