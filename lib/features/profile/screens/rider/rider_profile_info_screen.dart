import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/core/extensions/context_extensions.dart';
import 'package:drop_n_fresh/shared/enums/gender.dart';
import 'package:drop_n_fresh/shared/models/user_model.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/icons.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/models/rider_documents_model.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../providers/profile_providers.dart';
import '../../state/rider_profile_state.dart';

class RiderProfileInfoScreen extends ConsumerWidget {
  const RiderProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("RIDER PROFILE EDIT SCREEN BUILD");

    final AsyncValue<User> user = ref.watch(
      riderProfileProvider.select(
        (RiderProfileState value) => value.profileValue,
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        showBackBtn: true,
        actions: <IconButton>[
          IconButton(
            icon: const AssetLoader(
              assetPath: AppIcons.edit,
              width: 24,
              height: 24,
              color: AppColors.body,
            ),
            onPressed: () => user.whenData(
              (User user) => context.push(RoutePaths.riderProfileEdit),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.white,
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
            child: user.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (Object error, StackTrace stackTrace) => const Center(
                child: Text("Something went wrong!!"),
              ),
              data: (User data) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Profile Image with Camera Icon
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: AssetLoader(
                      assetPath: data.profilePicture,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceBetweenSections),

                  // Name
                  const _FieldLabel(label: 'Name'),
                  const SizedBox(height: AppSizes.xs),

                  Text(
                    data.fullName,
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.md),

                  // Email Address
                  const _FieldLabel(label: 'Email Address'),
                  Text(
                    data.email,
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.md),
                  // Phone Number
                  const _FieldLabel(label: 'Phone Number'),
                  Text(
                    data.phoneNumber ?? "Unknown",
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.md),
                  // Location
                  const _FieldLabel(label: 'Location'),
                  Text(
                    data.address.address,
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.sm),

                  // // Age
                  // const _FieldLabel(label: 'Age'),
                  // Text(
                  //   profile.age.toString(),
                  //   style: AppTextStyles.paragraph0,
                  // ),
                  // const SizedBox(height: AppSizes.md),
                  // const DashedDivider(
                  //   dashGap: 1,
                  //   dashLength: 5.0,
                  //   color: AppColors.body,
                  // ),
                  const SizedBox(height: AppSizes.md),
                  // Gender
                  const _FieldLabel(label: 'Gender'),
                  Text(
                    Gender.fromString(data.profile?.gender)?.name ?? "Unknown",
                    style: AppTextStyles.paragraph0,
                  ),
                  const SizedBox(height: AppSizes.md),

                  const DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),

                  const SizedBox(height: AppSizes.md),

                  _Documents(
                    user: data,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Documents extends StatelessWidget {
  final User user;
  const _Documents({required this.user});

  @override
  Widget build(BuildContext context) {
    final RiderVerification? riderVerification = user.riderVerification;

    if (riderVerification == null) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Verification status banner
        _buildStatusBanner(riderVerification),
        const SizedBox(height: AppSizes.lg),

        // Documents sections
        _DocumentSection(
          title: "NID",
          hasFront: riderVerification.nid?.front != null,
          hasBack: riderVerification.nid?.back != null,
          frontUrl: riderVerification.nid?.front.url,
          backUrl: riderVerification.nid?.back.url,
        ),
        const SizedBox(height: AppSizes.md),

        _DocumentSection(
          title: "Driving License",
          hasFront: riderVerification.drivingLicense?.front != null,
          hasBack: riderVerification.drivingLicense?.back != null,
          frontUrl: riderVerification.drivingLicense?.front.url,
          backUrl: riderVerification.drivingLicense?.back.url,
        ),
        const SizedBox(height: AppSizes.md),

        _DocumentSection(
          title: "Insurance",
          hasDocument: riderVerification.insurance?.document != null,
          documentUrl: riderVerification.insurance?.document.url,
        ),
        const SizedBox(height: AppSizes.md),

        _DocumentSection(
          title: "Selfie",
          hasDocument: riderVerification.selfie?.image != null,
          documentUrl: riderVerification.selfie?.image.url,
        ),
        const SizedBox(height: AppSizes.md),

        _VehicleInfo(
          vehicle: riderVerification.vehicle,
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: AppSizes.md),
            const Icon(Icons.document_scanner, size: 48, color: AppColors.body),
            const SizedBox(height: AppSizes.md),
            Text(
              "No rider documents found",
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              "Complete verification to start deliveries",
              style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(RiderVerification verification) {
    Color color;
    String text;
    IconData icon;

    switch (verification.verificationStatus) {
      case 'approved':
        color = AppColors.title;
        text = "Verified";
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = AppColors.title;
        text = "Rejected";
        icon = Icons.error;
        break;
      default:
        color = AppColors.title;
        text = "Pending review";
        icon = Icons.hourglass_empty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.sm,
        horizontal: AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.sm),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSizes.sm),
          Text(
            "Status: $text",
            style: AppTextStyles.paragraph0.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// Simple expandable document section
class _VehicleInfo extends StatefulWidget {
  final Vehicle? vehicle;

  const _VehicleInfo({
    this.vehicle,
  });

  @override
  State<_VehicleInfo> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<_VehicleInfo> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final bool hasContent = widget.vehicle != null;
    const Color statusColor = AppColors.body;
    final String statusText = hasContent ? "Uploaded" : "Missing";

    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.white50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.sm),
        side: const BorderSide(color: AppColors.body, width: .5),
      ),
      child: InkWell(
        onTap: hasContent
            ? () => setState(() => _isExpanded = !_isExpanded)
            : null,
        child: Column(
          children: <Widget>[
            // Header row
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      getIconForTitle("Vehicle"),
                      size: 24,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Vehicle",
                          style: AppTextStyles.heading4.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          statusText,
                          style: AppTextStyles.paragraph2.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasContent)
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.body,
                      size: 28,
                    ),
                ],
              ),
            ),

            // Expanded content (images)
            if (_isExpanded && hasContent) ...<Widget>[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //============================
                    Text(
                      "VEHICLE TYPE",
                      style: AppTextStyles.paragraph0.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      widget.vehicle?.vehicleType ?? "Not Specify",
                      style: AppTextStyles.paragraph0,
                    ),
                    const SizedBox(height: AppSizes.md),

                    const DashedDivider(
                      dashGap: 1,
                      dashLength: 5.0,
                      color: AppColors.body,
                    ),

                    const SizedBox(height: AppSizes.md),

                    //============================
                    Text(
                      "BRAND NAME",
                      style: AppTextStyles.paragraph0.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      widget.vehicle?.manufacturer ?? "Not Specify",
                      style: AppTextStyles.paragraph0,
                    ),
                    const SizedBox(height: AppSizes.md),

                    const DashedDivider(
                      dashGap: 1,
                      dashLength: 5.0,
                      color: AppColors.body,
                    ),

                    const SizedBox(height: AppSizes.md),

                    //============================
                    Text(
                      "YEAR OF MANUFACTURE",
                      style: AppTextStyles.paragraph0.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      widget.vehicle?.yearOfManufacture ?? "Not Specify",
                      style: AppTextStyles.paragraph0,
                    ),
                    const SizedBox(height: AppSizes.md),

                    const DashedDivider(
                      dashGap: 1,
                      dashLength: 5.0,
                      color: AppColors.body,
                    ),

                    const SizedBox(height: AppSizes.md),

                    //============================
                    Text(
                      "COLOR",
                      style: AppTextStyles.paragraph0.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      widget.vehicle?.color ?? "Not Specify",
                      style: AppTextStyles.paragraph0,
                    ),
                    const SizedBox(height: AppSizes.md),

                    const DashedDivider(
                      dashGap: 1,
                      dashLength: 5.0,
                      color: AppColors.body,
                    ),

                    const SizedBox(height: AppSizes.md),

                    //============================
                    Text(
                      "NUMBER PLATE",
                      style: AppTextStyles.paragraph0.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      widget.vehicle?.numberPlate ?? "Not Specify",
                      style: AppTextStyles.paragraph0,
                    ),
                    const SizedBox(height: AppSizes.md),

                    const DashedDivider(
                      dashGap: 1,
                      dashLength: 5.0,
                      color: AppColors.body,
                    ),

                    const SizedBox(height: AppSizes.md),

                    //============================
                    if (widget.vehicle?.image != null)
                      buildDocumentPreview(
                        title: "Vehicle Image",
                        url: widget.vehicle!.image.url,
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DocumentSection extends StatefulWidget {
  final String title;
  final bool hasFront;
  final bool hasBack;
  final bool hasDocument;
  final String? frontUrl;
  final String? backUrl;
  final String? documentUrl;

  const _DocumentSection({
    required this.title,
    this.hasFront = false,
    this.hasBack = false,
    this.hasDocument = false,
    this.frontUrl,
    this.backUrl,
    this.documentUrl,
  });

  @override
  State<_DocumentSection> createState() => _DocumentSectionState();
}

class _DocumentSectionState extends State<_DocumentSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool hasContent =
        widget.hasFront || widget.hasBack || widget.hasDocument;
    const Color statusColor = AppColors.body;
    final String statusText = hasContent ? "Uploaded" : "Missing";

    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.white50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.sm),
        side: const BorderSide(color: AppColors.body, width: .5),
      ),
      child: InkWell(
        onTap: hasContent
            ? () => setState(() => _isExpanded = !_isExpanded)
            : null,
        child: Column(
          children: <Widget>[
            // Header row
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      getIconForTitle(widget.title),
                      size: 24,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: AppTextStyles.heading4.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          statusText,
                          style: AppTextStyles.paragraph2.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasContent)
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.body,
                      size: 28,
                    ),
                ],
              ),
            ),

            // Expanded content (images)
            if (_isExpanded && hasContent) ...<Widget>[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  children: <Widget>[
                    if (widget.hasFront && widget.frontUrl != null) ...<Widget>[
                      buildDocumentPreview(
                        title: "${widget.title} Front",
                        url: widget.frontUrl!,
                      ),
                      const SizedBox(height: AppSizes.sm),
                    ],
                    if (widget.hasBack && widget.backUrl != null) ...<Widget>[
                      buildDocumentPreview(
                        title: "${widget.title} Back",
                        url: widget.backUrl!,
                      ),
                      const SizedBox(height: AppSizes.sm),
                    ],
                    if (widget.hasDocument &&
                        widget.documentUrl != null) ...<Widget>[
                      buildDocumentPreview(
                        title: widget.title,
                        url: widget.documentUrl!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

IconData getIconForTitle(String title) {
  switch (title.toLowerCase()) {
    case 'nid':
      return Icons.badge;
    case 'driving license':
      return Icons.directions_car;
    case 'insurance':
      return Icons.description;
    case 'selfie':
      return Icons.face;
    case 'vehicle':
      return Icons.motorcycle;
    default:
      return Icons.document_scanner;
  }
}

Widget buildDocumentPreview({required String title, required String url}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: AppTextStyles.paragraph0.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: AppSizes.sm),
      ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.sm),
        child: AssetLoader(
          shape: BoxShape.rectangle,
          assetPath: url,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    ],
  );
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.paragraph1.copyWith(color: AppColors.body),
    );
  }
}
