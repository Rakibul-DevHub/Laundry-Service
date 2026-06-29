// features/business/notifiers/business_hours_notifier.dart

import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/features/profile/model/business_hours_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessHoursNotifier extends AutoDisposeNotifier<BusinessHoursState> {
  late final ApiClient _apiClient;

  @override
  BusinessHoursState build() {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => fetchBusinessHours());
    return const BusinessHoursState();
  }

  Future<void> fetchBusinessHours() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final BusinessHoursResponse response = await _apiClient
          .handleRequest<BusinessHoursResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.providerBusinessHours,
            fromJson: BusinessHoursResponse.fromJson,
          );

      if (!response.success) {
        _initializeWithDefaults();
        return;
      }

      if (response.data.businessHours.isEmpty) {
        _initializeWithDefaults();
      } else {
        final List<DaySchedule> sorted =
            List<DaySchedule>.from(response.data.businessHours)..sort(
              (DaySchedule a, DaySchedule b) =>
                  a.dayIndex.compareTo(b.dayIndex),
            );

        state = state.copyWith(
          businessHoursData: BusinessHoursData(
            businessHours: sorted,
            updatedAt: response.data.updatedAt,
          ),
          isLoading: false,
        );
      }
    } catch (e) {
      _initializeWithDefaults();
    }
  }

  void _initializeWithDefaults() {
    final List<DaySchedule> defaultSchedules = _getDefaultSchedules();

    state = state.copyWith(
      businessHoursData: BusinessHoursData(
        businessHours: defaultSchedules,
        updatedAt: DateTime.now(),
      ),
      isLoading: false,
    );
  }

  List<DaySchedule> _getDefaultSchedules() {
    const List<String> days = <String>[
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
    ];
    return days.map((String day) {
      return DaySchedule(
        day: day,
        isOpen: true,
        is24Hours: false,
        openTime: '09:00',
        closeTime: '18:00',
      );
    }).toList();
  }

  void toggleDay(String day) {
    final List<DaySchedule> currentSchedules =
        state.businessHoursData?.businessHours ?? _getDefaultSchedules();

    final List<DaySchedule> updatedSchedules = currentSchedules.map((
      DaySchedule schedule,
    ) {
      if (schedule.day == day.toLowerCase()) {
        return schedule.copyWith(isOpen: !schedule.isOpen);
      }
      return schedule;
    }).toList();

    state = state.copyWith(
      businessHoursData:
          state.businessHoursData?.copyWith(
            businessHours: updatedSchedules,
            updatedAt: DateTime.now(),
          ) ??
          BusinessHoursData(
            businessHours: updatedSchedules,
            updatedAt: DateTime.now(),
          ),
    );
  }

  void toggle24Hours(String day) {
    final List<DaySchedule> currentSchedules =
        state.businessHoursData?.businessHours ?? _getDefaultSchedules();

    final List<DaySchedule> updatedSchedules = currentSchedules.map((
      DaySchedule schedule,
    ) {
      if (schedule.day == day.toLowerCase()) {
        return schedule.copyWith(
          is24Hours: !schedule.is24Hours,
          openTime: schedule.is24Hours ? schedule.openTime : null,
          closeTime: schedule.is24Hours ? schedule.closeTime : null,
        );
      }
      return schedule;
    }).toList();

    state = state.copyWith(
      businessHoursData:
          state.businessHoursData?.copyWith(
            businessHours: updatedSchedules,
            updatedAt: DateTime.now(),
          ) ??
          BusinessHoursData(
            businessHours: updatedSchedules,
            updatedAt: DateTime.now(),
          ),
    );
  }

  void setOpenTime(String day, String time) {
    final List<DaySchedule> currentSchedules =
        state.businessHoursData?.businessHours ?? _getDefaultSchedules();

    final List<DaySchedule> updatedSchedules = currentSchedules.map((
      DaySchedule schedule,
    ) {
      if (schedule.day == day.toLowerCase()) {
        return schedule.copyWith(openTime: time);
      }
      return schedule;
    }).toList();

    state = state.copyWith(
      businessHoursData:
          state.businessHoursData?.copyWith(
            businessHours: updatedSchedules,
            updatedAt: DateTime.now(),
          ) ??
          BusinessHoursData(
            businessHours: updatedSchedules,
            updatedAt: DateTime.now(),
          ),
    );
  }

  void setCloseTime(String day, String time) {
    final List<DaySchedule> currentSchedules =
        state.businessHoursData?.businessHours ?? _getDefaultSchedules();

    final List<DaySchedule> updatedSchedules = currentSchedules.map((
      DaySchedule schedule,
    ) {
      if (schedule.day == day.toLowerCase()) {
        return schedule.copyWith(closeTime: time);
      }
      return schedule;
    }).toList();

    state = state.copyWith(
      businessHoursData:
          state.businessHoursData?.copyWith(
            businessHours: updatedSchedules,
            updatedAt: DateTime.now(),
          ) ??
          BusinessHoursData(
            businessHours: updatedSchedules,
            updatedAt: DateTime.now(),
          ),
    );
  }

  Future<bool> saveBusinessHours() async {
    if (state.businessHoursData == null) {
      Toast.showWarning('No business hours to save');
      return false;
    }

    final String? validationError = _validateBusinessHours(
      state.businessHoursData!.businessHours,
    );

    if (validationError != null) {
      Toast.showWarning(validationError);
      return false;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      final UpdateBusinessHoursRequest request = UpdateBusinessHoursRequest(
        businessHours: state.businessHoursData!.businessHours,
      );

      final BusinessHoursResponse response = await _apiClient
          .handleRequest<BusinessHoursResponse>(
            httpMethod: HttpMethod.patch,
            endpoint: ApiEndpoints.providerBusinessHours,
            fromJson: BusinessHoursResponse.fromJson,
            data: request.toJson(),
          );

      if (response.data.businessHours.isNotEmpty) {
        final List<DaySchedule> sorted =
            List<DaySchedule>.from(
              response.data.businessHours,
            )..sort(
              (DaySchedule a, DaySchedule b) =>
                  a.dayIndex.compareTo(b.dayIndex),
            );

        state = state.copyWith(
          businessHoursData: BusinessHoursData(
            businessHours: sorted,
            updatedAt: response.data.updatedAt,
          ),
          isSaving: false,
        );
      }

      Toast.showSuccess(response.message);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to save: ${e.toString()}',
        isSaving: false,
      );
      Toast.showError(ExceptionHandler.errorMessage(e));
      return false;
    }
  }

  String? _validateBusinessHours(List<DaySchedule> schedules) {
    for (final DaySchedule schedule in schedules) {
      // Rule: If day is open AND not 24 hours, must have both open and close times
      if (schedule.isOpen && !schedule.is24Hours) {
        // Check open time
        if (schedule.openTime == null || schedule.openTime!.trim().isEmpty) {
          return '${schedule.displayName}: Open time is required';
        }

        // Check close time
        if (schedule.closeTime == null || schedule.closeTime!.trim().isEmpty) {
          return '${schedule.displayName}: Close time is required';
        }

        // Validate time format (HH:mm 24-hour format)
        final RegExp timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
        if (!timeRegex.hasMatch(schedule.openTime!)) {
          return '${schedule.displayName}: Invalid open time format (use HH:MM)';
        }
        if (!timeRegex.hasMatch(schedule.closeTime!)) {
          return '${schedule.displayName}: Invalid close time format (use HH:MM)';
        }

        // Optional: Validate close time is after open time (same day)
        try {
          final List<String> openParts = schedule.openTime!.split(':');
          final List<String> closeParts = schedule.closeTime!.split(':');
          final int openTotalMinutes =
              int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
          final int closeTotalMinutes =
              int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);

          if (closeTotalMinutes <= openTotalMinutes) {
            return '${schedule.displayName}: Close time must be after open time';
          }
        } catch (e) {
          return '${schedule.displayName}: Invalid time values';
        }
      }

      // Rule: If day is closed, times should be null/empty (optional cleanup)
      if (!schedule.isOpen) {
        // Auto-clear times for closed days to keep JSON clean
        // This is optional but helps with backend consistency
      }
    }

    return null; // All validations passed
  }

  void resetToDefaults() {
    state = state.copyWith(
      businessHoursData: BusinessHoursData(
        businessHours: _getDefaultSchedules(),
        updatedAt: DateTime.now(),
      ),
    );
  }
}

class BusinessHoursState {
  final BusinessHoursData? businessHoursData;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  const BusinessHoursState({
    this.businessHoursData,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  BusinessHoursState copyWith({
    BusinessHoursData? businessHoursData,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return BusinessHoursState(
      businessHoursData: businessHoursData ?? this.businessHoursData,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

final AutoDisposeNotifierProvider<BusinessHoursNotifier, BusinessHoursState>
businessHoursProvider =
    NotifierProvider.autoDispose<BusinessHoursNotifier, BusinessHoursState>(
      BusinessHoursNotifier.new,
    );
