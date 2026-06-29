import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../widgets/vehicle_info/brand_name_field.dart';
import '../../widgets/vehicle_info/color_field.dart';
import '../../widgets/vehicle_info/model_field.dart';
import '../../widgets/vehicle_info/number_plate_field.dart';
import '../../widgets/vehicle_info/vehicle_image_field.dart';
import '../../widgets/vehicle_info/vehicle_info_button.dart';
import '../../widgets/vehicle_info/vehicle_type_field.dart';
import '../../widgets/vehicle_info/year_field.dart';

class VerifyRiderIdentityVehicleInfo extends ConsumerWidget {
  const VerifyRiderIdentityVehicleInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppBar(title: "Vehicle Information"),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: context.getKeyboardHeight,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontal,
                vertical: AppSizes.screenVertical,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Vehicle Type
                  Text(
                    "1. Vehicle Type",
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  const VehicleTypeField(),
                  const SizedBox(height: AppSizes.spaceBetweenInputs),

                  // Brand Name
                  Text(
                    "2. Brand Name",
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  const BrandNameField(),
                  const SizedBox(height: AppSizes.spaceBetweenInputs),

                  // Model
                  Text(
                    "3. Model Name",
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  const ModelField(),
                  const SizedBox(height: AppSizes.spaceBetweenInputs),

                  // Color
                  Text(
                    "4. Color",
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  const ColorField(),
                  const SizedBox(height: AppSizes.spaceBetweenInputs),

                  // Year
                  Text(
                    "5. Year of Manufacture",
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  const YearField(),
                  const SizedBox(height: AppSizes.spaceBetweenInputs),

                  // Number Plate
                  Text(
                    "6. Number Plate",
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  const NumberPlateField(),
                  const SizedBox(height: AppSizes.spaceBetweenInputs),

                  // vehicle image
                  Text(
                    "1. Vehicle Image",
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
                  const VehicleImageField(),
                  const SizedBox(height: AppSizes.spaceBetweenInputs),

                  // Submit Button
                  const VehicleInfoButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
