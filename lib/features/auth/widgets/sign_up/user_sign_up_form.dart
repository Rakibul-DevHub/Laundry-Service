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

class UserForm extends ConsumerWidget {
  final Role role;
  const UserForm(this.role, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("SIGN UP _UserForm SCREEN BUILD");

    return Column(
      children: <Widget>[
        SignUpTextField(
          role: role,
          labelText: AppStrings.signUPName,
          getValue: (SignUpState s) => s.userName,
          getError: (SignUpState s) => s.userNameError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setUserName(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).userNameValidate(),
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          role: role,
          labelText: AppStrings.signUPPhone,
          getValue: (SignUpState s) => s.userPhone,
          getError: (SignUpState s) => s.userPhoneError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setUserPhone(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).userPhoneValidate(),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          role: role,
          labelText: AppStrings.signUPEmail,
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
          role: role,
          labelText: AppStrings.signUPLocation,
          getValue: (SignUpState s) => s.userLocation,
          getError: (SignUpState s) => s.userLocationError,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setUserLocation(v),
          onUnfocus: (WidgetRef ref) =>
              ref.read(signUpProvider(role).notifier).userLocationValidate(),
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        // Date of Birth (keep as is since it uses ValueNotifier)
        _UserDateOfBirthField(role: role),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpDropdownField(
          role: role,
          labelText: AppStrings.signUPGender,
          getValue: (SignUpState s) => s.userGender,
          onChanged: (WidgetRef ref, String v) =>
              ref.read(signUpProvider(role).notifier).setUserGender(v),
          items: const <String>[
            AppStrings.male,
            AppStrings.female,
            AppStrings.other,
          ],
        ),
        const SizedBox(height: AppSizes.spaceBetweenInputs),
        SignUpTextField(
          role: role,
          labelText: AppStrings.signUPPassword,
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

// Keep date picker as separate widget
class _UserDateOfBirthField extends ConsumerStatefulWidget {
  final Role role;
  const _UserDateOfBirthField({required this.role});

  @override
  ConsumerState<_UserDateOfBirthField> createState() =>
      _UserDateOfBirthFieldState();
}

class _UserDateOfBirthFieldState extends ConsumerState<_UserDateOfBirthField> {
  //  Created once, survives rebuilds
  DateTime? _dob;

  @override
  Widget build(BuildContext context) {
    //  Sync from provider state on first build
    // so back-navigation also restores the value
    _dob ??= ref.read(signUpProvider(widget.role)).userDateOfBirth;

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
              .setUserDateOfBirth(picked);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: AppStrings.dateOfBirth,
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          _dob == null
              ? AppStrings.selectDate
              : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
        ),
      ),
    );
  }
}
