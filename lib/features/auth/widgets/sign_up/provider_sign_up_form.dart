import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/sizes.dart';
import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/enums/role.dart';
import '../../providers/auth_providers.dart';
import '../../state/sign_up_state.dart';
import 'sign_up_text_field.dart';

class ProviderForm extends ConsumerWidget {
  final Role role;
  const ProviderForm(this.role, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("SIGN UP _ProviderForm SCREEN BUILD");

    return Column(
      children: <Widget>[
        SignUpTextField(
          labelText: AppStrings.signUPBusinessName,
          role: role,
          getValue: (SignUpState s) => s.businessName,
          getError: (SignUpState s) => s.businessNameError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setBusinessName(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).businessNameValidate(),
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          labelText: AppStrings.signUPOwnerName,
          role: role,
          getValue: (SignUpState s) => s.ownerName,
          getError: (SignUpState s) => s.ownerNameError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setOwnerName(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).ownerNameValidate(),
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          labelText: AppStrings.signUPTaxID,
          role: role,
          getValue: (SignUpState s) => s.taxId,
          getError: (SignUpState s) => s.taxIdError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setTaxId(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).taxIdValidate(),
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          labelText: AppStrings.signUPEmail,
          role: role,
          getValue: (SignUpState s) => s.email,
          getError: (SignUpState s) => s.emailError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setEmail(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).emailValidate(),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          labelText: AppStrings.signUPPhone,
          role: role,
          getValue: (SignUpState s) => s.providerPhone,
          getError: (SignUpState s) => s.providerPhoneError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setProviderPhone(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).providerPhoneValidate(),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          labelText: AppStrings.signUPLocation,
          role: role,
          getValue: (SignUpState s) => s.providerLocation,
          getError: (SignUpState s) => s.providerLocationError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setProviderLocation(v),
          onUnfocus: (WidgetRef ref) => ref
              .read(signUpProvider(role).notifier)
              .providerLocationValidate(),
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          labelText: AppStrings.signUPPassword,
          role: role,
          getValue: (SignUpState s) => s.password,
          getError: (SignUpState s) => s.passwordError,
          obscureText: true,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setPassword(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).passwordValidate(),
        ),
      ],
    );
  }
}
