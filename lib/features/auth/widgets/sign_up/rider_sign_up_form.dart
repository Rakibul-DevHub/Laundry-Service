import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/sizes.dart';
import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/enums/role.dart';
import '../../providers/auth_providers.dart';
import '../../state/sign_up_state.dart';
import 'sign_up_dropdown.dart';
import 'sign_up_text_field.dart';

class RiderForm extends ConsumerWidget {
  final Role role;
  const RiderForm(this.role, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("SIGN UP _RiderForm SCREEN BUILD");
    return Column(
      children: <Widget>[
        SignUpTextField(
          labelText: AppStrings.signUPName,
          role: role,
          getValue: (SignUpState s) => s.riderName,
          getError: (SignUpState s) => s.riderNameError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setRiderName(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).riderNameValidate(),
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
          getValue: (SignUpState s) => s.riderPhone,
          getError: (SignUpState s) => s.riderPhoneError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setRiderPhone(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).riderPhoneValidate(),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          labelText: AppStrings.signUPLocation,
          role: role,
          getValue: (SignUpState s) => s.riderLocation,
          getError: (SignUpState s) => s.riderLocationError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setRiderLocation(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).riderLocationValidate(),
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        _RiderDateOfBirthField(role: role),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpDropdownField(
          role: role,
          labelText: AppStrings.signUPGender,
          getValue: (SignUpState s) => s.riderGender,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setRiderGender(v),
          items: const <String>[
            AppStrings.male,
            AppStrings.female,
            AppStrings.other,
          ],
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          labelText: AppStrings.signUPPassword,
          role: role,
          getValue: (SignUpState s) => s.password,
          getError: (SignUpState s) => s.passwordError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setPassword(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).passwordValidate(),
          obscureText: true,
        ),
      ],
    );
  }
}

class _RiderDateOfBirthField extends ConsumerStatefulWidget {
  final Role role;
  const _RiderDateOfBirthField({required this.role});

  @override
  ConsumerState<_RiderDateOfBirthField> createState() =>
      _RiderDateOfBirthFieldState();
}

class _RiderDateOfBirthFieldState
    extends ConsumerState<_RiderDateOfBirthField> {
  DateTime? _dob;

  @override
  Widget build(BuildContext context) {
    _dob ??= ref.read(signUpProvider(widget.role)).riderDateOfBirth;

    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _dob ?? DateTime(1990),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => _dob = picked);
          ref
              .read(signUpProvider(widget.role).notifier)
              .setRiderDateOfBirth(picked);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          // labelText: AppStrings.dateOfBirth,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          _dob == null
              ? AppStrings.dateOfBirth
              : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
        ),
      ),
    );
  }
}
