// features/bookings/widgets/booking_progress_indicator.dart

import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:flutter/material.dart';

class BookingProgressIndicator extends StatelessWidget {
  final int currentStep;

  const BookingProgressIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < 4; i++) ...<Widget>[
          _buildCircle(i, isActive: i <= currentStep),

          if (i < 3) _buildConnector(isActive: i < currentStep),
        ],
      ],
    );
  }

  Widget _buildCircle(int index, {required bool isActive}) {
    return Expanded(
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.grey50,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: isActive ? AppColors.white : AppColors.title,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnector({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.grey50,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
