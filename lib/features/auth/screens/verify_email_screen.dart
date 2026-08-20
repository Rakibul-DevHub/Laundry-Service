// verify_email_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../core/config/strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../shared/enums/verify_email_type.dart';
import '../../../shared/widgets/app_elevated_button.dart';
import '../providers/auth_providers.dart';
import '../state/verify_email_state.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;
  final VerifyEmailType type;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.type,
  });

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(verifyEmailProvider.notifier)
            .initialize(widget.email, widget.type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final VerifyEmailState state = ref.watch(verifyEmailProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: context.getKeyboardHeight,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.screenHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppStrings.verifyEmailTitle,
                    style: AppTextStyles.heading1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    AppStrings.verifyEmailSubTitle,
                    style: AppTextStyles.subTitle1.copyWith(
                      color: AppColors.body,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceBetweenSections),

                  // Code Input
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Container>.generate(6, (int index) {
                        const double spacing =
                            (5 * AppSizes.screenHorizontal * 2);
                        final double boxSize =
                            (context.screenWidth - spacing) / 4;

                        return Container(
                          width: boxSize,
                          height: boxSize,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.body),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: TextField(
                              focusNode: state.focusNodes[index],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                                isCollapsed: true,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (String value) {
                                if (value.length == 1) {
                                  ref
                                      .read(verifyEmailProvider.notifier)
                                      .setCodeAndMove(index, value);
                                } else if (value.isEmpty) {
                                  // Handle backspace
                                  ref
                                      .read(verifyEmailProvider.notifier)
                                      .handleBackspace(
                                        index,
                                      );
                                }
                              },
                              style: AppTextStyles.heading3,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),

                  // Timer & Resend
                  if (state.resendTimer > 0)
                    Column(
                      children: <Widget>[
                        Text(
                          AppStrings.didNotReceiveCode,
                          style: AppTextStyles.paragraph0,
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.timer,
                              size: 20,
                              color: AppColors.body,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "0:${state.resendTimer.toString().padLeft(2, '0')}",
                              style: AppTextStyles.paragraph0,
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: state.canResend
                          ? () => ref
                                .read(verifyEmailProvider.notifier)
                                .handleResend()
                          : null,
                      child: Text(
                        "${AppStrings.didNotReceiveCode} ${AppStrings.resendIt}",
                        style: AppTextStyles.paragraph0.copyWith(
                          color: state.canResend
                              ? AppColors.primary
                              : AppColors.grey50,
                        ),
                      ),
                    ),

                  const SizedBox(height: AppSizes.spaceBetweenSections),

                  // Verify Button
                  AppElevatedButton(
                    label: AppStrings.verifyEmailBtn,
                    onPressed: state.isSubmitting || !state.isValidCode
                        ? null
                        : () => ref
                              .read(verifyEmailProvider.notifier)
                              .handleVerify(),
                    isEnabled: state.isValidCode,
                    isLoading: state.isSubmitting,
                  ),

                  const SizedBox(height: AppSizes.sm),

                  // Error Message
                  if (state.error != null)
                    Text(
                      state.error!,
                      style: AppTextStyles.paragraph0.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
