import 'package:flutter/material.dart';

import '../../../app/theme/styles/app_text_styles.dart';

class EarningsListTopSectionRider extends StatelessWidget {
  const EarningsListTopSectionRider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Earnings History',
          style: AppTextStyles.heading3,
        ),
        // Consumer(
        //   builder: (BuildContext context, WidgetRef ref, Widget? widget) {
        //     return InkWell(
        //       onTap: () {
        //         _showDatePicker(context, ref);
        //       },
        //       splashColor: AppColors.paste50,
        //       highlightColor: AppColors.paste50,
        //       borderRadius: BorderRadius.circular(
        //         AppSizes.borderRadiusSm,
        //       ),
        //       child: Row(
        //         children: <Widget>[
        //           Text(
        //             DateFormat(
        //               'MMM dd, yyyy',
        //             ).format(
        //               ref.watch(
        //                     riderEarningsProvider.select(
        //                       (EarningsRiderState state) => state.selectedDate,
        //                     ),
        //                   ) ??
        //                   DateTime.now(),
        //             ),
        //             style: AppTextStyles.paragraph0.copyWith(
        //               color: AppColors.body,
        //             ),
        //           ),
        //           const SizedBox(width: 4),
        //           const Icon(Icons.calendar_today, size: 16),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }

  // void _showDatePicker(BuildContext context, WidgetRef ref) {
  //   showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime.now(),
  //   ).then((DateTime? selectedDate) {
  //     if (selectedDate != null) {
  //       ref.read(riderEarningsProvider.notifier).setSelectedDate(selectedDate);
  //     }
  //   });
  // }
}
